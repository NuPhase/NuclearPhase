/obj/item/storage/pill_bottle/antitox
	name = "pill bottle (antitoxins)"
	desc = "Contains pills used to counter toxins."

	startswith = list(/obj/item/chems/pill/antitox = 21)
	wrapper_color = COLOR_GREEN

/obj/item/storage/pill_bottle/antitoxins
	name = "pill bottle (antitoxins)"
	desc = "Contains pills used to treat toxic substances in the blood."

	startswith = list(/obj/item/chems/pill/antitoxins = 21)
	wrapper_color = COLOR_GREEN

/obj/item/storage/pill_bottle/charcoal
	name = "pill bottle (charcoal)"
	desc = "Contains pills used to counter toxins."

	startswith = list(/obj/item/chems/pill/charcoal = 21)
	wrapper_color = COLOR_BLACK

/obj/item/storage/pill_bottle/antibiotics
	name = "pill bottle (antibiotics)"
	desc = "A theta-lactam antibiotic. Effective against many diseases likely to be encountered in space."

	startswith = list(/obj/item/chems/pill/antibiotics = 14)
	wrapper_color = COLOR_PALE_GREEN_GRAY

/obj/item/storage/pill_bottle/painkillers
	name = "pill bottle (painkillers)"
	desc = "Contains pills used to relieve pain."

	startswith = list(/obj/item/chems/pill/painkillers = 14)
	wrapper_color = COLOR_PURPLE_GRAY

//Baycode specific Psychiatry pills.
/obj/item/storage/pill_bottle/antidepressants
	name = "pill bottle (antidepressants)"
	desc = "Mild antidepressant. For use in individuals suffering from depression or anxiety. 15u dose per pill."

	startswith = list(/obj/item/chems/pill/antidepressants = 21)
	wrapper_color = COLOR_GRAY

/obj/item/storage/pill_bottle/stimulants
	name = "pill bottle (stimulants)"
	desc = "Mental stimulant. For use in individuals suffering from ADHD, or general concentration issues. 15u dose per pill."

	startswith = list(/obj/item/chems/pill/stimulants = 21)
	wrapper_color = COLOR_GRAY

/obj/item/storage/pill_bottle/assorted
	name = "pill bottle (assorted)"
	desc = "Commonly found on paramedics, these assorted pill bottles contain all the basics."

	startswith = list(
			/obj/item/chems/pill/antitoxins = 6,
			/obj/item/chems/pill/sugariron = 2,
			/obj/item/chems/pill/painkillers = 2,
			/obj/item/chems/pill/antirads
		)

/obj/item/storage/pill_bottle/betapace
	name = "pill bottle (betapace)"
	desc = "Betapace is a betablocker used in treating high heartrate and arrythmias. Dosed in 5ml."

	startswith = list(/obj/item/chems/pill/betapace = 21)
	wrapper_color = COLOR_GRAY

/obj/item/storage/pill_bottle/fentanyl
	name = "pill bottle (fentanyl)"
	desc = "Fentanyl is an extremely powerful opioid. Dosed in 250mcg."

	startswith = list(/obj/item/chems/pill/fentanyl = 21)
	wrapper_color = COLOR_RED

/obj/item/storage/pill_bottle/oxycodone
	name = "pill bottle (oxycodone)"
	desc = "Dosed in 20mg."

	startswith = list(/obj/item/chems/pill/oxycodone = 21)
	wrapper_color = COLOR_RED

/obj/item/storage/pill_bottle/handmade
	name = "pill bottle (handmade)"
	startswith = list(/obj/item/chems/pill/betapace = 2, /obj/item/chems/pill/charcoal = 5)