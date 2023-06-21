/obj/machinery/reactor_button/rswitch/valve/pump1v1
	name = "F-CP 1V-IN"
	id = "F-CP 1V-IN"
	icon_state = "switch2-off"
	off_icon_state = "switch2-off"
	on_icon_state = "switch2-on"
/obj/machinery/reactor_button/rswitch/valve/pump1v2
	name = "F-CP 1V-EX"
	id = "F-CP 1V-EX"
	icon_state = "switch2-off"
	off_icon_state = "switch2-off"
	on_icon_state = "switch2-on"
/obj/machinery/reactor_button/rswitch/valve/pump2v1
	name = "F-CP 2V-IN"
	id = "F-CP 2V-IN"
	icon_state = "switch2-off"
	off_icon_state = "switch2-off"
	on_icon_state = "switch2-on"
/obj/machinery/reactor_button/rswitch/valve/pump2v2
	name = "F-CP 2V-EX"
	id = "F-CP 2V-EX"
	icon_state = "switch2-off"
	off_icon_state = "switch2-off"
	on_icon_state = "switch2-on"

/obj/machinery/reactor_button/rswitch/valve/pump3v1
	name = "T-CP 1V-IN"
	id = "T-CP 1V-IN"
/obj/machinery/reactor_button/rswitch/valve/pump3v2
	name = "T-CP 1V-EX"
	id = "T-CP 1V-EX"
/obj/machinery/reactor_button/rswitch/valve/pump4v1
	name = "T-CP 2V-IN"
	id = "T-CP 2V-IN"
/obj/machinery/reactor_button/rswitch/valve/pump4v2
	name = "T-CP 2V-EX"
	id = "T-CP 2V-EX"
/obj/machinery/reactor_button/presvalve/tprescontrol
	name = "T-PRES-CONTROL"
	id = "T-PRES-CONTROL"

/obj/machinery/reactor_button/rswitch/valve/feedmakeup
	name = "T-FEEDWATER V-MAKEUP"
	id = "T-FEEDWATER V-MAKEUP"

/obj/machinery/reactor_button/regvalve/feeddrain
	name = "T-FEEDWATER V-DRAIN"
	id = "T-FEEDWATER V-DRAIN"

/obj/machinery/reactor_button/rswitch/preheat
	name = "F-PREHEAT"
	id = "heater"

/obj/machinery/reactor_button/rswitch/preheat/do_action(mob/user)
	. = ..()
	var/obj/machinery/atmospherics/unary/heater/reactor/heater = reactor_components[id]
	if(state == 1)
		heater.use_power = POWER_USE_IDLE
		heater.power_rating = heater.max_power_rating
	else
		heater.use_power = POWER_USE_OFF
		heater.power_rating = 0

/obj/machinery/reactor_button/rswitch/preheat/coolant
	name = "T-COOLANT PREHEAT"
	id = "T-COOLANT PREHEAT"

/obj/machinery/reactor_button/regvalve/reactorfvin
	name = "REACTOR-F-V-IN"
	id = "REACTOR-F-V-IN"

/obj/machinery/reactor_button/regvalve/reactorfvout
	name = "REACTOR-F-V-OUT"
	id = "REACTOR-F-V-OUT"

/obj/machinery/reactor_button/regvalve/heatexchangervin
	name = "HEATEXCHANGER V-IN"
	id = "HEATEXCHANGER V-IN"

/obj/machinery/reactor_button/presvalve/tcoolantvin
	name = "T-COOLANT V-IN"
	id = "T-COOLANT V-IN"

/obj/machinery/reactor_button/presvalve/tcoolantvout
	name = "T-COOLANT V-OUT"
	id = "T-COOLANT V-OUT"

/obj/machinery/reactor_button/rswitch/generator_connection/first
	name = "TURB 1-GRID"
	id = "generator1"

/obj/machinery/reactor_button/rswitch/generator_connection/second
	name = "TURB 2-GRID"
	id = "generator2"

/obj/machinery/reactor_button/rswitch/generator_connection/first/do_action(mob/user)
	. = ..()
	var/obj/machinery/power/generator/turbine_generator/gen = rcontrol.generator1
	if(state == 1)
		gen.connected = TRUE
	else
		gen.connected = FALSE

/obj/machinery/reactor_button/rswitch/generator_connection/second/do_action(mob/user)
	..()
	var/obj/machinery/power/generator/turbine_generator/gen = rcontrol.generator2
	if(state == 1)
		gen.connected = TRUE
	else
		gen.connected = FALSE

/obj/machinery/reactor_button/protected/turbine_braking
	name = "TURB BRAKES"
	desc = "Turbine braking system switch. It's impossible to switch them off from here, you'll have to do it manually."
	cooldown = 30 SECONDS

/obj/machinery/reactor_button/protected/turbine_braking/do_action(mob/user)
	..()
	rcontrol.turbine1.braking = TRUE
	rcontrol.turbine2.braking = TRUE
	visible_message(SPAN_WARNING("[user] switches on the emergency brakes on the steam turbines!"))