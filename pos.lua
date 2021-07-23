
-- Temp storage of players
inotify.player_pos = {} -- Playername, Player position as string
inotify.player_pos_hud = {} -- Playername, Player HUD for displaying position

-- Shows our position
function inotify.render_pos(player, posi, off, align, scaler)
    local pname = player:get_player_name()
    -- = Obtain POS =
    local pos = player:get_pos()
    pos.x = string.format("%.1f", pos.x)
    pos.y = string.format("%.1f", pos.y)
    pos.z = string.format("%.1f", pos.z)
    pos = pos.x..", "..pos.y..", "..pos.z
    inotify.player_pos[pname] = pos
    -- = Form HUD stat =
    if inotify.player_pos_hud[pname] == nil then
        inotify.player_pos_hud[pname] = player:hud_add({
            hud_elem_type = "text",
            position      = posi,
            offset        = off,
            text          = ""..pos.."",
            alignment     = align,
            scale         = scaler,
            number        = inotify.colors.white,
        })
    else
        player:hud_change(inotify.player_pos_hud[pname], "text", ""..pos.."")
    end
end

-- Shows to us another players position
function inotify.render_pos_other(player, other_player, posi, off, align, scaler)
    local pname = player:get_player_name()
    local oname = other_player:get_player_name()
    local jname = pname.."~"..oname
    -- = Obtain POS =
    local my_pos = player:get_pos()
    local their_pos = other_player:get_pos()
    local pos = other_player:get_pos()
    pos.x = string.format("%.1f", pos.x)
    pos.y = string.format("%.1f", pos.y)
    pos.z = string.format("%.1f", pos.z)
    pos = pos.x..", "..pos.y..", "..pos.z
    local mpos = player:get_pos()
    mpos.x = string.format("%.1f", mpos.x)
    mpos.y = string.format("%.1f", mpos.y)
    mpos.z = string.format("%.1f", mpos.z)
    mpos = mpos.x..", "..mpos.y..", "..mpos.z
    -- = Calculate distance from me to them =
    local dist = vector.distance(my_pos, their_pos)
    dist = string.format("%.0f", dist) -- Merge into whole number
    inotify.player_pos[oname] = pos
    inotify.player_pos[pname] = mpos
    -- = Form HUD stat =
    if inotify.player_pos_hud[jname] == nil then
        inotify.player_pos_hud[jname] = player:hud_add({
            hud_elem_type = "text",
            position      = posi,
            offset        = off,
            text          = ""..pos.." ("..dist..")",
            alignment     = align,
            scale         = scaler,
            number        = inotify.colors.white,
        })
    else
        player:hud_change(inotify.player_pos_hud[jname], "text", ""..pos.." ("..dist..")")
    end
end

--[[ Disabled, see init.lua
-- Actively obtain the players postions
minetest.register_globalstep(function(dtime)
    for _, player in ipairs(minetest.get_connected_players()) do
        inotify.render_pos(
            player,
            {x=0.5, y=0.90},
            {x=-500, y=0},
            {x=0, y=0},
            {x=100, y=100}
        )
    end
end)

-- Actively remove the players postion data from playerlist
minetest.register_on_leaveplayer(function(object, timed_out)
    inotify.player_pos[object:get_player_name()] = nil
    inotify.player_pos_hud[object:get_player_name()] = nil
end)
]]
