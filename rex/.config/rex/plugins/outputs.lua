-- Per-command output picker (ctrl+space>b): a full-screen fzf window, commands left, output right.
-- Rex exposes no per-command output API and the scrollback carries no prompt marks, so the
-- scrollback text is split on the starship prompt symbols (starship.toml [character]).
-- A program that prints one of the symbols at the start of a line will split wrongly.

local symbols = { "❯ ", "✗ " }

local function split_commands(text)
  local commands, current = {}, nil
  for line in (text .. "\n"):gmatch("(.-)\n") do
    local cmd
    for _, symbol in ipairs(symbols) do
      local _, stop = line:find(symbol, 1, true)
      if stop then cmd = line:sub(stop + 1) break end
    end
    if cmd then
      current = { cmd = cmd, output = {} }
      commands[#commands + 1] = current
    elseif current then
      current.output[#current.output + 1] = line
    end
  end
  return commands
end

local fzf = require("plugins.fzf")

rex.action({
  name = "command_output",
  title = "Copy Command Output…",
  run = function(ctx)
    local screen = rex.block.call("com.superlogical.terminal", "format", {
      block_id = ctx.block_id, format = "text", unwrap = true, trim = true,
    })
    local dir = fzf.tmpdir()

    local index = {}
    local commands = split_commands(screen.content)
    for i = #commands, 1, -1 do -- newest first
      local c = commands[i]
      local output = table.concat(c.output, "\n"):gsub("^%s+", ""):gsub("%s+$", "")
      if c.cmd ~= "" and output ~= "" then
        local id = tostring(#index + 1)
        fzf.write(dir .. "/" .. id, output)
        index[#index + 1] = id .. "\t" .. c.cmd
      end
    end
    if #index == 0 then return end
    fzf.write(dir .. "/index", table.concat(index, "\n") .. "\n")

    -- enter copies the highlighted output; esc just closes
    fzf.float(ctx, {
      dir = dir,
      args = table.concat({
        "--preview 'bat --color=always --theme=\"Catppuccin Mocha\" --style=plain --paging=never -l log " .. dir .. "/{1}'",
        "--preview-window 'right:75%:wrap'",
        "--bind 'enter:execute-silent(pbcopy < " .. dir .. "/{1})+abort'",
      }, " "),
      after = "rm -rf " .. dir .. ";",
    })
  end,
})
