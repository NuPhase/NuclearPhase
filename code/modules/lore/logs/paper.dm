/obj/item/paper/guide
	persist_on_init = FALSE

/obj/item/paper/guide/srec_injections
	name = "SREC treatment guidelines"
	info = "<h1><b>WEHS <font color=\"blue\">SREC LAB</font></b></h1><BR> \
			<h2>SREC Treatment Guidelines</h2>\
			The patient should be informed about their condition and given at least 2 full injectors with SREC inhibitor.<BR> \
			<BR> \
			<h2>Inhibitor Dose Chart</h2><BR>\
			<b>>80mcg/ml</b> --> 1 dose(10mg) every 30 minutes.<BR>\
			<b>>120mcg/ml</b> --> 2 doses(20mg) every 30 minutes.<BR>\
			<b>>160mcg/ml</b> --> 4 doses(40mg) every 30 minutes.<BR>"

/obj/item/paper/guide/srec_description
	name = "SREC infection classification"
	info = "<h1><b>WEHS <font color=\"blue\">SREC LAB</font></b></h1><BR> \
			<h2>SREC Infection Classification</h2>\
			Единица измерения дозы: мкг/мл - концентрация СРЕЗ-частиц в биологических жидкостях (кровь, лимфа, спинномозговая жидкость).<BR> \
			<BR> \
			<row><cell><b>Стадия</b><cell><b>Диапазон дозы</b><cell><b>Название</b><cell><b>Симптомы</b><cell><b>Медицинская оценка</b><BR>\
			<row><cell>0<cell><80 мкг/мл<cell>Субклиническая<cell>Нет видимых симптомов<cell>Инфекция считается безопасной, наблюдение не требуется<BR>\
			<row><cell>I<cell>80-120 мкг/мл<cell>Микроциркуляторная<cell>Побледнение кожи, похолодание конечностей, ухудшение зрения, парестезии<cell>Нарушение микроперфузии. Обязателен мониторинг каждые 6 мес.<BR>\
			<row><cell>II<cell>120-140 мкг/мл<cell>Неврологическая начальная<cell>Потеря аппетита, снижение болевой чувствительности, изменение окраски глаз<cell>Начало проникновения кристаллов в нейроны. Ограничение физнагрузки.<BR>\
			<row><cell>III<cell>140-160 мкг/мл<cell>Иммунная реактивная<cell>Лихорадка, слабость, мышечные боли<cell>Воспалительный ответ на гипоперфузию. Рекомендуется госпитализация.<BR>\
			<row><cell>IV<cell>160-180 мкг/мл<cell>Нейропаралитическая<cell>Частичный паралич, зелёный оттенок склер, анергия<cell>Инактивация иммунной системы, риск обострения от ЭМ-воздействий.<BR>\
			<row><cell>V<cell>180-200 мкг/мл<cell>Перициркуляторная<cell>Коллапсы, тахикардия, судороги при ЭМ-импульсах<cell>Крайне нестабильное состояние. Электрошок смертелен. Изоляция.<BR>\
			<row><cell>VI<cell>200-700 мкг/мл<cell>Органная<cell>Нарушение функций печени, почек, лёгких<cell>Переход в терминальные формы. Жизнь возможна только с поддерживающей терапией.<BR>\
			<row><cell>VII<cell>700-1000 мкг/мл<cell>Кристаллическая<cell>Кристаллизация тканей конечностей, полная утрата болевой чувствительности, возможна эйфория<cell>Летальный прогноз. Эвтаназия или криостаз - стандартный протокол.<BR>\
			<BR>\
			<b>Пояснение:</b><BR>\
			<list>\
			<*>Этапы IV-VII подлежат обязательной регистрации в медицинских записях.<BR>\
			<*>Пациенты стадии V и выше считаются потенциально опасными при воздействии радиации, СВЧ или дефибрилляции (возможен выброс антиматерии).<BR>\
			<*>Некоторые пациенты стадии II-III демонстрируют кратковременные когнитивные улучшения и эмоциональную гиперчувствительность - это считается побочным эффектом кристаллической стимуляции ЦНС.<BR>\
			</list>"

