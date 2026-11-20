-- Floating fzf. Colours are Catppuccin Mocha, verbatim from github.com/catppuccin/fzf
-- (themes/catppuccin-fzf-mocha.sh). `flags` is shared by every picker, in the floating layer or in a script.
local M = {}

local colors = table.concat({
  "bg+:#313244", "bg:#1E1E2E", "spinner:#F5E0DC", "hl:#F38BA8", "fg:#CDD6F4", "header:#F38BA8",
  "info:#CBA6F7", "pointer:#F5E0DC", "marker:#B4BEFE", "fg+:#CDD6F4", "prompt:#CBA6F7", "hl+:#F38BA8",
  "selected-bg:#45475A", "border:#6C7086", "label:#CDD6F4",
}, ",")

M.flags = "--layout reverse --info inline-right --prompt '❯ ' --pointer '▌' --border rounded --color '" .. colors .. "'"

-- For fzf over the list `dir/index` (tab-separated, id first; only the rest is shown).
M.list_flags = M.flags .. " --delimiter '\\t' --with-nth 2.."

function M.write(path, content)
  local f = assert(io.open(path, "w"))
  f:write(content)
  f:close()
end

function M.tmpdir()
  local dir = os.tmpname()
  os.remove(dir)
  rex.exec({ "mkdir", "-p", dir })
  return dir
end

-- Run a shell command in a floating layer over the active window. bounds = {x, y, w, h} fractions.
function M.layer(ctx, command, bounds)
  local view = rex.call("session.view", { session_id = ctx.session_id })
  rex.call("session.new_layer", {
    session_id = ctx.session_id,
    window_id = view.active_window_id,
    bounds = bounds or { 0, 0, 1, 1 },
    focus = true,
    layout = rex.layout.block({
      flavor = "com.superlogical.terminal.shell",
      options = { command = { "sh", "-c", command } },
    }),
  })
end

-- opts: dir (holds `index`), args (extra fzf flags), bounds, after (shell ending in `;`, run when fzf exits).
function M.float(ctx, opts)
  M.layer(ctx, table.concat({ "fzf", M.list_flags, opts.args, "<", opts.dir .. "/index;", opts.after }, " "), opts.bounds)
end

return M
