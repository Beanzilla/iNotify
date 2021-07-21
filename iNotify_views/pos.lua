
-- Temp storage of players
inotify.player_pos = {} -- Playername, Player position as string
inotify.player_pos_hud = {} -- Playername, Player HUD for displaying position

-- Actively obtain the players postions
minetest.register_globalstep(function(dtime)
    for _, player in ipairs(minetest.get_connected_players()) do
        local pname = player:get_player_name()
        local pos = player:get_pos() -- Get the position then convert it to whole numbers
        pos.x = string.format("%.1f", pos.x)
        pos.y = string.format("%.1f", pos.y)
        pos.z = string.format("%.1f", pos.z)
        pos = pos.x..", "..pos.y..", "..pos.z -- Convert it to a whole string
        local old = "" -- Used to tell if the pos changed, thus needing HUD change
        local dirty = true -- Assume we need to change/add the hud
        if inotify.player_pos[pname] ~= nil then
            old = inotify.player_pos[pname]
            if old == pos then
                dirty = false
            else
                inotify.player_pos[pname] = ""..pos
            end
        else
            inotify.player_pos[pname] = ""..pos
        end
        -- Now to render the players postion...
        if inotify.player_pos_hud[pname] == nil then
            inotify.player_pos_hud[pname] = player:hud_add({
                hud_elem_type = "text",
                position      = {x = 0.5, y = 0.90},
                offset        = {x = -500, y = 0},
                text          = ""..inotify.player_pos[pname],
                alignment     = {x = 0, y = 0},
                scale         = {x = 100, y = 100},
                number        = inotify.colors.white or 0xFFFFFF,
            })
        else
            -- hud_change
            if dirty then -- Only update if position is different/changed
                player:hud_change(inotify.player_pos_hud[pname], "text", ""..inotify.player_pos[pname])
            end
        end
    end
end)

-- Actively remove the players postion data from playerlist
minetest.register_on_leaveplayer(function(object, timed_out)
    inotify.player_pos[object:get_player_name()] = nil
    inotify.player_pos_hud[object:get_player_name()] = nil
end)
