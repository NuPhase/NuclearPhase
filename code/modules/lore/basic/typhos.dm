/obj/item/info_container/phone/typhos
	desc = "Its silver-shining case has a large 'UN' logo stamped on it. Looks like it belonged to someone important."
	var/message

/obj/item/info_container/phone/typhos/show_information(mob/user)
	if(message)
		to_chat(user, SPAN_NOTICE(message))
		return

// Captain
/obj/item/info_container/phone/typhos/unique1
	message = "Слишком много шума вокруг. Если он перегреется, то нас просто разорвет. Но если не прыгнем... у них не будет шансов. Принимаю решение: прыжок. Прости меня, Эмма. Если 'Икарус' уцелеет, то у вас будет шанс меня спасти."

// Engineer
/obj/item/info_container/phone/typhos/unique2
	message = "Черновик сообщения(не отправлено):\n \
				Я усилил магнитную обвязку, но поле нестабильно. Варп нестабилен как стекло. Мы не выживем. Я рад, что был частью чего-то важного. Даже если нас не вспомнят."

/obj/item/info_container/phone/typhos/unique3
	message = "Ping log:\n \
				Sirius Relay - UNREACHABLE\n \
				UN Rescue Grid - UNREACHABLE\n \
				Commander - 60ms\n \
				Home(mother) - UNREACHABLE"

/obj/item/info_container/phone/typhos/unique4
	message = "Все получили >40 Зв. Боли почти нет, только дрожь и свет. Остались часы. Я... не боюсь. Но больно, что не помогла."

/obj/item/info_container/phone/typhos/unique5
	message = "Ещё один прыжок, и домой. Или в никуда. Если я не вернусь - ты всегда был моим героем."

/obj/item/info_container/phone/typhos/unique6
	message = "Газ идёт по орбите. Я фильтры обновил, но это не спасёт. У нас 60 минут. Наверное, это и есть конец миссии. Надеюсь, что груз на 'Икарусе' выживет."

/obj/item/info_container/phone/typhos/unique7
	message = "Если найдёшь это... скажи людям на планете, мы пытались. Мы действительно пытались."

/obj/item/info_container/phone/typhos/unique8
	message = "Облако содержит H₂, гелий, вероятно следы органики. Красиво. Опасно. И... тихо. Я боюсь, что никто это не узнает."

/obj/item/info_container/phone/typhos/unique9
	message = "It has a password and a few notifications on the screen: \n \
				\[11 new messages from: MOTHER\]"