#define SUIT_PROPULSION_OFF "offline"
#define SUIT_PROPULSION_COOLING "cooling down"
#define SUIT_PROPULSION_READY "ready"
#define SUIT_PROPULSION_ATTACK_PERCENT 10

#define STATUS_MESSAGE_COOLDOWN 100
#define KWH_PER_KG_WEIGHT 1.2

/obj/item/storage/backpack/lifesupportpack
	name = "life support unit"
	icon = 'icons/obj/items/storage/backpack/backpack_ert.dmi'
	icon_state = ICON_STATE_WORLD
	w_class = ITEM_SIZE_HUGE
	slot_flags = SLOT_BACK
	max_w_class = ITEM_SIZE_LARGE
	max_storage_space = DEFAULT_BACKPACK_STORAGE

	var/obj/item/tank/oxygen_tank = null
	var/obj/item/tank/propulsion_tank = null
	var/obj/item/tank/waste_tank = null

	var/obj/item/co2filter/atmosphere_filter = null

	var/target_pressure = 45 //kPa
	var/atmosphere_uptake = FALSE

	var/propulsion_status = SUIT_PROPULSION_READY
	var/propulsion_cooldown = 30

	var/status_warning_cooldown = FALSE
	var/obj/abstract/modules_holder/modules = null

	var/obj/item/clothing/suit/modern/space/owner = null

	var/obj/item/cell/battery = null
	var/battery_type = /obj/item/cell/doublecapacity
	canremove = FALSE

/obj/item/storage/backpack/lifesupportpack/Initialize()
	. = ..()
	oxygen_tank = new /obj/item/tank/oxygen/modulated
	propulsion_tank = new /obj/item/tank/propfuel
	waste_tank = new /obj/item/tank/waste
	battery = new battery_type
	modules = new /obj/abstract/modules_holder
	atmosphere_filter = new /obj/item/co2filter/large
	oxygen_tank.forceMove(modules)
	propulsion_tank.forceMove(modules)
	waste_tank.forceMove(modules)
	battery.forceMove(modules)
	var/obj/item/co2filter/newfilter = new /obj/item/co2filter
	newfilter.forceMove(src)
	newfilter.on_enter_storage(src)

/obj/item/storage/backpack/lifesupportpack/mob_can_equip(M, slot, disable_warning, force)
	return FALSE

/obj/item/storage/backpack/lifesupportpack/examine(mob/user, distance, infix, suffix)
	. = ..()
	if(atmosphere_uptake)
		to_chat(user, "<span class='danger'>The suit uses the external atmosphere.</span>")
	if(atmosphere_filter)
		to_chat(user, "Its CO2 filter is at [round(atmosphere_filter.return_capacity())]% capacity.")
	else
		to_chat(user, "<span class='danger'>It doesn't have a CO2 filter installed.</span>")
	to_chat(user, "Tank pressure readouts:")
	if(oxygen_tank)
		to_chat(user, "	  Oxygen tank: [round(oxygen_tank.air_contents.return_pressure())]kPa.")
	if(propulsion_tank)
		to_chat(user, "	  Propulsion tank: [round(propulsion_tank.air_contents.return_pressure())]kPa.")
	if(waste_tank)
		to_chat(user, "	  Waste tank: [round(waste_tank.air_contents.return_pressure())]kPa.")
	to_chat(user, "Target pressure is set at [target_pressure]kPa.")
	if(battery)
		to_chat(user, "Battery charge is [round(battery.charge)]Wh.")
	to_chat(user, "Propulsions systems are [propulsion_status].")

