#define FISSION_RATE 0.001
#define NEUTRON_FLUX_RATE 0.05
#define NEUTRON_MOLE_ENERGY 100000
#define RADS_PER_NEUTRON 0.3
#define REACTOR_POWER_MODIFIER 10
#define WATTS_PER_KPA 0.1
#define REACTOR_SHIELDING_COEFFICIENT 0.0005

/obj/machinery/power/hybrid_reactor
	name = "reactor superstructure"
	icon = 'icons/obj/machines/power/fission.dmi'
	icon_state = "fission_core"
	density = 1
	anchored = 1
	var/neutron_flux = 1 //a flux of 1 will mean that neutron amount does not change
	var/neutron_rate = 0
	var/neutron_moles = 0 //how many moles can we split
	var/meltdown = FALSE
	var/was_shut_down = FALSE
	var/shutdown_failure = FALSE
	var/last_radiation = 0

	var/containment = FALSE
	var/field_power_consumption = 0
	var/shield_temperature = 36

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

	var/last_neutron_moles = neutron_moles

	process_fission(GM)
	process_fusion(GM)

	if(last_neutron_moles)
		neutron_rate = neutron_moles / last_neutron_moles
	else
		neutron_rate = 0

	var/total_radiation = neutron_moles * RADS_PER_NEUTRON
	last_radiation = total_radiation
	SSradiation.radiate(src, total_radiation)
	SSradiation.radiate(superstructure, total_radiation * REACTOR_SHIELDING_COEFFICIENT)

	if(GM.temperature > 5000)
		if(containment)
			field_power_consumption = GM.return_pressure() * WATTS_PER_KPA
			use_power_oneoff(field_power_consumption, EQUIP)

/obj/machinery/power/hybrid_reactor/proc/process_fission(datum/gas_mixture/GM)
	for(var/g in GM.gas)
		var/decl/material/mat = GET_DECL(g)
		var/react_amount = GM.gas[g] * FISSION_RATE * neutron_flux + 0.0001
		var/neutrons_absorbed = mat.neutron_absorption * react_amount
		if(mat.fission_energy)
			neutron_moles += mat.fission_energy * react_amount / NEUTRON_MOLE_ENERGY
			GM.adjust_gas(mat.type, react_amount * -1)
			if(mat.fission_products)
				for(var/fp in mat.fission_products)
					GM.adjust_gas(fp, react_amount*mat.fission_products[fp])
		var/actually_absorbed = min(neutrons_absorbed, neutron_moles)
		neutron_moles -= actually_absorbed
		GM.add_thermal_energy(max(0, NEUTRON_MOLE_ENERGY * actually_absorbed))
	neutron_flux = Interpolate(neutron_flux, Clamp(neutron_moles * NEUTRON_FLUX_RATE, 0, 1000), 0.2)

/obj/machinery/power/hybrid_reactor/proc/process_fusion(datum/gas_mixture/GM)
	for(var/cur_reaction_type in subtypesof(/decl/thermonuclear_reaction))
		var/decl/thermonuclear_reaction/cur_reaction = GET_DECL(cur_reaction_type)

		if(!(cur_reaction.first_reactant in GM.gas))
			continue
		if(!(cur_reaction.second_reactant in GM.gas))
			continue
		if(cur_reaction.minimum_temperature > GM.temperature)
			continue

		var/uptake_moles = min(GM.gas[cur_reaction.first_reactant], GM.gas[cur_reaction.second_reactant])
		GM.adjust_gas(cur_reaction.first_reactant, !uptake_moles*0.5)
		GM.adjust_gas(cur_reaction.second_reactant, !uptake_moles*0.5)
		GM.adjust_gas(cur_reaction.product, uptake_moles)
		GM.add_thermal_energy(cur_reaction.mean_energy * uptake_moles)
		neutron_moles += cur_reaction.free_neutron_moles * uptake_moles

/obj/machinery/power/hybrid_reactor/proc/receive_power(power) //in watts
	var/turf/A = get_turf(src)
	var/datum/gas_mixture/GM = A.return_air()
	GM.add_thermal_energy(power)
	return

/obj/machinery/power/hybrid_reactor/proc/prime_alarms()

/obj/machinery/power/hybrid_reactor/proc/activate_alarms()
	for(var/obj/machinery/rotating_alarm/SL in rcontrol.spinning_lights)
		addtimer(CALLBACK(SL, /obj/machinery/rotating_alarm/proc/set_on), rand(1,20))

/obj/machinery/power/hybrid_reactor/proc/start_burning()
	var/list/animate_targets = superstructure.get_above_oo() + superstructure
	for(var/thing in animate_targets)
		var/atom/movable/AM = thing
		animate(AM, color = "#ff0000", time = 60 SECONDS, easing = CUBIC_EASING)
		AM.animate_filter("glow", list(color = "#ff0000", offset=2, size=10, time = 60 SECONDS, easing = CUBIC_EASING))
		AM.set_light(5, 3, "#ff0000")

/obj/machinery/power/hybrid_reactor/proc/close_blastdoors()

/obj/machinery/power/hybrid_reactor/proc/launch_fuel_cells()

/obj/machinery/power/hybrid_reactor/proc/close_radlocks()
	for(var/obj/machinery/door/blast/regular/radlock/cur_radlock in rcontrol.radlocks)
		cur_radlock.force_close() //they have their own reduntant power supply systems
	radio_announce("RADIATION LOCKS: CLOSED.", rcontrol.name)

