// In exchange for martial skills beyond ranged, they can now set traps, too.
/datum/advclass/mamluk/zephyr
	name = "zephyr"
	tutorial = "You are a professional soldier of the realm, specializing in ranged implements. You sport a keen eye, looking for your enemies weaknesses."
	//allowed_maps = list("Desert Town")
	outfit = /datum/outfit/job/roguetown/mamluk/zephyr

	category_tags = list(CTAG_MENATARMS)
	//Garrison ranged/speed class. Time to go wild
	subclass_stats = list(
		STATKEY_SPD = 2,// seems kinda lame but remember guardsman bonus!!
		STATKEY_PER = 2,
		STATKEY_WIL = 1,
		traits_applied = list(TRAIT_MEDIUMARMOR))

	subclass_skills = list(
		/datum/skill/combat/crossbows = SKILL_LEVEL_MASTER,
		/datum/skill/combat/bows = SKILL_LEVEL_MASTER,
		/datum/skill/combat/slings = SKILL_LEVEL_MASTER,//Your entire point is ranged.
		/datum/skill/combat/wrestling = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/knives = SKILL_LEVEL_EXPERT,//You get a knife, just in case.
		/datum/skill/combat/maces = SKILL_LEVEL_JOURNEYMAN,//And can double in maces and swords.
		/datum/skill/combat/swords = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/whipsflails = SKILL_LEVEL_JOURNEYMAN, //slave patrol!
		/datum/skill/misc/climbing = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/sneaking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/riding = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/tracking = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/traps = SKILL_LEVEL_APPRENTICE,
	)
	extra_context = "Chooses between Light Armor (Dodge Expert) & Medium Armor. Additionally, this subclass can set traps."

/datum/outfit/job/roguetown/mamluk/zephyr/pre_equip(mob/living/carbon/human/H)
	..()
	neck = /obj/item/clothing/neck/roguetown/chaincoif
	pants = /obj/item/clothing/under/roguetown/splintlegs
	wrists = /obj/item/clothing/wrists/roguetown/splintarms
	gloves = /obj/item/clothing/gloves/roguetown/fingerless_leather
	armor = /obj/item/clothing/suit/roguetown/armor/chainmail/mamaluke
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson
	head = /obj/item/clothing/head/roguetown/helmet/mamalukehelm

	H.adjust_blindness(-3)
	if(H.mind)
		var/weapons = list("Crossbow","Bow","Sling")
		var/weapon_choice = input(H, "Choose your weapon.", "TAKE UP ARMS") as anything in weapons
		H.set_blindness(0)
		switch(weapon_choice)
			if("Crossbow")
				beltr = /obj/item/quiver/bolts
				r_hand = /obj/item/gun/ballistic/revolver/grenadelauncher/crossbow
			if("Bow") // They can head down to the armory to sideshift into one of the other bows.
				beltr = /obj/item/quiver/arrows
				r_hand = /obj/item/gun/ballistic/revolver/grenadelauncher/bow/recurve
			if("Sling")
				beltr = /obj/item/quiver/sling/iron
				r_hand = /obj/item/gun/ballistic/revolver/grenadelauncher/sling // Both are belt slots and it's not worth setting where the cugel goes for everyone else, sad.
				
		var/weapons2 = list("Scimitar","Whip","Club")
		var/weapon_choice2 = input(H, "Choose your sidearm.", "TAKE UP ARMS") as anything in weapons2
		switch(weapon_choice2)
			if("Scimitar")
				beltl = /obj/item/rogueweapon/scabbard/sword
				l_hand = /obj/item/rogueweapon/sword/saber/iron
			if("Whip") // They can head down to the armory to sideshift into one of the other bows.
				beltl = /obj/item/rogueweapon/whip
			if("Club")
				beltl = /obj/item/rogueweapon/mace/cudgel
		backpack_contents = list(
			/obj/item/rogueweapon/huntingknife/idagger/steel/special = 1,
			/obj/item/rope/chain = 1,
			/obj/item/storage/keyring/guardcastle = 1,
			/obj/item/rogueweapon/scabbard/sheath = 1,
			/obj/item/reagent_containers/glass/bottle/rogue/healthpot = 1,
			)
		H.verbs |= /mob/proc/haltyell
		//Skirmishers get funny spells. Wowzers.
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/targeted/skirmisher_trap)

