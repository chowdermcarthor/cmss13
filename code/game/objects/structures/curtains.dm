/obj/structure/curtain
	icon = 'icons/obj/structures/curtain.dmi'
	name = "curtain"
	icon_state = "green"
	layer = ABOVE_MOB_LAYER
	opacity = 1
	density = 0

/obj/structure/curtain/open/New()
	..()
	toggle()

/obj/structure/curtain/bullet_act(obj/item/projectile/P, def_zone)
	if(P.damage)
		visible_message("<span class='warning'>[P] tears [src] down!</span>")
		qdel(src)
	return 0

/obj/structure/curtain/attack_hand(mob/user)
	playsound(get_turf(loc), "rustle", 15, 1, 6)
	toggle()
	..()

/obj/structure/curtain/proc/toggle()
	opacity = !opacity
	if(opacity)
		icon_state = "[initial(icon_state)]"
		layer = ABOVE_MOB_LAYER
	else
		icon_state = "[initial(icon_state)]-o"
		layer = OBJ_LAYER

/obj/structure/curtain/shower
	name = "shower curtain"
	color = "#ACD1E9"
	alpha = 200

/obj/structure/curtain/black
	name = "black curtain"
	color = "#222222"

/obj/structure/curtain/medical
	name = "plastic curtain"
	color = "#B8F5E3"
	alpha = 200

/obj/structure/curtain/open/shower
	name = "shower curtain"
	color = "#ACD1E9"
	alpha = 200

/obj/structure/curtain/open/black
	name = "black curtain"
	color = "#222222"

/obj/structure/curtain/open/medical
	name = "plastic curtain"
	color = "#B8F5E3"
	alpha = 200

/obj/structure/curtain/red
	name = "red curtain"
	icon_state = "red"