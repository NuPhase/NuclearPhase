/obj/item/assembly/signaler
	name = "remote signaling device"
	desc = "Used to remotely activate devices."
	icon_state = "signaller"
	item_state = "signaler"
	origin_tech = "{'magnets':1}"
	material = /decl/material/solid/metal/steel
	matter = list(
		/decl/material/solid/fiberglass = MATTER_AMOUNT_REINFORCEMENT,
		/decl/material/solid/metal/copper = MATTER_AMOUNT_TRACE
	)
	wires = WIRE_RECEIVE | WIRE_PULSE | WIRE_RADIO_PULSE | WIRE_RADIO_RECEIVE

	secured = 1

	var/code = 30
	var/frequency = 1457
	var/delay = 0
	var/airlock_wire = null
	var/datum/wires/connected = null
	var/datum/radio_frequency/radio_connection
	var/deadman = 0

/obj/item/assembly/signaler/Initialize()
	. = ..()
	set_frequency(frequency)

/obj/item/assembly/signaler/activate()
	if(cooldown > 0)	return 0
	cooldown = 2
	spawn(10)
		process_cooldown()

	signal()
	return 1

/obj/item/assembly/signaler/on_update_icon()
	. = ..()
	if(holder)
		holder.update_icon()

/obj/item/assembly/signaler/attack_self(mob/user)
	tgui_interact(user)

/obj/item/assembly/signaler/tgui_host(mob/user)
	if(holder)
		return holder
	else
		return ..()

/obj/item/assembly/signaler/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "Signaler", "Remote Signaling Device")
		ui.open()

/obj/item/assembly/signaler/tgui_data(mob/user)
	var/list/data = list(
		"maxFrequency" = RADIO_HIGH_FREQ,
		"minFrequency" = RADIO_LOW_FREQ,
		"frequency" = frequency,
		"code" = code
	)
	return data

/obj/item/assembly/signaler/tgui_act(action, params)
	. = ..()

	if(.)
		return

	switch(action)
		if("adjust")
			if(params["freq"])
				set_frequency(sanitize_frequency(text2num(params["freq"]), RADIO_LOW_FREQ, RADIO_HIGH_FREQ))
			else if(params["code"])
				code = clamp(text2num(params["code"]), 1, 100)
		if("reset")
			if(params["reset"])
				switch(params["reset"])
					if("freq")
						set_frequency(RADIO_LOW_FREQ)
					if("code")
						code = 1
		if("signal")
			activate()
	. = TRUE

	return

/obj/item/assembly/signaler/proc/signal()
	if(!radio_connection) return

	var/datum/signal/signal = new
	signal.source = src
	signal.encryption = code
	signal.data["message"] = "ACTIVATE"
	radio_connection.post_signal(src, signal)


/obj/item/assembly/signaler/pulse(var/radio = 0)
	if(src.connected && src.wires)
		connected.Pulse(src)
	else if(holder)
		holder.process_activation(src, 1, 0)
	else
		..(radio)
	return 1


/obj/item/assembly/signaler/receive_signal(datum/signal/signal)
	if(!signal)	return 0
	if(signal.encryption != code)	return 0
	if(!(src.wires & WIRE_RADIO_RECEIVE))	return 0
	pulse(1)
	if(!holder)
		audible_message(SPAN_NOTICE("[html_icon(src)] *beep* *beep*"), null, 3)

/obj/item/assembly/signaler/proc/set_frequency(new_frequency)
	set waitfor = 0
	if(!frequency)
		return
	if(!radio_controller)
		sleep(20)
	if(!radio_controller)
		return
	radio_controller.remove_object(src, frequency)
	frequency = new_frequency
	radio_connection = radio_controller.add_object(src, frequency, RADIO_CHAT)
	return

/obj/item/assembly/signaler/Process()
	if(!deadman)
		STOP_PROCESSING(SSobj, src)
	var/mob/M = src.loc
	if(!M || !ismob(M))
		if(prob(5))
			signal()
		deadman = 0
		STOP_PROCESSING(SSobj, src)
	else if(prob(5))
		M.visible_message("[M]'s finger twitches a bit over [src]'s signal button!")
	return

/obj/item/assembly/signaler/verb/deadman_it()
	set src in usr
	set name = "Threaten to push the button!"
	set desc = "BOOOOM!"

	if(!deadman)
		deadman = 1
		START_PROCESSING(SSobj, src)
		log_and_message_admins("is threatening to trigger a signaler deadman's switch")
		usr.visible_message("<span class='danger'>[usr] moves their finger over [src]'s signal button...</span>")
	else
		deadman = 0
		STOP_PROCESSING(SSobj, src)
		log_and_message_admins("stops threatening to trigger a signaler deadman's switch")
		usr.visible_message("<span class='notice'>[usr] moves their finger away from [src]'s signal button.</span>")


/obj/item/assembly/signaler/Destroy()
	if(radio_controller)
		radio_controller.remove_object(src,frequency)
	frequency = 0
	. = ..()