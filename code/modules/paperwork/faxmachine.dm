var/global/list/allfaxes = list()
var/global/list/alldepartments = list()

var/global/list/adminfaxes = list()	//cache for faxes that have been sent to admins

/obj/machinery/photocopier/faxmachine
	name = "fax machine"
	icon = 'icons/obj/bureaucracy.dmi'
	icon_state = "fax"
	insert_anim = "faxsend"
	var/send_access = list(list(access_lawyer, access_bridge, access_armory, access_qm))

	idle_power_usage = 30
	active_power_usage = 200

	var/obj/item/card/id/scan = null // identification
	var/authenticated = 0
	var/sendcooldown = 0 // to avoid spamming fax messages
	var/department = "Unknown" // our department
	var/destination = null // the department we're sending to
	var/hassignal = FALSE //We have no hope

	var/static/list/admin_departments

/obj/machinery/photocopier/faxmachine/Initialize()
	. = ..()

	//if(!admin_departments)
	//	admin_departments = list("[global.using_map.boss_name]", "Sol Federal Police", "[global.using_map.boss_short] Supply") + global.using_map.map_admin_faxes
	if(!admin_departments)
		admin_departments = list("Central Planetary Emergency Uplink", "Rescue Operations Center")
	global.allfaxes += src
	if(!destination)
		destination = "Rescue Operations Center"
	//if( !(("[department]" in global.alldepartments) || ("[department]" in admin_departments)))
	//	global.alldepartments |= department

/obj/machinery/photocopier/faxmachine/attackby(obj/item/O, mob/user)
	if(istype(O, /obj/item/card/id))
		if(!user.unEquip(O, src))
			return
		scan = O
		to_chat(user, "<span class='notice'>You insert \the [O] into \the [src].</span>")
	else
		..()

/obj/machinery/photocopier/faxmachine/interface_interact(mob/user)
	interact(user)
	return TRUE

/obj/machinery/photocopier/faxmachine/interact(mob/user)
	user.set_machine(src)

	var/dat = "Fax Machine<BR>"

	var/scan_name
	if(scan)
		scan_name = scan.name
	else
		scan_name = "--------"

	dat += "Confirm Identity: <a href='byond://?src=\ref[src];scan=1'>[scan_name]</a><br>"

	if(authenticated)
		dat += "<a href='byond://?src=\ref[src];logout=1'>{Log Out}</a>"
	else
		dat += "<a href='byond://?src=\ref[src];auth=1'>{Log In}</a>"

	dat += "<hr>"

	if(authenticated)
		dat += "<b>Logged in to:</b> [global.using_map.boss_name] Quantum Entanglement Network<br><br>"

		if(copyitem)
			dat += "<a href='byond://?src=\ref[src];remove=1'>Remove Item</a><br><br>"

			if(!sendcooldown && hassignal)
				dat += "<a href='byond://?src=\ref[src];send=1'>Send</a><br>"
				dat += "<b>Currently sending:</b> [copyitem.name]<br>"
				dat += "<b>Sending to:</b> <a href='byond://?src=\ref[src];dept=1'>[destination]</a><br>"
			else
				dat += "<b>Transmitter arrays realigning. Please stand by.</b><br>"

		else
			if(sendcooldown)
				dat += "Please insert paper to send via secure connection.<br><br>"
				dat += "<b>Transmitter arrays realigning. Please stand by.</b><br>"
			else
				dat += "Please insert paper to send via secure connection.<br><br>"

	else
		dat += "Proper authentication is required to use this device.<br><br>"

		if(copyitem)
			dat += "<a href ='byond://?src=\ref[src];remove=1'>Remove Item</a><br>"

	show_browser(user, dat, "window=copier")
	onclose(user, "copier")
	return

/obj/machinery/photocopier/faxmachine/OnTopic(mob/user, href_list, state)
	if(href_list["send"])
		if(copyitem)
			if (destination in admin_departments)
				send_admin_fax(user, destination)
			else
				sendfax(destination)

			if (sendcooldown)
				spawn(sendcooldown) // cooldown time
					sendcooldown = 0
		return TOPIC_REFRESH

	if(href_list["remove"])
		OnRemove(user)
		return TOPIC_REFRESH

	if(href_list["scan"])
		if (scan)
			if(ishuman(user))
				user.put_in_hands(scan)
			else
				scan.dropInto(loc)
			scan = null
		else
			var/obj/item/I = user.get_active_hand()
			if (istype(I, /obj/item/card/id) && user.unEquip(I, src))
				scan = I
		authenticated = 0
		return TOPIC_REFRESH

	if(href_list["dept"])
		var/desired_destination = input(user, "Which department?", "Choose a department", "") as null|anything in (global.alldepartments + admin_departments)
		if(desired_destination && CanInteract(user, state))
			destination = desired_destination
		return TOPIC_REFRESH

	if(href_list["auth"])
		if ( (!( authenticated ) && (scan)) )
			if (has_access(send_access, scan.GetAccess()))
				authenticated = 1
		return TOPIC_REFRESH

	if(href_list["logout"])
		authenticated = 0
		return TOPIC_REFRESH

