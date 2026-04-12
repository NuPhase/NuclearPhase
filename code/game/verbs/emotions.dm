//from infinity
/mob/living/var/emoteCooldown = (3 SECONDS)
/mob/living/var/emoteLastUse = -1000

/mob/living/proc/emoteCooldownCheck()
	if(emoteLastUse <= (world.time - emoteCooldown))
		emoteLastUse = world.time
		return 1
	else
		to_chat(src, SPAN_WARNING("At least [round(emoteCooldown/10)] seconds should pass between emotes."))
		return 0

/mob/living/verb/laugh()
	set name = "Laugh"
	set category = "Emote"
	emote("laugh")

/mob/living/verb/giggle()
	set name = "Giggle"
	set category = "Emote"
	emote("giggle")

/mob/living/verb/scratch()
	set name = "Scratch"
	set category = "Emote"
	emote("scratch")

/mob/living/verb/scream()
	set name = "Scream"
	set category = "Emote"
	emote("scream")

/mob/living/verb/blush()
	set name = "Blush"
	set category = "Emote"
	emote("blush")

/mob/living/verb/blink()
	set name = "Blink"
	set category = "Emote"
	emote("blink")

/mob/living/verb/bow()
	set name = "Bow"
	set category = "Emote"
	emote("bow")

/mob/living/verb/choke()
	set name = "Choke"
	set category = "Emote"
	emote("choke")

/mob/living/verb/chuckle()
	set name = "Chuckle"
	set category = "Emote"
	emote("chuckle")

/mob/living/verb/collapse()
	set name = "Collapse"
	set category = "Emote"
	emote("collapse")

/mob/living/verb/cough()
	set name = "Cough"
	set category = "Emote"
	emote("cough")

/mob/living/verb/cry()
	set name = "Cry"
	set category = "Emote"
	emote("cry")

/mob/living/verb/clap()
	set name = "Clap"
	set category = "Emote"
	emote("clap")

/mob/living/verb/drool()
	set name = "Drool"
	set category = "Emote"
	emote("drool")

/mob/living/verb/faint()
	set name = "Faint"
	set category = "Emote"
	emote("faint")

/mob/living/verb/frown()
	set name = "Frown"
	set category = "Emote"
	emote("frown")

/mob/living/verb/gasp()
	set name = "Gasp"
	set category = "Emote"
	emote("gasp")

/mob/living/verb/glare()
	set name = "Glare"
	set category = "Emote"
	emote("glare")

/mob/living/verb/tfist()
	set name = "Clench Fists"
	set category = "Emote"
	emote("tfist")

/mob/living/verb/groan()
	set name = "Groan"
	set category = "Emote"
	emote("groan")

/mob/living/verb/grin()
	set name = "Grin"
	set category = "Emote"
	emote("grin")

/mob/living/verb/look()
	set name = "Look"
	set category = "Emote"
	emote("look")

/mob/living/verb/nod()
	set name = "Nod"
	set category = "Emote"
	emote("nod")

/mob/living/verb/moan_emote()
	set name = "Moan"
	set category = "Emote"
	emote("moan")

/mob/living/verb/shake()
	set name = "Shake"
	set category = "Emote"
	emote("shake")

/mob/living/verb/sigh()
	set name = "Sigh"
	set category = "Emote"
	emote("sigh")

/mob/living/verb/smile()
	set name = "Smile"
	set category = "Emote"
	emote("smile")

/mob/living/verb/sneeze()
	set name = "Чихнуть"
	set category = "Emote"
	emote("sneeze")

/mob/living/verb/grunt()
	set name = "Grunt"
	set category = "Emote"
	emote("grunt")

/mob/living/verb/sniff()
	set name = "Sniff"
	set category = "Emote"
	emote("sniff")

/mob/living/verb/snore()
	set name = "Snore"
	set category = "Emote"
	emote("snore")

/mob/living/verb/shrug()
	set name = "Shrug"
	set category = "Emote"
	emote("shrug")

/mob/living/verb/hshrug()
	set name = "Shrug Lightly"
	set category = "Emote"
	emote("hshrug")

/mob/living/verb/stare()
	set name = "Stare"
	set category = "Emote"
	emote("stare")

/mob/living/verb/tremble()
	set name = "Tremble"
	set category = "Emote"
	emote("tremble")

/mob/living/verb/twitch_v()
	set name = "Twitch Intensely"
	set category = "Emote"
	emote("twitch_v")

/mob/living/verb/twitch()
	set name = "Twitch"
	set category = "Emote"
	emote("twitch")

/mob/living/verb/wave()
	set name = "Wave"
	set category = "Emote"
	emote("wave")

/mob/living/verb/whimper()
	set name = "Whimper"
	set category = "Emote"
	emote("whimper")

/mob/living/verb/whistle()
	set name = "Whistle"
	set category = "Emote"
	emote("whistle")

/mob/living/verb/wink()
	set name = "Wink"
	set category = "Emote"
	emote("wink")

/mob/living/verb/yawn()
	set name = "Yawn"
	set category = "Emote"
	emote("yawn")

/mob/living/verb/salute()
	set name = "Salute"
	set category = "Emote"
	emote("salute")

/mob/living/verb/rsalute()
	set name = "Salute Response"
	set category = "Emote"
	emote("rsalute")

/mob/living/verb/attention()
	set name = "Stand at Attention"
	set category = "Emote"
	emote("attention")

/mob/living/verb/eyebrow()
	set name = "Eyebrow"
	set category = "Emote"
	emote("eyebrow")

/mob/living/verb/alook()
	set name = "Look to the side"
	set category = "Emote"
	emote("alook")

/mob/living/verb/snap()
	set name = "Snap Fingers"
	set category = "Emote"
	emote("snap")
