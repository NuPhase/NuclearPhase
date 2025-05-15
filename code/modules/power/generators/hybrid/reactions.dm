/decl/thermonuclear_reaction
	var/decl/material/first_reactant = null
	var/decl/material/second_reactant = null
	var/decl/material/product = null
	var/s_factor = 1
	var/mean_energy = 0 //millions of joules per mole
	var/free_neutron_moles = 0
	var/minimum_temperature = 300000 //that is considered cold fusion lol

/decl/thermonuclear_reaction/Initialize()
	. = ..()
	mean_energy *= 1000000

/decl/thermonuclear_reaction/hydrogen_hydrogen
	first_reactant = /decl/material/gas/hydrogen
	second_reactant = /decl/material/gas/hydrogen
	product = /decl/material/gas/helium
	mean_energy = 2580000
	minimum_temperature = 110 MEGAKELVIN
	free_neutron_moles = 1
	s_factor = 1

/decl/thermonuclear_reaction/deuterium_tritium
	first_reactant = /decl/material/gas/hydrogen/deuterium
	second_reactant = /decl/material/gas/hydrogen/tritium
	product = /decl/material/gas/helium
	mean_energy = 1700000
	minimum_temperature = 90 MEGAKELVIN
	free_neutron_moles = 1.5
	s_factor = 10

/decl/thermonuclear_reaction/deuterium_deuterium
	first_reactant = /decl/material/gas/hydrogen/deuterium
	second_reactant = /decl/material/gas/hydrogen/deuterium
	product = /decl/material/gas/hydrogen/tritium
	mean_energy = 352000
	minimum_temperature = 130 MEGAKELVIN
	free_neutron_moles = 0
	s_factor = 3

/decl/thermonuclear_reaction/helium3_helium3
	first_reactant = /decl/material/gas/helium/isotopethree
	second_reactant = /decl/material/gas/helium/isotopethree
	product = /decl/material/gas/helium
	mean_energy = 1240000
	minimum_temperature = 170 MEGAKELVIN
	free_neutron_moles = 3
	s_factor = 5

/decl/thermonuclear_reaction/helium4_helium4
	first_reactant = /decl/material/gas/helium
	second_reactant = /decl/material/gas/helium
	product = /decl/material/solid/carbon
	mean_energy = 468000
	minimum_temperature = 100 MEGAKELVIN
	free_neutron_moles = 0
	s_factor = 3

/decl/thermonuclear_reaction/deuterium_helium3
	first_reactant = /decl/material/gas/hydrogen/deuterium
	second_reactant = /decl/material/gas/helium/isotopethree
	product = /decl/material/gas/helium
	mean_energy = 1730000
	minimum_temperature = 130 MEGAKELVIN
	free_neutron_moles = 0
	s_factor = 4

/decl/thermonuclear_reaction/carbon_helium4
	first_reactant = /decl/material/solid/carbon
	second_reactant = /decl/material/gas/helium
	product = /decl/material/solid/metal/beryllium
	mean_energy = 1340000
	minimum_temperature = 170 MEGAKELVIN
	free_neutron_moles = 0
	s_factor = 10