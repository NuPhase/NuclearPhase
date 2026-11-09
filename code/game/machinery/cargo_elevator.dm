/obj/machinery/computer/cargocontrol
	name = "warehouse terminal"
	desc = "A cheap laptop."
	icon_state = "off"
	icon_keyboard = null
	icon_screen = "blank"
	density = 0
	var/list/item_cart = list() // type = amount
	var/list/fluid_cart = list() // type = list(amount, container_string)
	// container string can be: canister, barrel, bottle, ingots

/obj/machinery/computer/cargocontrol/interface_interact(user)
	tgui_interact(user)
	return TRUE

/obj/machinery/computer/cargocontrol/physical_attack_hand(user)
	tgui_interact(user)
	return TRUE

/obj/machinery/computer/cargocontrol/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "CargoTerminal", "Cargo Terminal")
		ui.open()

/obj/machinery/computer/cargocontrol/tgui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	switch(action)
		if("raise")
			warehouse_elevator.raise(item_cart, fluid_cart)
			item_cart.Cut()
			fluid_cart.Cut()
		if("lower")
			warehouse_elevator.lower()
		if("cartItem")
			var/item_type = text2path(params["itemType"])
			if(!item_type)
				return
			if(item_type in item_cart)
				return
			item_cart[item_type] = 1
			playsound(src, 'sound/machines/chime.ogg', 50)
		if("cartFluid")
			var/fluid_type = text2path(params["fluidType"])
			if(!fluid_type)
				return
			if(fluid_type in fluid_cart)
				return
			fluid_cart[fluid_type] = list(1, "barrel")
			playsound(src, 'sound/machines/chime.ogg', 50)
		if("uncartItem")
			var/item_type = text2path(params["itemType"])
			if(!item_type)
				return
			if(!(item_type in item_cart))
				return
			item_cart -= item_type
			playsound(src, 'sound/machines/chime.ogg', 50)
		if("uncartFluid")
			var/fluid_type = text2path(params["fluidType"])
			if(!fluid_type)
				return
			if(!(fluid_type in fluid_cart))
				return
			fluid_cart -= fluid_type
			playsound(src, 'sound/machines/chime.ogg', 50)
		if("setCartItemAmount")
			var/item_type = text2path(params["itemType"])
			if(!item_type)
				return
			item_cart[item_type] = Clamp(params["newAmount"], 1, SSpersistence.loaded_item_pool[item_type])
			playsound(src, "keyboard", 50)
		if("setCartFluidAmount")
			var/fluid_type = text2path(params["fluidType"])
			if(!fluid_type)
				return
			fluid_cart[fluid_type][1] = Clamp(params["newAmount"], 1, SSpersistence.fluid_pool[fluid_type])
			playsound(src, "keyboard", 50)
		if("setCartFluidContainer")
			var/fluid_type = text2path(params["fluidType"])
			if(!fluid_type)
				return
			var/container_string = params["newContainer"]
			if(!(container_string in list("canister", "barrel", "bottle", "ingots")))
				return
			fluid_cart[fluid_type][2] = container_string
			playsound(src, "keyboard", 50)

/obj/machinery/computer/cargocontrol/tgui_static_data(mob/user)
	var/list/data = list(
		"items" = assemble_item_list(),
		"fluids" = assemble_fluid_list()
	)
	return data

/obj/machinery/computer/cargocontrol/tgui_data(mob/user)
	var/list/data = list(
		"itemCart" = assemble_item_cart(),
		"fluidCart" = assemble_fluid_cart()
	)
	return data

/obj/machinery/computer/cargocontrol/proc/assemble_item_cart()
	var/list/item_list = list()
	for(var/item_type in item_cart)
		var/obj/item/O = item_type
		item_list += list(list("name" = capitalize(O::name), "amount" = item_cart[item_type], "type" = item_type, "maxAmount" = SSpersistence.loaded_item_pool[item_type]))
	return item_list

/obj/machinery/computer/cargocontrol/proc/assemble_fluid_cart()
	var/list/fluid_list = list()
	for(var/fluid_type in fluid_cart)
		var/decl/material/mat = GET_DECL(fluid_type)
		fluid_list += list(list("name" = mat.name, "amount" = fluid_cart[fluid_type][1], "type" = fluid_type, "container" = fluid_cart[fluid_type][2], "maxAmount" = SSpersistence.fluid_pool[fluid_type]))
	return fluid_list

/obj/machinery/computer/cargocontrol/proc/assemble_item_list()
	var/list/item_list = list()
	for(var/item_type in SSpersistence.loaded_item_pool)
		var/obj/item/O = item_type
		item_list += list(list("name" = capitalize(O::name), "amount" = SSpersistence.loaded_item_pool[item_type], "weight" = O::weight, "type" = item_type))
	return item_list

/obj/machinery/computer/cargocontrol/proc/assemble_fluid_list()
	var/list/fluid_list = list()
	for(var/fluid_type in SSpersistence.fluid_pool)
		if(!SSpersistence.fluid_pool[fluid_type])
			continue // nothing left
		var/decl/material/mat = GET_DECL(fluid_type)
		fluid_list += list(list(
			"name" = mat.name,
			"color" = mat.color,
			"amount" = SSpersistence.fluid_pool[fluid_type],
			"molarVolume" = mat.molar_volume,
			"molarMass" = mat.molar_mass,
			"toxicity" = mat.toxicity,
			"radioactivity" = mat.radioactivity,
			"loreText" = mat.lore_text,
			"type" = fluid_type
		))
	return fluid_list