/obj/machinery/photocopier/faxmachine/proc/sendfax(var/destination)
	if(stat & (BROKEN|NOPOWER))
		return

	use_power_oneoff(200)

	var/success = 0
	for(var/obj/machinery/photocopier/faxmachine/F in global.allfaxes)
		if( F.department == destination )
			success = F.recievefax(copyitem)

	if (success)
		visible_message("[src] beeps, \"Message transmitted successfully.\"")
		//sendcooldown = 600
	else
		visible_message("[src] beeps, \"Error transmitting message.\"")

/obj/machinery/photocopier/faxmachine/proc/recievefax(var/obj/item/incoming)
	if(stat & (BROKEN|NOPOWER))
		return 0

	if(department == "Unknown")
		return 0	//You can't send faxes to "Unknown"

	flick("faxreceive", src)
	playsound(loc, "sound/machines/dotprinter.ogg", 50, 1)

	// give the sprite some time to flick
	sleep(20)

	if (istype(incoming, /obj/item/paper))
		copy(incoming)
	else if (istype(incoming, /obj/item/photo))
		photocopy(incoming)
	else if (istype(incoming, /obj/item/paper_bundle))
		bundlecopy(incoming)
	else
		return 0

	use_power_oneoff(active_power_usage)
	return 1

/obj/machinery/photocopier/faxmachine/proc/send_admin_fax(var/mob/sender, var/destination)
	if(stat & (BROKEN|NOPOWER))
		return

	use_power_oneoff(200)

	//recieved copies should not use toner since it's being used by admins only.
	var/obj/item/rcvdcopy
	if (istype(copyitem, /obj/item/paper))
		rcvdcopy = copy(copyitem, 0)
	else if (istype(copyitem, /obj/item/photo))
		rcvdcopy = photocopy(copyitem, 0)
	else if (istype(copyitem, /obj/item/paper_bundle))
		rcvdcopy = bundlecopy(copyitem, 0)
	else
		visible_message("[src] beeps, \"Error transmitting message.\"")
		return

	rcvdcopy.forceMove(null) //hopefully this shouldn't cause trouble
	global.adminfaxes += rcvdcopy

	//message badmins that a fax has arrived
	if (destination == global.using_map.boss_name)
		message_admins(sender, "[uppertext(destination)] FAX", rcvdcopy, destination, "#006100")
	else if (destination == "Sol Federal Police")
		message_admins(sender, "[uppertext(destination)] FAX", rcvdcopy, destination, "#1f66a0")
	else if (destination == "[global.using_map.boss_short] Supply")
		message_admins(sender, "[uppertext(destination)] FAX", rcvdcopy, destination, "#5f4519")
	else if (destination in global.using_map.map_admin_faxes)
		message_admins(sender, "[uppertext(destination)] FAX", rcvdcopy, destination, "#510b74")
	else
		message_admins(sender, "[uppertext(destination)] FAX", rcvdcopy, "UNKNOWN")

	sendcooldown = 1800
	sleep(50)
	visible_message("[src] beeps, \"Message transmitted successfully.\"")


/obj/machinery/photocopier/faxmachine/proc/message_admins(var/mob/sender, var/faxname, var/obj/item/sent, var/reply_type, font_colour="#006100")
	var/msg = "<span class='notice'><b><font color='[font_colour]'>[faxname]: </font>[get_options_bar(sender, 2,1,1)]"
	msg += "(<A HREF='?_src_=holder;take_ic=\ref[sender]'>TAKE</a>) (<a href='?_src_=holder;FaxReply=\ref[sender];originfax=\ref[src];replyorigin=[reply_type]'>REPLY</a>)</b>: "
	msg += "Receiving '[sent.name]' via secure connection ... <a href='?_src_=holder;AdminFaxView=\ref[sent]'>view message</a></span>"

	for(var/client/C in global.admins)
		if(check_rights((R_ADMIN|R_MOD),0,C))
			to_chat(C, msg)
			sound_to(C, 'sound/machines/dotprinter.ogg')
