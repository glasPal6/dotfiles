-- Pane focus: alt+shift+arrows shared with neovim (smart-splits.nvim sees the key when nvim has focus).
-- The nvim side is nvim/.config/nvim/lua/plugins/smart_splits.lua.

local function is_vim(ctx)
  local proc = rex.block.call("com.superlogical.terminal", "process", { block_id = ctx.block_id })
  local fg = proc and proc.foreground
  if not fg then return false end
  for _, s in ipairs({ fg.name or "", (fg.argv0 or ""):match("[^/]*$") }) do
    if s:match("^n?vim") then return true end
  end
  return false
end

for _, direction in ipairs({ "left", "right", "up", "down" }) do
  rex.bind("alt+shift+" .. direction, function(ctx)
    if is_vim(ctx) then return false end
    rex.session.focus_direction({ direction = direction })
    return true
  end)
end
