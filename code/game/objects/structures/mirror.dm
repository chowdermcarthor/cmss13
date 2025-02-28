
/obj/structure/mirror
	name = "mirror"
	desc = "Mirror mirror on the wall, who's the most robust of them all?"
	icon = 'icons/obj/structures/props/watercloset.dmi'
	icon_state = "mirror"
	density = 0
	anchored = 1
	var/shattered = 0


/obj/structure/mirror/attack_hand(mob/user as mob)

	if(shattered) return

	if(ishuman(user))
		var/mob/living/carbon/human/H = user

		if(H.a_intent == INTENT_HARM)
			if(shattered)
				playsound(src.loc, 'sound/effects/hit_on_shattered_glass.ogg', 25, 1)
				return
			if(prob(30) || H.species.can_shred(H))
				user.visible_message(SPAN_DANGER("[user] smashes [src]!"))
				shatter()
			else
				user.visible_message(SPAN_DANGER("[user] hits [src] and bounces off!"))
			return

		var/userloc = H.loc

		//see code/modules/mob/new_player/preferences.dm at approx line 545 for comments!
		//this is largely copypasted from there.

		//handle facial hair (if necessary)
		if(H.gender == MALE)
			var/list/species_facial_hair = list()
			if(H.species)
				for(var/i in GLOB.facial_hair_styles_list)
					var/datum/sprite_accessory/facial_hair/tmp_facial = GLOB.facial_hair_styles_list[i]
					if(H.species.name in tmp_facial.species_allowed)
						if(tmp_facial.selectable)
							species_facial_hair += i
			else
				species_facial_hair = GLOB.facial_hair_styles_list

			var/new_style = input(user, "Select a facial hair style", "Grooming")  as null|anything in species_facial_hair
			if(userloc != H.loc) return //no tele-grooming
			if(new_style)
				H.f_style = new_style

		//handle normal hair
		var/list/species_hair = list()
		if(H.species)
			for(var/i in GLOB.hair_styles_list)
				var/datum/sprite_accessory/hair/tmp_hair = GLOB.hair_styles_list[i]
				if(H.species.name in tmp_hair.species_allowed)
					if(tmp_hair.selectable)
						species_hair += i
		else
			species_hair = GLOB.hair_styles_list

		var/new_style = input(user, "Select a hair style", "Grooming")  as null|anything in species_hair
		if(userloc != H.loc) return //no tele-grooming
		if(new_style)
			H.h_style = new_style

		H.update_hair()


/obj/structure/mirror/proc/shatter()
	if(shattered) return
	shattered = 1
	icon_state = "mirror_broke"
	playsound(src, "shatter", 70, 1)
	desc = "Oh no, seven years of bad luck!"


/obj/structure/mirror/bullet_act(var/obj/item/projectile/Proj)
	if(prob(Proj.damage * 2))
		if(!shattered)
			shatter()
		else
			playsound(src, 'sound/effects/hit_on_shattered_glass.ogg', 25, 1)
	..()
	return 1


/obj/structure/mirror/attackby(obj/item/I as obj, mob/user as mob)
	if(shattered)
		playsound(src.loc, 'sound/effects/hit_on_shattered_glass.ogg', 25, 1)
		return

	if(prob(I.force * 2))
		visible_message(SPAN_WARNING("[user] smashes [src] with [I]!"))
		shatter()
	else
		visible_message(SPAN_WARNING("[user] hits [src] with [I]!"))
		playsound(src.loc, 'sound/effects/Glasshit.ogg', 25, 1)

/obj/structure/mirror/attack_animal(mob/user as mob)
	if(!isanimal(user)) return
	var/mob/living/simple_animal/M = user
	if(M.melee_damage_upper <= 0) return
	if(shattered)
		playsound(src.loc, 'sound/effects/hit_on_shattered_glass.ogg', 25, 1)
		return
	user.visible_message(SPAN_DANGER("[user] smashes [src]!"))
	shatter()
