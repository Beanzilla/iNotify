
-- Freespace counts as a completely empty slot in inventory
inotify.free_space = {}
inotify.free_space_hud = {}

function inotify.render_inv(player, pos, off, align, scaler)
    local pname = player:get_player_name()
    local inv = player:get_inventory()
    -- = Obtain free sapce and max space =
    local empty = 0
    for _, s in ipairs(inv:get_list("main")) do
        if(s:is_empty()) then
            empty = empty + 1
        end
    end
    local space_max = inv:get_size("main")
    local used = math.abs( empty - space_max )  -- Obtain the amount being used rather than amount full
    -- = Form free space percent (Change it so instead of tracking empty track used percent)
    local perc = ((used / space_max) * 100)
    -- = Check if in the health tracker, check if needing update to HUD
    local dirty = true -- Assume we do need to update
    if inotify.free_space[pname] ~= nil then
        if inotify.free_space[pname] == used then
            dirty = false
        else
            inotify.free_space[pname] = used
        end
    else
        inotify.free_space[pname] = used
    end
    -- = Form HUD stat =
    if inotify.free_space_hud[pname] == nil then
        local color = inotify.colors.white
        if perc <= 25 then
            color = inotify.colors.green
        elseif perc <= 50 and perc > 25 then
            color = inotify.colors.dark_green
        elseif perc <= 75 and perc > 50 then
            color = inotify.colors.yellow
        elseif perc <= 95 and perc > 75 then
            color = inotify.colors.orange
        elseif perc > 95 then
            color = inotify.colors.red
        end
        inotify.free_space_hud[pname] = player:hud_add({
            hud_elem_type = "text",
            position      = pos,
            offset        = off,
            text          = ""..inotify.free_space[pname].."/"..inv:get_size("main").." "..string.format("%.0f", perc).."%",
            alignment     = align,
            scale         = scaler,
            number        = color,
        })
    else
        if dirty then
            player:hud_change(inotify.free_space_hud[pname], "text", ""..inotify.free_space[pname].."/"..inv:get_size("main").." "..string.format("%.0f", perc).."%")
            local color = inotify.colors.white
            if perc <= 25 then
                color = inotify.colors.green
            elseif perc <= 50 and perc > 25 then
                color = inotify.colors.dark_green
            elseif perc <= 75 and perc > 50 then
                color = inotify.colors.yellow
            elseif perc <= 95 and perc > 75 then
                color = inotify.colors.orange
            elseif perc > 95 then
                color = inotify.colors.red
            end
            player:hud_change(inotify.free_space_hud[pname], "number", color)
        end
    end
end

--[[ Disabled, see init.lua
-- Actively obtain players freespace count
minetest.register_globalstep(function(dtime)
    for _, player in ipairs(minetest.get_connected_players()) do
        inotify.render_inv(
            player,
            {x=0.5, y=0.90},
            {x=-500, y=20},
            {x=0, y=0},
            {x=100, y=100}
        )
    end
end)

minetest.register_on_leaveplayer(function(object, timed_out)
    inotify.free_space[object:get_player_name()] = nil
    inotify.free_space_hud[object:get_player_name()] = nil
end)
]]