//Skirmisher's tripwire. Just Pioneer's with edits.
//As with Pioneer, it has exploits. I hate this so much.
//This does not make use of the sapper check. Just shovels.
// /obj/effect/proc_holder/spell/targeted/skirmisher_trap
// 	name = "Set Trap (Delayed)"
// 	desc = "After 8 seconds, a trap arms beneath your feet. Wardens and MAAs are immune to setting them off."
// 	overlay_state = "trap2"//Temp.
// 	invocations = list("A rod of iron...")
// 	range = 0
// 	releasedrain = 0
// 	recharge_time = 50 SECONDS
// 	max_targets = 0
// 	cast_without_targets = TRUE
// 	antimagic_allowed = TRUE
// 	associated_skill = /datum/skill/craft/traps
// 	invocation_type = "whisper"
// 	miracle = FALSE
// 	req_items = list(/obj/item/rogueweapon/shovel)
// 	var/setup_delay = 8 SECONDS
// 	var/pending = FALSE
// 	var/trap_path = /obj/structure/trap/bogtrap/bomb


//Do this if it turns out to be absurd.
//Having skirmishers able to alarm areas makes sense.
//They're not offensive traps for the most part. Unlike poison gas and explosives.
/*
	if(_is_town_area(T))//Inverse. Find a good spot, buddy.
		to_chat(user, span_warning("I cannot set a trap here; the ground is too soft."))
		revert_cast()
		return FALSE
*/

	// for(var/obj/structure/fluff/traveltile/TT in range(1, T))
	// 	to_chat(user, span_warning("Should find better place to set up the trap."))
	// 	revert_cast()
	// 	return FALSE

//Rous for silly traps. Will it be useful? Probably not. Knockdown will, though.
//Flare trap is effectively a global alarm. Same as the church bell.
//Now you can alarm the keep's rooftop on lowpop and such.
	// var/list/trap_choices = list(
	// 	"Rous"			= /obj/structure/trap/bogtrap/rous,
	// 	"Flare"			= /obj/structure/trap/bogtrap/flare_trap,
	// )

	// var/choice = input(user, "Select the trap type to rig:", "Trap") as null|anything in trap_choices
	// if(!choice)
	// 	revert_cast()
	// 	return FALSE

	// var/trap_path = trap_choices[choice]

	// pending = TRUE

	// user.visible_message(
	// 	span_notice("[user] kneels, rigging something beneath their feet."),
	// 	span_notice("I begin setting a [choice] trap.")
	// )
	// playsound(user, 'sound/misc/clockloop.ogg', 50, TRUE)

	// if(!do_after(user, setup_delay, target = T))
	// 	pending = FALSE
	// 	to_chat(user, span_warning("I stop setting the trap."))
	// 	revert_cast()
	// 	return FALSE

	// for(var/obj/structure/fluff/traveltile/TT in range(1, T))
	// 	pending = FALSE
	// 	to_chat(user, span_warning("Should find better place to set up the trap."))
	// 	revert_cast()
	// 	return FALSE

	// _clear_existing_trap(T)
	// _spawn_trap(T, trap_path)

	// user.visible_message(
	// 	span_warning("A hidden mechanism clicks into place under [user]!"),
	// 	span_notice("The [choice] trap arms beneath my feet.")
	// )
	// playsound(T, 'sound/misc/chains.ogg', 50, TRUE)

	// message_admins("[user.real_name]([key_name(user)]) has planted a trap, [ADMIN_JMP(user)]")
	// log_admin("[user.real_name]([key_name(user)]) has planted a trap")

	// pending = FALSE
	// return TRUE
