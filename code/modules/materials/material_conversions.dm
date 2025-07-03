/proc/mat_stack_to_gas(obj/item/stack/material/stack, datum/gas_mixture/gasmix)
	var/sheet_volume = stack.amount * SHEET_MATERIAL_AMOUNT
	var/resulting_moles = sheet_volume / stack.material.molar_volume
	gasmix.adjust_gas_temp(stack.material.type, resulting_moles, stack.temperature)
	qdel(stack)