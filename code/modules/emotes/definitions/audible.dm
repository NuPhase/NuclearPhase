/decl/emote/audible
	key = "burp"
	emote_message_3p = "USER отрыгается."
	message_type = AUDIBLE_MESSAGE

/decl/emote/audible/do_extra(atom/user)
	if(emote_sound)
		var/playable = emote_sound
		if (islist(emote_sound))
			playable = pick(emote_sound)
		playsound(user.loc, playable, 50, 0)

/decl/emote/audible/deathgasp_alien
	key = "deathgasp"
	emote_message_3p = "USER издает слабеющий гортанный визг, зеленая кровь пузырится из его пасти."

/decl/emote/audible/gasp
	key ="gasp"
	emote_message_3p = "USER задыхается!"
	conscious = 0

/decl/emote/audible/agony
	key = "agony"
	emote_message_3p = "USER кричит в агонии!"
	emote_sound = list(
		FEMALE = list('sound/voice/firescream_female1.ogg', 'sound/voice/firescream_female2.ogg', 'sound/voice/emotes/agony_female_1.ogg', 'sound/voice/emotes/agony_female_2.ogg', 'sound/voice/emotes/agony_female_3.ogg', 'sound/voice/emotes/agony_female_4.ogg', 'sound/voice/emotes/agony_female_5.ogg'),
		MALE = list('sound/voice/firescream1.ogg', 'sound/voice/firescream2.ogg', 'sound/voice/firescream3.ogg', 'sound/voice/emotes/agony_male_1.ogg')
	)

/decl/emote/audible/scretch
	key ="scretch"
	emote_message_3p = "USER чешется."

/decl/emote/audible/choke
	key ="choke"
	emote_message_3p = "USER давится!"
	conscious = 0

/decl/emote/audible/gnarl
	key ="gnarl"
	emote_message_3p = "USER скалится и показывает свои зубы."

/decl/emote/audible/alarm
	key = "alarm"
	emote_message_1p = "You подал сигнал тревоги."
	emote_message_3p = "USER подаёт сигнал тревоги."

/decl/emote/audible/alert
	key = "alert"
	emote_message_1p = "You издаёте огорченный звук."
	emote_message_3p = "USER издал огорченный звук."

/decl/emote/audible/notice
	key = "notice"
	emote_message_1p = "You включаете громкий сигнал."
	emote_message_3p = "USER проигрывает громкий сигнал."

/decl/emote/audible/whistle
	key = "whistle"
	emote_message_1p = "Вы свистите!"
	emote_message_3p = "USER свистит!"

/decl/emote/audible/boop
	key = "boop"
	emote_message_1p = "You boop."
	emote_message_3p = "USER boops."

/decl/emote/audible/sneeze
	key = "sneeze"
	emote_message_3p = "USER чихает!"

/decl/emote/audible/sniff
	key = "sniff"
	emote_message_3p = "USER нюхает."

/decl/emote/audible/snore
	key = "snore"
	emote_message_3p = "USER храпит."
	conscious = 0

/decl/emote/audible/whimper
	key = "whimper"
	emote_message_3p = "USER хнычет."

/decl/emote/audible/yawn
	key = "yawn"
	emote_message_3p = "USER зевает."

/decl/emote/audible/clap
	key = "clap"
	emote_message_3p = "USER хлопает."

/decl/emote/audible/chuckle
	key = "chuckle"
	emote_message_3p = "USER усмехается."

/decl/emote/audible/cough
	key = "cough"
	emote_message_3p = "USER кашляет!"
	conscious = 0

/decl/emote/audible/cry
	key = "cry"
	emote_message_3p = "USER плачет..."

/decl/emote/audible/sigh
	key = "sigh"
	emote_message_3p = "USER вздыхает."

/decl/emote/audible/laugh
	key = "laugh"
	emote_message_3p = "USER смеется!"
	emote_message_3p_target = "USER смеется над TARGET!"

/decl/emote/audible/mumble
	key = "mumble"
	emote_message_3p = "USER бормочет."

/decl/emote/audible/grumble
	key = "grumble"
	emote_message_3p = "USER бурчит."

/decl/emote/audible/groan
	key = "groan"
	emote_message_3p = "USER болезненно стонет!"
	conscious = 0

/decl/emote/audible/moan
	key = "moan"
	emote_message_3p = "USER стонет!"
	conscious = 0

/decl/emote/audible/giggle
	key = "giggle"
	emote_message_3p = "USER хихикает."

/decl/emote/audible/finger_snap
	key = "snap"
	emote_message_3p = "USER щёлкает пальцами."
	// emote_sound = 'sound/voice/emotes/fingersnap.ogg'

/decl/emote/audible/scream
	key = "scream"
	emote_message_3p = "USER кричит!"

/decl/emote/audible/grunt
	key = "grunt"
	emote_message_3p = "USER ворчит."


/decl/emote/audible/roar
	key = "roar"
	emote_message_3p = "USER рычит!"

/decl/emote/audible/bellow
	key = "bellow"
	emote_message_3p = "USER bellows!"

/decl/emote/audible/howl
	key = "howl"
	emote_message_3p = "USER воет!"

/decl/emote/audible/wheeze
	key = "wheeze"
	emote_message_3p = "USER хрипит."

