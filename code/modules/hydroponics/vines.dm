
// SPACE VINES (Note that this code is very similar to Biomass code)
/obj/effect/plantsegment
	name = "space vines"
	desc = "An extremely expansionistic species of vine."
	icon = 'icons/effects/spacevines.dmi'
	icon_state = "Light1"
	anchored = 1
	density = 0
	layer = FLY_LAYER

	// Vars used by vines with seed data.
	var/age = 0
	var/lastproduce = 0
	var/harvest = 0
	var/list/chems
	var/plant_damage_noun = "Thorns"
	var/limited_growth = 0

	// Life vars/
	var/energy = 0
	var/obj/effect/plant_controller/master = null
	var/datum/seed/seed

/obj/effect/plantsegment/New()
	return

/obj/effect/plantsegment/Destroy()
	if(master)
		master.vines -= src
		master.growth_queue -= src
	. = ..()

/obj/effect/plantsegment/initialize_pass_flags(var/datum/pass_flags_container/PF)
	..()
	if (PF)
		PF.flags_pass = PASS_OVER|PASS_AROUND|PASS_UNDER|PASS_THROUGH

/obj/effect/plantsegment/attackby(obj/item/W as obj, mob/user as mob)
	if(iswelder(W))
		var/obj/item/tool/weldingtool/WT = W
		if(WT.remove_fuel(0, user))
			qdel(src)
	else if(W.heat_source >= 3500)
		qdel(src)
	else if(W.sharp)
		switch(W.sharp)
			if(IS_SHARP_ITEM_BIG)
				qdel(src)
			if(IS_SHARP_ITEM_ACCURATE)
				if(prob(60))
					qdel(src)
			if(IS_SHARP_ITEM_SIMPLE)
				if(prob(25))
					qdel(src)
	else
		manual_unbuckle(user)
		return



/obj/effect/plantsegment/attack_hand(mob/user as mob)

	if(user.a_intent == INTENT_HELP && seed && harvest)
		seed.harvest(user,1)
		harvest = 0
		lastproduce = age
		update()
		return

	manual_unbuckle(user)

/obj/effect/plantsegment/manual_unbuckle(mob/user)
	if(buckled_mob)
		if(prob(seed ? min(max(0,100 - seed.potency),100) : 50))
			if(buckled_mob.buckled == src)
				if(buckled_mob != user)
					buckled_mob.visible_message(\
						SPAN_NOTICE("[user.name] frees [buckled_mob.name] from [src]."),\
						SPAN_NOTICE("[user.name] frees you from [src]."),\
						SPAN_WARNING("You hear shredding and ripping."))
				else
					buckled_mob.visible_message(\
						SPAN_NOTICE("[buckled_mob.name] struggles free of [src]."),\
						SPAN_NOTICE("You untangle [src] from around yourself."),\
						SPAN_WARNING("You hear shredding and ripping."))
			unbuckle()
			return 1
		else
			var/text = pick("rips","tears","pulls")
			user.visible_message(\
				SPAN_NOTICE("[user.name] [text] at [src]."),\
				SPAN_NOTICE("You [text] at [src]."),\
				SPAN_WARNING("You hear shredding and ripping."))
	return 0

/obj/effect/plantsegment/proc/grow()

	if(!energy)
		src.icon_state = pick("Med1", "Med2", "Med3")
		energy = 1

		//Low-lying creepers do not block vision or grow thickly.
		if(limited_growth)
			energy = 2
			return

		src.opacity = 1
		layer = FLY_LAYER
	else if(!limited_growth)
		src.icon_state = pick("Hvy1", "Hvy2", "Hvy3")
		energy = 2

/obj/effect/plantsegment/proc/entangle_mob()

	if(limited_growth)
		return

	if(prob(seed ? seed.potency : 25))

		if(!buckled_mob)
			var/mob/living/carbon/V = locate() in src.loc
			if(V && (V.stat != DEAD) && (V.buckled != src)) // If mob exists and is not dead or captured.
				V.buckled = src
				V.forceMove(src.loc)
				V.update_canmove()
				src.buckled_mob = V
				to_chat(V, SPAN_DANGER("The vines [pick("wind", "tangle", "tighten")] around you!"))

		// FEED ME, SEYMOUR.
		if(buckled_mob && seed && (buckled_mob.stat != DEAD)) //Don't bother with a dead mob.

			var/mob/living/M = buckled_mob
			if(!istype(M)) return
			var/mob/living/carbon/human/H = buckled_mob

			// Drink some blood/cause some brute.
			if(seed.carnivorous == 2)
				to_chat(buckled_mob, SPAN_DANGER("\The [src] pierces your flesh greedily!"))

				var/damage = rand(round(seed.potency/2),seed.potency)
				if(!istype(H))
					H.apply_damage(damage, BRUTE)
					return

				var/obj/limb/affecting = H.get_limb(pick("l_foot","r_foot","l_leg","r_leg","l_hand","r_hand","l_arm", "r_arm","head","chest","groin"))

				if(affecting)
					affecting.take_damage(damage, 0)
					if(affecting.parent)
						affecting.parent.add_autopsy_data("[plant_damage_noun]", damage)
				else
					H.apply_damage(damage, BRUTE)

				H.UpdateDamageIcon()
				H.updatehealth()

			// Inject some chems.
			if(seed.chems && seed.chems.len && istype(H))
				to_chat(H, SPAN_DANGER("You feel something seeping into your skin!"))
				for(var/rid in seed.chems)
					var/injecting = min(5,max(1,seed.potency/5))
					H.reagents.add_reagent(rid,injecting)

