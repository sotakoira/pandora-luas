-- https://github.com/sotakoira/pandora-luas
-- https://github.com/danielkrupinski/Osiris/pull/2736/

local enable_dm_god = ui.add_checkbox("Enable deathmatch godmode")
local delay = 250 -- delay between commands
local curtime = global_vars.curtime

function godmode(event)

	if not engine.is_connected then
		return
	end

gm_active = enable_dm_god:get()
	if not gm_active then
		return
	end

game_mode = cvar.find_var("game_mode")
game_type = cvar.find_var("game_type")

	if not game_mode == 2 and not game_type == 1 then
		return
	end
	
localplayer = entity_list.get_client_entity(engine.get_local_player())
localplayer_isalive = localplayer:get_prop("DT_BasePlayer", "m_iHealth"):get_int() > 0
localplayer_isimmune = localplayer:get_prop("DT_CSPlayer", "m_bGunGameImmunity"):get_bool()

	if not localplayer_isalive or not localplayer_isimmune then
		return
	end
	
	if (global_vars.curtime < curtime + (delay / 1000)) then 
		return
	end
	
engine.execute_client_cmd("open_buymenu")
curtime = global_vars.curtime

end

function reset(event)
if engine.get_player_for_user_id(event:get_int("userid")) == engine.get_local_player() then
curtime = 0
end
end

callbacks.register("player_connect_full", reset)
callbacks.register("paint", godmode)