// OVERWATCH - Advanced Admin Tracking System
// Tracks combat events and interactions for all players

GLOBAL_LIST_EMPTY(overwatch_events) // List of lists, keyed by ckey

#define OVERWATCH_MAX_EVENTS 100
#define OVERWATCH_EVENT_ATTACK "attack"
#define OVERWATCH_EVENT_INTERACT "interact"

/datum/overwatch_event
	var/event_type
	var/timestamp
	var/ckey  // Player this event is about
	var/turf/location
	var/x_coord
	var/y_coord
	var/z_coord
	var/location_text  // Cached location string matching LOGS output

/datum/overwatch_event/New(mob/target)
	timestamp = world.time
	if(target && target.client)
		ckey = target.client.ckey
		if(target.loc && isturf(target.loc))
			location = get_turf(target)
			x_coord = location.x
			y_coord = location.y
			z_coord = location.z
			// Mirror the LOGS location format so admins see the same
			// area/coordinate text they would in attack logs.
			location_text = loc_name(target)

/datum/overwatch_event/proc/get_timestamp_text()
	return time2text(timestamp, "hh:mm:ss")

/datum/overwatch_event/proc/get_location_text()
	if(location_text)
		return location_text
	if(x_coord && y_coord && z_coord)
		return "\[[x_coord],[y_coord],[z_coord]\]"
	return "Unknown"

/datum/overwatch_event/proc/get_summary()
	return "\[[get_timestamp_text()]\] [get_location_text()]"

// Combat tracking
/datum/overwatch_event/attack
	event_type = OVERWATCH_EVENT_ATTACK
	var/attacker_ckey
	var/attacker_name
	var/victim_ckey
	var/victim_name
	var/turf/attacker_location
	var/attacker_x
	var/attacker_y
	var/attacker_z
	var/damage_amount
	var/damage_type
	var/weapon_name
	var/victim_new_hp  // Mirrors NEWHP from LOGS where available

/datum/overwatch_event/attack/New(mob/living/attacker, mob/living/victim, damage, damagetype, obj/item/weapon)
	..( victim)
	
	if(!attacker || !victim)
		return
	
	// Victim info (already set by parent)
	victim_ckey = ckey
	victim_name = victim.real_name || victim.name
	
	// Attacker info
	if(attacker.client)
		attacker_ckey = attacker.client.ckey
	attacker_name = attacker.real_name || attacker.name
	
	if(attacker.loc && isturf(attacker.loc))
		attacker_location = get_turf(attacker)
		attacker_x = attacker_location.x
		attacker_y = attacker_location.y
		attacker_z = attacker_location.z
	
	damage_amount = damage
	damage_type = damagetype

	// Capture the victim's new HP at the time of the attack, similar to
	// how log_combat records NEWHP in the attack logs. This keeps
	// Overwatch aligned with existing LOGS data without extra work in
	// callers.
	if(istype(victim))
		victim_new_hp = victim.health
	
	if(weapon)
		weapon_name = weapon.name
	else
		weapon_name = "unarmed"

/datum/overwatch_event/attack/get_summary()
	. = "[..()]"
	var/damage_info = ""
	if(!isnull(damage_amount))
		damage_info = "[damage_amount]"
	if(damage_type)
		if(length(damage_info))
			damage_info = "[damage_info] [damage_type]"
		else
			damage_info = "[damage_type]"
	. += " [attacker_name] attacked [victim_name]"
	if(length(damage_info))
		. += " ([damage_info])"
	if(!isnull(victim_new_hp))
		. += " (NEWHP: [victim_new_hp])"
	if(weapon_name)
		. += " with [weapon_name]"

// Interaction tracking  
/datum/overwatch_event/interact
	event_type = OVERWATCH_EVENT_INTERACT
	var/interactor_ckey
	var/interactor_name
	var/obj/target_ref
	var/target_name
	var/action_type  // "touched", "opened", "closed", "lockpicked", "picked_up", "dropped", "equipped", etc.

/datum/overwatch_event/interact/New(mob/user, atom/target, action)
	var/turf/T = get_turf(target)
	if(T)
		location = T
		x_coord = T.x
		y_coord = T.y
		z_coord = T.z
	
	timestamp = world.time
	
	if(user && user.client)
		interactor_ckey = user.client.ckey
		ckey = interactor_ckey
	interactor_name = user?.real_name || user?.name || "Unknown"
	
	target_ref = target
	target_name = target.name
	action_type = action

/datum/overwatch_event/interact/get_summary()
	. = "[..()]"
	. += " [interactor_name] [action_type] [target_name]"

// Recording functions

// Internal helper: attach an event to a given ckey's history
/proc/overwatch_add_event_for_ckey(ckey, datum/overwatch_event/event)
	if(!ckey || !event)
		return
	if(!GLOB.overwatch_events[ckey])
		GLOB.overwatch_events[ckey] = list()
	var/list/events = GLOB.overwatch_events[ckey]
	events += event
	while(events.len > OVERWATCH_MAX_EVENTS)
		var/datum/overwatch_event/oldest = events[1]
		events -= oldest
		qdel(oldest)

