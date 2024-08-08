/obj/machinery/portable_atmospherics/canister
	name = "\improper Canister: \[CAUTION\]"
	desc = "A 700L canister. 61kg empty weight."
	icon = 'icons/obj/atmospherics/canisters.dmi'
	icon_state = "yellow"
	density = 1
	var/health = 100.0
	obj_flags = OBJ_FLAG_CONDUCTIBLE
	w_class = ITEM_SIZE_GARGANTUAN
	construct_state = /decl/machine_construction/pipe/welder
	uncreated_component_parts = null
	matter = list(
		/decl/material/solid/metal/steel = 10 * SHEET_MATERIAL_AMOUNT
	)

	var/valve_open = 0
	var/release_pressure = ONE_ATMOSPHERE
	var/release_flow_rate = ATMOS_DEFAULT_VOLUME_PUMP //in L/s

	var/canister_color = "yellow"
	var/can_label = 1
	start_pressure = 12 * ONE_ATMOSPHERE
	var/temperature_resistance = 1000 + T0C
	volume = 700
	interact_offline = 1 // Allows this to be used when not in powered area.
	var/update_flag = 0
	weight = 61

/obj/machinery/portable_atmospherics/canister/Initialize(mapload, material)
	if(ispath(material))
		matter = list()
		matter[material] = 10 * SHEET_MATERIAL_AMOUNT
	. = ..(mapload)

/obj/machinery/portable_atmospherics/canister/drain_power()
	return -1

/obj/machinery/portable_atmospherics/canister/sleeping_agent
	name = "\improper Canister: \[N2O\]"
	icon_state = "redws"
	canister_color = "redws"
	can_label = 0
	initial_gas = list(/decl/material/gas/nitrous_oxide = 1)

/obj/machinery/portable_atmospherics/canister/nitrogen
	name = "\improper Canister: \[N2\]"
	icon_state = "red"
	canister_color = "red"
	can_label = 0
	initial_gas = list(/decl/material/gas/nitrogen = 1)

/obj/machinery/portable_atmospherics/canister/nitrogen/prechilled
	name = "\improper Canister: \[N2 (Cooling)\]"

/obj/machinery/portable_atmospherics/canister/oxygen
	name = "\improper Canister: \[O2\]"
	icon_state = "blue"
	canister_color = "blue"
	can_label = 0
	initial_gas = list(/decl/material/gas/oxygen = 1)

/obj/machinery/portable_atmospherics/canister/oxygen/prechilled
	name = "\improper Canister: \[O2 (Cryo)\]"
	start_pressure = 20 * ONE_ATMOSPHERE

/obj/machinery/portable_atmospherics/canister/hydrogen
	name = "\improper Canister: \[Hydrogen\]"
	icon_state = "purple"
	canister_color = "purple"
	can_label = 0
	initial_gas = list(/decl/material/gas/hydrogen = 1)

/obj/machinery/portable_atmospherics/canister/water
	name = "\improper Canister: \[Water\]"
	icon_state = "water"
	can_label = 0
	start_pressure = ONE_ATMOSPHERE*1.5
	initial_gas = list(/decl/material/liquid/water = 0.99, /decl/material/gas/nitrogen = 0.01)

/obj/machinery/portable_atmospherics/canister/water/tall
	name = "\improper Industrial Tank: \[Water\]"
	volume = 95000 //2m radius, 8m height
	icon = 'icons/obj/atmospherics/96x192.dmi'
	icon_state = "water"
	canister_color = "water"
	layer = ABOVE_HUMAN_LAYER
	start_dirty = TRUE
	dirt_sprites_amount = 4

/obj/machinery/portable_atmospherics/canister/empty/water
	icon_state = "purple"
	canister_type = /obj/machinery/portable_atmospherics/canister/water

/obj/machinery/portable_atmospherics/canister/carbon_dioxide
	name = "\improper Canister \[CO2\]"
	icon_state = "black"
	canister_color = "black"
	can_label = 0
	initial_gas = list(/decl/material/gas/carbon_dioxide = 1)

/obj/machinery/portable_atmospherics/canister/tungstenhexafluoride
	name = "\improper Canister \[WF6\]"
	icon_state = "wf6"
	canister_color = "wf6"
	can_label = 0
	initial_gas = list(/decl/material/gas/tungstenhexafluoride = 1)

/obj/machinery/portable_atmospherics/canister/empty/tungstenhexafluoride
	icon_state = "wf6"
	canister_type = /obj/machinery/portable_atmospherics/canister/tungstenhexafluoride

/obj/machinery/portable_atmospherics/canister/reactor
	name = "\improper Canister \[W\]"
	icon_state = "black"
	canister_color = "black"
	can_label = 0
	initial_gas = list(/decl/material/solid/metal/tungsten = 0.95, /decl/material/gas/nitrogen = 0.05)
	start_temperature = 4200