/obj/item/paper/guide/anaesthesia
	name = "anaesthesia dose chart"
	info = "<h1><b>WEHS <font color=\"blue\">ER LAB</font></b></h1><BR> \
			<h2>Surgery Anaesthesia Chart</h2><BR>\
			<BR><h3>Propofol</h3><BR>\
			<b>Initial injection</b> - 10mg.<BR>\
			<b>Maintenance</b> - 5mg per minute.<BR>\
			<BR><h3>Fentanyl</h3><BR>\
			<b>Initial injection</b> - 2.7mg.<BR>\
			<b>Maintenance</b> - 0.2mg per minute.<BR>\
			<BR><h3>Nitrous Oxide</h3><BR>\
			<b>Initial induction</b> - 15-25kPa.<BR>\
			<b>Maintenance</b> - 5kPa.<BR>"

/obj/item/paper/guide/emergencies
	name = "emergency personnel protocols"
	info = "<h1>ПРОТОКОЛЫ ДЕЙСТВИЙ В ЧРЕЗВЫЧАЙНЫХ СИТУАЦИЯХ</h1><BR>\
			Все действия выполнять спокойно, быстро и строго по пунктам. Если не уверен - попроси помощи по рации.<BR>\
			<BR>\
			<h2>ПОЖАР ИЛИ ПРОБЛЕМЫ С ВОЗДУХОМ</h2><BR>\
			<b>Признаки:</b> дым, запах гари, тревога вентиляции, резь в глазах, ощущение удушья.<BR>\
			<b>Действия:</b><BR>\
			<list>\
			<*>1. Надень маску фильтрации (находится в персональном наборе или пожарных шкафах).<BR>\
			<*>2. Нажми кнопку тревоги на стене и сообщи о пожаре по рации.<BR>\
			<*>3. Покинь зону.<BR>\
			<*>4. Не открывай двери вручную, если они заперты - жди автоматического открытия.<BR>\
			</list>\
			<h2>ЗАТОПЛЕНИЕ</h2><BR>\
			<b>Признаки:</b> вода на полу, журчание в стенах.<BR>\
			<b>Действия:</b><BR>\
			<list>\
			<*>1. Сообщи о затоплении по рации.<BR>\
			<*>2. Не трогай воду руками, особенно рядом с кабелями или техникой.<BR>\
			</list>\
			<h2>ЧЕЛОВЕК В ОПАСНОСТИ</h2><BR>\
			<b>Примеры:</b> обморок, кровь, крик, судороги, боль.<BR>\
			<b>Действия:</b><BR>\
			<list>\
			<*>1. Убедись, что место безопасно для тебя.<BR>\
			<*>2. Позови на помощь по рации, сообщив своё местоположение.<BR>\
			<*>3. Если пострадавший в сознании - успокой, не трогай.<BR>\
			<*>4. Если в бессознании - не двигай его, проверь дыхание и пульс.<BR>\
			<*>5. При отсутствии дыхания или пульса начни СЛР.<BR>\
			<*>6. Не давай пищу/воду/таблетки, только сообщи и жди прибытия медиков.<BR>\
			</list>\
			"

/obj/item/paper/guide/facility_ai
	name = "facility AI note"
	info = "What's actually insane is that we're using something we don't fully understand.<BR> \
			The code of the SCS core is massive, with literal millions of lines.<BR> \
			Redundant calls. Unreadable structure. Constant callbacks to an address that doesn't exist.<BR> \
			It's way more than a simple facility control AI, but its current form was severely lobotomized ever since it was disconnected from the global network.<BR> \
			I think we may find what we're looking for where the signals actually point to.<BR> \
			They're routed through the main government data center, but are actually going elsewhere.<BR> \
			There's a small building connected to an underground tunnel on highway 23.<BR> \
			The answer is there.<BR>"