#define FISSION_RATE 0.15
#define NEUTRON_FLUX_RATE 0.05
#define NEUTRONS_PER_RAD 17
#define REACTOR_POWER_MODIFIER 10

/obj/machinery/power/hybrid_reactor
	name = "reactor superstructure"
	icon = 'icons/obj/machines/power/fission.dmi'
	icon_state = "fission_core"
	density = 1
	anchored = 1
	var/neutron_flux = 1
	var/meltdown = FALSE
	var/was_shut_down = FALSE
	var/shutdown_failure = FALSE
	var/obj/structure/reactor_superstructure/superstructure

/obj/machinery/power/hybrid_reactor/Initialize()
	. = ..()
	reactor_components["core"] += src
	rcontrol.initialize()
	spawn(1 MINUTE)
		superstructure = reactor_components["superstructure"]

/obj/machinery/power/hybrid_reactor/Destroy()
	. = ..()
	reactor_components["core"] = null

/obj/machinery/power/hybrid_reactor/Process()
	rcontrol.control()
	var/turf/A = get_turf(src)
	var/datum/gas_mixture/GM = A.return_air()
	var/total_radiation = 0
	total_radiation += process_fission(GM)
	total_radiation += process_fusion(GM)
	SSradiation.radiate(src, total_radiation)

/obj/machinery/power/hybrid_reactor/proc/process_fission(datum/gas_mixture/GM)
	var/total_neutron_amount = 20
	for(var/g in GM.gas)
		var/decl/material/mat = GET_DECL(g)
		var/react_amount = GM.gas[g] * FISSION_RATE
		var/neutrons_absorbed = mat.neutron_absorption * react_amount
		if(mat.neutron_production)
			total_neutron_amount += mat.neutron_production * react_amount * neutron_flux
			GM.adjust_gas(mat.uid, !react_amount)
			if(mat.fission_products)
				for(var/fp in mat.fission_products)
					GM.adjust_gas(fp, react_amount)
		total_neutron_amount -= neutrons_absorbed
		GM.add_thermal_energy(mat.fission_energy * neutrons_absorbed * 10)
	neutron_flux = Interpolate(neutron_flux, Clamp(total_neutron_amount * NEUTRON_FLUX_RATE, 10, 1000000000), 0.2)
	return neutron_flux / NEUTRONS_PER_RAD


/obj/machinery/power/hybrid_reactor/proc/process_fusion(datum/gas_mixture/GM)
	//GM.add_thermal_energy(1000000)
	return 100

/obj/machinery/power/hybrid_reactor/proc/receive_power(power) //in watts
	var/turf/A = get_turf(src)
	var/datum/gas_mixture/GM = A.return_air()
	GM.add_thermal_energy(power * 1000) //?
	return

/obj/machinery/power/hybrid_reactor/proc/prime_alarms()

/obj/machinery/power/hybrid_reactor/proc/activate_alarms()

/obj/machinery/power/hybrid_reactor/proc/start_burning()
	superstructure.color = LIGHT_COLOR_FIRE

/obj/machinery/power/hybrid_reactor/proc/close_blastdoors()

/obj/machinery/power/hybrid_reactor/proc/launch_fuel_cells()

/obj/machinery/power/hybrid_reactor/proc/close_radlocks()

/obj/machinery/power/hybrid_reactor/proc/make_plasmaball()
	superstructure.icon = 'icons/obj/engine/energy_ball.dmi'
	superstructure.icon_state = "energy_ball_fast"
	superstructure.color = LIGHT_COLOR_BLUE
	superstructure.pixel_x = 0
	superstructure.pixel_y = 0
	superstructure.name = "self-contained plasma sphere"
	superstructure.desc = "The heart of all death and destruction..."
	superstructure.set_light(20, 10, LIGHT_COLOR_BLUE)
	animate(superstructure, transform = matrix()*10, time = 490, easing = CIRCULAR_EASING)

/obj/machinery/power/hybrid_reactor/proc/produce_explosion()

