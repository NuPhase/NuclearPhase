/obj/machinery/atmospherics/unary/caster
	name = "Hellcat X115 caster"
	desc = "A hillariously named casting press made for liquid metals."
	icon = 'icons/obj/machines/large_casting_machine.dmi'
	icon_state = "map"
	bound_height = 64
	bound_width = 64
	density = 1
	appearance_flags = PIXEL_SCALE | LONG_GLIDE
	var/obj/machinery/portable_atmospherics/contained_canister
	var/operating = FALSE
	var/obj/effect/cover_overlay
	var/datum/sound_token/sound_token
	var/sound_id
	var/datum/beam/connection_beam

/obj/machinery/atmospherics/unary/caster/Initialize()
	. = ..()
	icon_state = "bottom"
	cover_overlay = new
	cover_overlay.icon = 'icons/obj/machines/large_casting_machine.dmi'
	cover_overlay.icon_state = "top"
	cover_overlay.layer = ABOVE_HUMAN_LAYER
	cover_overlay.mouse_opacity = MOUSE_OPACITY_UNCLICKABLE
	cover_overlay.forceMove(get_turf(src))
	sound_id = "[/obj/machinery/atmospherics/unary/caster]_[sequential_id(/obj/machinery/atmospherics/unary/caster)]"

/obj/machinery/atmospherics/unary/caster/MouseDrop(over_object, src_location, over_location)
	. = ..()
	if(!istype(over_object, /obj/machinery/portable_atmospherics))
		return
	if(!Adjacent(over_object))
		return

	if(contained_canister)
		visible_message("\The [contained_canister] is disconnected from \the [src]")
		contained_canister = null
		playsound(src, 'sound/machines/podopen.ogg', 50, 0)
		QDEL_NULL(connection_beam)
	else if(over_object)
		if(!do_after(usr, 30, over_object))
			return
		if(contained_canister)
			return
		visible_message("\The [usr] connects \the [over_object] to \the [src].")
		contained_canister = over_object
		playsound(src, 'sound/machines/podclose.ogg', 50, 0)
		connection_beam = Beam(contained_canister, "1-full", time = INFINITY, beam_color = COLOR_DARK_ORANGE)

/obj/machinery/atmospherics/unary/caster/physical_attack_hand(user)
	. = ..()
	tgui_interact(user)

/obj/machinery/atmospherics/unary/caster/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "MetalCaster", "Metal Caster")
		ui.open()

/obj/machinery/atmospherics/unary/caster/tgui_data(mob/user)
	return list("has_canister" = contained_canister,
				"canister_content_mass" = (contained_canister ? contained_canister.air_contents.get_mass() : 0),
				"canister_content_temperature" = (contained_canister ? contained_canister.air_contents.temperature : T20C),
				"is_operating" = operating)

/obj/machinery/atmospherics/unary/caster/tgui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	switch(action)
		if("start")
			if(!operating && params["cast_type"])
				var/cast_string = params["cast_type"]
				var/cast_type
				switch(cast_string)
					if("ingot")
						cast_type = /obj/item/stack/material/ingot
					if("rod")
						cast_type = /obj/item/stack/material/rods
					if("sheet")
						cast_type = /obj/item/stack/material/sheet
				start(cast_type)
			return TRUE
		if("stop")
			if(operating)
				stop()
			return TRUE
		if("remove_canister")
			if(contained_canister)
				eject_canister()
			return TRUE

/obj/machinery/atmospherics/unary/caster/proc/start(cast_type)
	operating = TRUE
	playsound(src, 'sound/machines/quiet_beep.ogg', 50)
	spawn(5)
		playsound(src, 'sound/machines/airlock_alarm.wav', 20, 0)
	spawn(15)
		place_cover()
	spawn(35)
		sound_token = play_looping_sound(src, sound_id, 'sound/machines/metal_caster/working.wav', 50, 10, 3)
	spawn(215)
		QDEL_NULL(sound_token)
		remove_cover()
	spawn(235)
		if(operating)
			try_cast(cast_type)
			operating = FALSE

/obj/machinery/atmospherics/unary/caster/proc/place_cover() //move -37 Y degrees
	playsound(src, 'sound/machines/metal_caster/upper_move.wav', 50, 0)
	cover_overlay.pixel_y = 0
	animate(cover_overlay, pixel_y = -37, 30, easing = SINE_EASING)

/obj/machinery/atmospherics/unary/caster/proc/remove_cover() //move +37 Y degrees
	playsound(src, 'sound/machines/metal_caster/upper_move.wav', 50, 0)
	cover_overlay.pixel_y = -37
	animate(cover_overlay, pixel_y = 0, 30, easing = SINE_EASING)

/obj/machinery/atmospherics/unary/caster/proc/stop()
	operating = FALSE
	QDEL_NULL(sound_token)
	remove_cover()
	return

/obj/machinery/atmospherics/unary/caster/proc/eject_canister()
	if(!contained_canister)
		return
	visible_message("\The [contained_canister] is disconnected from \the [src]")
	contained_canister = null
	playsound(src, 'sound/machines/podopen.ogg', 50, 0)
	QDEL_NULL(connection_beam)
	return

/obj/machinery/atmospherics/unary/caster/proc/try_cast(cast_type)
	if(!contained_canister)
		return
	var/used_mat
	for(var/mat in contained_canister.air_contents.liquids)
		used_mat = mat
		break
	if(!used_mat)
		return
	//var/decl/material/mat_datum = GET_DECL(used_mat)
	var/total_available_mass = contained_canister.air_contents.get_mass()
	if(12 > total_available_mass)
		return
	var/moles_to_remove = total_available_mass / contained_canister.air_contents.specific_mass()
	contained_canister.air_contents.remove(moles_to_remove)
	SSmaterials.create_object(used_mat, get_turf(src), total_available_mass / 12, cast_type)