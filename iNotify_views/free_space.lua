
-- Freespace counts as a completely empty slot in inventory
inotify.free_space = {}
inotify.free_space_hud = {}

-- Actively obtain players freespace count
minetest.register_globalstep(function(dtime)
    for _, player in ipairs(minetest.get_connected_players()) do
        local pname = player:get_player_name()
        local inv = player:get_inventory()
        local empty = 0
        local old = 0 -- Track if the number of slots empty has changed
        local dirty = true -- Only do HUD change if something changed
        local percent = 0 -- Make a percent  just to show free space left
        -- Iterate over the entire main inventory
        for _, s in ipairs(inv:get_list("main")) do
            if(s:is_empty()) then
                empty = empty + 1
            end
        end
        -- Check that we need to update the HUD
        if inotify.free_space[pname] ~= nil then
            old = inotify.free_space[pname]
            if old == empty then
                dirty = false
            else
                inotify.free_space[pname] = empty
                percent = (empty / inv:get_size("main")) * 100
            end
        else
            inotify.free_space[pname] = empty
            percent = (empty / inv:get_size("main")) * 100
        end
        -- Now to render the slots free...
        if inotify.free_space_hud[pname] == nil then
            local color = inotify.colors.white
            if percent < 25 then
                color = inotify.colors.red
            elseif percent < 50 and percent > 25 then
                color = inotify.colors.orange
            elseif percent < 75 and percent > 50 then
                color = inotify.colors.yellow
            elseif percent < 95 and percent > 75 then
                color = inotify.colors.dark_green
            elseif percent > 95 then
                color = inotify.colors.green
            end
            inotify.free_space_hud[pname] = player:hud_add({
                hud_elem_type = "text",
                position      = {x = 0.5, y = 0.90},
                offset        = {x = -500, y = 20},
                text          = ""..inotify.free_space[pname].."/"..inv:get_size("main").." "..string.format("%.0f", percent).."%",
                alignment     = {x = 0, y = 0},
                scale         = {x = 100, y = 100},
                number        = color or 0xFFFFFF,
            })
            -- Color changes after hud_add seem to get ignored, but work afterwords
            -- Current solution, pre-define the color before creation.
        else
            -- HUD change
            if dirty then -- Only update when changed
                player:hud_change(inotify.free_space_hud[pname], "text", ""..inotify.free_space[pname].."/"..inv:get_size("main").." "..string.format("%.0f", percent).."%")
                if percent < 25 then
                    player:hud_change(inotify.free_space_hud[pname], "number", inotify.colors.red)
                elseif percent < 50 and percent > 25 then
                    player:hud_change(inotify.free_space_hud[pname], "number", inotify.colors.orange)
                elseif percent < 75 and percent > 50 then
                    player:hud_change(inotify.free_space_hud[pname], "number", inotify.colors.yellow)
                elseif percent < 95 and percent > 75 then
                    player:hud_change(inotify.free_space_hud[pname], "number", inotify.colors.dark_green)
                elseif percent > 95 then
                    player:hud_change(inotify.free_space_hud[pname], "number", inotify.colors.green)
                end
            end
        end
    end
end)

minetest.register_on_leaveplayer(function(object, timed_out)
    inotify.free_space[object:get_player_name()] = nil
    inotify.free_space_hud[object:get_player_name()] = nil
end)