/obj/machinery/portable_atmospherics/canister/empty/reactor
	icon_state = "black"
	canister_type = /obj/machinery/portable_atmospherics/canister/reactor

/obj/machinery/portable_atmospherics/canister/air
	name = "\improper Canister \[Air\]"
	icon_state = "grey"
	canister_color = "grey"
	can_label = 0

/obj/machinery/portable_atmospherics/canister/air/airlock
	start_pressure = 3 * ONE_ATMOSPHERE

/obj/machinery/portable_atmospherics/canister/empty
	start_pressure = 0
	can_label = 1
	var/obj/machinery/portable_atmospherics/canister/canister_type = /obj/machinery/portable_atmospherics/canister

/obj/machinery/portable_atmospherics/canister/empty/Initialize()
	. = ..()
	name = 	initial(canister_type.name)
	icon_state = 	initial(canister_type.icon_state)
	canister_color = 	initial(canister_type.canister_color)

/obj/machinery/portable_atmospherics/canister/empty/air
	icon_state = "grey"
	canister_type = /obj/machinery/portable_atmospherics/canister/air
/obj/machinery/portable_atmospherics/canister/empty/oxygen
	icon_state = "blue"
	canister_type = /obj/machinery/portable_atmospherics/canister/oxygen
/obj/machinery/portable_atmospherics/canister/empty/nitrogen
	icon_state = "red"
	canister_type = /obj/machinery/portable_atmospherics/canister/nitrogen
/obj/machinery/portable_atmospherics/canister/empty/carbon_dioxide
	icon_state = "black"
	canister_type = /obj/machinery/portable_atmospherics/canister/carbon_dioxide
/obj/machinery/portable_atmospherics/canister/empty/sleeping_agent
	icon_state = "redws"
	canister_type = /obj/machinery/portable_atmospherics/canister/sleeping_agent
/obj/machinery/portable_atmospherics/canister/empty/hydrogen
	icon_state = "purple"
	canister_type = /obj/machinery/portable_atmospherics/canister/hydrogen




/obj/machinery/portable_atmospherics/canister/proc/check_change()
	var/old_flag = update_flag
	update_flag = 0
	if(holding)
		update_flag |= 1
	if(connected_port)
		update_flag |= 2

	var/tank_pressure = return_pressure()
	if(tank_pressure < 10)
		update_flag |= 4
	else if(tank_pressure < ONE_ATMOSPHERE)
		update_flag |= 8
	else if(tank_pressure < 15*ONE_ATMOSPHERE)
		update_flag |= 16
	else
		update_flag |= 32

	if(update_flag == old_flag)
		return 1
	else
		return 0

/obj/machinery/portable_atmospherics/canister/on_update_icon()
/*
update_flag
1 = holding
2 = connected_port
4 = tank_pressure < 10
8 = tank_pressure < ONE_ATMOS
16 = tank_pressure < 15*ONE_ATMOS
32 = tank_pressure go boom.
*/

	if (src.destroyed)
		overlays.Cut()
		src.icon_state = text("[]-1", src.canister_color)
		return

	if(icon_state != "[canister_color]")
		icon_state = "[canister_color]"

	if(check_change()) //Returns 1 if no change needed to icons.
		return

	weight = initial(weight) + air_contents.get_mass()
	overlays.Cut()

	if(update_flag & 1)
		overlays += "can-open"
	if(update_flag & 2)
		overlays += "can-connector"
	if(update_flag & 4)
		overlays += "can-o0"
	if(update_flag & 8)
		overlays += "can-o1"
	else if(update_flag & 16)
		overlays += "can-o2"
	else if(update_flag & 32)
		overlays += "can-o3"
	return

/obj/machinery/portable_atmospherics/canister/fire_act(datum/gas_mixture/air, exposed_temperature, exposed_volume)
	if(exposed_temperature > temperature_resistance)
		health -= 5
		healthcheck()
	return ..()

/obj/machinery/portable_atmospherics/canister/proc/healthcheck()
	if(destroyed)
		return 1

	if (src.health <= 10)
		var/atom/location = src.loc
		location.assume_air(air_contents)

		src.destroyed = 1
		playsound(src.loc, 'sound/effects/tank_rupture.wav', 10, 1, -3)
		src.set_density(0)
		update_icon()

		if (src.holding)
			src.holding.dropInto(loc)
			src.holding = null

		return 1
	else
		return 1

