/obj/machinery/photocopier
	name                  = "photocopier"
	icon                  = 'icons/obj/machines/photocopier.dmi'
	icon_state            = "photocopier"
	anchored              = TRUE
	density               = TRUE
	idle_power_usage      = 30
	active_power_usage    = 200
	atom_flags            = ATOM_FLAG_CLIMBABLE
	obj_flags             = OBJ_FLAG_ANCHORABLE
	construct_state       = /decl/machine_construction/default/panel_closed
	maximum_component_parts = list(
		/obj/item/stock_parts/printer = 1,
		/obj/item/stock_parts         = 10,
	)
	uncreated_component_parts = null
	var/tmp/insert_anim   = "photocopier_animation"
	var/obj/item/scanner_item                  //what's in the scanner
	var/obj/item/stock_parts/printer/printer   //What handles the printing queue
	var/tmp/max_copies    = 10                 //how many copies can be copied at once- idea shamelessly stolen from bs12's copier!
	var/tmp/busy          = FALSE              //Whether we should allow people to mess with the settings and contents
	var/accept_refill     = FALSE              //Whether we should handle attackby paper to be sent to the paper bin, or to the scanner slot
	var/total_printing    = 0                  //The total number of pages we are printing in the current run

/obj/machinery/photocopier/Initialize(mapload, d=0, populate_parts = TRUE)
	. = ..()
	if(.!= INITIALIZE_HINT_QDEL && populate_parts && printer)
		//Mapped photocopiers shall spawn with ink and paper
		printer.make_full()

/obj/machinery/photocopier/Destroy()
	scanner_item = null
	printer = null
	return ..()

/obj/machinery/photocopier/RefreshParts()
	. = ..()
	printer = get_component_of_type(/obj/item/stock_parts/printer) //Cache the printer component
	if(printer)
		printer.show_queue_ctrl = FALSE //Make sure we don't let users mess with the print queue
		printer.register_on_printed_page(  CALLBACK(src, /obj/machinery/photocopier/proc/update_ui))
		printer.register_on_finished_queue(CALLBACK(src, /obj/machinery/photocopier/proc/update_ui))
		printer.register_on_print_error(   CALLBACK(src, /obj/machinery/photocopier/proc/update_ui))
		printer.register_on_status_changed(CALLBACK(src, /obj/machinery/photocopier/proc/update_ui))

/obj/machinery/photocopier/on_update_icon()
	cut_overlays()
	//Set the icon first
	if(scanner_item)
		icon_state = "photocopier_paper"
	else
		icon_state = initial(icon_state)

	//If powered and working add the flashing lights
	if(inoperable())
		return
	//Warning lights
	if(scanner_item)
		add_overlay("photocopier_ready")
	if(!printer?.has_enough_to_print())
		add_overlay("photocopier_bad")

/obj/machinery/photocopier/proc/update_ui()
	SSnano.update_uis(src)
	update_icon()

/obj/machinery/photocopier/proc/queue_copies(var/copy_amount, var/mob/user)
	if(!scanner_item)
		if(user)
			to_chat(user, SPAN_WARNING("Insert something to copy first!"))
		return FALSE

	//First, check we have enough to print the copies
	var/required_toner = 0
	var/required_paper = 1

	//Compile the total amount needed for printing the whole bundle if applicable
	if(istype(scanner_item, /obj/item/paper_bundle))
		var/obj/item/paper_bundle/B = scanner_item
		for(var/obj/item/I in B.pages)
			required_toner += istype(I, /obj/item/photo)? TONER_USAGE_PHOTO : TONER_USAGE_PAPER
		required_paper = length(B.pages)
	else if(istype(scanner_item, /obj/item/photo))
		required_toner = TONER_USAGE_PHOTO
	else
		required_toner = TONER_USAGE_PAPER

	if(!printer?.has_enough_to_print(required_toner, required_paper * copy_amount))
		buzz("Warning: Not enough paper or toner!")
		return FALSE

	//If we have enough go ahead
	var/list/obj/item/scanned_item = scan_item(scanner_item) //Generate the copies we'll queue for printing
	for(var/i=1 to copy_amount)
		for(var/obj/item/page in scanned_item)
			printer.queue_job(page)

	//Play the scanner animation
	flick(insert_anim, src)

	//Actually start printing out the copies we created when queueing
	start_processing_queue()
	return TRUE

/obj/machinery/photocopier/proc/start_processing_queue()
	if(!printer)
		return FALSE
	audible_message(SPAN_NOTICE("\The [src] whirrs into action."))
	total_printing = printer.get_amount_queued()
	printer.start_printing_queue()

	use_power_oneoff(active_power_usage)
	update_icon()
	SSnano.update_uis(src)
	return TRUE

