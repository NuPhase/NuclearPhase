#define FISSION_RATE 0.01 //General modifier of fission speed
#define NEUTRON_FLUX_RATE 0.001 //Neutron flux per neutron mole
#define NEUTRON_MOLE_ENERGY 1000 //J per neutron mole
#define RADS_PER_NEUTRON 30
#define REACTOR_POWER_MODIFIER 10 //Currently unused
#define WATTS_PER_KPA 0.5
#define REACTOR_SHIELDING_COEFFICIENT 0.05
#define REACTOR_MODERATOR_POWER 0.27

#define MAX_MAGNET_DELTA 800000000
#define MAX_MAGNET_CHARGE 10000000

/obj/machinery/power/hybrid_reactor
	name = "reactor superstructure"
	icon = 'icons/obj/machines/power/fission.dmi'
	icon_state = "fission_core"
	density = 1
	anchored = 1

	var/slow_neutrons = 0
	var/fast_neutrons = 0
	var/total_neutrons = 0

	var/xray_flux = 0

	var/neutron_rate = 0
	var/neutron_moles = 0 //how many moles can we split
	var/neutrons_absorbed = 0

	var/meltdown = FALSE
	var/was_shut_down = FALSE
	var/shutdown_failure = FALSE
	var/last_radiation = 0

	var/containment = TRUE
	var/magnets_quenched = FALSE // needs manual reset
	var/field_power_consumption = 0
	var/shield_temperature = 36
	var/field_battery_charge = MAX_MAGNET_CHARGE
	var/field_charging = FALSE // whether we soak power

	var/moderator_position = 0.15 //0-1. 1 means it scatters most of the neutrons.
	var/reflector_position = 1 //0-1. 1 means it reflects most of the neutrons.

	var/obj/structure/reactor_superstructure/superstructure

	var/datum/gas_mixture/containment_field

/obj/machinery/power/hybrid_reactor/Initialize()
	. = ..()
	containment_field = new(50000, 4200)
	reactor_components["core"] += src
	rcontrol.initialize()
	spawn(1 MINUTE)
		superstructure = reactor_components["superstructure"]

/obj/machinery/power/hybrid_reactor/Destroy()
	. = ..()
	reactor_components["core"] = null

/obj/machinery/power/hybrid_reactor/Process()
	var/last_neutrons = slow_neutrons + fast_neutrons

	var/list/returned_list = containment_field.handle_nuclear_reactions(slow_neutrons, fast_neutrons)
	slow_neutrons = returned_list["slow_neutrons_changed"]
	fast_neutrons = returned_list["fast_neutrons_changed"]

	handle_control_panels()

	xray_flux = 0
	process_fusion(containment_field)

	total_neutrons = slow_neutrons + fast_neutrons

	if(last_neutrons)
		neutron_rate = total_neutrons / last_neutrons
	else
		neutron_rate = 1

	var/total_radiation = total_neutrons * RADS_PER_NEUTRON
	last_radiation = total_radiation
	SSradiation.radiate(src, total_radiation)
	SSradiation.radiate(superstructure, total_radiation * REACTOR_SHIELDING_COEFFICIENT)

	if(containment_field.temperature > 1000)
		if(containment)
			field_power_consumption = containment_field.return_pressure() * WATTS_PER_KPA
			field_battery_charge = max(0, field_battery_charge - field_power_consumption * CELLRATE)
		if(field_charging && powered(EQUIP) && MAX_MAGNET_CHARGE > field_battery_charge)
			var/charge_delta = (MAX_MAGNET_CHARGE - field_battery_charge)/CELLRATE
			charge_delta = min(MAX_MAGNET_DELTA, charge_delta) //so we don't drain all power at once
			field_battery_charge += charge_delta * CELLRATE
			use_power_oneoff(charge_delta, EQUIP)

