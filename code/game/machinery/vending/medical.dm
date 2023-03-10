
/obj/machinery/vending/medical
	name = "NanoMed Plus"
	desc = "Medical drug dispenser."
	icon_state = "med"
	icon_deny = "med-deny"
	icon_vend = "med-vend"
	vend_delay = 18
	markup = 0
	base_type = /obj/machinery/vending/medical
	product_ads = "Go save some lives!;The best stuff for your medbay.;Only the finest tools.;Natural chemicals!;This stuff saves lives.;Don't you want some?;Ping!"
	initial_access = list(access_medical_equip)
	products = list(
		/obj/item/chems/glass/bottle/charcoal = 4,
		/obj/item/chems/glass/bottle/stabilizer = 4,
		/obj/item/chems/glass/bottle/sedatives = 4,
		/obj/item/chems/glass/bottle/bromide = 4,
		/obj/item/chems/syringe/antibiotic = 4,
		/obj/item/chems/syringe = 12,
		/obj/item/scanner/health = 5,
		/obj/item/chems/glass/beaker = 4,
		/obj/item/chems/dropper = 2,
		/obj/item/stack/medical/advanced/bruise_pack = 3,
		/obj/item/stack/medical/advanced/ointment = 3,
		/obj/item/stack/medical/splint = 2,
		/obj/item/chems/hypospray/autoinjector/pain = 4
	)
	contraband = list(
		/obj/item/clothing/mask/chewable/candy/lolli/meds = 8,
		/obj/item/chems/pill/bromide = 3,
		/obj/item/chems/pill/stox = 4,
		/obj/item/chems/pill/antitox = 6
	)
	idle_power_usage = 211 //refrigerator - believe it or not, this is actually the average power consumption of a refrigerated vending machine according to NRCan.

/obj/machinery/vending/wallmed1
	name = "wall mounted medkit"
	desc = "A firstaid kit mounted on the wall."
	product_ads = "Go save some lives!;The best stuff for your medbay.;Only the finest tools.;Natural chemicals!;This stuff saves lives.;Don't you want some?"
	icon_state = "wallmed"
	icon_deny = "wallmed-deny"
	icon_vend = "wallmed-vend"
	base_type = /obj/machinery/vending/wallmed1
	density = 0 //It is wall-mounted, and thus, not dense. --Superxpdude
	products = list(
		/obj/item/stack/medical/bruise_pack = 3,
		/obj/item/stack/medical/ointment = 3,
	)
	contraband = list(/obj/item/chems/syringe/antitoxin = 4,/obj/item/chems/syringe/antibiotic = 4,/obj/item/chems/pill/bromide = 1)

/obj/machinery/vending/wallmed2
	name = "wall mounted medkit"
	desc = "A firstaid kit mounted on the wall."
	product_ads = "Go save some lives!;The best stuff for your medbay.;Only the finest tools.;Natural chemicals!;This stuff saves lives.;Don't you want some?"
	icon_state = "wallmed"
	icon_deny = "wallmed-deny"
	icon_vend = "wallmed-vend"
	density = 0 //It is wall-mounted, and thus, not dense. --Superxpdude
	base_type = /obj/machinery/vending/wallmed2
	products = list(
		/obj/item/stack/medical/bruise_pack = 4,
		/obj/item/stack/medical/ointment = 4,
	)
	contraband = list(/obj/item/chems/pill/bromide = 3, /obj/item/chems/hypospray/autoinjector/pain = 2)
