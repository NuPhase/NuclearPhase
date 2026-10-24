// Refueling floor lid. Used to transfer fuel and take samples.
/obj/structure/fission_reactor_lid
	name = "BRO-SMUT refueling lid"
	desc = "Быстрый Реактор Опытный - С Металлическим Улучшенным Теплоносителем upper lid. Used for refueling and taking samples."
	anchored = TRUE
	density = FALSE
	appearance_flags = PIXEL_SCALE | LONG_GLIDE
	icon = 'icons/obj/machines/fission_lid.dmi'
	icon_state = "map"
	pixel_y = -112
	pixel_x = -112
	bound_width = 224
	bound_height = 224

/obj/structure/fission_reactor_lid/get_mechanics_info()
	return "Use a vial on it to get a sample."