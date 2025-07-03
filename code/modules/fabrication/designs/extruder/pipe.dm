/decl/extruder_recipe/pipe
	name = "Steel Straight Pipe"
	input_material = /decl/material/solid/metal/steel
	input_amount = 4000
	output_item = /obj/item/pipe
	minimum_skill = SKILL_BASIC
	progress_step = 50
	var/output_construction_type = /obj/machinery/atmospherics/pipe/simple/hidden
	var/output_icon = 'icons/obj/atmospherics/pipes/pipe-item.dmi'
	var/output_icon_state = "simple"
	var/output_color = PIPE_COLOR_GREY
	var/output_pipe_class = PIPE_CLASS_BINARY
	var/output_rotate_class = PIPE_ROTATE_STANDARD
	var/output_connect_types = CONNECT_TYPE_REGULAR

/decl/extruder_recipe/pipe/hafnium_carbide
	name = "HfC Straight Pipe"
	input_material = /decl/material/solid/stone/ceramic/hafniumcarbide
	input_amount = 10200
	minimum_skill = SKILL_ADEPT
	output_construction_type = /obj/machinery/atmospherics/pipe/simple/visible/hafnium_carbide
	output_icon = 'icons/obj/atmospherics/pipes/inconelpipe.dmi'
	output_icon_state = "11"
	output_color = PIPE_COLOR_BLACK