/proc/overwatch_record_attack(mob/living/attacker, mob/living/victim, damage, damagetype, obj/item/weapon)
	// Require at least one player-side ckey so we have somewhere to store it
	if(!attacker && !victim)
		return
	var/attacker_ckey = attacker?.client?.ckey
	var/victim_ckey = victim?.client?.ckey
	if(!attacker_ckey && !victim_ckey)
		return

	// Create the event (damage may be 0/unknown for some sources like log_combat)
	var/datum/overwatch_event/attack/event = new(attacker, victim, damage, damagetype, weapon)

	// Attach to victim history (what has damaged this mob)
	if(victim_ckey)
		overwatch_add_event_for_ckey(victim_ckey, event)

	// Attach to attacker history (what this mob has damaged)
	if(attacker_ckey && attacker_ckey != victim_ckey)
		overwatch_add_event_for_ckey(attacker_ckey, event)

/proc/overwatch_record_interact(mob/user, atom/target, action)
	// Lightweight check - only track if user is a player
	if(!user || !target || !user.client || !user.ckey)
		return
	
	// Only track specific object types to reduce overhead
	if(!istype(target, /obj/item) && !istype(target, /obj/structure/mineral_door))
		return
	
	var/datum/overwatch_event/interact/event = new(user, target, action)
	
	// Store on the object itself
	if(!target.overwatch_history)
		target.overwatch_history = list()
	
	target.overwatch_history += event
	
	// Trim to max events
	while(target.overwatch_history.len > OVERWATCH_MAX_EVENTS)
		var/datum/overwatch_event/oldest = target.overwatch_history[1]
		target.overwatch_history -= oldest
		qdel(oldest)

// Add overwatch history to atoms
// Visual marker system
/obj/effect/overwatch_marker
	name = "OVERWATCH marker"
	desc = "Administrative tracking marker"
	icon = 'icons/effects/effects.dmi'
	icon_state = "shield2"
	layer = ABOVE_MOB_LAYER
	anchored = TRUE
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	invisibility = INVISIBILITY_OBSERVER // Only observers / aghosts can see

/obj/effect/overwatch_marker/attacker
	name = "Attacker Position"
	icon_state = "shield2"
	color = "#FF0000"

/obj/effect/overwatch_marker/victim
	name = "Victim Position"  
	icon_state = "shield2"
	color = "#0000FF"

/obj/effect/overwatch_marker/Initialize()
	. = ..()
	// Auto-delete after 30 seconds
	QDEL_IN(src, 30 SECONDS)

// Shared proc to display overwatch interaction history for an atom
/atom/proc/show_overwatch_history(mob/user)
	if(!user || !user.client || !check_rights(R_ADMIN, FALSE, user.client))
		return

	if(!overwatch_history || !overwatch_history.len)
		to_chat(user, span_notice("[src] has no recorded interactions."))
		return

	var/list/output = list()
	output += "<b>OVERWATCH - Interaction History for [name]</b><br>"
	output += "<i>Showing last [overwatch_history.len] interactions:</i><br><br>"

	for(var/datum/overwatch_event/interact/event in overwatch_history)
		output += "[event.get_summary()]<br>"

	var/datum/browser/popup = new(user, "overwatch_history_[world.time]", "OVERWATCH History", 600, 400)
	popup.set_content(output.Join())
	popup.open()

// Context menu verb for viewing item interactions
/obj/item/verb/check_overwatch_history()
	set name = "Check Overwatch History"
	set src in view(1)

	src.show_overwatch_history(usr)

// Context menu verb for viewing mineral door interactions
/obj/structure/mineral_door/verb/check_overwatch_history()
	set name = "Check Overwatch History"
	set src in view(1)

	src.show_overwatch_history(usr)

// Admin verb for showing first strike markers
/client/proc/overwatch_show_first_strike(ckey as text)
	set category = "Admin.Game"
	set name = "OVERWATCH: Show First Strike"
	set desc = "Visualize the location of the first attack on a player"
	
	if(!check_rights(R_ADMIN))
		return
	
	var/list/events = GLOB.overwatch_events[ckey]
	if(!events || !length(events))
		to_chat(src, span_notice("No OVERWATCH data found for [ckey]."))
		return
	
	// Find first attack event
	var/datum/overwatch_event/attack/first_attack
	for(var/datum/overwatch_event/event in events)
		if(istype(event, /datum/overwatch_event/attack))
			first_attack = event
			break
	
	if(!first_attack)
		to_chat(src, span_notice("No attack events found for [ckey]."))
		return
	
	// Create markers
	if(first_attack.location && first_attack.attacker_location)
		// Victim marker
		var/obj/effect/overwatch_marker/victim/victim_marker = new(first_attack.location)
		victim_marker.name = "Victim: [first_attack.victim_name]"
		
		// Attacker marker
		var/obj/effect/overwatch_marker/attacker/attacker_marker = new(first_attack.attacker_location)
		attacker_marker.name = "Attacker: [first_attack.attacker_name]"
		
		// Message to admin
		to_chat(src, span_adminnotice("OVERWATCH: First strike markers placed for [ckey]"))
		to_chat(src, span_notice("[first_attack.get_summary()]"))
		to_chat(src, span_notice("Markers will disappear in 30 seconds."))
		
		// Log it
		message_admins("[key_name_admin(src)] used OVERWATCH First Strike visualization for [ckey].")
	else
		to_chat(src, span_warning("Location data not available for this attack."))