/obj/machinery/portable_atmospherics/canister/dismantle()
	var/turf/T = get_turf(src)
	if(T)
		T.assume_air(air_contents)
	for(var/path in matter)
		SSmaterials.create_object(path, get_turf(src), round(matter[path]/SHEET_MATERIAL_AMOUNT))
	qdel(src)

/obj/machinery/portable_atmospherics/canister/Process()
	if (destroyed)
		return

	..()

	if(valve_open)
		var/datum/gas_mixture/environment
		if(holding)
			environment = holding.air_contents
		else
			environment = loc.return_air()
		for(var/g in air_contents.gas)
			if(air_contents.phases[g] == MAT_PHASE_LIQUID)
				var/turf/target = get_turf(src)
				var/obj/effect/fluid/F = locate() in target
				var/decl/material/mat = GET_DECL(g)
				if(!F) F = new(target)
				var/condense_reagent_amt = air_contents.gas[g] * mat.molar_volume * 0.3 + 0.1
				F.reagents.add_reagent(g, condense_reagent_amt)
				F.temperature = air_contents.temperature
				air_contents.gas.Remove(g)

		var/env_pressure = environment.return_pressure()
		var/pressure_delta = release_pressure - env_pressure

		if((air_contents.temperature > 0) && (pressure_delta > 0))
			var/transfer_moles = calculate_transfer_moles(air_contents, environment, pressure_delta)
			transfer_moles = min(transfer_moles, (release_flow_rate/air_contents.volume)*air_contents.total_moles) //flow rate limit

			var/returnval = pump_gas_passive(src, air_contents, environment, transfer_moles)
			if(returnval >= 0)
				src.update_icon()
				if(holding)
					holding.queue_icon_update()

	if(air_contents.return_pressure() < 1)
		can_label = 1
	else
		can_label = 0

	air_contents.fire_react()

/obj/machinery/portable_atmospherics/canister/proc/return_temperature()
	var/datum/gas_mixture/GM = src.return_air()
	if(GM && GM.volume>0)
		return GM.temperature
	return 0

/obj/machinery/portable_atmospherics/canister/proc/return_pressure()
	var/datum/gas_mixture/GM = src.return_air()
	if(GM && GM.volume>0)
		return GM.return_pressure()
	return 0

/obj/machinery/portable_atmospherics/canister/bullet_act(var/obj/item/projectile/Proj)
	if(!(Proj.damage_type == BRUTE || Proj.damage_type == BURN))
		return

	if(Proj.damage)
		src.health -= round(Proj.damage / 2)
		healthcheck()
	..()

/obj/machinery/portable_atmospherics/canister/bash(var/obj/item/W, var/mob/user)
	. = ..()
	if(.)
		health -= W.force
		healthcheck()

/obj/machinery/portable_atmospherics/canister/attackby(var/obj/item/W, var/mob/user)
	if(istype(user, /mob/living/silicon/robot) && istype(W, /obj/item/tank/jetpack))
		var/obj/item/tank/jetpack/pack = W
		var/datum/gas_mixture/thejetpack = pack.air_contents
		if(!thejetpack)
			return FALSE
		var/env_pressure = thejetpack.return_pressure()
		var/pressure_delta = min(10*ONE_ATMOSPHERE - env_pressure, (air_contents.return_pressure() - env_pressure)/2)
		//Can not have a pressure delta that would cause environment pressure > tank pressure
		var/transfer_moles = 0
		if((air_contents.temperature > 0) && (pressure_delta > 0))
			transfer_moles = pressure_delta*thejetpack.volume/(air_contents.temperature * R_IDEAL_GAS_EQUATION)//Actually transfer the gas
			var/datum/gas_mixture/removed = air_contents.remove(transfer_moles)
			thejetpack.merge(removed)
			to_chat(user, "You pulse-pressurize your jetpack from the tank.")
			return TRUE
		return FALSE

	. = ..()

	SSnano.update_uis(src) // Update all NanoUIs attached to src

/obj/machinery/portable_atmospherics/canister/interface_interact(mob/user)
	tgui_interact(user)
	return TRUE

/obj/machinery/portable_atmospherics/canister/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "Canister", "Canister Manipulation")
		ui.open()
		ui.set_autoupdate(TRUE)

