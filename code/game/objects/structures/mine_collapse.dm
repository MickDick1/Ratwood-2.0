GLOBAL_VAR_INIT(mine_collapse_active, 0)

/obj/structure/mine_collapse
	name = "mineshaft collapse trigger"
	icon_state = "nothing"
	desc = ""
	icon = 'icons/obj/hand_of_god_structures.dmi'
	icon_state = "trap"
	density = FALSE
	anchored = TRUE
	alpha = 0
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	appearance_flags = 0
	max_integrity = 0
	bound_width = 128
	obj_flags = INDESTRUCTIBLE
	var/last_trigger = 0
	var/time_between_triggers = 1 MINUTES //takes a minute to recharge

	var/turf/closed/respawn_rock = /turf/closed/mineral/random/rogue
	var/rolling_rocks = FALSE

	var/list/static/whitelist_typecache
	var/list/static/absorb_rocks_typecache

/obj/structure/mine_collapse/salt
	respawn_rock = /turf/closed/mineral/rogue/salt

/obj/structure/mine_collapse/Initialize(mapload)
	. = ..()

	if(!whitelist_typecache)
		whitelist_typecache = typecacheof(/mob/living/carbon/human)
	if(!absorb_rocks_typecache)
		absorb_rocks_typecache = typecacheof(list(/obj/item/natural/rock, /obj/item/natural/stone))
	last_trigger = world.time

/obj/structure/mine_collapse/Crossed(atom/movable/AM)
	if(last_trigger + time_between_triggers > world.time)
		return
	// only trigger traps with these types
	if(!is_type_in_typecache(AM, whitelist_typecache))
		return
	last_trigger = world.time
	if(ishuman(AM))
		var/mob/living/carbon/human/steve = AM
		if(!prob(4))
			return
		var/turf/T = get_turf(src)
		if(!T || isclosedturf(T))
			return
		if(!istype(T, /turf/open/floor/rogue))
			return
		to_chat(steve, span_danger("You feel rocks fall from the ceiling!"))
		trigger_collapse()

/obj/structure/mine_collapse/proc/trigger_collapse(triggered_by_neighbor = FALSE, do_sfx = TRUE)
	var/turf/T = get_turf(src)
	if(!T || !istype(T, /turf/open/floor/rogue))
		return FALSE
	rolling_rocks = TRUE
	last_trigger = world.time
	GLOB.mine_collapse_active++

	var/time_delay
	if(triggered_by_neighbor) // these trigger shorter
		time_delay = rand(2 SECONDS, 4 SECONDS)
		var/obj/effect/temp_visual/trap/mine_collapse/right/short/left = new /obj/effect/temp_visual/trap/mine_collapse/left/short(T)
		var/obj/effect/temp_visual/trap/mine_collapse/right/short/right = new /obj/effect/temp_visual/trap/mine_collapse/right/short(T)
		if(left && right && time_delay > left.duration) // set fade out to disappear when collapse() is called
			left.fade_time = right.fade_time = time_delay - left.duration
	else
		time_delay = 4 SECONDS
		new /obj/effect/temp_visual/trap/mine_collapse/left(T)
		new /obj/effect/temp_visual/trap/mine_collapse/right(T)
	addtimer(CALLBACK(src, PROC_REF(collapse), triggered_by_neighbor), wait = time_delay)
	if(do_sfx)
		playsound(src, 'sound/misc/cavein.ogg', 200, TRUE)
	return TRUE

/obj/structure/mine_collapse/proc/collapse(triggered_by_neighbor = FALSE)
	rolling_rocks = FALSE
	GLOB.mine_collapse_active--
	var/turf/T = get_turf(src)
	if(!T || !istype(T, /turf/open/floor/rogue))
		return

	for(var/obj/structure/closet/I in T) // dump chests/closets
		I.dump_contents()
	for(var/obj/structure/handcart/I in T) // dump handcarts
		I.dump_contents()
	for(var/obj/item/natural/I in T) // absorb smaller stones
		if(is_type_in_typecache(I, absorb_rocks_typecache))
			qdel(I)
	for(var/mob/living/L in T)
		var/def_zone = BODY_ZONE_CHEST
		if(iscarbon(L))
			var/mob/living/carbon/C = L
			if(C.mobility_flags & MOBILITY_STAND)
				def_zone = pick(BODY_ZONE_CHEST, BODY_ZONE_CHEST, BODY_ZONE_R_ARM, BODY_ZONE_L_ARM)
			else
				def_zone = BODY_ZONE_HEAD
		var/obj/item/bodypart/BP = L.get_bodypart(def_zone)
		if(BP)
			L.visible_message(span_boldwarning("Rocks comes crashing down on [L]'s [BP.name]!"), \
					span_userdanger("Rocks crushes my [BP.name]!"))
			L.emote("paincrit", forced = TRUE)
			BP.add_wound(/datum/wound/fracture)
			BP.update_disabled()
			L.apply_damage(90, BRUTE, def_zone)
			L.Paralyze(80)

	var/area/center_area = get_area(T) // get the area before we fill with rock wall
	var/turf/X = T.PlaceOnTop(respawn_rock)
	if(!X)
		return
	playsound(src, 'sound/misc/meteorimpact.ogg', 200, TRUE)
	if(!triggered_by_neighbor)
		X.loud_message("The ground shakes, and falling rocks echo", hearing_distance = 14)
	if(GLOB.mine_collapse_active > 5)
		return
	var/trigger_sfx = TRUE
	for(var/obj/structure/mine_collapse/other_mineshafts in range(2, src))
		if(src == other_mineshafts)
			continue
		if(other_mineshafts.rolling_rocks)
			continue
		if(isclosedturf(other_mineshafts))
			continue
		if(center_area != get_area(other_mineshafts))
			continue
		if(other_mineshafts.trigger_collapse(TRUE, trigger_sfx))
			trigger_sfx = FALSE
		if(prob(75))
			break

/obj/effect/temp_visual/trap/mine_collapse
	icon = 'icons/effects/effects.dmi'
	icon_state = "trap"
	light_outer_range = 0 // don't spam SSlighting
	duration = 3 SECONDS
	fade_time = 1 SECONDS

/obj/effect/temp_visual/trap/mine_collapse/left
	pixel_x = -8

/obj/effect/temp_visual/trap/mine_collapse/right
	pixel_x = 8

/obj/effect/temp_visual/trap/mine_collapse/left/short
	duration = 2 SECONDS
	fade_time = 0 SECONDS

/obj/effect/temp_visual/trap/mine_collapse/right/short
	duration = 2 SECONDS
	fade_time = 0 SECONDS
