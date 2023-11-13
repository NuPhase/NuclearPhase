#define PIXEL_SHIFT_MAXIMUM 16
#define PIXEL_SHIFT_PASSABLE_THRESHOLD 4

/mob
	/// If we are in the shifting setting.
	var/shifting = FALSE

	var/is_tilted
	var/is_shifted

	/// Takes the four cardinal direction defines. Any atoms moving into this atom's tile will be allowed to from the added directions.
	var/passthroughable = NONE

/datum/keybinding/mob/pixel_shift
	hotkey_keys = list("Space")
	name = "pixel_shift"
	full_name = "Pixel Shift"
	description = "Shift your characters offset."
	category = CATEGORY_MOVEMENT

/datum/keybinding/mob/pixel_shift/down(client/user)
	. = ..()
	if(.)
		return
	var/mob/M = user.mob
	M.shifting = TRUE
	return TRUE

/datum/keybinding/mob/pixel_shift/up(client/user)
	. = ..()
	if(.)
		return
	var/mob/M = user.mob
	M.shifting = FALSE
	return TRUE

/mob/proc/unpixel_shift()
	return

/mob/living/unpixel_shift()
	. = ..()
	passthroughable = NONE
	if(is_shifted)
		is_shifted = FALSE
		pixel_x = default_pixel_x
		pixel_y = default_pixel_y

/mob/proc/pixel_shift(direction)
	return

/mob/living/proc/set_pull_offsets(mob/living/pull_target, grab_state)
	pull_target.unpixel_shift()

/mob/living/proc/reset_pull_offsets(mob/living/pull_target, override)
	pull_target.unpixel_shift()

/mob/living/pixel_shift(direction)
	passthroughable = NONE
	// switch(direction) // diagonal pixel-shifting, rejoice
	if(CHECK_BITFIELD(direction, NORTH))
		if(pixel_y <= PIXEL_SHIFT_MAXIMUM + default_pixel_y)
			pixel_y++
			is_shifted = TRUE
	if(CHECK_BITFIELD(direction, EAST))
		if(pixel_x <= PIXEL_SHIFT_MAXIMUM + default_pixel_x)
			pixel_x++
			is_shifted = TRUE
	if(CHECK_BITFIELD(direction, SOUTH))
		if(pixel_y >= -PIXEL_SHIFT_MAXIMUM + default_pixel_y)
			pixel_y--
			is_shifted = TRUE
	if(CHECK_BITFIELD(direction, WEST))
		if(pixel_x >= -PIXEL_SHIFT_MAXIMUM + default_pixel_x)
			pixel_x--
			is_shifted = TRUE

	// Yes, I know this sets it to true for everything if more than one is matched.
	// Movement doesn't check diagonals, and instead just checks EAST or WEST, depending on where you are for those.
	if(pixel_y > PIXEL_SHIFT_PASSABLE_THRESHOLD)
		passthroughable |= EAST | SOUTH | WEST
	if(pixel_x > PIXEL_SHIFT_PASSABLE_THRESHOLD)
		passthroughable |= NORTH | SOUTH | WEST
	if(pixel_y < -PIXEL_SHIFT_PASSABLE_THRESHOLD)
		passthroughable |= NORTH | EAST | WEST
	if(pixel_x < -PIXEL_SHIFT_PASSABLE_THRESHOLD)
		passthroughable |= NORTH | EAST | SOUTH

/mob/living/CanPass(atom/movable/mover, turf/target, height, air_group)
	// Make sure to not allow projectiles of any kind past where they normally wouldn't.
	if(!istype(mover, /obj/item/projectile) && !mover.throwing && passthroughable & mover.dir)
		return TRUE
	return ..()
