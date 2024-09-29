/obj/structure/warp_drive_pylon
	name = "alcubierre drive pylon"
	desc = "A complicated negative energy management unit that manages the balance of energy in a warp drive. It's critical to ensuring the stability of the warp bubble."
	icon = 'icons/obj/kinetic_harvester.dmi'
	icon_state = "off"
	density = 1
	anchored = 1

/obj/structure/warp_drive_pylon/typhos //trigger typhos destruction event upon butchering

/obj/structure/warp_drive_pylon/broken
	name = "broken alcubierre drive pylon"
	desc = "A complicated negative energy management unit that manages the balance of energy in a warp drive. It's critical to ensuring the stability of the warp bubble. This one is busted."
	icon_state = "broken"

/obj/structure/warp_drive_pylon/broken/Initialize(ml, _mat, _reinf_mat)
	. = ..()
	SSorbit.icarus_broken_pylons += src

/obj/structure/warp_drive_pylon/broken/attackby(obj/item/O, mob/user)
	if(istype(O, /obj/item/info_container/encrypted/quantum_data/warp))
		if(!do_after(user, 25, src))
			return
		name = "alcubierre drive pylon"
		desc = "A complicated negative energy management unit that manages the balance of energy in a warp drive. It's critical to ensuring the stability of the warp bubble."
		icon_state = "off"
		qdel(O)
		SSorbit.icarus_broken_pylons -= src
		return
	. = ..()

/obj/structure/warp_drive_port
	name = "alcubierre drive port"
	desc = "A complex port for connecting alcubierre drive pylons."
	icon = 'icons/obj/machines/igniter.dmi'
	icon_state = "igniter1"
	density = 1
	anchored = 1

/obj/structure/warp_drive_storage
	name = "antimatter container"
	desc = "A huge electrostatic trap made for storing antimatter."
	icon = 'icons/obj/machines/cracker.dmi'
	icon_state = "cracker_on"
	density = 1
	anchored = 1

/obj/structure/warp_drive_storage/broken
	name = "broken antimatter container"
	icon_state = "cracker"