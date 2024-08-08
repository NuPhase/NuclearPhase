SUBSYSTEM_DEF(particles)
	name = "Particles"
	flags = SS_NO_FIRE
	var/list/premade_particles = list()

/datum/controller/subsystem/particles/proc/get_particle(particle_type)
	return premade_particles[particle_type]

/datum/controller/subsystem/particles/Initialize(start_timeofday)
	. = ..()
	for(var/particle_type in subtypesof(/particles/))
		var/particles/new_particle = new particle_type
		if(new_particle.is_global)
			premade_particles[particle_type] = new_particle
		else
			qdel(new_particle)