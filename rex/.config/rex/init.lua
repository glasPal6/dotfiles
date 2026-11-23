-- Rex config. Theme and font are app settings (Settings > Theme / Terminal), not Lua.
-- Font: defaults write com.superlogical.rex Workspace.terminalFontName "JetBrains Mono"

require("config.keybindings")

-- Personal
require("plugins.smart_splits")
require("plugins.session_creating")
require("plugins.switch")
require("plugins.outputs")

-- External
