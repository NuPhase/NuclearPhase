/turf/simulated/wall
	var/icon_temperature = T20C
	appearance_flags = KEEP_TOGETHER
	layer = ABOVE_TILE_LAYER
	var/must_reset = FALSE

/turf/simulated/wall/proc/debug(var/_size, var/_offet, var/_x = 0, var/_y = 0)
	remove_filter("glow")
	add_filter("glow",1, list(type="drop_shadow", x = _x, y = _y, offset = _offet, size = _size))

/turf/simulated/wall/Initialize(ml, materialtype, rmaterialtype)
	. = ..()
	color = initial(color) //we don't make use of the fancy overlay system for colours, use this to set the default.
	add_filter("glow",1, list(type="drop_shadow", x = 0, y = 0, offset = 0, size = 0))

/turf/simulated/wall/ProcessAtomTemperature()
	. = ..()
	if(temperature && (icon_temperature > 500 || temperature > 500)) //start glowing at 500K
		if(abs(temperature - icon_temperature) > 10)
			icon_temperature = temperature
			var/scale = max((icon_temperature - 500) / 1500, 0)

			var/h_r = heat2color_r(icon_temperature)
			var/h_g = heat2color_g(icon_temperature)
			var/h_b = heat2color_b(icon_temperature)

			if(icon_temperature < 2000) //scale up overlay until 2000K
				h_r = 64 + (h_r - 64)*scale
				h_g = 64 + (h_g - 64)*scale
				h_b = 64 + (h_b - 64)*scale
			var/scale_color = rgb(h_r, h_g, h_b)

			animate(src, color = scale_color, time = 2 SECONDS, easing = SINE_EASING)
			animate_filter("glow", list(color = scale_color, offset = 2, size = 6, time = 2 SECONDS, easing = LINEAR_EASING))
			set_light(min(3, scale*2.5), min(3, scale*2.5), scale_color)
			must_reset = TRUE
	else if(must_reset)
		set_light(0, 0)
		animate(src, color = initial(src.color), time = 2 SECONDS, easing = SINE_EASING)
		animate_filter("glow", list(offset = 0, size = 0, time = 2 SECONDS, easing = LINEAR_EASING))
		must_reset = FALSE
