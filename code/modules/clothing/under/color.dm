// items not part of the colour changing system

/obj/item/clothing/under/psyche
	name = "psychedelic jumpsuit"
	desc = "Groovy!"
	icon = 'icons/clothing/under/jumpsuits/jumpsuit_psychadelic.dmi'

/obj/item/clothing/under/color/orange
	name = "orange jumpsuit"
	desc = "It's standardised prisoner-wear. Its suit sensor controls are permanently set to the \"Fully On\" position."
	icon = 'icons/clothing/under/jumpsuits/jumpsuit_prisoner.dmi'
	has_sensor = 2
	sensor_mode = 3

/obj/item/clothing/under/color/blackjumpshorts
	name = "black jumpsuit shorts"
	desc = "The latest in space fashion, in a ladies' cut with shorts."
	icon = 'icons/clothing/under/jumpsuits/jumpsuit_shorts.dmi'

/obj/item/clothing/under/color
	name = "cotton jumpsuit"
	desc = "A comfy jumpsuit. It doesn't provide any protection at all, though."
	icon = 'icons/clothing/under/jumpsuits/jumpsuit.dmi'

/obj/item/clothing/under/color/white
	name = "white cotton jumpsuit"
	color = "#ffffff"

/obj/item/clothing/under/color/black
	name = "black cotton jumpsuit"
	color = "#3d3d3d"
	material = /decl/material/solid/cloth/black

/obj/item/clothing/under/color/grey
	name = "grey cotton jumpsuit"
	color = "#c4c4c4"
	material = /decl/material/solid/cloth/black

/obj/item/clothing/under/color/blue
	name = "blue cotton jumpsuit"
	color = "#0066ff"
	material = /decl/material/solid/cloth/blue

/obj/item/clothing/under/color/pink
	name = "pink cotton jumpsuit"
	color = "#df20a6"
	material = /decl/material/solid/cloth/purple

/obj/item/clothing/under/color/red
	name = "red cotton jumpsuit"
	color = "#ee1511"
	material = /decl/material/solid/cloth/red

/obj/item/clothing/under/color/green
	name = "green cotton jumpsuit"
	color = "#42a345"
	material = /decl/material/solid/cloth/green

/obj/item/clothing/under/color/yellow
	name = "yellow cotton jumpsuit"
	color = "#ffee00"
	material = /decl/material/solid/cloth/yellow

/obj/item/clothing/under/color/lightpurple
	name = "light purple cotton jumpsuit"
	color = "#c600fc"
	material = /decl/material/solid/cloth/purple

/obj/item/clothing/under/color/brown
	name = "brown cotton jumpsuit"
	color = "#c08720"
	material = /decl/material/solid/cloth/beige


/obj/item/clothing/under/graphene
	name = "synthetic graphene jumpsuit"
	desc = "A jumpsuit made of layered synthetic cloth and graphene. Although not so comfy, it's quite resistant all-around."
	icon = 'icons/clothing/under/jumpsuits/jumpsuit.dmi'
	color = "#2b2b2b"
	siemens_coefficient = 0.7
	material = /decl/material/solid/graphene_cloth
	armor = list(
		melee = ARMOR_MELEE_SMALL,
		bullet = ARMOR_BALLISTIC_SMALL,
		laser = ARMOR_LASER_MINOR,
		energy = ARMOR_ENERGY_SMALL,
		bio = ARMOR_BIO_SMALL,
		rad = ARMOR_RAD_MINOR
	)