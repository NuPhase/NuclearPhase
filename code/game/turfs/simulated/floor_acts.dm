/turf/simulated/floor/explosion_act(severity)
	SHOULD_CALL_PARENT(FALSE)
	switch(severity)
		if(1000 to INFINITY)
			ChangeTurf(get_base_turf_by_area(src))
		if(700 to 1000)
			if(prob(severity * 0.04))
				ReplaceWithLattice()
			else
				break_tile_to_plating()
		if(200 to 700)
			if(prob(severity * 0.03))
				break_tile_to_plating()
				var/decl/material/mat = GET_DECL(/decl/material/solid/metal/steel)
				mat.place_shard(src)
			else if(prob(severity * 0.12))
				break_tile()

/turf/simulated/floor/fire_act(datum/gas_mixture/air, exposed_temperature, exposed_volume)
	var/temp_destroy = get_damage_temperature()
	if(!burnt && prob(5))
		burn_tile(exposed_temperature)
	else if(temp_destroy && exposed_temperature >= (temp_destroy + 100) && prob(1) && !is_plating())
		make_plating() //destroy the tile, exposing plating
		burn_tile(exposed_temperature)
	return ..()

//should be a little bit lower than the temperature required to destroy the material
/turf/simulated/floor/proc/get_damage_temperature()
	return flooring ? flooring.damage_temperature : null

/turf/simulated/floor/adjacent_fire_act(turf/simulated/floor/adj_turf, datum/gas_mixture/adj_air, adj_temp, adj_volume)
	var/dir_to = get_dir(src, adj_turf)

	for(var/obj/structure/window/W in src)
		if(W.dir == dir_to || W.is_fulltile()) //Same direction or diagonal (full tile)
			W.fire_act(adj_air, adj_temp, adj_volume)
