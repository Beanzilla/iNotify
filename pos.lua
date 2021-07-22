
-- Temp storage of players
inotify.player_pos = {} -- Playername, Player position as string
inotify.player_pos_hud = {} -- Playername, Player HUD for displaying position

function inotify.render_pos(player, posi, off, align, scaler)
    local pname = player:get_player_name()
    -- = Obtain POS =
    local pos = player:get_pos()
    pos.x = string.format("%.1f", pos.x)
    pos.y = string.format("%.1f", pos.y)
    pos.z = string.format("%.1f", pos.z)
    pos = pos.x..", "..pos.y..", "..pos.z
    -- = Check if in the pos tracker, check if needing update to HUD
    local dirty = true -- Assume we do need to update
    if inotify.player_pos[pname] ~= nil then
        if inotify.player_pos[pname] == pos then
            dirty = false
        else
            inotify.player_pos[pname] = pos
        end
    else
        inotify.player_pos[pname] = pos
    end
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