/obj/item/storage/backpack/lifesupportpack/proc/do_support()
	var/power_draw = 0
	if(atmosphere_uptake)
		var/turf/simulated/T = get_turf(src)
		owner.internal_atmosphere.equalize(T.return_air())
	if(!battery)
		LAZYSET(owner.slowdown_per_slot, slot_wear_suit_str, 5)
		return
	if(!battery.charge)
		LAZYSET(owner.slowdown_per_slot, slot_wear_suit_str, 5)
		if(status_warning_cooldown == FALSE && prob(5))
			status_warning_cooldown = TRUE
			to_chat(owner.wearer, "<span class='danger'>\The [src] dictates: 'SUIT POWER SOURCE FAILURE.'.</span>")
			spawn(STATUS_MESSAGE_COOLDOWN)
				status_warning_cooldown = FALSE
		return
	LAZYSET(owner.slowdown_per_slot, slot_wear_suit_str, 1)

	if(!atmosphere_uptake)
		if(atmosphere_filter && atmosphere_filter.clean_gasmix(owner.internal_atmosphere))
			power_draw += atmosphere_filter.power_consumption
			//play working sound here
		else
			if(status_warning_cooldown == FALSE && prob(5))
				status_warning_cooldown = TRUE
				to_chat(owner.wearer, "<span class='danger'>\The [src] dictates: 'CHECK CO2. CHECK CO2.'.</span>")
				spawn(STATUS_MESSAGE_COOLDOWN)
					status_warning_cooldown = FALSE
		if(oxygen_tank)
			var/pressure_delta = target_pressure - owner.internal_atmosphere.return_pressure()
			var/transfer_moles = calculate_transfer_moles(oxygen_tank.air_contents, owner.internal_atmosphere, pressure_delta)
			power_draw += pump_gas(src, oxygen_tank.air_contents, owner.internal_atmosphere, transfer_moles)

	power_draw += owner.weight * KWH_PER_KG_WEIGHT

	battery.drain_power(0, 0, power_draw)

/obj/item/storage/backpack/lifesupportpack/proc/activate_propulsion(prop_percent)
	if(!propulsion_tank)
		return

	propulsion_status = SUIT_PROPULSION_COOLING
	spawn(propulsion_cooldown)
		propulsion_status = SUIT_PROPULSION_READY

	var/datum/gas_mixture/prop_air = propulsion_tank.air_contents.remove_ratio(prop_percent * 0.01)
	prop_air.volume = 1.2 //combustion chamber volume
	prop_air.fire_react(null, 1, 1)
	if(prop_air.temperature > 400)
		playsound(owner.wearer, 'sound/machines/disperser_fire.ogg', 50, 1)
	else
		playsound(owner.wearer, 'sound/effects/spray.ogg', 50)

	return prop_air

/obj/item/storage/backpack/lifesupportpack/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/co2filter))
		if(!atmosphere_filter)
			atmosphere_filter = W
			user.drop_from_inventory(W, modules)
			to_chat(usr, "<span class='notice'>You insert \the [W] into the [src].</span>")
			return
		else
			to_chat(usr, "<span class='notice'>\The [src] already has a CO2 filter installed, so you just put it into the backpack!</span>")
	if(istype(W, /obj/item/cell))
		if(!battery)
			battery = W
			user.drop_from_inventory(W, modules)
			to_chat(usr, "<span class='notice'>You insert \the [W] into the [src].</span>")
			return
		else
			to_chat(usr, "<span class='notice'>\The [src] already has a power source installed, so you just put it into the backpack!</span>")
	if(istype(W, /obj/item/tank))
		var/list/options = list()
		if(!oxygen_tank)
			options += "oxygen tank port"
		if(!propulsion_tank)
			options += "propulsion tank port"
		if(!waste_tank)
			options += "waste tank port"
		var/tank_to_add = input(usr, "Which tank port?", "Tank insertion") in options
		if(!tank_to_add)
			return
		switch(tank_to_add)
			if("oxygen tank port")
				oxygen_tank = W
			if("propulsion tank port")
				propulsion_tank = W
			if("waste tank port")
				waste_tank = W
		user.drop_from_inventory(W, modules)
		playsound(loc, 'sound/effects/spray3.ogg', 50)
		to_chat(usr, "<span class='notice'>You insert \the [W] into the [tank_to_add].</span>")
		return
	. = ..()



