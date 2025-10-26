/decl/cultural_info/location/sol
	name = "Solar System"
	description = "The cradle of humanity. It held 3 colonies at its peak population, but once the entire Earth population was obliterated, it entered a state of downfall and cut all contact in 2169. \
	The first crewed interstellar spacecraft was sent in 2124, with the last arriving in 2170s. You were a crew member of one of these ships."
	capital = "Mars(Formerly Earth)"
	ruling_body = "Unknown"
	economic_power = 2
	distance = 0

/decl/cultural_info/location/alpha_centauri
	name = "Alpha Centauri"
	description = "The first star system that was colonized by humanity. It is the most prosperous system of all, having sent multiple colonization ships towards Sirius. All contact was lost in 2171. You were either born there, or transported from Sol."
	capital = "Proxima B"
	ruling_body = "United Nations"
	economic_power = 5
	distance = 4.3

/decl/cultural_info/location/sirius
	name = "Sirius"
	description = "The youngest single-planet colony out of all three, the first people born here haven't reached their 50s yet. Every citizen of Sirius has a neural feedback implant."
	capital = "New Tokyo"
	ruling_body = "United Nations"
	economic_power = 3
	distance = 8.6

/decl/cultural_info/location/sirius/on_spawn(mob/living/carbon/human/H)
	var/obj/item/organ/external/head = GET_EXTERNAL_ORGAN(H, BP_HEAD)
	var/obj/item/implant/neural_link/installed_implant = new
	installed_implant.imp_in = H
	installed_implant.implanted = TRUE
	installed_implant.part = head
	LAZYADD(head.implants, installed_implant)
	H.StoreMemory("You've had a neural link implant installed.", /decl/memory_options/system)