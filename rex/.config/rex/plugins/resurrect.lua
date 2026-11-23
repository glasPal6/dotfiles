-- rex-resurrect: remember which coding agent (claude, codex, copilot) runs in
-- which Rex pane, and with which agent session, so that the agents can be
-- resumed in the same panes after the Rex server restarts.
--
-- One file, two roles:
--
--   * Required from init.lua (`require("resurrect").setup{}`), it defines the
--     resurrect_* actions and starts the tracker in the background.
--   * Run with `rex do resurrect.lua [cmd=...]`, it is the tracker itself
--     (cmd=daemon) or a one-shot command (status, scan, restore, stop).
--
-- Rex restores sessions, windows and panes with their IDs on restart, but
-- each pane comes back as a fresh shell. The tracker keeps a state file that
-- maps block ID -> agent + agent session ID + cwd. After a restart it types
-- the agent's resume command into each of those panes.

local MODNAME = ...

local M = {}

local HOME = os.getenv("HOME") or ""
local TERMINAL = "com.superlogical.terminal"
local UUID = "%x%x%x%x%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%x%x%x%x%x%x%x%x"

local SHELLS = {
  zsh = true, bash = true, fish = true, sh = true, dash = true, ksh = true,
  nu = true, tcsh = true, csh = true, xonsh = true, elvish = true, pwsh = true,
}

local defaults = {
  -- Where state.json, daemon.pid, daemon.log and last-restore.json live.
  state_dir = (os.getenv("XDG_STATE_HOME") or (HOME .. "/.local/state")) .. "/rex-resurrect",
  -- Path of the rex binary. Found from the running server when nil.
  rex_bin = nil,
  -- Seconds between full scans. These catch a session changed from inside a
  -- running agent, such as /resume or /clear, which Rex has no event for.
  scan_interval = 10,
  -- Seconds after a process starts or exits until the scan it triggers, and
  -- until the second scan that follows it.
  event_delay = 1,
  followup_delay = 10,
  -- While an agent seen less than id_retry_window seconds ago has no session
  -- ID yet, scan again every id_retry_interval seconds.
  id_retry_interval = 2,
  id_retry_window = 60,
  -- Seconds an agent may be gone from its pane before it is forgotten. It
  -- must outlast a server shutdown, where agents die before the tracker does.
  grace = 90,
  -- Resume agents on their own when the tracker sees a new server instance.
  auto_restore = true,
  -- Seconds to wait after a restart before typing into the restored panes.
  restore_delay = 3,
  -- Open a new tab for an agent whose pane no longer exists.
  reopen_missing = false,
  -- The command typed to resume each agent. {id} is the agent's session ID.
  -- `names` lists the program names that identify the agent. `env` lists
  -- the variables that select the agent's profile: the directory holding its
  -- configuration and sessions. Their values are recorded from the running
  -- agent and set again in front of the resume command.
  agents = {
    claude  = { names = { "claude" },  env = { "CLAUDE_CONFIG_DIR" }, resume = "claude --resume {id}" },
    codex   = { names = { "codex" },   env = { "CODEX_HOME" },        resume = "codex resume {id}" },
    copilot = { names = { "copilot" }, env = { "COPILOT_HOME" },      resume = "copilot --resume={id}" },
  },
}

---------------------------------------------------------------------------
-- Small helpers

local function merge(base, over)
  local out = {}
  for k, v in pairs(base) do
    out[k] = type(v) == "table" and merge(v, {}) or v
  end
  for k, v in pairs(over or {}) do
    if type(v) == "table" and type(out[k]) == "table" and #v == 0 then
      out[k] = merge(out[k], v)
    else
      out[k] = v
    end
  end
  return out
end

local function basename(path)
  if type(path) ~= "string" then return nil end
  return (path:gsub("/+$", ""):match("([^/]+)$"))
end

local function read_file(path)
  local f = io.open(path, "r")
  if not f then return nil end
  local text = f:read("*a")
  f:close()
  return text
end

local function write_file(path, text)
  local tmp = path .. ".tmp"
  local f, err = io.open(tmp, "w")
  if not f then return nil, err end
  f:write(text)
  f:close()
  return os.rename(tmp, path)
end

