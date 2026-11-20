-- All key bindings. Prefix is ctrl+space (as in tuios). The actions live in plugins/.
-- Rex's built-in shortcuts are not listed here: the app keeps them in its own settings (client.shortcuts.edit).

-- Ghostty
rex.bind("f11", "client.window.fullscreen.toggle")
rex.bind("cmd+v", "pane.paste")
rex.bind("cmd+c", "pane.copy")

-- zellij (non-mode keys only)
rex.bind("alt+n", "pane.split.auto")
rex.bind("alt+t", "client.tab.new")
rex.bind("alt+f", "pane.new_floating") -- scratchpad terminal; alt+cmd+m hides/shows it

-- Tabs (tuios workspaces): alt+ctrl+left/right
rex.bind("alt+ctrl+left", "client.tab.previous")
rex.bind("alt+ctrl+right", "client.tab.next")

-- Panes: alt+shift+arrows, in plugins/smart_splits.lua

-- Prefix: ctrl+space then a key
rex.bind("ctrl+space>ctrl+space", "pane.send_key", { key = "ctrl+space" })
rex.bind("ctrl+space>s", "switch_session")
rex.bind("ctrl+space>e", "pane.copy_mode.enter")
rex.bind("ctrl+space>y", "new_session")
rex.bind("ctrl+space>b", "command_output")