/obj/item/storage/backpack/lifesupportpack/verb/toggle_uptake()
	set name = "Switch Atmosphere Uptake Valve"
	set category = "Life Support"
	set src in usr

	var/mob/user = usr
	if(istype(user) && user.incapacitated())
		return

	atmosphere_uptake = !atmosphere_uptake
	if(atmosphere_uptake)
		to_chat(usr, "<span class='notice'>\The [src] now uses external atmosphere.</span>")
	else
		to_chat(usr, "<span class='notice'>\The [src] now uses oxygen from the tank in it.</span>")

/obj/item/storage/backpack/lifesupportpack/verb/change_target_pressure()
	set name = "Set pressurization target"
	set category = "Life Support"
	set src in usr

	var/mob/user = usr
	if(istype(user) && user.incapacitated())
		return

	var/new_targ_pressure = input(usr, "Set the target pressure for \the [src].", "Pressurization target setting", target_pressure) as null|num
	target_pressure = Clamp(new_targ_pressure, 0, 15000)
	to_chat(usr, "<span class='notice'>You've set the target pressure to [target_pressure]kPa.</span>")

/obj/item/storage/backpack/lifesupportpack/verb/remove_tank()
	set name = "Remove tank"
	set category = "Life Support"
	set src in usr

	var/mob/user = usr
	if(istype(user) && user.incapacitated())
		return

	var/list/options = list()
	if(oxygen_tank)
		options += "oxygen tank"
	if(propulsion_tank)
		options += "propulsion tank"
	if(waste_tank)
		options += "waste tank"
	var/tank_to_remove = input(usr, "Which tank to remove?", "Tank ejection") in options

	var/obj/item/tank/removed_tank = null
	switch(tank_to_remove)
		if("oxygen tank")
			removed_tank = oxygen_tank
			oxygen_tank = null
		if("propulsion tank")
			removed_tank = propulsion_tank
			propulsion_tank = null
			propulsion_status = SUIT_PROPULSION_OFF
		if("waste tank")
			removed_tank = waste_tank
			waste_tank = null

	if(!removed_tank)
		return
	removed_tank.canremove = 1
	usr.drop_from_inventory(removed_tank, src)
	usr.put_in_hands(removed_tank)
	playsound(loc, 'sound/effects/spray3.ogg', 50)

/obj/item/storage/backpack/lifesupportpack/verb/remove_co2_filter()
	set name = "Remove CO2 filter"
	set category = "Life Support"
	set src in usr

	var/mob/user = usr
	if(istype(user) && user.incapacitated())
		return

	if(atmosphere_filter)
		usr.drop_from_inventory(atmosphere_filter, src)
		usr.put_in_hands(atmosphere_filter)
		to_chat(usr, "<span class='notice'>You eject \the [atmosphere_filter].</span>")
		atmosphere_filter = null

/obj/item/storage/backpack/lifesupportpack/verb/remove_cell()
	set name = "Remove Power Source"
	set category = "Life Support"
	set src in usr

	var/mob/user = usr
	if(istype(user) && user.incapacitated())
		return

	if(battery)
		usr.drop_from_inventory(battery, src)
		usr.put_in_hands(battery)
		to_chat(usr, "<span class='notice'>You eject \the [battery].</span>")
		battery = null

/obj/item/storage/backpack/lifesupportpack/verb/purge()
	set name = "Purge Internal Atmosphere"
	set category = "Life Support"
	set src in usr

	var/mob/user = usr
	if(istype(user) && user.incapacitated())
		return

	owner.internal_atmosphere.remove(owner.internal_atmosphere.total_moles)
	do_support() //fill it up immediately
	to_chat(owner.wearer, SPAN_DANGER("INTERNAL ATMOSPHERE PURGED!"))
	playsound(owner.wearer, 'sound/effects/undock.ogg', 100, 1)


/obj/abstract/modules_holder
	name = "Modules holder unit"



/obj/item/storage/backpack/lifesupportpack/adaptive_cooling/Initialize()
	. = ..()
	create_reagents(12000)

#undef KWH_PER_KG_WEIGHT