/obj/machinery/power/hybrid_reactor/proc/handle_control_panels()
	var/slow_neutrons_lost = sqrt(slow_neutrons) * (1.001 - reflector_position)
	var/fast_neutrons_lost = sqrt(fast_neutrons) * (1.001 - reflector_position)
	slow_neutrons -= slow_neutrons_lost
	fast_neutrons -= fast_neutrons_lost

	var/fast_neutrons_moderated = sqrt(fast_neutrons) * REACTOR_MODERATOR_POWER * moderator_position
	fast_neutrons -= fast_neutrons_moderated
	slow_neutrons += fast_neutrons_moderated

/obj/machinery/power/hybrid_reactor/proc/process_fusion(datum/gas_mixture/containment_field)
	for(var/cur_reaction_type in subtypesof(/decl/thermonuclear_reaction))
		var/decl/thermonuclear_reaction/cur_reaction = GET_DECL(cur_reaction_type)

		if(!(cur_reaction.first_reactant in containment_field.gas))
			continue
		if(!(cur_reaction.second_reactant in containment_field.gas))
			continue
		if(cur_reaction.minimum_temperature > containment_field.temperature)
			continue

		var/uptake_moles = min(containment_field.gas[cur_reaction.first_reactant], containment_field.gas[cur_reaction.second_reactant]) / containment_field.volume * cur_reaction.cross_section
		containment_field.adjust_gas(cur_reaction.first_reactant, uptake_moles*-0.5, FALSE)
		containment_field.adjust_gas(cur_reaction.second_reactant, uptake_moles*-0.5, FALSE)
		containment_field.adjust_gas(cur_reaction.product, uptake_moles)
		containment_field.add_thermal_energy(cur_reaction.mean_energy * uptake_moles)
		fast_neutrons += cur_reaction.free_neutron_moles * uptake_moles
		xray_flux += uptake_moles * 1.74

/obj/machinery/power/hybrid_reactor/proc/receive_power(power) //in watts
	containment_field.add_thermal_energy(power)
	return

/obj/machinery/power/hybrid_reactor/proc/prime_alarms()

/obj/machinery/power/hybrid_reactor/proc/activate_alarms()
	for(var/obj/machinery/rotating_alarm/reactor/SL in rcontrol.spinning_lights)
		addtimer(CALLBACK(SL, /obj/machinery/rotating_alarm/proc/set_on), rand(1,20))
		SL.evac_alarm = new(SL, TRUE)

/obj/machinery/power/hybrid_reactor/proc/stop_alarms()
	for(var/obj/machinery/rotating_alarm/reactor/SL in rcontrol.spinning_lights)
		SL.set_off()
		QDEL_NULL(SL.evac_alarm)

/obj/machinery/power/hybrid_reactor/proc/start_burning()
	set waitfor = FALSE
	var/list/animate_targets = superstructure.get_above_oo() + superstructure
	for(var/thing in animate_targets)
		var/atom/movable/AM = thing
		var/obj/effect/abstract/particle_holder/our_particle_holder = new(AM.loc, /particles/smoke_continuous/fire/reactor)
		our_particle_holder.alpha = 220
		var/current_spawn_time = 2 SECONDS
		var/i
		for(i=0, i<20, i++)
			current_spawn_time += 3 SECONDS
			spawn(current_spawn_time)
				our_particle_holder.particles.spawning += 2
		animate(AM, color = list(3.5,0,0,0,0,0,0,0,0), time = 20 SECONDS, easing = CUBIC_EASING|EASE_OUT)
		AM.animate_filter("glow", list(color = "#ff0000", offset=2, size=10, time = 20 SECONDS, easing = CUBIC_EASING|EASE_OUT))
		AM.animate_filter("blur", list(size=3, time = 60 SECONDS, easing = CUBIC_EASING))
		AM.set_light(5, 1, "#ffdddd")
		spawn(5 SECONDS)
			AM.set_light(6, 2, "#ffb3b3")
		spawn(10 SECONDS)
			AM.set_light(7, 3, "#ff8181")
		spawn(20 SECONDS)
			animate(AM, color = list(3.5,0,0,2,0,0,0,0,0), time = 40 SECONDS, easing = CUBIC_EASING|EASE_OUT)
			AM.animate_filter("glow", list(color = AM.color, time = 40 SECONDS, easing = CUBIC_EASING|EASE_OUT))
			spawn(5 SECONDS)
				AM.set_light(8, 5, "#fcac77")
			spawn(10 SECONDS)
				AM.set_light(9, 5, "#fcee6f")

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
	cell_explosion(get_turf(superstructure), 2000, 20)
	var/list/our_mobs = mobs_on_main_map()
	for(var/mob/living/carbon/human/H in our_mobs)
		H.playsound_local(H.loc, 'sound/effects/explosion_huge.ogg', 20, 0)
		shake_camera(H, 140, 6)
	spawn(10 SECONDS)
		var/obj/effect/fluid/F = new(T)
		F.reagents.add_reagent(/decl/material/solid/metal/tungsten, 1000000)
		F.temperature = 3900

