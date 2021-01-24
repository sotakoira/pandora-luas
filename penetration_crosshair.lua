-- https://github.com/sotakoira/pandora-luas
ui.add_label("Aiming at player color")
local atplayer = ui.add_colorpicker("Aiming at player")
ui.add_label("Regular color")
local noplayer = ui.add_colorpicker("Regular")

function on_paint()  
    local_player = entity_list.get_client_entity(engine.get_local_player())

    if not engine.in_game() then
        return
    end

    if local_player == nil then 
        return
    end
    
    if local_player:get_prop("DT_BasePlayer", "m_iHealth"):get_int() <= 0 then
        return
    end
	
	penetration_damage = penetration.damage()
	aiming_at_player = penetration.aiming_at_player()
	
	if penetration_damage > 0 and aiming_at_player then render.add_indicator(tostring(penetration_damage), atplayer:get())
	elseif penetration_damage > 0 and not aiming_at_player then render.add_indicator(tostring(penetration_damage), noplayer:get())
	else return
	end
end

callbacks.register("paint", on_paint)