/obj/machinery/power/hybrid_reactor/proc/meltdown()
	meltdown = TRUE
	rcontrol.do_message("MAJOR SENSOR DAMAGE IN REACTOR UNIT", 3)
	sleep(10 SECONDS)
	rcontrol.do_message("MAJOR WIRING AND SENSOR DAMAGE IN REACTOR UNIT", 3)
	spawn(1 SECOND)
		rcontrol.do_message("DAMAGE CONTROL ACTIVE", 3)
		radio_announce("TOTAL CONTROL SYSTEMS FAILURE, ASSUME MANUAL CONTROL IMMEDIATELY.", rcontrol.name, "Engineering")
		rcontrol.mode = REACTOR_CONTROL_MODE_MANUAL
		rcontrol.autocontrol_available = FALSE
		rcontrol.semiautocontrol_available = FALSE
	sleep(10 SECONDS)
	prime_alarms()
	radio_announce("REACTOR CONTROL CONTINGENCY MODE: ACTIVE.", rcontrol.name)
	rcontrol.do_message("REACTOR MAGNETS EXTERNAL POWER LOSS", 3)
	spawn(1 SECOND)
		rcontrol.do_message("THERMOELECTRIC GENERATION START", 3)
	sleep(5 SECONDS)
	activate_alarms()
	radio_announce("SITEWIDE RADIATION INTERLOCKS WILL ACTIVATE IN: 90 SECONDS.", rcontrol.name)
	sleep(10 SECONDS)
	radio_announce("BLAST DOORS CLOSING IN: 20 SECONDS.", rcontrol.name)
	start_burning()
	neutron_flux *= 100
	rcontrol.do_message("THERMOELECTRIC SYSTEMS OVERHEAT", 3)
	rcontrol.do_message("MAJOR INTERNAL STRUCTURAL DAMAGE", 3)
	spawn(2 SECONDS)
		rcontrol.do_message("REACTOR UNIT SYSTEMS UNRESPONSIVE", 3)
		rcontrol.scram("CONTROL LOSS") //won't work lol
	for(var/mob/living/carbon/human/H in human_mob_list)
		if(H.job == "Engineer" || H.job == "Chief Engineer")
			H.playsound_local(H, 'sound/music/howmuchmorecanyoulose.ogg', 50, 0)
			to_chat(H, SPAN_ERPBOLD("And in times like these, it's up to you to decide: How much more can you lose?"))
	sleep(10 SECONDS)
	var/ann_name = "[pick(first_names_male)] [pick(last_names)]"
	radio_announce("ATTENTION ALL REACTOR OPERATIONS PERSONNEL.", ann_name)
	sleep(3 SECONDS)
	radio_announce("THIS IS OUR LAST CHANCE TO PREVENT THE UNCONTROLLABLE DETONATION OF THE H.S.S.R.", ann_name)
	sleep(4 SECONDS)
	radio_announce("CLIMB UP THE REACTOR UNIT, AND EJECT ALL FUEL CELLS NO LONGER THAN WITHIN 3 SECONDS OF EACH OTHER.", ann_name)
	sleep(3 SECONDS)
	radio_announce("TO INVOKE A REACTION STALL AND STOP THE THERMAL RUNAWAY. YOU HAVE A MINUTE, GOOD LUCK.", ann_name)
	sleep(5 SECONDS)
	close_blastdoors()
	radio_announce("SITEWIDE RADIATION INTERLOCKS WILL ACTIVATE IN: 1 MINUTE.", rcontrol.name)
	sleep(40 SECONDS)
	if(was_shut_down)
		launch_fuel_cells()
		rcontrol.do_message("SUCCESSFUL SHUTDOWN", 3)
		radio_announce("You did it. You god damn did it!", ann_name)
		spawn(1 SECOND)
			radio_announce("ABORTING...", rcontrol.name)
		return
	radio_announce("I believe it's too late... We're all gonna die.", ann_name)
	spawn(2 SECONDS)
		radio_announce("CONTINGENCY OPERATION FAILURE. SHUTTING DOWN...", rcontrol.name)
	sleep(12 SECONDS)
	close_radlocks()
	sleep(5 SECONDS)
	if(shutdown_failure)
		make_plasmaball()
		for(var/mob/living/carbon/human/H in human_mob_list)
			H.playsound_local(H, 'sound/music/criticalmass.ogg', 50, 0)
			to_chat(H, SPAN_ERPBOLD("There's the sun, the destroyer of worlds. Born with technology, the first of its kind."))
		sleep(49 SECONDS)
		for(var/mob/living/carbon/human/H in human_mob_list)
			to_chat(H, SPAN_ERPBOLD("It was meant to save the world from starvation and eternal cold, but it turned against everyone."))
		sleep(27 SECONDS)
		for(var/mob/living/carbon/human/H in human_mob_list)
			to_chat(H, SPAN_ERPBOLD("And now it shall feast upon the ones who tried to harness its power."))
		animate(superstructure, transform = matrix()*0.9, time = 310, easing = SINE_EASING | EASE_IN)
		spawn(310)
			animate(superstructure, transform = matrix()*0.01, time = 10, easing = QUAD_EASING | EASE_IN)
		sleep(32 SECONDS)
		explosion(superstructure, 25, 50, 75, 150)
		sound_to(world, sound('sound/effects/explosion_huge.ogg', 0, 0, 0, 20))
	else
		produce_explosion()