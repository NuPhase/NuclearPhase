#define LOCK_LOCKED 1
#define LOCK_BROKEN 2


/datum/lock
	var/name
	var/status = 0 //unlocked, 1 == locked 2 == broken
	var/lock_data = null //use case depends on type of lock. List for RFID
	var/atom/holder

/datum/lock/New(var/atom/h, var/complexity = 1)
	holder = h
	lock_data = complexity

/datum/lock/Destroy()
	holder = null
	. = ..()

/datum/lock/proc/can_open(var/mob/user)
	return TRUE

/datum/lock/proc/failure_open()
	return 0

//should return a delay before opening
/datum/lock/proc/success_open()
	return 1

/datum/lock/proc/unlock(var/key = "", var/mob/user)
	if(status ^ LOCK_LOCKED)
		to_chat(user, "<span class='warning'>Its already unlocked!</span>")
		return 2
	key = get_key_data(key, user)
	if(cmptext(lock_data,key) && (status ^ LOCK_BROKEN))
		status &= ~LOCK_LOCKED
		return 1
	return 0

/datum/lock/proc/lock(var/key = "", var/mob/user)
	if(status & LOCK_LOCKED)
		to_chat(user, "<span class='warning'>Its already locked!</span>")
		return 2
	key = get_key_data(key, user)
	if(cmptext(lock_data,key) && (status ^ LOCK_BROKEN))
		status |= LOCK_LOCKED
		return 1
	return 0

/datum/lock/proc/toggle(var/key = "", var/mob/user)
	if(status & LOCK_LOCKED)
		return unlock(key, user)
	else
		return lock(key, user)

/datum/lock/proc/getComplexity()
	return length(lock_data)

/datum/lock/proc/get_key_data(var/key = "", var/mob/user)
	if(istype(key,/obj/item/key))
		var/obj/item/key/K = key
		return K.get_data(user)
	if(istext(key))
		return key
	return null

/datum/lock/proc/isLocked()
	return status & LOCK_LOCKED

/datum/lock/proc/pick_lock(var/obj/item/I, var/mob/user)
	if(!istype(I) || (status ^ LOCK_LOCKED))
		return 0
	var/unlock_power = I.lock_picking_level
	if(!unlock_power)
		return 0
	user.visible_message("\The [user] takes out \the [I], picking \the [holder]'s lock.")
	if(!do_after(user, 20, holder))
		return 0
	if(prob(20*(unlock_power/getComplexity())))
		to_chat(user, "<span class='notice'>You pick open \the [holder]'s lock!</span>")
		unlock(lock_data)
		return 1
	else if(prob(5 * unlock_power))
		to_chat(user, "<span class='warning'>You accidently break \the [holder]'s lock with your [I]!</span>")
		status |= LOCK_BROKEN
	else
		to_chat(user, "<span class='warning'>You fail to pick open \the [holder].</span>")
	return 0

/datum/lock/keypad
	name = "keypad"

/datum/lock/keypad/New(atom/h, complexity)
	. = ..()
	lock_data = rand(11111, 55555)

/datum/lock/keypad/can_open(var/mob/user)
	var/user_input = tgui_input_number(user, "Enter a 5-digit code.", "Keycode Access", max_value = 99999, min_value = 11111, timeout = 20 SECONDS)
	return user_input == lock_data

/datum/lock/keypad/success_open()
	playsound(holder, 'sound/machines/beeps_airlock.wav', 25, 0)
	return 9

/datum/lock/keypad/failure_open()
	playsound(holder, 'sound/machines/buzz-two.ogg', 25, 0)

/datum/lock/id_card
	name = "RFID"

/datum/lock/id_card/can_open(var/mob/user)
	return has_access(lock_data, user.GetAccess())

/datum/lock/id_card/success_open()
	playsound(holder, 'sound/machines/beeps_airlock.wav', 25, 0)
	return 9

/datum/lock/id_card/failure_open()
	playsound(holder, 'sound/machines/buzz-two.ogg', 25, 0)

/datum/lock/key
	name = "keyed"

/datum/lock/key/New(atom/h, complexity)
	. = ..()
	lock_data = generateRandomString(complexity)