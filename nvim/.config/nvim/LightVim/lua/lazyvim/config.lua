local M = {}

local defaults = {
  colorscheme = "habamax"
}

local options

function M.setup(opts)
  options = vim.tbl_deep_extend("force", defaults, opts or {})
  local LazyVim = require("lazy.util")

  LazyVim.try(function()
    if type(M.colorscheme) == "function" then
      M.colorscheme()
    else
      vim.cmd.colorscheme(M.colorscheme)
    end
  end, {
    msg = "Could not load your colorscheme",
    on_error = function(msg)
      LazyVim.error(msg)
      vim.cmd.colorscheme("habamax")
    end,
  })
end

setmetatable(M, {
  __index = function(_, key)
    if options == nil then
      return vim.deepcopy(defaults)[key]
    end
    return options[key]
  end,
})

return M