/obj/effect/plantsegment/proc/update()
	if(!seed) return

	// Update bioluminescence.
	if(seed.biolum)
		SetLuminosity(1+round(seed.potency/10))
		return
	else
		SetLuminosity(0)

	// Update flower/product overlay.
	overlays.Cut()
	if(age >= seed.maturation)
		if(prob(20) && seed.products && seed.products.len && !harvest && ((age-lastproduce) > seed.production))
			harvest = 1
			lastproduce = age

		if(harvest)
			var/image/fruit_overlay = image('icons/obj/structures/machinery/hydroponics.dmi',"")
			if(seed.product_colour)
				fruit_overlay.color = seed.product_colour
			overlays += fruit_overlay

		if(seed.flowers)
			var/image/flower_overlay = image('icons/obj/structures/machinery/hydroponics.dmi',"[seed.flower_icon]")
			if(seed.flower_colour)
				flower_overlay.color = seed.flower_colour
			overlays += flower_overlay

/obj/effect/plantsegment/proc/spread()
	var/direction = pick(cardinal)
	var/step = get_step(src,direction)
	if(istype(step,/turf/open/floor))
		var/turf/open/floor/F = step
		if(!locate(/obj/effect/plantsegment,F))
			if(F.Enter(src))
				if(master)
					master.spawn_piece( F )

// Explosion damage.
/obj/effect/plantsegment/ex_act(severity)
	switch(severity)
		if(0 to EXPLOSION_THRESHOLD_LOW)
			if (prob(50))
				die()
				return
		if(EXPLOSION_THRESHOLD_LOW to EXPLOSION_THRESHOLD_MEDIUM)
			if (prob(90))
				die()
				return
		if(EXPLOSION_THRESHOLD_MEDIUM to INFINITY)
			die()
			return
	return

// Hotspots kill vines.
/obj/effect/plantsegment/fire_act(null, temp, volume)
	qdel(src)

/obj/effect/plantsegment/proc/die()
	if(seed && harvest && rand(5))
		seed.harvest(src,1)
		qdel(src)

/obj/effect/plantsegment/proc/life()

	if(!seed)
		return

	if(prob(30))
		age++

	var/turf/T = loc
	if(!loc)
		return

	var/pressure = T.return_pressure()
	var/temperature = T.return_temperature()

	if(pressure < seed.lowkpa_tolerance || pressure > seed.highkpa_tolerance)
		die()
		return

	if(abs(temperature - seed.ideal_heat) > seed.heat_tolerance)
		die()
		return

	var/area/A = T.loc
	if(A)
		var/light_available
		if(A.lighting_use_dynamic)
			light_available = max(0,min(10,T.lighting_lumcount)-5)
		else
			light_available =  5
		if(abs(light_available - seed.ideal_light) > seed.light_tolerance)
			die()
			return

/obj/effect/plantsegment/flamer_fire_act()
	qdel(src)
	return

/obj/effect/plant_controller

	//What this does is that instead of having the grow minimum of 1, required to start growing, the minimum will be 0,
	//meaning if you get the spacevines' size to something less than 20 plots, it won't grow anymore.

	var/list/obj/effect/plantsegment/vines = list()
	var/list/growth_queue = list()
	var/reached_collapse_size
	var/reached_slowdown_size
	var/datum/seed/seed

	var/collapse_limit = 250
	var/slowdown_limit = 30
	var/limited_growth = 0

/obj/effect/plant_controller/creeper
	collapse_limit = 6
	slowdown_limit = 3
	limited_growth = 1

/obj/effect/plant_controller/New()
	if(!istype(src.loc,/turf/open/floor))
		qdel(src)

	INVOKE_ASYNC(src, PROC_REF(spawn_piece), src.loc)

	START_PROCESSING(SSobj, src)

/obj/effect/plant_controller/Destroy()
	STOP_PROCESSING(SSobj, src)
	. = ..()

/obj/effect/plant_controller/proc/spawn_piece(var/turf/location)
	var/obj/effect/plantsegment/SV = new(location)
	SV.limited_growth = src.limited_growth
	growth_queue += SV
	vines += SV
	SV.master = src
	if(seed)
		SV.seed = seed
		SV.name = "[seed.seed_name] vines"
		SV.update()

/obj/effect/plant_controller/process()

	// Space vines exterminated. Remove the controller
	if(!vines)
		qdel(src)
		return

	// Sanity check.
	if(!growth_queue)
		qdel(src)
		return

	// Check if we're too big for our own good.
	if(vines.len >= (seed ? seed.potency * collapse_limit : 250) && !reached_collapse_size)
		reached_collapse_size = 1
	if(vines.len >= (seed ? seed.potency * slowdown_limit : 30) && !reached_slowdown_size )
		reached_slowdown_size = 1

	var/length = 0
	if(reached_collapse_size)
		length = 0
	else if(reached_slowdown_size)
		if(prob(seed ? seed.potency : 25))
			length = 1
		else
			length = 0
	else
		length = 1

	length = min(30, max(length, vines.len/5))

	// Update as many pieces of vine as we're allowed to.
	// Append updated vines to the end of the growth queue.
	var/i = 0
	var/list/obj/effect/plantsegment/queue_end = list()
	for(var/obj/effect/plantsegment/SV in growth_queue)
		i++
		queue_end += SV
		growth_queue -= SV

		SV.life()
		if(!SV) continue

		if(SV.energy < 2) //If tile isn't fully grown
			var/chance
			if(seed)
				chance = limited_growth ? round(seed.potency/2,1) : seed.potency
			else
				chance = 20

			if(prob(chance))
				SV.grow()

		else if(!seed || !limited_growth) //If tile is fully grown and not just a creeper.
			SV.entangle_mob()

		SV.update()
		SV.spread()
		if(i >= length)
			break

	growth_queue = growth_queue + queue_end
