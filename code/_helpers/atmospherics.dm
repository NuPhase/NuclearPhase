/obj/proc/analyze_gases(var/obj/A, var/mob/user, mode)
	user.visible_message("<span class='notice'>\The [user] has used \an [src] on \the [A].</span>")
	A.add_fingerprint(user)

	var/air_contents = A.return_air()
	if(!air_contents)
		to_chat(user, "<span class='warning'>Your [src] flashes a red light as it fails to analyze \the [A].</span>")
		return 0

	var/list/result = atmosanalyzer_scan(A, air_contents, mode)
	print_atmos_analysis(user, result)
	return 1

/proc/print_atmos_analysis(user, var/list/result)
	for(var/line in result)
		to_chat(user, "<span class='notice'>[line]</span>")

// Returns the steam enthalpy at a specific steam table point in J/mol
// Uses curve fitting, so only accurate between 450K to 1050K and between 1MPa and 7MPa
/proc/steam_enthalpy(pressure, temperature)
	var/p_7000 = pressure/7000
	var/a = 896 * (1.55 - (0.55*p_7000))
	var/b = 6.3
	var/c = 1.17 + 0.019*(1 - p_7000)
	var/kj_kg = a + (b*temperature) - (temperature**c) //kj/kg
	return kj_kg * 1000 * 0.018015 // convert to j/mol

#define KJ * 1000
#define MJ * 1000000