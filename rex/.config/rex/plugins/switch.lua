-- Session switcher (ctrl+space>s): floating fzf over the sessions.
-- The action must return at once (a waiting action blocks Rex's key handling), so fzf switches
-- itself with `rex do session.select`, which needs Remote Control on (Settings > Rex Server).
local fzf = require("plugins.fzf")

rex.action({
  name = "switch_session",
  title = "Switch Session…",
  run = function(ctx)
    local dir = fzf.tmpdir()
    local index = {}
    for _, s in ipairs(rex.call("session.list").sessions) do
      index[#index + 1] = s.session_id .. "\t" .. s.label
    end
    fzf.write(dir .. "/index", table.concat(index, "\n") .. "\n")
    fzf.float(ctx, {
      dir = dir,
      args = "--bind 'enter:execute-silent(rex do session.select session_id={1})+abort'",
      bounds = { 0.3, 0.2, 0.4, 0.5 },
      after = "rm -rf " .. dir .. ";",
    })
  end,
})