/obj/machinery/power/hybrid_reactor/proc/scr_det(id)
	var/obj/effect/scripted_detonation/scr_detonation = scripted_explosions[id]
	if(scr_detonation)
		scr_detonation.trigger()

/obj/machinery/power/hybrid_reactor/proc/scr_def(id)
	var/obj/effect/scripted_deflagration/scr_deflagration
	if(scr_deflagration)
		scr_deflagration.trigger()

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
	rcontrol.do_message("THERMOELECTRIC SYSTEMS OVERHEAT", 3)
	rcontrol.do_message("MAJOR INTERNAL STRUCTURAL DAMAGE", 3)
	scr_det("reactor1")
	spawn(2 SECONDS)
		rcontrol.do_message("REACTOR UNIT SYSTEMS UNRESPONSIVE", 3)
		rcontrol.scram("CONTROL LOSS") //won't work lol
		scr_det("reactor2")
	for(var/mob/living/carbon/human/H in human_mob_list)
		if(H.job == "Engineer" || H.job == "Chief Engineer")
			H.playsound_local(H, 'sound/music/howmuchmorecanyoulose.ogg', 50, 0)
			to_chat(H, SPAN_ERPBOLD("And in times like these, it's up to you to decide: How much more can you lose?"))
	sleep(10 SECONDS)
	var/ann_name = "[pick(first_names_male)] [pick(last_names)]"
	radio_announce("ATTENTION ALL REACTOR OPERATIONS PERSONNEL.", ann_name)
	sleep(3 SECONDS)
	scr_det("reactor3")
	radio_announce("THIS IS OUR LAST CHANCE TO PREVENT THE UNCONTROLLABLE DETONATION OF THE H.S.S.R.", ann_name)
	sleep(4 SECONDS)
	scr_det("reactor4")
	radio_announce("CLIMB UP THE REACTOR UNIT, AND EJECT ALL FUEL CELLS NO LONGER THAN WITHIN 3 SECONDS OF EACH OTHER.", ann_name)
	sleep(3 SECONDS)
	radio_announce("TO INVOKE A REACTION STALL AND STOP THE THERMAL RUNAWAY. YOU HAVE A MINUTE, GOOD LUCK.", ann_name)
	sleep(5 SECONDS)
	scr_det("reactor5")
	scr_det("reactor6")
	scr_det("reactor7")
	scr_det("reactor8")
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
	scr_def("dreactor1")
	spawn(2 SECONDS)
		radio_announce("CONTINGENCY OPERATION FAILURE. SHUTTING DOWN...", rcontrol.name)
		scr_def("machinehall")
	sleep(12 SECONDS)
	close_radlocks()
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
			to_chat(H, SPAN_ERPBOLD("Everything comes to an end, as with your own existence."))
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
	stop_alarms()
	produce_explosion()
	radio_announce("MULTIPLE SEISMIC VIBRATIONS OF MAGNITUDE 9 DETECTED.", rcontrol.name)