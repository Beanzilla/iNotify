
inotify = {}
--inotify.store = minetest.get_mod_storage()

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

local modpath = minetest.get_modpath("inotify_views")

-- Add utility functions
dofile(modpath.."/utils.lua")

-- Send off to sub-modules
dofile(modpath.."/pos.lua")
dofile(modpath.."/free_space.lua")
