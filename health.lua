
-- Health stat
inotify.health = {}
inotify.health_hud = {}

function inotify.render_health(player, pos, off, align, scaler)
    local pname = player:get_player_name()
    -- = Obtain HP and Max HP =
    local hp = player:get_hp()
    local hp_max = player:get_properties().hp_max
    -- = Form HP percent
    local hp_perc = (hp / hp_max) * 100
    -- = Check if in the health tracker, check if needing update to HUD
    local dirty = true -- Assume we do need to update
    if inotify.health[pname] ~= nil then
        if inotify.health[pname] == hp then
            dirty = false
        else
            inotify.health[pname] = hp
        end
    else
        inotify.health[pname] = hp
    end
    -- = Form HUD stat =
    if inotify.health_hud[pname] == nil then
        local color = inotify.colors.white
        if hp_perc <= 25 then
            color = inotify.colors.red
        elseif hp_perc <= 50 and hp_perc > 25 then
            color = inotify.colors.orange
        elseif hp_perc <= 75 and hp_perc > 50 then
            color = inotify.colors.yellow
        elseif hp_perc <= 95 and hp_perc > 75 then
            color = inotify.colors.dark_green
        elseif hp_perc > 95 then
            color = inotify.colors.green
        end
        inotify.health_hud[pname] = player:hud_add({
            hud_elem_type = "text",
            position      = pos,
            offset        = off,
            text          = "HP: "..string.format("%.0f", hp_perc).."%",
            alignment     = align,
            scale         = scaler,
            number        = color,
        })
    else
        if dirty then
            player:hud_change(inotify.health_hud[pname], "text", "HP: "..string.format("%.0f", hp_perc).."%")
            local color = inotify.colors.white
            if hp_perc <= 25 then
                color = inotify.colors.red
            elseif hp_perc <= 50 and hp_perc > 25 then
                color = inotify.colors.orange
            elseif hp_perc <= 75 and hp_perc > 50 then
                color = inotify.colors.yellow
            elseif hp_perc <= 95 and hp_perc > 75 then
                color = inotify.colors.dark_green
            elseif hp_perc > 95 then
                color = inotify.colors.green
            end
            player:hud_change(inotify.health_hud[pname], "number", color)
        end
    end
end

--[[ Disabled, see init.lua
-- Actively obtain players health
minetest.register_globalstep(function(dtime)
    for _, player in ipairs(minetest.get_connected_players()) do
        inotify.render_health(
            player,
            {x=0.5, y=0.90},
            {x=-500, y=-20},
            {x=0, y=0},
            {x=100, y=100}
        )
    end
end)

-- Attempt to cleanup any stale player info
minetest.register_on_leaveplayer(function(object, timed_out)
    inotify.health[object:get_player_name()] = nil
    inotify.health_hud[object:get_player_name()] = nil
end)
]]
