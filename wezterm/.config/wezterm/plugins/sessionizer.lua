-- from https://github.com/wez/wezterm/discussions/4796

local wezterm = require("wezterm")
local act = wezterm.action

local Sessionizer = {}

local fd = "/home/dylan/.local/bin/fd"
local work = "/home/dylan/Documents/University/"
local personal = "/home/dylan/Documents/Personal_Projects/"
local business = "/home/dylan/Documents/Business/"
local libraries = "/home/dylan/Documents/Libraries/"

Sessionizer.open = function(window, pane)
    local projects = {}
    local home = os.getenv("HOME") .. "/"

    local success, stdout, stderr = wezterm.run_child_process({
        fd,
        "-HI",
        ".git$",
        "--max-depth=4",
        "--prune",
        personal,
        libraries,
        work,
        business,
        -- add more paths here
    })

    if not success then
        wezterm.log_error("Failed to run fd: " .. stderr)
        return
    end

    -- define variables from from file paths extractions and
    -- fill table with results
    for line in stdout:gmatch("([^\n]*)\n?") do
        -- create label from file path
        local project = line:gsub("/.git.*", "")
        project = project:gsub("/$", "")
        local label = project:gsub(home, "")

        -- extract id. Used for workspace name
        local _, _, id = string.find(project, ".*/(.+)")
        id = id:gsub(".git", "") -- bare repo dirs typically end in .git, remove if so.

        table.insert(projects, { label = tostring(label), id = tostring(id) })
    end

    -- update previous_workspace before changing to new workspace.
    wezterm.GLOBAL.previous_workspace = window:active_workspace()
    window:perform_action(
        act.InputSelector({
            action = wezterm.action_callback(function(win, _, id, label)
                if not id and not label then
                    wezterm.log_info("Cancelled")
                else
                    wezterm.log_info("Selected " .. label)
                    win:perform_action(
                        act.SwitchToWorkspace({
                            name = id,
                            spawn = { cwd = home .. label },
                        }),
                        pane
                    )
                end
            end),
            fuzzy = true,
            title = "Select project",
            choices = projects,
        }),
        pane
    )
end

return Sessionizer
