
inotify = {}
--inotify.store = minetest.get_mod_storage()
inotify.VERSION = "1.4.1"
inotify.modpath = minetest.get_modpath("inotify")

-- Settings
inotify.interval_rate = minetest.settings:get("inotify.interval_rate")
inotify.include_day_count = minetest.settings:get_bool("inotify.include_day_count")
local do_health = minetest.settings:get_bool("inotify.display_health")
local do_pos = minetest.settings:get_bool("inotify.display_pos")
local do_freespace = minetest.settings:get_bool("inotify.display_freespace")
local do_clock = minetest.settings:get_bool("inotify.display_time")

if do_health == nil then
    do_health = false
    minetest.settings:set_bool("inotify.display_health", false)
end
if do_pos == nil then
    do_pos = true
    minetest.settings:set_bool("inotify.display_pos", true)
end
if do_freespace == nil then
    do_freespace = true
    minetest.settings:set_bool("inotify.display_freespace", true)
end
if do_clock == nil then
    do_clock = true
    minetest.settings:set_bool("inotify.display_time", true)
end

if inotify.interval_rate == nil then
    inotify.interval_rate = 3.0
    minetest.settings:set("inotify.interval_rate", 3.0)
else
    inotify.interval_rate = tonumber(inotify.interval_rate)
end
if inotify.include_day_count == nil then
    inotify.include_day_count = false
    minetest.settings:set_bool("inotify.include_day_count", false)
end

-- Colors, HEX, and RGB
-- Use https://duckduckgo.com/?t=ffab&q=rgb+to+hex&ia=answer to generate hex colors
inotify.colors = {
    white= 0xFFFFFF, -- 255, 255, 255
    black= 0x000000, -- 0  , 0  , 0
    green= 0x00FF00, -- 0  , 255, 0
    dark_green = 0x00AF00, -- 0  , 175, 0
    red= 0xFF0000, -- 255, 0  , 0
    blue= 0x0000FF, -- 0  , 0  , 255
    yellow= 0xFFFF00, -- 255, 255, 0
    cyan= 0x00FFFF, -- 0  , 255, 255
    magenta= 0xFF00FF, -- 255, 0  , 255
    orange = 0xFF9600, -- 255, 150, 0
}

-- Add utility functions
dofile(inotify.modpath.."/utils.lua")

-- Send off to sub-modules
dofile(inotify.modpath.."/pos.lua")
dofile(inotify.modpath.."/free_space.lua")
dofile(inotify.modpath.."/health.lua")
dofile(inotify.modpath.."/world_time.lua")

local interval = 0
minetest.register_globalstep(function(dtime)
    interval = interval + dtime
    if interval >= inotify.interval_rate then
        if do_health or do_freespace or do_pos then
            for _, player in ipairs(minetest.get_connected_players()) do
                if do_health then
                    inotify.render_health(
                        player,
                        {x=0.15, y=0.85},
                        {x=0, y=-20},
                        {x=0, y=0},
                        {x=100, y=100}
                    )
                end
                if do_pos then
                    inotify.render_pos(
                        player,
                        {x=0.15, y=0.85},
                        {x=0, y=0},
                        {x=0, y=0},
                        {x=100, y=100}
                    )
                end
                if do_freespace then
                    inotify.render_inv(
                        player,
                        {x=0.15, y=0.85},
                        {x=0, y=20},
                        {x=0, y=0},
                        {x=100, y=100}
                    )
                end
            end
        end
        interval = 0
    end
    -- Update time per second
    if do_clock then
        for _, player in ipairs(minetest.get_connected_players()) do
            inotify.render_worldt(
                player,
                {x=0.15, y=0.85},
                {x=0, y=-40},
                {x=0, y=0},
                {x=100, y=100}
            )
        end
    end
end)

-- Cleanup some player info
minetest.register_on_leaveplayer(function(object, timed_out)
    local pname = object:get_player_name()
    if inotify.health[pname] ~= nil then
        inotify.health[pname] = nil
        inotify.health_hud[pname] = nil
    end

    if inotify.player_pos[pname] ~= nil then
        inotify.player_pos[pname] = nil
        inotify.player_pos_hud[pname] = nil
    end

    if inotify.free_space[pname] ~= nil then
        inotify.free_space[pname] = nil
        inotify.free_space_hud[pname] = nil
    end

    if inotify.worldt_hud[pname] ~= nil then
        inotify.worldt_hud[pname] = nil
    end
end)

minetest.log("action", "[iNotify] Version: "..inotify.VERSION)
minetest.log("action", "[iNotify] Ready")
