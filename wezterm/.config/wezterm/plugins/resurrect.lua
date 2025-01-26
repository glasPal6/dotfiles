local config    = {}
local wezterm   = require 'wezterm'
local resurrect = wezterm.plugin.require("https://github.com/MLFlexer/resurrect.wezterm")

resurrect.periodic_save({
    interval_seconds = 60 * 10,
    save_tabs = true,
    save_windows = true,
    save_workspaces = true,
})
resurrect.set_max_nlines(0)

resurrect.set_encryption({
    enable      = true,
    method      = "age",
    -- private_key = "~/dotfiles/wezterm/.config/wezterm/plugins/resurrect_key.txt",
    private_key = wezterm.home_dir .. "/.config/wezterm/plugins/resurrect_key.txt",
    public_key  = "age16neefgeclnu2rqmezvjdqyk3fhdwupd83ffsytaadadd5rs859aq8ahvzc",
})

wezterm.on("sessionizer.open.created", function(window, label)
    local workspace_state = resurrect.workspace_state

    wezterm.log_info("Restoring " .. label)
    workspace_state.restore_workspace(resurrect.load_state(label, "workspace"), {
        window = window,
        relative = true,
        restore_text = true,
        on_pane_restore = resurrect.tab_state.default_on_pane_restore,
    })
end)

wezterm.on("sessionizer.open.selected", function(window, path, label)
    local workspace_state = resurrect.workspace_state
    wezterm.log_info("Saving " .. workspace_state.get_workspace_state().workspace)
    if workspace_state.get_workspace_state().workspace ~= "Base" then
        resurrect.save_state(workspace_state.get_workspace_state())
    end
end)

config.keys = {
    {
        key = 'W',
        mods = 'LEADER',
        action = wezterm.action_callback(function(win, pane) -- luacheck: ignore 212
            local state = resurrect.workspace_state.get_workspace_state()
            resurrect.save_state(state)
            resurrect.window_state.save_window_action()
        end),
    },
    {
        key = 'L',
        mods = 'LEADER',
        action = wezterm.action_callback(function(win, pane)
            resurrect.fuzzy_load(win, pane, function(id, label) -- luacheck: ignore 212
                local type = string.match(id, "^([^/]+)")       -- match before '/'
                id         = string.match(id, "([^/]+)$")       -- match after '/'
                id         = string.match(id, "(.+)%..+$")      -- remove file extension

                local opts = {
                    window          = win:mux_window(),
                    relative        = true,
                    restore_text    = true,
                    on_pane_restore = resurrect.tab_state.default_on_pane_restore,
                }

                if type == "workspace" then
                    local state = resurrect.load_state(id, "workspace")
                    wezterm.log_info("Loaded " .. id)
                    resurrect.workspace_state.restore_workspace(state, opts)
                elseif type == "window" then
                    local state = resurrect.load_state(id, "window")
                    -- opts.tab = win:active_tab()
                    resurrect.window_state.restore_window(pane:window(), state, opts)
                elseif type == "tab" then
                    local state = resurrect.load_state(id, "tab")
                    resurrect.tab_state.restore_tab(pane:tab(), state, opts)
                end
            end)
        end),
    },
    {
        key = 'D',
        mods = 'LEADER',
        action = wezterm.action_callback(function(win, pane)
            resurrect.fuzzy_load(
                win,
                pane,
                function(id)
                    resurrect.delete_state(id)
                end,
                {
                    title             = 'Delete State',
                    description       = 'Select session to delete and press Enter = accept, Esc = cancel, / = filter',
                    fuzzy_description = 'Search session to delete: ',
                    is_fuzzy          = true,
                }
            )
        end),
    }
}

return config
