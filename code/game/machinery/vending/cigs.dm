
// This monstrosity deserves own file
/obj/machinery/vending/cigarette
	name = "Cigarette machine" //OCD had to be uppercase to look nice with the new formating
	desc = "A specialized vending machine designed to contribute to your slow and uncomfortable death."
	product_slogans = "There's no better time to start smokin'.;\
		Smoke now, and win the adoration of your peers.;\
		They beat cancer centuries ago, so smoke away.;\
		If you're not smoking, you must be joking."
	product_ads = "Probably not bad for you!;\
		Don't believe the scientists!;\
		It's good for you!;\
		Don't quit, buy more!;\
		Smoke!;\
		Nicotine heaven.;\
		Best cigarettes since 2150.;\
		Award-winning cigarettes, all the best brands.;\
		Feeling temperamental? Try a Temperamento!;\
		Carcinoma Angels - go fuck yerself!;\
		Don't be so hard on yourself, kid. Smoke a Lucky Star!;\
		We understand the depressed, alcoholic cowboy in you. That's why we also smoke Jericho.;\
		Professionals. Better cigarettes for better people. Yes, better people."
	vend_delay = 21
	icon_state = "cigs"
	icon_vend = "cigs-vend"
	icon_deny = "cigs-deny"
	base_type = /obj/machinery/vending/cigarette
	products = list()
	contraband = list(
		/obj/item/flame/lighter/zippo = 4,
		/obj/item/clothing/mask/smokable/cigarette/rolled/sausage = 3,
		/obj/item/storage/fancy/cigar = 5,
		/obj/item/storage/fancy/cigarettes/killthroat = 5
	)
