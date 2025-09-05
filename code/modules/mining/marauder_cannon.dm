/obj/machinery/emitter/marauder
	name = "MARAUDER railgun"
	icon = 'icons/obj/machines/power/fusion.dmi'
	desc = "A coaxial plasma railgun. It can dump an insane amount of energy into a small plasma projectile, accelerating it to about 3% light speed. Surprisingly convenient for digging rocks."
	icon_state = "emitter-off"
	use_power = POWER_USE_IDLE
	active_power_usage = 5000000

	construct_state = /decl/machine_construction/default/panel_closed
	base_type = /obj/machinery/emitter/marauder

	uncreated_component_parts = list(
		/obj/item/stock_parts/power/apc
	)

	efficiency = 0.8
	fire_delay = 50
	burst_shots = 1
	core_skill = SKILL_DEVICES

	weight = 90

/obj/machinery/emitter/marauder/get_emitter_beam()
	return new /obj/item/projectile/beam/plasma_discharge(get_turf(src))

/obj/machinery/emitter/marauder/on_update_icon()
	if (active && (can_use_power_oneoff(active_power_usage) <= 0))
		icon_state = "emitter-on"
	else
		icon_state = "emitter-off"