/obj/machinery/power/hybrid_reactor/proc/make_plasmaball()
	superstructure.icon = 'icons/obj/engine/energy_ball.dmi'
	superstructure.icon_state = "energy_ball_fast"
	superstructure.color = LIGHT_COLOR_BLUE
	superstructure.pixel_x = 0
	superstructure.pixel_y = 0
	superstructure.update_above()
	superstructure.name = "self-contained plasma sphere"
	superstructure.desc = "The heart of all death and destruction..."
	superstructure.set_light(20, 10, LIGHT_COLOR_BLUE)
	var/list/animate_targets = superstructure.get_above_oo() + superstructure
	for(var/thing in animate_targets)
		var/atom/movable/AM = thing
		animate(AM, transform = matrix()*10, time = 490, easing = CIRCULAR_EASING)

/obj/machinery/power/hybrid_reactor/proc/produce_explosion()
	var/turf/T = superstructure.loc
	explosion(superstructure, 25, 50, 75, 150)
	var/list/our_mobs = mobs_on_main_map()
	for(var/mob/living/carbon/human/H in our_mobs)
		H.playsound_local(H.loc, 'sound/effects/explosion_huge.ogg', 20, 0)
		shake_camera(H, 20, 5)
	spawn(10 SECONDS)
		var/obj/effect/fluid/F = new(T)
		F.reagents.add_reagent(/decl/material/solid/metal/tungsten, 1000000)
		F.temperature = 3900

/obj/machinery/power/hybrid_reactor/proc/meltdown()
	meltdown = TRUE
	var/obj/effect/scripted_detonation/scr_detonation
	var/obj/effect/scripted_deflagration/scr_deflagration
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
	scr_detonation = scripted_explosions["reactor1"]
	scr_detonation.trigger()
	spawn(2 SECONDS)
		rcontrol.do_message("REACTOR UNIT SYSTEMS UNRESPONSIVE", 3)
		rcontrol.scram("CONTROL LOSS") //won't work lol
		scr_detonation = scripted_explosions["reactor2"]
		scr_detonation.trigger()
	for(var/mob/living/carbon/human/H in human_mob_list)
		if(H.job == "Engineer" || H.job == "Chief Engineer")
			H.playsound_local(H, 'sound/music/howmuchmorecanyoulose.ogg', 50, 0)
			to_chat(H, SPAN_ERPBOLD("And in times like these, it's up to you to decide: How much more can you lose?"))
	sleep(10 SECONDS)
	var/ann_name = "[pick(first_names_male)] [pick(last_names)]"
	radio_announce("ATTENTION ALL REACTOR OPERATIONS PERSONNEL.", ann_name)
	sleep(3 SECONDS)
	scr_detonation = scripted_explosions["reactor3"]
	scr_detonation.trigger()
	radio_announce("THIS IS OUR LAST CHANCE TO PREVENT THE UNCONTROLLABLE DETONATION OF THE H.S.S.R.", ann_name)
	sleep(4 SECONDS)
	scr_detonation = scripted_explosions["reactor4"]
	scr_detonation.trigger()
	radio_announce("CLIMB UP THE REACTOR UNIT, AND EJECT ALL FUEL CELLS NO LONGER THAN WITHIN 3 SECONDS OF EACH OTHER.", ann_name)
	sleep(3 SECONDS)
	radio_announce("TO INVOKE A REACTION STALL AND STOP THE THERMAL RUNAWAY. YOU HAVE A MINUTE, GOOD LUCK.", ann_name)
	sleep(5 SECONDS)
	scr_detonation = scripted_explosions["reactor5"]
	scr_detonation.trigger()
	scr_detonation = scripted_explosions["reactor8"]
	scr_detonation.trigger()
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
	scr_deflagration = scripted_explosions["dreactor1"]
	scr_deflagration.trigger()
	spawn(2 SECONDS)
		radio_announce("CONTINGENCY OPERATION FAILURE. SHUTTING DOWN...", rcontrol.name)
		scr_deflagration = scripted_explosions["machinehall"]
		scr_deflagration.trigger()
	sleep(12 SECONDS)
	close_radlocks()
	sleep(5 SECONDS)
	if(shutdown_failure)
		make_plasmaball()
		visible_message("<span class=bigdanger>The reactor implodes on itself, creating something that cannot be described with any language!</span>", range = 20)
		for(var/mob/living/carbon/human/H in human_mob_list)
			H.playsound_local(H, 'sound/music/criticalmass.ogg', 50, 0)
			to_chat(H, SPAN_ERPBOLD("Here comes true fusion, the kind that destroys whole worlds. Born with technology, the first of its kind."))
		sleep(49 SECONDS)
		for(var/mob/living/carbon/human/H in human_mob_list)
			to_chat(H, SPAN_ERPBOLD("Destined to starve and die, far from being controlled nor sustained."))
		sleep(27 SECONDS)
		for(var/mob/living/carbon/human/H in human_mob_list)
			to_chat(H, SPAN_ERPBOLD("Everything comes to an end, including your own existence."))
		var/list/animate_targets = superstructure.get_above_oo() + superstructure
		for(var/thing in animate_targets)
			var/atom/movable/AM = thing
			animate(AM, transform = matrix()*0.9, time = 290, easing = SINE_EASING | EASE_IN)
		for(var/obj/machinery/rotating_alarm/SL in rcontrol.spinning_lights)
			SL.set_color(COLOR_RED_LIGHT)
		spawn(29 SECONDS)
			for(var/thing in animate_targets)
				var/atom/movable/AM = thing
				animate(AM, transform = matrix()*0.01, time = 10, easing = QUAD_EASING | EASE_IN)
		sleep(30 SECONDS)
	produce_explosion()
	radio_announce("MULTIPLE SEISMIC VIBRATIONS OF MAGNITUDE 9 DETECTED.", rcontrol.name)