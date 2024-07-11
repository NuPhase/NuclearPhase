#define MODE_NOMINAL  "NOMINAL"  // Steady power supply from turbines.
#define MODE_NO_MAIN  "BACKUP"   // No turbines, generators provide enough power.
#define MODE_RESERVE  "BATTERIES"// No generators, running on batteries.
#define MODE_OFFLINE  "OFFLINE"  // No active control measures.

/datum/power_control_system
	var/mode = MODE_NOMINAL // Current mode of operation
	var/list/log_messages = list() // All active, non-cleared messages
	var/list/log_archive = list() // All messages

	// Associative lists of switchable transformers.
	// ID = reference
	var/list/feeder_transformers = list() // GEN to BUS | TURBINE to BUS
	var/list/sector_transformers = list() // BUS to SEC A/B/C/D/E
	var/list/all_transformers = list() // All switchable transformers. Not associative.

	var/list/sector_ids = list("A", "B", "C", "D", "E")

/datum/power_control_system/New()
	. = ..()
	spawn(30 SECONDS)
		assemble_transformer_lists()
		START_PROCESSING(SSobj, src)

/datum/power_control_system/Process()
	if(mode == MODE_OFFLINE)
		return
	assess_bus()
	if(mode == MODE_NO_MAIN || mode == MODE_RESERVE)
		assess_gen()

/datum/power_control_system/proc/assemble_transformer_lists()
	var/list/sector_transformers_ids = list()
	for(var/sector_id in sector_ids)
		sector_transformers_ids += "BUS to SEC [sector_id]"

	// Find the required transformers and toss them into their respective lists
	for(var/obj/machinery/power/generator/transformer/switchable/our_trans in all_transformers)
		if(our_trans.uid in list("GEN to BUS", "TURBINE to BUS"))
			feeder_transformers[our_trans.uid] = our_trans
			continue
		if(our_trans.uid in sector_transformers_ids)
			sector_transformers[our_trans.uid] = our_trans

// Makes a log on the console. If critical, sends a message on the tech radio frequency.
/datum/power_control_system/proc/make_report(message, is_critical)
	log_archive += message
	if((message in log_messages))
		return // We already have it
	log_messages += message
	if(is_critical)
		radio_announce(message, "Power Control System")

/datum/power_control_system/proc/enable_noncritical_transformers()
	var/list/sector_transformers_ids = list()
	for(var/sector_id in list("A", "D"))
		sector_transformers_ids += "BUS to SEC [sector_id]"
	for(var/sector_id in sector_transformers_ids)
		var/obj/machinery/power/generator/transformer/switchable/our_trans = sector_transformers[sector_id]
		our_trans.switch_on()

/datum/power_control_system/proc/disable_noncritical_transformers()
	var/list/sector_transformers_ids = list()
	for(var/sector_id in list("A", "D"))
		sector_transformers_ids += "BUS to SEC [sector_id]"
	for(var/sector_id in sector_transformers_ids)
		var/obj/machinery/power/generator/transformer/switchable/our_trans = sector_transformers[sector_id]
		our_trans.switch_off()

/datum/power_control_system/proc/switch_mode(new_mode)
	if(mode == new_mode)
		return
	mode = new_mode
	make_report("Mode switched to [new_mode]")
	if(new_mode == MODE_OFFLINE)
		for(var/obj/machinery/power/generator/transformer/switchable/our_trans in all_transformers)
			our_trans.busy = FALSE
	else
		for(var/obj/machinery/power/generator/transformer/switchable/our_trans in all_transformers)
			our_trans.busy = TRUE
	switch(new_mode)
		if(MODE_NOMINAL)
			var/obj/machinery/power/generator/transformer/switchable/our_trans = feeder_transformers["TURBINE to BUS"]
			our_trans.switch_on()
			our_trans = feeder_transformers["GEN to BUS"]
			our_trans.switch_off()
			enable_noncritical_transformers()
		if(MODE_NO_MAIN)
			var/obj/machinery/power/generator/transformer/switchable/our_trans = feeder_transformers["TURBINE to BUS"]
			our_trans.switch_off()
			our_trans = feeder_transformers["GEN to BUS"]
			our_trans.switch_on()
			enable_noncritical_transformers()
			make_report("Warning - Loss of main turbine power", TRUE)
		if(MODE_RESERVE)
			var/obj/machinery/power/generator/transformer/switchable/our_trans = feeder_transformers["TURBINE to BUS"]
			our_trans.switch_off()
			our_trans = feeder_transformers["GEN to BUS"]
			our_trans.switch_on()
			disable_noncritical_transformers()
			make_report("Warning - Loss of backup power", TRUE)
		if(MODE_OFFLINE)
			enable_noncritical_transformers()

// Checks the bus for possible errors.
// If no power is coming from TURBINE to BUS, switch mode to MODE_NO_MAIN and call assess_gen()
// If power is available on TURBINE to BUS, switch mode to MODE_NOMINAL
// Should return TRUE if no errors are found
/datum/power_control_system/proc/assess_bus()
	//Check if we have power on turbine transformer
	var/obj/machinery/power/generator/transformer/switchable/our_trans = feeder_transformers["TURBINE to BUS"]
	if(mode == MODE_NOMINAL && (!our_trans.available() || !our_trans.on))
		switch_mode(MODE_NO_MAIN)
		assess_gen()
		return FALSE
	else if(our_trans.available())
		switch_mode(MODE_NOMINAL)
		return FALSE
	return TRUE

/datum/power_control_system/proc/assess_gen()
	var/obj/machinery/power/generator/transformer/switchable/our_trans = feeder_transformers["GEN to BUS"]
	var/has_active_generator = FALSE
	for(var/obj/machinery/power/generator/port_gen/our_gen in our_trans.powernet.nodes)
		if(our_gen.active)
			has_active_generator = TRUE
			break
	if(!has_active_generator)
		switch_mode(MODE_RESERVE)
	else
		switch_mode(MODE_NO_MAIN)

	return TRUE