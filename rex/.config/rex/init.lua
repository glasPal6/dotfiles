-- Rex config. Theme and font are app settings (Settings > Theme / Terminal), not Lua.
-- Font: defaults write com.superlogical.rex Workspace.terminalFontName "JetBrains Mono"

require("config.keybindings")

for _, plugin in ipairs({ "smart_splits", "session_creating", "switch", "outputs" }) do
  require("plugins." .. plugin)
end
