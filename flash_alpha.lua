-- https://github.com/sotakoira/pandora-luas
local alpha_slider = ui.add_slider("Flash alpha", 1, 255)

function main()
if engine.is_connected() then
local_player = entity_list.get_client_entity(engine.get_local_player())
local_player:get_prop("DT_CSPlayer", "m_flFlashMaxAlpha"):set_float(alpha_slider:get())
end
end

callbacks.register("paint", main)