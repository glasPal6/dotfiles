-- Rex config. Theme and font are app settings (Settings > Theme / Terminal), not Lua.
-- Font: defaults write com.superlogical.rex Workspace.terminalFontName "JetBrains Mono"

require("config.keybindings")

-- Personal
require("plugins.smart_splits")
require("plugins.session_creating")
require("plugins.switch")
require("plugins.outputs")

-- External
do
	local r = rex.exec({ [[/opt/homebrew/bin/rexurrect]], "auto-restore" }, {
		env = {
			REXURRECT_STATE_DIR = [[/Users/dylankamstra/.local/state/rexurrect]],
			REXURRECT_CONFIG = [[/Users/dylankamstra/.config/rexurrect/config.toml]],
		},
	})
	if r then
		io.stderr:write(r.stderr)
	end
end
