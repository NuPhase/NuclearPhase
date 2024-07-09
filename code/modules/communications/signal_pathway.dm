/*
Variables:
	sender_penetration - determines how far a signal can travel without starting being blocked by something.
	penetration_modifier - a general modifier for how well the signal penetrates objects
	receiver_amplification - how much quality boost does a signal receive

	zdistance - how much distance do we have between Z of the sender and Z of the receiver
	zblockage - how much quality we take away per unit of zdistance
*/

/proc/get_signal_quality(atom/sender, atom/receiver, sender_penetration = 2, penetration_modifier = 1, receiver_amplification = 0) //Across a Z-level
	var/quality = 100
	quality += receiver_amplification
	var/datum/point/vector/tracing = new(sender.x, sender.y, sender.z, 0, 0, get_projectile_angle(sender, receiver))
	for(var/i=0, i < get_dist(sender, receiver), i++)
		var/turf/blocking = tracing.return_turf()
		tracing.increment()
		if(blocking)
			quality -= rand(blocking.signal_block_coef/2, blocking.signal_block_coef) * penetration_modifier
	return max(0, quality)