// Admin verb for showing all attacks on a player
/client/proc/overwatch_show_all_attacks(ckey as text)
	set category = "Admin.Game"
	set name = "OVERWATCH: Show All Attacks"
	set desc = "Show a list of all attacks on a player"
	
	if(!check_rights(R_ADMIN))
		return
	
	var/list/events = GLOB.overwatch_events[ckey]
	if(!events || !length(events))
		to_chat(src, span_notice("No OVERWATCH data found for [ckey]."))
		return
	
	var/list/output = list()
	output += "<b>OVERWATCH - Combat Log for [ckey]</b><br>"
	output += "<i>Showing last [length(events)] events:</i><br><br>"
	
	for(var/datum/overwatch_event/event in events)
		if(istype(event, /datum/overwatch_event/attack))
			output += "[event.get_summary()]<br>"
	
	var/datum/browser/popup = new(mob, "overwatch_combat", "OVERWATCH Combat Log", 800, 600)
	popup.set_content(output.Join())
	popup.open()

// Wrapper for showing first strike from ticket UI
/client/proc/overwatch_show_first_strike_from_ticket(ckey)
	if(!check_rights(R_ADMIN))
		return
	
	var/list/events = GLOB.overwatch_events[ckey]
	if(!events || !length(events))
		to_chat(src, span_notice("No OVERWATCH data found for [ckey]."))
		return
	
	// Find first attack event
	var/datum/overwatch_event/attack/first_attack
	for(var/datum/overwatch_event/event in events)
		if(istype(event, /datum/overwatch_event/attack))
			first_attack = event
			break
	
	if(!first_attack)
		to_chat(src, span_notice("No attack events found for [ckey]."))
		return
	
	// Create markers
	if(first_attack.location && first_attack.attacker_location)
		// Victim marker
		var/obj/effect/overwatch_marker/victim/victim_marker = new(first_attack.location)
		victim_marker.name = "Victim: [first_attack.victim_name]"
		
		// Attacker marker
		var/obj/effect/overwatch_marker/attacker/attacker_marker = new(first_attack.attacker_location)
		attacker_marker.name = "Attacker: [first_attack.attacker_name]"
		
		// Message to admin
		to_chat(src, span_adminnotice("OVERWATCH: First strike markers placed for [ckey]"))
		to_chat(src, span_notice("[first_attack.get_summary()]"))
		to_chat(src, span_notice("Markers will disappear in 30 seconds."))
		
		// Log it
		message_admins("[key_name_admin(src)] used OVERWATCH First Strike visualization for [ckey].")
	else
		to_chat(src, span_warning("Location data not available for this attack."))

// Show a specific attack event from the ticket OVERWATCH panel
/client/proc/overwatch_show_attack_event_from_ticket(ckey, event_index)
	if(!check_rights(R_ADMIN))
		return

	if(!ckey)
		return

	var/list/events = GLOB.overwatch_events[ckey]
	if(!events || !length(events))
		to_chat(src, span_notice("No OVERWATCH data found for [ckey]."))
		return

	if(!isnum(event_index))
		event_index = text2num(event_index)

	if(event_index < 1 || event_index > events.len)
		to_chat(src, span_warning("Invalid OVERWATCH event selected."))
		return

	var/datum/overwatch_event/event = events[event_index]
	if(!istype(event, /datum/overwatch_event/attack))
		to_chat(src, span_notice("Selected OVERWATCH event is not a combat event."))
		return

	var/datum/overwatch_event/attack/A = event
	if(A.location)
		var/obj/effect/overwatch_marker/victim/victim_marker = new(A.location)
		victim_marker.name = "Victim: [A.victim_name]"

	if(A.attacker_location)
		var/obj/effect/overwatch_marker/attacker/attacker_marker = new(A.attacker_location)
		attacker_marker.name = "Attacker: [A.attacker_name]"

	if(A.location || A.attacker_location)
		to_chat(src, span_adminnotice("OVERWATCH: Markers placed for selected combat event on [ckey]."))
		to_chat(src, span_notice("[A.get_summary()]"))
		to_chat(src, span_notice("Markers will disappear in 30 seconds."))
		message_admins("[key_name_admin(src)] used OVERWATCH event visualization for [ckey] (event #[event_index]).")
	else
		to_chat(src, span_warning("Location data not available for this attack."))
