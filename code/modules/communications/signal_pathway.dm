/*
Variables:
	sender_penetration - determines how far a signal can travel without starting being blocked by something.
	penetration_modifier - a general modifier for how well the signal penetrates objects
	receiver_amplification - how much quality boost does a signal receive

	zdistance - how much distance do we have between Z of the sender and Z of the receiver
	zblockage - how much quality we take away per unit of zdistance
*/

/proc/get_local_signal_quality(atom/sender, atom/receiver, sender_penetration, penetration_modifier, receiver_amplification) //Across a Z-level
	var/quality = 100
	var/x = abs(receiver.x - sender.x)
	var/y = abs(receiver.y - sender.y)
	quality += receiver_amplification
	var/datum/vector2/vec = new(x, y)
	var/hip = round(vec.get_hipotynuse())
	var/datum/vector2/norm_vec = new()
	for (var/block in range(hip))
		norm_vec.normalise()
		norm_vec.mult(block)
		var/turf/blocking = locate(round(norm_vec.x), round(norm_vec.y), receiver.z)
		quality -= rand(blocking.signal_block_coef/2, blocking.signal_block_coef)
	return quality


/proc/get_global_signal_quality(atom/sender, atom/receiver, sender_penetration, penetration_modifier, receiver_amplification, zdistance, zblockage) //Across Z-levels
	var/quality = 100
	var/x = abs(receiver.x - sender.x)
	var/y = abs(receiver.y - sender.y)
	var/z = abs(receiver.z - sender.z)
	quality += receiver_amplification
	var/datum/vector3/vec = new(x, y, z)
	var/hip = round(vec.get_hipotynuse())
	var/datum/vector3/norm_vec = new()
	for (var/block in range(hip))
		norm_vec.normalise()
		norm_vec.mult(block)
		var/turf/blocking = locate(round(norm_vec.x), round(norm_vec.y), round(norm_vec.z))
		quality -= rand(blocking.signal_block_coef/2, blocking.signal_block_coef)

	return quality