-- New session (ctrl+space>y): fzf a folder under
-- ~/Documents, type a name, optionally add nvim, claude and term tabs.
-- The pickers run in a floating shell, because a waiting action blocks Rex's key handling. The shell
-- ends by calling create_session through `rex do`, which also needs Remote Control to switch to it.
local fzf = require("plugins.fzf")

local root = os.getenv("HOME") .. "/Documents"

local function shell_block(dir, input)
  return rex.layout.block({
    flavor = "com.superlogical.terminal.shell",
    options = { cwd = dir, initial_input = input },
  })
end

rex.action({
  name = "create_session",
  title = "Create Session",
  args = { dir = "string", name = "string", dev = "string" },
  run = function(_, args)
    local windows = { { window_label = "term", layout = shell_block(args.dir) } }
    if args.dev == "yes" then
      windows = {
        { window_label = "nvim", layout = shell_block(args.dir, "nvim .\r") },
        { window_label = "claude", layout = shell_block(args.dir, "claude\r") },
        windows[1],
      }
    end
    local created = rex.call("session.create", { label = args.name, initial_windows = windows })
    rex.client.queue("session.select", { session_id = created.session_id })
  end,
})

rex.action({
  name = "new_session",
  title = "New Session in Folder…",
  run = function(ctx)
    local script = table.concat({
      "dir=$(cd " .. root .. " && fd -t d --max-depth 3 | fzf " .. fzf.flags .. " --prompt 'Folder ❯ ' " ..
      "--preview 'eza -al --git --color=always --group-directories-first " .. root .. "/{}') || exit 0",
      "printf 'Session name: '; read -r name",
      "name=$(printf %s \"$name\" | tr '. ' '__'); [ -n \"$name\" ] || exit 0",
      "dev=$(printf 'yes\\nno\\n' | fzf " .. fzf.flags .. " --prompt 'nvim, claude and term tabs? ❯ ' --height 6) || exit 0",
      "rex do create_session dir=\"" .. root .. "/${dir%/}\" name=\"$name\" dev=\"$dev\"",
    }, "; ")
    fzf.layer(ctx, script, { 0.1, 0.1, 0.8, 0.8 })
  end,
})
