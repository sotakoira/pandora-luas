-- https://github.com/sotakoira/pandora-luas
local revealer_logs = ui.add_checkbox("Logs")
local revealer_logs_color = ui.add_colorpicker("Logs color")
local revealer_mode = ui.add_dropdown("Mode", {"none", "say", "say_team", "playerchatwheel"})
local playerchatwheel_color = ui.add_dropdown("playerchatwheel - Color", {"default", "white", "green", "blue", "darkblue", "darkred", "gold", "grey", "lightgreen", "lightred", "lime", "orchid", "yellow", "palered"})
local queue_delay = ui.add_slider("Delay", 700, 2000)

local radio_colors = {
"",
"",
"",
"",
"",
"",
"",
"",
"",
"",
"",
"",
"	",
"",
}
queue_delay:set_visible(false)
playerchatwheel_color:set_visible(false)

local options = {}
local queue = {}
local curtime = global_vars.curtime

function vote_options(event)
    for i = 0, event:get_int("count") do
        options[i] = event:get_string("option" .. (i + 1)):lower()
    end
end

function vote_cast(event)
mode = revealer_mode:get()
logs = revealer_logs:get()
if mode == 0 and not logs then

return
end

	entityid = event:get_int("entityid")
	if (entityid) then
	team = event:get_int("team")
	vote_option = event:get_int("vote_option")
	entityid_info = engine.get_player_info(entityid)
	entityid_name = entityid_info.name
	choice = options[vote_option]
	if team == 2 then team = "[Terrorists] "
	elseif team == 3 then team = "[Counter-Terrorists] "
	else team = "[Vote] "
	end
	
	msg = (team .. entityid_name .. " voted " .. choice)
	
	if logs then
	client.log(msg, revealer_logs_color:get(), "vote")
	end
	
	if (mode == 1 or mode == 2) then -- say + say_team
		table.insert(queue, msg)
		return
		end

		if (mode == 3) then -- playerchatwheel
		picked_color = playerchatwheel_color:get()
		engine.execute_client_cmd("playerchatwheel . \"" .. radio_colors[picked_color + 1] .. msg .. "\"")
		return
		end

	end

end

function queue_main(event) 
		vischeck()
		mode = revealer_mode:get()
		connected = engine.is_connected()
		delay = queue_delay:get()
		
		if ((mode == 0 or mode == 3) or not connected or #queue == 0 ) then -- none
		return
		end
		if (global_vars.curtime < curtime + (delay / 1000)) then -- queue_delay
		return
		end
		if mode == 1 then -- say
		engine.execute_client_cmd("say " .. table.remove(queue));
		curtime = global_vars.curtime
		return
		end
		
		if mode == 2 then -- say_team
		engine.execute_client_cmd("say_team " .. table.remove(queue));
		curtime = global_vars.curtime 
		return
		end

end

function reset(event)
if engine.get_player_for_user_id(event:get_int("userid")) == engine.get_local_player() then
curtime = 0
end
end

function vischeck(event)
vis_open = ui.is_open()
vis_mode = revealer_mode:get()


if vis_mode == 1 or vis_mode == 2 and vis_open then
queue_delay:set_visible(true)
else queue_delay:set_visible(false)
end

if vis_mode == 3 and vis_open then
playerchatwheel_color:set_visible(true)
else playerchatwheel_color:set_visible(false)
end
end

callbacks.register("vote_options", vote_options)
callbacks.register("vote_cast", vote_cast)
callbacks.register("player_connect_full", reset)
callbacks.register("paint", queue_main)