local function exec(argv, opts)
  local r = rex.exec(argv, opts or { timeout = 10 })
  if r == nil or not r.ok then return nil end
  return r.stdout
end

local function shquote(s)
  return "'" .. tostring(s):gsub("'", "'\\''") .. "'"
end

local function stamp(t)
  return os.date("!%Y-%m-%dT%H:%M:%SZ", t or os.time())
end

local log_path
local function log(fmt, ...)
  local line = stamp() .. " " .. string.format(fmt, ...)
  if log_path then
    local f = io.open(log_path, "a")
    if f then
      f:write(line, "\n")
      f:close()
      return
    end
  end
  print(line)
end

---------------------------------------------------------------------------
-- Finding an agent's session ID from its process

local function process_args(pid)
  return exec({ "ps", "-o", "args=", "-p", tostring(pid) })
end

-- The pid and its children and grandchildren. Codex is a node launcher that
-- runs the real program as a child.
local function process_family(pid)
  local pids = { tostring(pid) }
  local i = 1
  while i <= #pids and #pids < 32 do
    local out = exec({ "pgrep", "-P", pids[i] })
    for child in (out or ""):gmatch("%d+") do
      pids[#pids + 1] = child
    end
    i = i + 1
  end
  return pids
end

-- Every file the processes hold open, one path per line.
local function open_files(pids)
  local r = rex.exec({ "lsof", "-p", table.concat(pids, ","), "-Fn" }, { timeout = 10, stderr = false })
  return r and r.stdout or ""
end

-- A session ID given on the command line, as in `claude --resume ID`.
local function id_from_args(pid)
  local args = process_args(pid)
  if not args then return nil end
  if args:find("resume", 1, true) or args:find("%-%-session%-id") or args:find(" %-r[ =]") then
    return args:match(UUID)
  end
  return nil
end

-- One environment variable of a process, or nil. An agent's own environment
-- can differ from the tracker's: direnv, for one, may point CLAUDE_CONFIG_DIR
-- at another directory per project. A value with a space in it is cut short.
local function process_env(pid, name)
  if type(name) ~= "string" or not name:match("^[%a_][%w_]*$") then return nil end
  local f = io.open("/proc/" .. pid .. "/environ", "rb")
  if f then
    local env = "\0" .. (f:read("*a") or "")
    f:close()
    return env:match("%z" .. name .. "=([^%z]*)")
  end
  local out = exec({ "ps", "eww", "-o", "command=", "-p", tostring(pid) })
  return out and (" " .. out):match(" " .. name .. "=(%S+)")
end

local resolvers = {}

-- Claude Code writes ~/.claude/sessions/PID.json and keeps it current, so
-- it follows /clear and /resume.
function resolvers.claude(pid)
  local dir = process_env(pid, "CLAUDE_CONFIG_DIR") or os.getenv("CLAUDE_CONFIG_DIR") or (HOME .. "/.claude")
  local text = read_file(dir .. "/sessions/" .. pid .. ".json")
  if text then
    local info = rex.json.decode(text)
    if type(info) == "table" and type(info.sessionId) == "string" then
      return info.sessionId, info.cwd
    end
  end
  return id_from_args(pid)
end

-- Codex keeps its rollout file open:
-- ~/.codex/sessions/YYYY/MM/DD/rollout-TIMESTAMP-UUID.jsonl
function resolvers.codex(pid)
  local files = open_files(process_family(pid))
  local id = files:match("/rollout%-[^/\n]-(" .. UUID .. ")%.jsonl")
  return id or id_from_args(pid)
end

-- Copilot marks its session with ~/.copilot/session-state/UUID/inuse.PID.hold
function resolvers.copilot(pid)
  local dir = process_env(pid, "COPILOT_HOME") or os.getenv("COPILOT_HOME") or (HOME .. "/.copilot")
  local out = exec({
    "sh", "-c",
    'for f in "$1"/session-state/*/inuse."$2".hold; do [ -e "$f" ] && echo "$f"; done; true',
    "sh", dir, tostring(pid),
  })
  local id = out and out:match("/session%-state/(" .. UUID .. ")/")
  if id then return id end
  id = open_files(process_family(pid)):match("/session%-state/(" .. UUID .. ")/")
  return id or id_from_args(pid)
end

-- The agent running in a terminal, from the terminal's `process` result.
-- Returns the agent's name and its process, or nil.
local function detect(proc, opts)
  local candidates = {}
  if type(proc.foreground) == "table" then candidates[#candidates + 1] = proc.foreground end
  for _, p in ipairs(proc.ancestors or {}) do candidates[#candidates + 1] = p end

  for _, p in ipairs(candidates) do
    local names = {}
    for _, field in ipairs({ "argv0", "invoked_path", "script", "name", "path" }) do
      local n = basename(p[field])
      if n then names[n:gsub("^%-", "")] = true end
    end
    for agent, spec in pairs(opts.agents) do
      for _, n in ipairs(spec.names or { agent }) do
        if names[n] then return agent, p end
      end
    end
  end
  return nil
end

---------------------------------------------------------------------------
-- Calling Rex. A script must be attached to a session to query it.

local function with_attach(session_id, fn)
  local r, err = fn()
  if r == nil and tostring(err):find("not attached", 1, true) then
    rex.session.attach{ session_id = session_id }
    r, err = fn()
  end
  return r, err
end

local function scall(method, session_id, args)
  args = args or {}
  args.session_id = session_id
  return with_attach(session_id, function() return rex.call(method, args) end)
end

local function bcall(method, session_id, block_id, args)
  args = args or {}
  args.session_id = session_id
  args.block_id = block_id
  return with_attach(session_id, function() return rex.block.call(TERMINAL, method, args) end)
end

---------------------------------------------------------------------------
-- State

local function state_path(opts) return opts.state_dir .. "/state.json" end

-- Whether a file or directory belongs to the user running this.
local function owned(path)
  return exec({ "test", "-O", path }) ~= nil
end

-- The state decides what is typed into panes, so it is read only from a
-- file and directory this user owns. Anything else loads as empty.
local function load_state(opts)
  local state
  local text = read_file(state_path(opts))
  if text then
    if owned(opts.state_dir) and owned(state_path(opts)) then
      state = rex.json.decode(text)
    else
      rex.log("warn", "rex-resurrect: ignoring " .. state_path(opts) .. ": not owned by this user")
    end
  end
  if type(state) ~= "table" then state = {} end
  if type(state.entries) ~= "table" then state.entries = {} end
  for block_id, e in pairs(state.entries) do
    if type(block_id) ~= "string" or type(e) ~= "table" then state.entries[block_id] = nil end
  end
  state.version = 1
  return state
end

local function save_state(opts, state)
  state.heartbeat = os.time()
  local text = rex.json.encode(state, { indent = true })
  if not text then return nil, "cannot encode state" end
  return write_file(state_path(opts), text)
end

-- Look at every terminal on the server and bring state.entries up to date.
-- Returns true, or nil and a message when the server could not be asked. A
-- session or block that fails to answer keeps its entries untouched.
local function scan(state, opts)
  local list, err = rex.call("session.list")
  if not list then return nil, err end

  local now = os.time()
  local seen, unknown_sessions = {}, {}

  for _, s in ipairs(list.sessions or {}) do
    local blocks = scall("session.list_blocks", s.session_id)
    if not blocks then
      unknown_sessions[s.session_id] = true
    else
      for _, b in ipairs(blocks.blocks or {}) do
        if b.creator_name == TERMINAL then
          local proc = bcall("process", s.session_id, b.block_id)
          if not proc then
            seen[b.block_id] = true
          else
            local agent, p = detect(proc, opts)
            if agent then
              seen[b.block_id] = true
              local e = state.entries[b.block_id]
              if not e or e.agent ~= agent or e.pid ~= p.pid then
                e = { agent = agent, pid = p.pid, first_seen = now }
                state.entries[b.block_id] = e
              end
              local id, cwd = (resolvers[agent] or id_from_args)(p.pid)
              if id then e.agent_session_id = id end
              e.cwd = cwd or p.cwd or e.cwd
              e.env = nil
              for _, name in ipairs(opts.agents[agent].env or {}) do
                local value = process_env(p.pid, name)
                if value then
                  e.env = e.env or {}
                  e.env[name] = value
                end
              end
              e.rex_session_id = s.session_id
              e.rex_session_label = s.label
              e.window_id = b.window_id
              e.last_seen = now
              e.gone_at = nil
            end
          end
        end
      end
    end
  end

  for block_id, e in pairs(state.entries) do
    if not seen[block_id] and not unknown_sessions[e.rex_session_id] then
      if not e.gone_at then
        e.gone_at = now
      elseif now - e.gone_at > opts.grace then
        state.entries[block_id] = nil
      end
    end
  end
  return true
end

---------------------------------------------------------------------------
-- Restore

-- The command typed to resume an entry's agent, or nil and a reason.
--
-- The state file is only data: it never holds a command. The command comes
-- from the `agents` option, and the state file fills in two values, both
-- checked here because they end up typed into a shell:
--
--   * the session ID, which must be a UUID and nothing else;
--   * the directory, which is typed only when the pane is somewhere else
--     (`pane_cwd`), must exist, and must have no control characters. A
--     terminal reads those as key presses, which quoting does not stop;
--   * the profile directories, held to the same rules. Only the variables
--     named in the `agents` option are ever set, whatever the file says.
local function plain_dir(path, must_own)
  if type(path) ~= "string" or path:sub(1, 1) ~= "/" or path:find("[%z\1-\31\127]") then
    return nil, "is not a plain absolute path"
  end
  -- Shells disagree about these inside single quotes: fish reads \' as a
  -- quote, PowerShell and Nushell don't read '\'' as one, and csh expands !.
  -- A directory name is chosen by whoever made the directory, a cloned
  -- repository included, so a path with any of them is never typed.
  if path:find("['\\!]") then
    return nil, "has a quote, backslash or exclamation mark in it"
  end
  if not exec({ "test", "-d", path }) then return nil, "no longer exists" end
  -- An agent runs the hooks and settings it finds in its profile directory,
  -- so one that someone else owns is never selected.
  if must_own and not exec({ "test", "-O", path }) then return nil, "is not owned by this user" end
  return true
end

local function resume_command(opts, e, pane_cwd)
  local spec = opts.agents[e.agent]
  if not spec or type(spec.resume) ~= "string" then return nil, "no resume command for " .. tostring(e.agent) end
  local id = e.agent_session_id
  if type(id) ~= "string" then return nil, "no agent session ID was captured" end
  if not id:match("^" .. UUID .. "$") then return nil, "the agent session ID is not a UUID" end
  local cmd = spec.resume:gsub("{id}", function() return id end)

  for i = #(spec.env or {}), 1, -1 do
    local name = spec.env[i]
    local value = type(e.env) == "table" and e.env[name] or nil
    if value ~= nil then
      if type(name) ~= "string" or not name:match("^[%a_][%w_]*$") then
        return nil, "bad variable name in the agents option"
      end
      local ok, why = plain_dir(value, true)
      if not ok then return nil, "the recorded " .. name .. " " .. why end
      cmd = name .. "=" .. shquote(value) .. " " .. cmd
    end
  end

  local cwd = e.cwd
  if cwd ~= nil and cwd ~= pane_cwd then
    local ok, why = plain_dir(cwd)
    if not ok then return nil, "the recorded directory " .. why end
    cmd = "cd -- " .. shquote(cwd) .. " && " .. cmd
  end
  return cmd
end

local uid
local function my_uid()
  if uid == nil then
    local out = exec({ "id", "-u" })
    uid = out and tonumber(out:match("%d+")) or false
  end
  return uid
end

-- Resume the agent of each entry in its pane. `how.include_gone` also
-- resumes agents that had already left their pane. `how.dry` types nothing.
local function restore(state, opts, how)
  how = how or {}
  local results = {}

  local block_ids = {}
  for block_id in pairs(state.entries) do block_ids[#block_ids + 1] = block_id end
  table.sort(block_ids)

  for _, block_id in ipairs(block_ids) do
    local e = state.entries[block_id]
    local res = {
      block_id = block_id,
      agent = e.agent,
      agent_session_id = e.agent_session_id,
      rex_session = e.rex_session_label,
    }
    results[#results + 1] = res

    -- Rex restores a pane in the directory it was in, so the pane's own
    -- directory is used when it can be read, and no `cd` is typed.
    local proc = bcall("process", e.rex_session_id, block_id)
    local pane_cwd = proc and proc.foreground and proc.foreground.cwd
    local cmd, why = resume_command(opts, e, pane_cwd)
    res.command = cmd
    if not cmd then
      res.result, res.reason = "skipped", why
    elseif e.gone_at and not how.include_gone then
      res.result, res.reason = "skipped", "the agent had exited before the restart"
    else
      if not proc then
        if not opts.reopen_missing then
          res.result, res.reason = "skipped", "the pane no longer exists"
        elseif how.dry then
          res.result = "would reopen"
        else
          local w, err = scall("session.new_window", e.rex_session_id, {
            layout = rex.layout.block{
              flavor = TERMINAL .. ".shell",
              options = { cwd = e.cwd, initial_input = cmd .. "\n" },
            },
          })
          if w then
            res.result, res.new_block_id = "reopened", w.block_ids and w.block_ids[1]
          else
            res.result, res.reason = "failed", tostring(err)
          end
        end
      elseif detect(proc, opts) then
        res.result, res.reason = "skipped", "an agent is already running in the pane"
      elseif not (proc.foreground and SHELLS[(proc.foreground.name or ""):gsub("^%-", "")]) then
        res.result = "skipped"
        res.reason = "the pane is busy with " .. tostring(proc.foreground and proc.foreground.name or "another program")
      elseif proc.foreground.user_id ~= nil and proc.foreground.user_id ~= my_uid() then
        res.result, res.reason = "skipped", "the pane's shell runs as another user"
      elseif how.dry then
        res.result = "would resume"
      else
        -- Ctrl-U first: it discards anything already typed at the prompt, so
        -- the command can't be appended to a half-written line.
        local w, err = bcall("write", e.rex_session_id, block_id, { data = "\21" .. cmd .. "\r" })
        if w then
          res.result = "resumed"
        else
          res.result, res.reason = "failed", tostring(err)
        end
      end
    end
  end
  return results
end

---------------------------------------------------------------------------
-- The tracker

local function pid_path(opts) return opts.state_dir .. "/daemon.pid" end

local function my_pid()
  local out = exec({ "sh", "-c", "echo $PPID" })
  return out and tonumber(out:match("%d+"))
end

-- The pid of the running tracker, or nil.
local function daemon_pid(opts)
  local text = read_file(pid_path(opts))
  local pid = text and tonumber(text:match("%d+"))
  if not pid then return nil end
  local args = process_args(pid)
  if args and args:find(" do ", 1, true) and args:find("daemon", 1, true) then return pid end
  return nil
end

-- The state directory is readable and writable by its owner only.
local function make_state_dir(opts)
  rex.exec({ "mkdir", "-p", opts.state_dir })
  rex.exec({ "chmod", "700", opts.state_dir })
end

local function daemon(opts)
  make_state_dir(opts)
  if not owned(opts.state_dir) then
    print("rex-resurrect: " .. opts.state_dir .. " is not owned by this user; not starting")
    return rex.stop(0)
  end
  log_path = opts.state_dir .. "/daemon.log"

  local me = my_pid()
  local other = daemon_pid(opts)
  if other and other ~= me then
    return rex.stop(0)
  end
  write_file(pid_path(opts), tostring(me) .. "\n")
  -- Two trackers started together both get this far. The last writer stays.
  rex.sleep(0.5)
  if tonumber((read_file(pid_path(opts)) or ""):match("%d+")) ~= me then
    return rex.stop(0)
  end

  local size = #(read_file(log_path) or "")
  if size > 1024 * 1024 then os.remove(log_path) end

  local state = load_state(opts)
  log("tracker started, pid %s, %d known agents", tostring(me), (function()
    local n = 0
    for _ in pairs(state.entries) do n = n + 1 end
    return n
  end)())

  -- Notice a server other than the one the state was written under, and
  -- resume what was running on the old one.
  local function check_instance()
    local status = rex.call("server.status")
    if not status or not status.instance_id then return false end
    if state.instance_id == status.instance_id then return true end

    local restarted = state.instance_id ~= nil
    state.instance_id = status.instance_id
    if not restarted then return true end

    log("server restarted (instance %s)", status.instance_id)
    if opts.auto_restore and next(state.entries) then
      rex.sleep(opts.restore_delay)
      local results = restore(state, opts, { include_gone = true })
      for _, r in ipairs(results) do
        log("restore %s %s in %s: %s%s", tostring(r.agent), tostring(r.agent_session_id),
          tostring(r.rex_session), r.result, r.reason and (" (" .. r.reason .. ")") or "")
      end
      write_file(opts.state_dir .. "/last-restore.json",
        rex.json.encode({ at = stamp(), results = results }, { indent = true }) or "{}")
    end
    -- Give every agent a fresh grace period to come back in.
    for _, e in pairs(state.entries) do e.gone_at = nil end
    return true
  end

  local retry
  local function tick()
    if not check_instance() then
      log("server did not answer, skipping scan")
      return
    end
    local ok, err = scan(state, opts)
    if not ok then
      log("scan failed: %s", tostring(err))
      return
    end
    local saved, serr = save_state(opts, state)
    if not saved then log("cannot write state: %s", tostring(serr)) end

    -- An agent takes a moment to record its session after it starts. Look
    -- again soon while a new agent has no session ID, so that a restart in
    -- its first seconds doesn't lose it.
    if retry then retry:cancel() end
    retry = nil
    local now = os.time()
    for _, e in pairs(state.entries) do
      if not e.gone_at and not e.agent_session_id and now - (e.first_seen or 0) < opts.id_retry_window then
        retry = rex.after(opts.id_retry_interval, tick)
        break
      end
    end
  end

  -- A process change means an agent may have started or exited. Scan at
  -- once, to record it, and again a little later, to catch a session the
  -- user picked by hand (`claude --resume`, /resume) once the agent was up.
  local first, second
  local function soon()
    if first then first:cancel() end
    if second then second:cancel() end
    first = rex.after(opts.event_delay, tick)
    second = rex.after(opts.followup_delay, tick)
  end

  rex.on("terminal.process_changed", soon)
  rex.on("block_created", soon)
  rex.on("block_closed", soon)
  rex.on("session_destroyed", soon)
  rex.every(opts.scan_interval, tick)
  tick()
end

---------------------------------------------------------------------------
-- Reports

local function summary(opts, state)
  local now = os.time()
  local agents = {}
  for block_id, e in pairs(state.entries) do
    agents[#agents + 1] = {
      agent = e.agent,
      agent_session_id = e.agent_session_id,
      cwd = e.cwd,
      rex_session = e.rex_session_label,
      block_id = block_id,
      state = e.gone_at and ("gone " .. (now - e.gone_at) .. "s ago") or "running",
      resume = (resume_command(opts, e, e.cwd)),
    }
  end
  table.sort(agents, function(a, b) return a.block_id < b.block_id end)
  return {
    tracker_pid = daemon_pid(opts),
    state_file = state_path(opts),
    last_scan = state.heartbeat and stamp(state.heartbeat) or nil,
    agents = agents,
  }
end

---------------------------------------------------------------------------
-- init.lua side

local function script_path()
  local src = debug.getinfo(1, "S").source or ""
  return (src:gsub("^@", ""))
end

-- The server's own binary and command line, as seen from a command it runs.
local function parent_process()
  -- On Linux, a binary replaced by an upgrade while the server runs reads as
  -- "/usr/bin/rex (deleted)". The new binary is at the same path, so drop
  -- the suffix, and fall back to PATH when nothing executable is there.
  local bin = exec({ "sh", "-c", [[
b=$(readlink "/proc/$PPID/exe" 2>/dev/null) || b=$(ps -o comm= -p "$PPID")
b=${b% (deleted)}
[ -x "$b" ] || b=$(command -v rex 2>/dev/null) || b=
printf '%s' "$b"
]] })
  local args = exec({ "sh", "-c", "ps -o args= -p $PPID" })
  return bin and bin:gsub("%s+$", ""), args or ""
end

local function run_cli(opts, args)
  local bin = opts.rex_bin or parent_process()
  -- Arguments go in on standard input, so they never show in `ps`.
  local r, err = rex.exec({
    bin, "do", script_path(), "--args", "-",
  }, { timeout = 60, stdin = rex.json.encode(args) })
  if not r then return nil, err end
  if not r.ok then return nil, (r.stderr ~= "" and r.stderr or r.stdout) end
  return rex.json.decode(r.stdout) or r.stdout
end

local function start_daemon(opts)
  local bin, args = parent_process()
  -- Only the server starts the tracker. `rex config check` loads this file
  -- too, and must not leave a process behind.
  if not args:find(" server", 1, true) then return end
  bin = opts.rex_bin or bin
  if not bin or bin == "" then
    rex.log("warn", "rex-resurrect: cannot find the rex binary; set rex_bin")
    return
  end

  make_state_dir(opts)
  -- The options are read from a file in the private state directory rather
  -- than passed on the command line, where any user could read them.
  local args_file = opts.state_dir .. "/daemon-args.json"
  local wrote, werr = write_file(args_file, rex.json.encode({ cmd = "daemon", opts = opts }))
  if not wrote then
    rex.log("warn", "rex-resurrect: cannot write " .. args_file .. ": " .. tostring(werr))
    return
  end
  -- The server may not be listening yet while it loads its configuration,
  -- so keep trying for a minute. A tracker that ran and exited cleanly, as
  -- a duplicate does, ends the loop.
  local loop = [[
n=0
while [ "$n" -lt 20 ]; do
  "$1" --autostart=false do "$2" --all --args "$3" >>"$4" 2>&1 && exit 0
  n=$((n+1))
  sleep 3
done
]]
  local h, err = rex.exec.start({
    "sh", "-c", loop, "rex-resurrect",
    bin, script_path(),
    "@" .. args_file,
    opts.state_dir .. "/daemon.out",
  }, { detach = true, stdout = false, stderr = false })
  if not h then rex.log("warn", "rex-resurrect: cannot start the tracker: " .. tostring(err)) end
end

function M.setup(user_opts)
  local opts = merge(defaults, user_opts)
  M.opts = opts
  -- Loaded by a script rather than the server: nothing to set up.
  if rex.args ~= nil then return M end

  rex.action{
    name = "resurrect_status",
    title = "Resurrect: Show Tracked Agents",
    category = "Resurrect",
    description = "List the agents rex-resurrect is tracking and how each would be resumed.",
    run = function() return summary(opts, load_state(opts)) end,
  }

  rex.action{
    name = "resurrect_restore",
    title = "Resurrect: Resume Tracked Agents",
    category = "Resurrect",
    description = "Type each tracked agent's resume command into its pane, where the pane is at a shell prompt.",
    args = { all = "boolean?", dry = "boolean?" },
    run = function(_, args)
      args = args or {}
      return run_cli(opts, { cmd = "restore", all = args.all, dry = args.dry, opts = opts })
    end,
  }

  rex.action{
    name = "resurrect_restart",
    title = "Resurrect: Restart Tracker",
    category = "Resurrect",
    description = "Stop the background tracker and start it again with the current configuration.",
    run = function()
      run_cli(opts, { cmd = "stop", opts = opts })
      start_daemon(opts)
      return "restarted"
    end,
  }

  start_daemon(opts)
  return M
end

---------------------------------------------------------------------------
-- Script side: rex do resurrect.lua [cmd=status|scan|restore|stop|daemon]

if MODNAME == nil and rex.args ~= nil then
  local a = rex.args
  local opts = merge(defaults, type(a.opts) == "table" and a.opts or {})
  local cmd = a.cmd or "status"

  if cmd == "daemon" then
    daemon(opts)
    return
  elseif cmd == "status" then
    return summary(opts, load_state(opts))
  elseif cmd == "scan" then
    -- Look now. Nothing is written unless write=true, so a running tracker
    -- keeps sole charge of the state file.
    local state = a.write and load_state(opts) or { entries = {} }
    local ok, err = scan(state, opts)
    if not ok then error(tostring(err), 0) end
    if a.write then
      make_state_dir(opts)
      save_state(opts, state)
    end
    return summary(opts, state)
  elseif cmd == "restore" then
    return restore(load_state(opts), opts, { include_gone = a.all, dry = a.dry })
  elseif cmd == "stop" then
    local pid = daemon_pid(opts)
    if not pid then return "the tracker is not running" end
    rex.exec({ "kill", tostring(pid) })
    return "stopped tracker " .. pid
  else
    error("unknown cmd: " .. tostring(cmd) .. " (status, scan, restore, stop, daemon)", 0)
  end
end

return M