/obj/machinery/photocopier/proc/stop_processing_queue()
	if(!printer)
		return FALSE
	total_printing = 0
	printer.stop_printing_queue()
	printer.clear_job_queue()

	update_use_power(POWER_USE_IDLE)
	update_icon()
	SSnano.update_uis(src)
	return TRUE

/obj/machinery/photocopier/interface_interact(mob/user)
	interact(user)
	return TRUE

/obj/machinery/photocopier/interact(mob/user)
	user.set_machine(src)

	var/dat = "Photocopier<BR><BR>"
	if(copyitem)
		dat += "<a href='byond://?src=\ref[src];remove=1'>Remove Item</a><BR>"
		if(toner)
			dat += "<a href='byond://?src=\ref[src];copy=1'>Copy</a><BR>"
			dat += "Printing: [copies] copies."
			dat += "<a href='byond://?src=\ref[src];min=1'>-</a> "
			dat += "<a href='byond://?src=\ref[src];add=1'>+</a><BR><BR>"
	else if(toner)
		dat += "Please insert something to copy.<BR><BR>"
	if(istype(user,/mob/living/silicon))
		dat += "<a href='byond://?src=\ref[src];aipic=1'>Print photo from database</a><BR><BR>"
	dat += "Current toner level: [toner]"
	if(!toner)
		dat +="<BR>Please insert a new toner cartridge!"
	show_browser(user, dat, "window=copier")
	onclose(user, "copier")
	return

/obj/machinery/photocopier/OnTopic(user, href_list, state)
	if(href_list["copy"])
		for(var/i = 0, i < copies, i++)
			if(toner <= 0)
				break
			if (istype(copyitem, /obj/item/paper))
				copy(copyitem, 1)
				sleep(15)
			else if (istype(copyitem, /obj/item/photo))
				photocopy(copyitem)
				sleep(15)
			else if (istype(copyitem, /obj/item/paper_bundle))
				var/obj/item/paper_bundle/B = bundlecopy(copyitem)
				sleep(15*B.pages.len)
			else
				to_chat(user, "<span class='warning'>\The [copyitem] can't be copied by \the [src].</span>")
				break

			use_power_oneoff(active_power_usage)
		return TOPIC_REFRESH

	if(href_list["remove"])
		OnRemove(user)
		return TOPIC_REFRESH

	if(href_list["min"])
		if(copies > 1)
			copies--
		return TOPIC_REFRESH

	else if(href_list["add"])
		if(copies < maxcopies)
			copies++
		return TOPIC_REFRESH

	if(href_list["aipic"])
		if(!istype(user,/mob/living/silicon)) return

		if(toner >= 5)
			var/mob/living/silicon/tempAI = user
			var/obj/item/camera/siliconcam/camera = tempAI.silicon_camera

			if(!camera)
				return
			var/obj/item/photo/selection = camera.selectpicture()
			if (!selection)
				return

			var/obj/item/photo/p = photocopy(selection)
			if (p.desc == "")
				p.desc += "Copied by [tempAI.name]"
			else
				p.desc += " - Copied by [tempAI.name]"
			toner -= 5
			sleep(15)
		return TOPIC_REFRESH

/obj/machinery/photocopier/proc/OnRemove(mob/user)
	if(copyitem)
		user.put_in_hands(copyitem)
		to_chat(user, "<span class='notice'>You take \the [copyitem] out of \the [src].</span>")
		copyitem = null

/obj/machinery/photocopier/attackby(obj/item/O, mob/user)
	if(istype(O, /obj/item/paper) || istype(O, /obj/item/photo) || istype(O, /obj/item/paper_bundle))
		if(!copyitem)
			if(!user.unEquip(O, src))
				return
			copyitem = O
			to_chat(user, "<span class='notice'>You insert \the [O] into \the [src].</span>")
			flick(insert_anim, src)
			updateUsrDialog()
		else
			to_chat(user, "<span class='notice'>There is already something in \the [src].</span>")
	else if(istype(O, /obj/item/toner))
		if(toner <= 10) //allow replacing when low toner is affecting the print darkness
			if(!user.unEquip(O, src))
				return
			to_chat(user, "<span class='notice'>You insert the toner cartridge into \the [src].</span>")
			var/obj/item/toner/T = O
			toner += T.toner_amount
			qdel(O)
			updateUsrDialog()
		else
			to_chat(user, "<span class='notice'>This cartridge is not yet ready for replacement! Use up the rest of the toner.</span>")
	else ..()

