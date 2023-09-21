
/obj/item/gun/energy/sniperrifle
	name = "HEP-R"
	desc = "High Energy Particle Rifle. Takes time to charge."
	icon = 'icons/obj/guns/laser_sniper.dmi'
	icon_state = ICON_STATE_WORLD
	origin_tech = "{'combat':6,'materials':5,'powerstorage':4}"
	projectile_type = /obj/item/projectile/beam/highenergy
	one_hand_penalty = 5 // The weapon itself is heavy, and the long barrel makes it hard to hold steady with just one hand.
	slot_flags = SLOT_BACK
	charge_cost = 700
	max_shots = 4
	fire_delay = 35
	force = 10
	w_class = ITEM_SIZE_HUGE
	accuracy = 6
	scoped_accuracy = 9
	scope_zoom = 2
	power_supply = /obj/item/cell/smes
	var/charging = FALSE

/obj/item/gun/energy/sniperrifle/admin
	projectile_type = /obj/item/projectile/beam/plasma_discharge

/obj/item/gun/energy/sniperrifle/Fire(atom/target, mob/living/user, clickparams, pointblank, reflex, set_click_cooldown)
	if(!user || !target || charging)
		return
	if(target.z != user.z)
		return

	add_fingerprint(user)

	if((!waterproof && submerged()) || !special_check(user))
		return

	if(safety())
		if(user.a_intent == I_HURT && !user.skill_fail_prob(SKILL_WEAPONS, 100, SKILL_EXPERT, 0.5)) //reflex un-safeying
			toggle_safety(user)
		else
			handle_click_empty(user)
			return

	if(world.time < next_fire_time)
		if (world.time % 3) //to prevent spam
			to_chat(user, "<span class='warning'>[src] is not ready to fire again!</span>")
		return

	last_safety_check = world.time
	if(set_click_cooldown)
		var/shoot_time = (burst - 1) * burst_delay + 10
		user.setClickCooldown(shoot_time) //no clicking on things while shooting
		next_fire_time = world.time + shoot_time

	var/held_twohanded = (user.can_wield_item(src) && src.is_held_twohanded(user))

	//actually attempt to shoot
	var/turf/targloc = get_turf(target) //cache this in case target gets deleted during shooting, e.g. if it was a securitron that got destroyed.
	playsound(get_turf(user), 'sound/weapons/gunshot/gauss_powerup.mp3', 50, 0)
	charging = TRUE
	sleep(10)
	charging = FALSE
	for(var/i in 1 to burst)
		var/obj/projectile = consume_next_projectile(user)
		if(!projectile)
			handle_click_empty(user)
			break
		playsound(get_turf(user), 'sound/weapons/gunshot/gauss_shot.mp3', 50, 0)
		process_accuracy(projectile, user, target, i, held_twohanded)

		if(pointblank)
			process_point_blank(projectile, user, target)

		if(process_projectile(projectile, user, target, user.zone_sel?.selecting, clickparams))
			handle_post_fire(user, target, pointblank, reflex, projectile)
			update_icon()

		if(i < burst)
			sleep(burst_delay)

		if(!(target && target.loc))
			target = targloc
			pointblank = 0

	//update timing
	var/delay = min(max(burst_delay+1, fire_delay), DEFAULT_QUICK_COOLDOWN)
	if(delay)
		user.setClickCooldown(delay)
	next_fire_time = world.time + delay