var/global/obj/machinery/cargo_elevator/warehouse_elevator

/obj/machinery/cargo_elevator
	name = "cargo elevator"
	desc = "An elevator connecting to an automated storage system."
	icon = 'icons/obj/machines/cargo_elevator.dmi'
	icon_state = "supply_elevator_lowered"
	layer = CATWALK_LAYER
	use_power = POWER_USE_IDLE
	density = FALSE
	anchored = TRUE
	bound_width = 160
	bound_height = 160
	idle_power_usage = 5000
	active_power_usage = 70000
	var/raised = FALSE

/obj/machinery/cargo_elevator/Initialize()
	. = ..()
	warehouse_elevator = src

/obj/machinery/cargo_elevator/Destroy()
	. = ..()
	warehouse_elevator = null

/obj/machinery/cargo_elevator/Cross(O, mustcheck)
	. = ..()
	if(raised)
		return
	if(ismob(O))
		var/mob/M = O
		M.ghostize(FALSE)
	visible_message(SPAN_DANGER("[O] falls into \the [src]!"))
	qdel(O)

/obj/machinery/cargo_elevator/proc/raise(list/item_cart, list/fluid_cart)
	if(raised)
		return
	raised = TRUE
	flick("supply_elevator_raising", src)
	icon_state = "supply_elevator_raised"
	sleep(20)
	for(var/item_type in item_cart)
		var/obj/item/I = item_type // type
		var/turf/T = pick(locs)
		var/list/spawn_list = list()
		spawn_list[item_type] = item_cart[item_type]
		create_objects_in_loc_pooled(T, spawn_list)
		var/crate_type
		switch(item_cart[item_type])
			if(5 to 30)
				crate_type = /obj/structure/closet/crate
			if(30 to INFINITY)
				crate_type = /obj/structure/largecrate
		if(crate_type)
			var/obj/spawned_crate = new crate_type(T)
			spawned_crate.name = "[spawned_crate.name] - [initial(I.name)]"
			if(crate_type == /obj/structure/closet/crate)
				var/obj/structure/closet/crate/cc = spawned_crate
				cc.store_contents()
	for(var/fluid_type in fluid_cart)
		var/turf/T = pick(locs)
		var/list/fluid_info = fluid_cart[fluid_type]
		switch(fluid_info[2])
			if("canister")
				var/obj/machinery/portable_atmospherics/canister/empty/spawned_canister = new(T)
				var/decl/material/mat = GET_DECL(fluid_type)
				var/spawn_amount = fluid_info[1]
				var/max_amount
				if(mat.phase_at_temperature(T20C, ONE_ATMOSPHERE) == MAT_PHASE_GAS)
					max_amount = (MAX_PUMP_PRESSURE * spawned_canister.volume) / (R_IDEAL_GAS_EQUATION * T20C)
				else
					max_amount = spawned_canister.volume * 0.001 * mat.liquid_density / mat.gas_molar_mass
				spawn_amount = min(spawn_amount, max_amount)
				spawn_amount = min(spawn_amount, SSpersistence.take_reagent(fluid_type, spawn_amount))
				spawn_amount /= mat.molar_volume
				spawn_amount = min(max_amount, spawn_amount)
				spawned_canister.air_contents.pressure = ONE_ATMOSPHERE
				spawned_canister.name = "\improper Canister \[[capitalize(mat.name)]\]"
				spawned_canister.air_contents.adjust_gas(fluid_type, spawn_amount)
			if("barrel")
				var/obj/structure/reagent_dispensers/barrel/spawned_barrel = new(T)
				var/decl/material/mat = GET_DECL(fluid_type)
				var/spawn_amount = fluid_info[1]
				spawn_amount = min(spawn_amount, spawned_barrel.reagents.maximum_volume)
				spawn_amount = min(spawn_amount, SSpersistence.take_reagent(fluid_type, spawn_amount))
				spawned_barrel.reagents.add_reagent(fluid_type, spawn_amount)
				spawned_barrel.color = mat.color
				spawned_barrel.name = "[spawned_barrel.name] - [mat.name]"
				spawned_barrel.update_icon()
			if("bottle")
				var/obj/item/chems/glass/bottle/spawned_bottle = new(T)
				var/decl/material/mat = GET_DECL(fluid_type)
				var/spawn_amount = fluid_info[1]
				spawn_amount = min(spawn_amount, spawned_bottle.reagents.maximum_volume)
				spawn_amount = min(spawn_amount, SSpersistence.take_reagent(fluid_type, spawn_amount))
				spawned_bottle.reagents.add_reagent(fluid_type, spawn_amount)
				spawned_bottle.label_text = mat.name
				spawned_bottle.update_name_label()
				spawned_bottle.update_icon()
			if("ingots")
				var/spawn_amount = fluid_info[1]
				spawn_amount = min(spawn_amount, SSpersistence.take_reagent(fluid_type, spawn_amount))
				SSmaterials.create_object(fluid_type, T, spawn_amount / SHEET_MATERIAL_AMOUNT, /obj/item/stack/material/ingot)

/obj/machinery/cargo_elevator/proc/lower()
	if(has_items_on_platform())
		state("Cannot lower with a loaded platform.")
		return
	if(!raised)
		return
	raised = FALSE
	flick("supply_elevator_lowering", src)
	icon_state = "supply_elevator_lowered"

/obj/machinery/cargo_elevator/proc/has_items_on_platform()
	for(var/turf/T in locs)
		for(var/obj/item/I in T)
			return TRUE
	return FALSE