/obj/machinery/photocopier/explosion_act(severity)
	..()
	if(!QDELETED(src) && (severity == 2 || prob(50)) && toner)
		new /obj/effect/decal/cleanable/blood/oil(get_turf(src))
		toner = 0

/obj/machinery/photocopier/proc/copy(var/obj/item/paper/copy, var/need_toner=1)
	var/obj/item/paper/c = new copy.type(loc, copy.text, copy.name, copy.metadata )

	c.color = COLOR_WHITE

	if(toner > 10)	//lots of toner, make it dark
		c.info = "<font color = #101010>"
	else			//no toner? shitty copies for you!
		c.info = "<font color = #808080>"
	var/copied = copy.info
	copied = replacetext(copied, "<font face=\"[c.deffont]\" color=", "<font face=\"[c.deffont]\" nocolor=")	//state of the art techniques in action
	copied = replacetext(copied, "<font face=\"[c.crayonfont]\" color=", "<font face=\"[c.crayonfont]\" nocolor=")	//This basically just breaks the existing color tag, which we need to do because the innermost tag takes priority.
	c.info += copied
	c.info += "</font>"//</font>
	c.SetName(copy.name) // -- Doohl
	c.fields = copy.fields
	c.stamps = copy.stamps
	c.stamped = copy.stamped
	c.ico = copy.ico
	c.offset_x = copy.offset_x
	c.offset_y = copy.offset_y
	var/list/temp_overlays = copy.overlays       //Iterates through stamps
	var/image/img                                //and puts a matching
	for (var/j = 1, j <= min(temp_overlays.len, copy.ico.len), j++) //gray overlay onto the copy
		if (findtext(copy.ico[j], "cap") || findtext(copy.ico[j], "cent"))
			img = image('icons/obj/bureaucracy.dmi', "paper_stamp-circle")
		else if (findtext(copy.ico[j], "deny"))
			img = image('icons/obj/bureaucracy.dmi', "paper_stamp-x")
		else
			img = image('icons/obj/bureaucracy.dmi', "paper_stamp-dots")
		img.pixel_x = copy.offset_x[j]
		img.pixel_y = copy.offset_y[j]
		c.overlays += img
	c.updateinfolinks()
	if(need_toner)
		toner--
	if(toner == 0)
		visible_message("<span class='notice'>A red light on \the [src] flashes, indicating that it is out of toner.</span>")
	c.update_icon()
	return c

/obj/machinery/photocopier/proc/photocopy(var/obj/item/photo/photocopy, var/need_toner=1)
	var/obj/item/photo/p = photocopy.copy()
	p.dropInto(loc)

	if(toner > 10)	//plenty of toner, go straight greyscale
		p.img.MapColors(rgb(77,77,77), rgb(150,150,150), rgb(28,28,28), rgb(0,0,0))//I'm not sure how expensive this is, but given the many limitations of photocopying, it shouldn't be an issue.
		p.update_icon()
	else			//not much toner left, lighten the photo
		p.img.MapColors(rgb(77,77,77), rgb(150,150,150), rgb(28,28,28), rgb(100,100,100))
		p.update_icon()
	if(need_toner)
		toner -= 5	//photos use a lot of ink!
	if(toner < 0)
		toner = 0
		visible_message("<span class='notice'>A red light on \the [src] flashes, indicating that it is out of toner.</span>")

	return p

//If need_toner is 0, the copies will still be lightened when low on toner, however it will not be prevented from printing. TODO: Implement print queues for fax machines and get rid of need_toner
/obj/machinery/photocopier/proc/bundlecopy(var/obj/item/paper_bundle/bundle, var/need_toner=1)
	var/obj/item/paper_bundle/p = new /obj/item/paper_bundle (src)
	for(var/obj/item/W in bundle.pages)
		if(toner <= 0 && need_toner)
			toner = 0
			visible_message("<span class='notice'>A red light on \the [src] flashes, indicating that it is out of toner.</span>")
			break

		if(istype(W, /obj/item/paper))
			W = copy(W)
		else if(istype(W, /obj/item/photo))
			W = photocopy(W)
		W.forceMove(p)
		p.pages += W

	p.dropInto(loc)
	p.update_icon()
	p.icon_state = "paper_words"
	p.SetName(bundle.name)
	return p

/obj/item/toner
	name = "toner cartridge"
	icon = 'icons/obj/items/tonercartridge.dmi'
	icon_state = "tonercartridge"
	var/toner_amount = 30
