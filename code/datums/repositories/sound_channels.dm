var/global/repository/sound_channels/sound_channels = new

/repository/sound_channels
	var/datum/stack/available_channels
	var/list/keys_by_channel           // So we know who to blame if we run out
	var/channel_ceiling	= 1024         // Initial value is the current BYOND maximum number of channels

	var/lobby_channel
	var/vote_channel
	var/ambience_channel
	var/admin_channel
	var/weather_channel
	var/long_channel

/repository/sound_channels/New()
	..()
	available_channels = new()
	lobby_channel =    RequestChannel("LOBBY")
	vote_channel =     RequestChannel("VOTE")
	ambience_channel = RequestChannel("AMBIENCE")
	admin_channel =    RequestChannel("ADMIN_FUN")
	weather_channel =  RequestChannel("WEATHER")
	long_channel = 	   RequestChannel("LONG")

/repository/sound_channels/proc/RequestChannel(var/key)
	. = RequestChannels(key, 1)
	return LAZYLEN(.) && .[1]

/repository/sound_channels/proc/RequestChannels(var/key, var/amount)
	if(!key)
		CRASH("Invalid key given.")
	. = list()

	for(var/i = 1 to amount)
		var/channel = available_channels.Pop() // Check if someone else has released their channel.
		if(!channel)
			if(channel_ceiling <= 0) // This basically means we ran out of channels
				break
			channel = channel_ceiling--
		. += channel

	if(length(.) != amount)
		ReleaseChannels(.)
		CRASH("Unable to supply the requested amount of channels: [key] - Expected [amount], was [length(.)]")

	for(var/channel in .)
		LAZYSET(keys_by_channel, "[channel]", key)
	return .

/repository/sound_channels/proc/ReleaseChannel(var/channel)
	ReleaseChannels(list(channel))

/repository/sound_channels/proc/ReleaseChannels(var/list/channels)
	for(var/channel in channels)
		LAZYREMOVE(keys_by_channel, "[channel]")
		available_channels.Push(channel)