/obj/machinery/portable_atmospherics/canister/tgui_data(mob/user)
	var/list/data = list(
		"portConnected" = connected_port ? 1 : 0,
		"tankPressure" = round(air_contents.return_pressure() ? air_contents.return_pressure() : 0),
		"tankLevel" = round(((air_contents.volume - air_contents.available_volume) / air_contents.volume)*100),
		"releasePressure" = round(release_pressure ? release_pressure : 0),
		"valveOpen" = valve_open ? 1 : 0,
		"isPrototype" = FALSE,
		"hasHoldingTank" = holding ? 1 : 0,
		"restricted" = can_label ? 1 : 0,
		"defaultReleasePressure" = TANK_DEFAULT_RELEASE_PRESSURE,
		"minReleasePressure" = round(ONE_ATMOSPHERE/10),
		"maxReleasePressure" = round(10*ONE_ATMOSPHERE),
		"pressureLimit" = round(MAX_TANK_PRESSURE),
		"holdingTankLeakPressure" = round(TANK_LEAK_PRESSURE),
		"holdingTankFragPressure" = round(TANK_FRAGMENT_PRESSURE)
	)
	if(holding)
		data["holdingTank"] = list("name" = holding.name, "tankPressure" = round(holding.air_contents.return_pressure()))
	return data

/obj/machinery/portable_atmospherics/canister/tgui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	switch(action)
		if("relabel")
			if (!can_label)
				return 0
			var/list/colors = list(
				"\[N2O\]" =       "redws",
				"\[N2\]" =        "red",
				"\[O2\]" =        "blue",
				"\[CO2\]" =       "black",
				"\[H2\]" =        "purple",
				"\[Air\]" =       "grey",
				"\[CAUTION\]" =   "yellow",
				"\[Explosive\]" = "orange"
			)
			var/label = input(usr, "Choose canister label", "Gas canister") as null|anything in colors
			if (label && CanUseTopic(usr, state))
				canister_color = colors[label]
				icon_state = colors[label]
				SetName("\improper Canister: [label]")
			update_icon()
			. = TRUE
		if("pressure")
			var/pressure = params["pressure"]
			if(pressure == "reset")
				pressure = TANK_DEFAULT_RELEASE_PRESSURE
				. = TRUE
			else if(pressure == "min")
				pressure = round(ONE_ATMOSPHERE/10)
				. = TRUE
			else if(pressure == "max")
				pressure = round(10*ONE_ATMOSPHERE)
				. = TRUE
			else if(pressure == "input")
				pressure = tgui_input_number(usr, "New release pressure", "Canister Pressure", release_pressure, round(10*ONE_ATMOSPHERE), round(ONE_ATMOSPHERE/10))
				if(!isnull(pressure) && !..())
					. = TRUE
			else if(text2num(pressure) != null)
				pressure = text2num(pressure)
				. = TRUE
			if(.)
				release_pressure = clamp(round(pressure), round(ONE_ATMOSPHERE/10), round(10*ONE_ATMOSPHERE))
				investigate_log("was set to [release_pressure] kPa by [key_name(usr)].")
		if("valve")
			if(!valve_open)
				if(!holding)
					log_open()
			valve_open = !valve_open
			. = TRUE
		if("eject")
			if(holding)
				holding.dropInto(loc)
				holding = null
				update_icon()
				. = TRUE

/obj/machinery/portable_atmospherics/canister/CanUseTopic()
	if(destroyed)
		return STATUS_CLOSE
	return ..()

// Spawn debug tanks.
/obj/machinery/portable_atmospherics/canister/helium
	name = "\improper Canister \[He\]"
	icon_state = "black"
	canister_color = "black"
	can_label = 0
	initial_gas = list(/decl/material/gas/helium = 1)

/obj/machinery/portable_atmospherics/canister/liquid_helium
	name = "\improper Canister \[LHe2\]"
	icon_state = "black"
	canister_color = "black"
	can_label = 0
	initial_gas = list(/decl/material/gas/helium = 1)
	start_temperature = 3

/obj/machinery/portable_atmospherics/canister/liquid_hydrogen
	name = "\improper Canister \[LH2\]"
	icon_state = "purple"
	canister_color = "purple"
	can_label = 0
	initial_gas = list(/decl/material/gas/hydrogen = 0.95, /decl/material/gas/helium = 0.05)
	start_temperature = 15

/obj/machinery/portable_atmospherics/canister/liquid_methane
	name = "\improper Canister \[LCH\]"
	icon_state = "purple"
	canister_color = "purple"
	can_label = 0
	initial_gas = list(/decl/material/gas/methane = 0.95, /decl/material/gas/helium = 0.05)
	start_temperature = 93

/obj/machinery/portable_atmospherics/canister/liquid_methane/central
	volume = 1767146 //7.5m sphere

/obj/machinery/portable_atmospherics/canister/methyl_bromide
	name = "\improper Canister \[CH3Br\]"
	icon_state = "black"
	canister_color = "black"
	can_label = 0
	initial_gas = list(/decl/material/gas/methyl_bromide = 1)

/obj/machinery/portable_atmospherics/canister/chlorine
	name = "\improper Canister \[Cl\]"
	icon_state = "black"
	canister_color = "black"
	can_label = 0
	initial_gas = list(/decl/material/gas/chlorine = 1)