
/obj/structure/reagent_dispensers
	name = "dispenser"
	desc = "A large tank for storing chemicals."
	icon = 'icons/obj/objects.dmi'
	icon_state = "watertank"
	density =  TRUE
	anchored = FALSE

	var/unwrenched = FALSE
	var/initial_capacity = 1000
	var/initial_reagent_types  // A list of reagents and their ratio relative the initial capacity. list(/decl/material/liquid/water = 0.5) would fill the dispenser halfway to capacity.
	var/amount_per_transfer_from_this = 10
	var/possible_transfer_amounts = @"[10,25,50,100,500]"

/obj/structure/reagent_dispensers/Initialize()
	. = ..()
	create_reagents(initial_capacity)
	if (!possible_transfer_amounts)
		verbs -= /obj/structure/reagent_dispensers/verb/set_amount_per_transfer_from_this
	for(var/reagent_type in initial_reagent_types)
		var/reagent_ratio = initial_reagent_types[reagent_type]
		reagents.add_reagent(reagent_type, reagent_ratio * initial_capacity)

/obj/structure/reagent_dispensers/is_pressurized_fluid_source()
	return TRUE

/obj/structure/reagent_dispensers/proc/leak()
	var/turf/T = get_turf(src)
	if(reagents && T)
		reagents.trans_to_turf(T, min(reagents.total_volume, FLUID_PUDDLE))

/obj/structure/reagent_dispensers/Move()
	. = ..()
	if(. && unwrenched)
		leak()

/obj/structure/reagent_dispensers/Process()
	if(unwrenched)
		leak()

/obj/structure/reagent_dispensers/examine(mob/user)
	. = ..()
	if(unwrenched)
		to_chat(user, SPAN_WARNING("Someone has wrenched open its tap - it's spilling everywhere!"))

/obj/structure/reagent_dispensers/Destroy()
	. = ..()
	STOP_PROCESSING(SSprocessing, src)

/obj/structure/reagent_dispensers/attackby(obj/item/W, mob/user)
	if(IS_WRENCH(W))
		unwrenched = !unwrenched
		visible_message(SPAN_NOTICE("\The [user] wrenches \the [src]'s tap [unwrenched ? "open" : "shut"]."))
		if(unwrenched)
			log_and_message_admins("opened a tank at [get_area_name(loc)].")
			START_PROCESSING(SSprocessing, src)
		else
			STOP_PROCESSING(SSprocessing, src)
		return TRUE
	. = ..()

/obj/structure/reagent_dispensers/examine(mob/user, distance)
	. = ..()
	if(distance <= 2)
		to_chat(user, SPAN_NOTICE("It contains:"))
		if(LAZYLEN(reagents?.reagent_volumes))
			for(var/rtype in reagents.reagent_volumes)
				var/decl/material/R = GET_DECL(rtype)
				to_chat(user, SPAN_NOTICE("[REAGENT_VOLUME(reagents, rtype)] units of [R.name]"))
		else
			to_chat(user, SPAN_NOTICE("Nothing."))

/obj/structure/reagent_dispensers/verb/set_amount_per_transfer_from_this()
	set name = "Set transfer amount"
	set category = "Object"
	set src in view(1)
	if(!CanPhysicallyInteract(usr))
		to_chat(usr, SPAN_NOTICE("You're in no condition to do that!'"))
		return
	var/N = input("Amount per transfer from this:","[src]") as null|anything in cached_json_decode(possible_transfer_amounts)
	if(!CanPhysicallyInteract(usr))  // because input takes time and the situation can change
		to_chat(usr, SPAN_NOTICE("You're in no condition to do that!'"))
		return
	if (N)
		amount_per_transfer_from_this = N

/obj/structure/reagent_dispensers/physically_destroyed(var/skip_qdel)
	if(reagents?.total_volume)
		var/turf/T = get_turf(src)
		if(T)
			var/obj/effect/fluid/F = locate() in T
			if(!F) F = new(T)
			reagents.trans_to_holder(F.reagents, reagents.total_volume)
	. = ..()

/obj/structure/reagent_dispensers/explosion_act(severity)
	. = ..()
	if(. && (severity == 1) || (severity == 2 && prob(50)) || (severity == 3 && prob(5)))
		physically_destroyed()