/decl/emote/audible/gasp
	emote_sound = list(
		MALE = list(
			'sound/voice/emotes/gasp_male1.ogg', 'sound/voice/emotes/gasp_male2.ogg',
			'sound/voice/emotes/gasp_male3.ogg', 'sound/voice/emotes/gasp_male4.ogg',
			'sound/voice/emotes/gasp_male5.ogg', 'sound/voice/emotes/gasp_male6.ogg',
			'sound/voice/emotes/gasp_male7.ogg'),
		FEMALE = list(
			'sound/voice/emotes/gasp_female1.ogg', 'sound/voice/emotes/gasp_female2.ogg',
			'sound/voice/emotes/gasp_female3.ogg', 'sound/voice/emotes/gasp_female4.ogg',
			'sound/voice/emotes/gasp_female5.ogg', 'sound/voice/emotes/gasp_female6.ogg',
			'sound/voice/emotes/gasp_female7.ogg'))

/decl/emote/audible/whimper
	emote_sound = list(
		MALE = list(
			'sound/voice/emotes/whimper/whimper_male.ogg',
			'sound/voice/emotes/whimper/whimper_male2.ogg',
			'sound/voice/emotes/whimper/whimper_male3.ogg',
		),
		FEMALE = list(
			'sound/voice/emotes/whimper/whimper_female.ogg',
			'sound/voice/emotes/whimper/whimper_female2.ogg',
			'sound/voice/emotes/whimper/whimper_female3.ogg',

		)
	)

/decl/emote/audible/whistle
	emote_sound = 'sound/voice/emotes/whistle.ogg'

/decl/emote/audible/sneeze
	emote_sound = list(
		MALE = list('sound/voice/emotes/sneeze_male_1.ogg', 'sound/voice/emotes/sneeze_male_2.ogg'),
		FEMALE = list('sound/voice/emotes/sneeze_female_1.ogg', 'sound/voice/emotes/sneeze_female_2.ogg'))

/decl/emote/audible/snore
	emote_sound = list(
		'sound/voice/emotes/snore_1.ogg', 'sound/voice/emotes/snore_2.ogg',
		'sound/voice/emotes/snore_3.ogg', 'sound/voice/emotes/snore_4.ogg',
		'sound/voice/emotes/snore_5.ogg', 'sound/voice/emotes/snore_6.ogg',
		'sound/voice/emotes/snore_7.ogg')
/decl/emote/audible/yawn
	emote_sound = list(
		MALE = list('sound/voice/emotes/yawn_male_1.ogg', 'sound/voice/emotes/yawn_male_2.ogg'),
		FEMALE = list('sound/voice/emotes/yawn_female_1.ogg', 'sound/voice/emotes/yawn_female_2.ogg',
						'sound/voice/emotes/yawn_female_3.ogg'))

/decl/emote/audible/clap
	emote_sound = 'sound/voice/emotes/clap.ogg'

/decl/emote/audible/cough
	emote_sound = list(
		MALE = list(
			'sound/voice/emotes/cough/cough_01.ogg',
			'sound/voice/emotes/cough/cough_02.ogg',
			'sound/voice/emotes/cough/cough_03.ogg',
			'sound/voice/emotes/cough/cough_05.ogg',
			'sound/voice/emotes/cough/cough01_man.ogg',
			'sound/voice/emotes/cough/cough02_man.ogg',
			'sound/voice/emotes/cough/cough03_man.ogg',
			'sound/voice/emotes/cough/cough04_man.ogg',
			'sound/voice/emotes/cough_male_1.ogg',
			'sound/voice/emotes/cough_male_2.ogg'
			),
		FEMALE = list(
			'sound/voice/emotes/cough/cough01_woman.ogg',
			'sound/voice/emotes/cough/cough02_woman.ogg',
			'sound/voice/emotes/cough/cough03_woman.ogg',
			'sound/voice/emotes/cough/cough04_woman.ogg',
			'sound/voice/emotes/cough/cough05_woman.ogg',
			'sound/voice/emotes/cough/cough06_woman.ogg',
			'sound/voice/emotes/cough/cough07_woman.ogg'
		)
	)

/decl/emote/audible/cry
	emote_sound = list(
		MALE = list('sound/voice/emotes/cry_male_1.ogg', 'sound/voice/emotes/cry_male_2.ogg'),
		FEMALE = list('sound/voice/emotes/cry_female_1.ogg', 'sound/voice/emotes/cry_female_2.ogg',
						'sound/voice/emotes/cry_female_3.ogg'))

/decl/emote/audible/sigh
	emote_sound = list(
		MALE = 'sound/voice/emotes/sigh/sigh_male.ogg',
		FEMALE = 'sound/voice/emotes/sigh/sigh_female.ogg')

/decl/emote/audible/laugh
	emote_sound = list(
		MALE = list('sound/voice/emotes/laugh_male_1.ogg', 'sound/voice/emotes/laugh_male_2.ogg', 'sound/voice/emotes/laugh_male_3.ogg'),
		FEMALE = list('sound/voice/emotes/laugh_female_1.ogg', 'sound/voice/emotes/laugh_female_2.ogg', 'sound/voice/emotes/laugh_female_3.ogg'))

/decl/emote/audible/giggle
	emote_sound = list(
		MALE = 'honk/sound/emotes/laugh_m1.ogg',
		FEMALE = list('sound/voice/emotes/giggle/giggle02_woman.ogg', 'sound/voice/emotes/giggle/giggle03_woman.ogg'))

/decl/emote/audible/scream
	emote_sound = list(
		MALE = list('sound/voice/emotes/scream_male_1.ogg', 'sound/voice/emotes/scream_male_2.ogg',
					'sound/voice/emotes/scream_male_3.ogg'),
		FEMALE = list('sound/voice/fear_woman1.ogg', 'sound/voice/fear_woman2.ogg', 'sound/voice/fear_woman3.ogg'))

/decl/emote/audible/scream/monkey
	emote_sound = list(
		'sound/voice/emotes/pain_monkey_1.ogg',
		'sound/voice/emotes/pain_monkey_2.ogg',
		'sound/voice/emotes/pain_monkey_3.ogg'
		)
