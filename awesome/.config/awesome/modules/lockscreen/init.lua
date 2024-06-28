local gfs = require("gears.filesystem")

local lock_screen = {}

local config_dir = gfs.get_configuration_dir()
package.cpath = config_dir .. "modules/lockscreen/lib/?.so" .. ";" .. package.cpath

-- TODO: Works on Arch
lock_screen.init = function()
    -- local pam = require("liblua_pam")
    lock_screen.authenticate = function(password)
        -- return pam.auth_current_user(password)
        return password == require("hardcode_password")
    end
    require("modules.lockscreen.lockscreen")
end

return lock_screen
