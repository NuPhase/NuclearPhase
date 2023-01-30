#define LASER_MODE_IGNITION   "ignition"
#define LASER_MODE_IMPULSE    "impulse"
#define LASER_MODE_CONTINUOUS "continuous"

#define NEUTRON_MODE_BOMBARDMENT  "bombardment"
#define NEUTRON_MODE_MODERATION   "moderation"
#define NEUTRON_MODE_OFF		  "off"

/obj/machinery/rlaser
	name = "industrial laser"
	desc = "A huge, hefty piece of optics machinery."
	anchored = TRUE
	density = FALSE
	var/omode = LASER_MODE_IMPULSE
	var/nmode = NEUTRON_MODE_OFF
	var/operating = FALSE
	var/armed = FALSE
	var/primed = FALSE
	var/capacitor_charge = 0
	use_power = POWER_USE_OFF
	idle_power_usage = 10000
	active_power_usage = 60000
	required_interaction_dexterity = DEXTERITY_COMPLEX_TOOLS
	layer = ABOVE_HUMAN_LAYER
	var/lasid = ""

/obj/machinery/rlaser/Initialize()
	. = ..()
	reactor_components[lasid] += src

/obj/machinery/rlaser/examine(mob/user)
	. = ..()
	if(armed)
		var/omessage = ""
		switch(omode)
			if(LASER_MODE_IGNITION)
				omessage = "Its spin-capacitors hum at max RPM. It is armed and ready."
			if(LASER_MODE_IMPULSE)
				omessage = "Its focus system constantly spins, as if aiming at something."
			if(LASER_MODE_CONTINUOUS)
				omessage = "It emits a constant, low-power buzz."
		to_chat(user, omessage)
	if(operating && nmode == NEUTRON_MODE_BOMBARDMENT)
		to_chat(user, "A faint blue glow can be seen on its nozzle...")

/obj/machinery/rlaser/proc/switch_omode(nomode)
	switch(nomode)
		if(LASER_MODE_IGNITION)
			use_power = POWER_USE_ACTIVE
			START_PROCESSING_MACHINE(src, MACHINERY_PROCESS_SELF)
		if(LASER_MODE_IMPULSE)
			use_power = POWER_USE_IDLE
			STOP_PROCESSING_MACHINE(src, MACHINERY_PROCESS_ALL)
		if(LASER_MODE_CONTINUOUS)
			START_PROCESSING_MACHINE(src, MACHINERY_PROCESS_SELF)
			use_power = POWER_USE_IDLE
	omode = nomode

/obj/machinery/rlaser/Process()
	if(omode == LASER_MODE_IGNITION)
		capacitor_charge += 1
		capacitor_charge = Clamp(capacitor_charge, 1, 100)
		if(capacitor_charge == 100)
			STOP_PROCESSING_MACHINE(src, MACHINERY_PROCESS_ALL)

/obj/machinery/rlaser/proc/prime()
	if(!armed)
		return FALSE
	if(omode == LASER_MODE_IGNITION)
		primed = TRUE
		spawn(10)
			playsound(src, 'sound/machines/constantlowbuzzer.ogg', 50, FALSE, 50, 1)
		spawn(50)
			if(primed) //in case of abort
				fire(capacitor_charge * active_power_usage)
			primed = FALSE
		return TRUE
	return FALSE

/obj/machinery/rlaser/proc/fire(power)
	if(omode == LASER_MODE_IGNITION)
		playsound(src, 'sound/machines/laserignition.ogg', 100, FALSE, 50, 1, ignore_walls = TRUE)
		capacitor_charge = 0
		START_PROCESSING_MACHINE(src, MACHINERY_PROCESS_SELF)
		var/obj/machinery/power/hybrid_reactor/R = reactor_components["core"]
		R.receive_power(power * 1000)
		var/obj/item/projectile/beam/sniper/reactor/A = new /obj/item/projectile/beam/sniper/reactor(get_turf(src))
		A.launch(laser_receivers[lasid])
	return

/obj/structure/rlaser_receiver
	var/resid = ""
	anchored = TRUE

/obj/structure/rlaser_receiver/Initialize()
	. = ..()
	laser_receivers[resid] += src