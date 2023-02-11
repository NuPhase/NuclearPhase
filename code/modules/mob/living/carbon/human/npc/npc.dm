/mob/living/carbon/human/npc
	var/datum/npc_controller/controller = null
	faction = "npc"

/mob/living/carbon/human/npc/ssd_check()
	return FALSE

/mob/living/carbon/human/npc/combat/Life()
	. = ..()
	controller.trigger()

/mob/living/carbon/human/npc/combat/Initialize(mapload, species_name, datum/dna/new_dna)
	. = ..()
	zone_sel = new /obj/screen/zone_sel( null )
	controller = new /datum/npc_controller/combat
	controller.owner = src
	var/decl/hierarchy/outfit/hefamilitant/outf = new
	outf.equip(src)
	for(var/obj/item/gun/projectile/ngun in contents)
		ngun.safety_state = FALSE
		controller.current_weapon = ngun
		break
	anchored = 1
	spawn(600)
		anchored = 0

/mob/living/carbon/human/npc/combat/death(gibbed, deathmessage, show_dead_message)
	. = ..()
	qdel(controller)