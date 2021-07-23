
inotify = {}

inotify.store = minetest.get_mod_storage()

-- Temp/Perm storage for players
-- The players "group" or "team" or "party"
inotify.connected = {} -- Playername, Players seperated by commas (,)

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

local modpath = minetest.get_modpath("inotify")

-- Add utility functions
dofile(modpath.."/utils.lua")

-- Send off to sub-modules
dofile(modpath.."/pos.lua")
dofile(modpath.."/free_space.lua")
dofile(modpath.."/health.lua")

minetest.register_globalstep(function(dtime)
    for _, player in ipairs(minetest.get_connected_players()) do
        inotify.render_health(
            player,
            {x=0.15, y=0.85},
            {x=0, y=-20},
            {x=0, y=0},
            {x=100, y=100}
        )
        inotify.render_pos(
            player,
            {x=0.15, y=0.85},
            {x=0, y=0},
            {x=0, y=0},
            {x=100, y=100}
        )
        inotify.render_inv(
            player,
            {x=0.15, y=0.85},
            {x=0, y=20},
            {x=0, y=0},
            {x=100, y=100}
        )
        -- Let's hard code 2 players to see their positions
        local Test1 = minetest.get_player_by_name("Test1")
        local Test2 = minetest.get_player_by_name("Test2")
        if Test1 ~= nil and Test2 ~= nil then
            inotify.render_pos_other(
                Test1,
                Test2,
                {x=0.15, y=0.5},
                {x=0, y=0},
                {x=0, y=0},
                {x=100, y=100}
            )
            inotify.render_pos_other(
                Test2,
                Test1,
                {x=0.15, y=0.5},
                {x=0, y=0},
                {x=0, y=0},
                {x=100, y=100}
            )
        end
    end
end)

-- Cleanup some player info
minetest.register_on_leaveplayer(function(object, timed_out)
    local pname = object:get_player_name()
    inotify.health[pname] = nil
    object:hud_remove(inotify.health_hud[pname])
    inotify.health_hud[pname] = nil

    inotify.player_pos[pname] = nil
    object:hud_remove(inotify.player_pos_hud[pname])
    inotify.player_pos_hud[pname] = nil

    inotify.free_space[pname] = nil
    object:hud_remove(inotify.free_space_hud[pname])
    inotify.free_space_hud[pname] = nil
end)
