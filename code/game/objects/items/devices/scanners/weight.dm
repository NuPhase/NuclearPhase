/obj/item/scanner/weight
	name = "handheld weight scale"
	desc = "A simple scale for measuring object mass."
	icon = 'icons/obj/items/device/scanner/xenobio_scanner.dmi'
	icon_state = "xenobio"
	item_state = "analyzer"
	scan_sound = 'sound/effects/magnetclamp.ogg'
	printout_color = "#f3e6ff"
	material = /decl/material/solid/metal/steel
	matter = list(
		/decl/material/solid/fiberglass = MATTER_AMOUNT_REINFORCEMENT,
		/decl/material/solid/plastic = MATTER_AMOUNT_TRACE
	)

/obj/item/scanner/weight/scan(atom/O, mob/user)
	scan_title = "Weight scan data"
	if(O.weight > 1)
		scan_data =  "Object mass: [round(O.weight, 0.1)]kg."
	else
		scan_data =  "Object mass: [round(O.weight*1000)]g."
	user.show_message(SPAN_NOTICE(scan_data))