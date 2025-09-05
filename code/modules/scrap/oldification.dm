/obj/proc/make_old(change_looks = TRUE)
	if(change_looks)
		name = pick("old ", "expired ", "dirty ") + initial(name)
		desc += pick(" Warranty has expired.", " The inscriptions on this thing were erased by time.", " Looks completely wasted.")
	germ_level = pick(80,110,160)
	if(prob(40))
		if(prob(70))
			light_power = light_power / pick(1.5, 2, 2.5)
		if(prob(70))
			light_range = light_range / pick(1.5, 2, 2.5)
		if(prob(15))
			light_range = 0
			light_power = 0
	for(var/obj/item/sub_item in contents)
		sub_item.make_old()
	update_icon()

/obj/item/make_old()
	..()
	siemens_coefficient += 0.3

/obj/item/weapon/storage/make_old()
	var/del_count = rand(0,contents.len)
	for(var/i = 1 to del_count)
		var/removed_item = pick(contents)
		contents -= removed_item
		qdel(removed_item)
	..()

/obj/item/chems/make_old()
	reagents.remove_any(rand(0, 1000))
	reagents.add_reagent(/decl/material/liquid/water/dirty3, rand(0,100))
	..()

/obj/item/stack/sheet/make_old()
	return
/obj/item/stack/rods/make_old()
	return
/obj/item/weapon/shard/make_old()
	return

/obj/item/clothing/make_old()
	if(prob(25))
		heat_protection = 0
	if(prob(25))
		cold_protection = 0
	if(prob(35))
		contaminate()
	if(prob(75))
		generate_blood_overlay()
	..()

/obj/item/clothing/glasses/make_old()
	..()
	if(prob(75))
		vision_flags = 0
	if(prob(75))
		darkness_view = -1

/obj/machinery/floodlight/make_old()
	..()
	if(prob(75))
		l_power = l_power / 2

/obj/machinery/make_old()
	..()
	if(prob(60))
		stat |= BROKEN
	if(prob(60))
		emagged = 1

/obj/machinery/vending/make_old()
	..()
	if(prob(60))
		shut_up = 0
	if(prob(60))
		shoot_inventory = 1
	if(prob(75))
		var/del_count = rand(0,product_records.len)
		for(var/i = 1 to del_count)
			var/removed_item = pick(product_records)
			product_records -= removed_item
			qdel(removed_item)