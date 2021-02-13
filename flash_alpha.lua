-- https://github.com/sotakoira/pandora-luas
ui.add_label("Works only after you get flashed for the first time on a map.")
local alpha_slider = ui.add_slider("Flash alpha", 1, 255)

function on_throw(event)
weapon = event:get_string("weapon")
if weapon == "flashbang" then
local_player = entity_list.get_client_entity(engine.get_local_player())
flFlashMaxAlpha = local_player:get_prop("DT_CSPlayer", "m_flFlashMaxAlpha")
if flFlashMaxAlpha:get_float() ~= alpha_slider:get() then
flFlashMaxAlpha:set_float(alpha_slider:get())
end
end
end

callbacks.register("grenade_thrown", on_throw)
