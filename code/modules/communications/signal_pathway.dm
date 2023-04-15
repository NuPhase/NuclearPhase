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
	quality += receiver_amplification
	return quality


/proc/get_global_signal_quality(atom/sender, atom/receiver, sender_penetration, penetration_modifier, receiver_amplification, zdistance, zblockage) //Across Z-levels
	var/quality = 100
	quality += receiver_amplification
	return quality