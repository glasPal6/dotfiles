-- Neovim navigation
local wezterm = require('wezterm')

local function is_vim(pane)
    return pane:get_user_vars().IS_NVIM == 'true'
end

local direction_keys = {
    Left = 'LeftArrow',
    Down = 'DownArrow',
    Up = 'UpArrow',
    Right = 'RightArrow',
    LeftArrow = 'Left',
    DownArrow = 'Down',
    UpArrow = 'Up',
    RightArrow = 'Right',
}

local function split_nav(resize_or_move, key)
    return {
        key = key,
        mods = resize_or_move == 'resize' and 'META' or 'CTRL',
        action = wezterm.action_callback(function(win, pane)
            if is_vim(pane) then
                -- pass the keys through to vim/nvim
                win:perform_action({
                    SendKey = { key = key, mods = resize_or_move == 'resize' and 'META' or 'CTRL' },
                }, pane)
            else
                if resize_or_move == 'resize' then
                    win:perform_action({ AdjustPaneSize = { direction_keys[key], 3 } }, pane)
                else
                    win:perform_action({ ActivatePaneDirection = direction_keys[key] }, pane)
                end
            end
        end),
    }
end

return {
    keys = {
        -- move between split panes
        split_nav('move', 'LeftArrow'),
        split_nav('move', 'DownArrow'),
        split_nav('move', 'UpArrow'),
        split_nav('move', 'RightArrow'),
        -- resize panes
        split_nav('resize', 'LeftArrow'),
        split_nav('resize', 'DownArrow'),
        split_nav('resize', 'UpArrow'),
        split_nav('resize', 'RightArrow'),
    },
}

