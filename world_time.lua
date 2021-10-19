
inotify.worldt_hud = {}

function inotify.get_mi(hour)
    hr = tonumber(hour)
    if hr >= 0 and hr <= 11 then return 'am' end -- midnight->noon
    if hr >= 12 and hr <= 23 then return 'pm' end -- noon->midnight
    minetest.log("warning", "Could not get mi from "..tostring(hour))
end

function inotify.render_worldt(player, posi, off, align, scaler)
    local pname = player:get_player_name()
    -- Obtain world time
    local worldtime = math.floor((minetest.get_timeofday() * 24000) * 3.6)
    local day_count = minetest.get_day_count()

    local hours = os.date("!%I", worldtime)
    local minutes = os.date("!%M", worldtime)
    local mi = inotify.get_mi(os.date("!%H", worldtime))

    local time_stamp = ""..tostring(hours)..":"..tostring(minutes).." "..mi
    
    if inotify.include_day_count then
        time_stamp = time_stamp.." ("..tostring(day_count)..")"
    end

    --minetest.log("action", "World time "..tostring(worldtime).." Day Count "..tostring(day_count))
    --minetest.log("action", time_stamp)

    if inotify.worldt_hud[pname] == nil then
        local cl = inotify.colors.green -- Daytime == bright
        if mi == "am" then -- Nighttime == dark
            cl = inotify.colors.dark_green
        end
        inotify.worldt_hud[pname] = player:hud_add({
            hud_elem_type = "text",
            position = posi,
            offset = off,
            text = ""..time_stamp.."",
            alignment = align,
            scale = scaler,
            number = cl
        })
    else
        local cl = inotify.colors.green
        if mi == "am" then
            cl = inotify.colors.dark_green
        end
        player:hud_change(
            inotify.worldt_hud[pname],
            "text",
            ""..time_stamp..""
        )
        player:hud_change(
            inotify.worldt_hud[pname],
            "number",
            cl
        )
    end

end