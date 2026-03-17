/datum/job/roguetown/mamluksergeant
	title = "Mamluk Sergeant"// Googling terms Naqib seems to mean something like Captain and has a nice ring to it?
	flag = MAMLUKSERGEANT
	department_flag = GARRISON
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = ACCEPTED_RACES
	allowed_ages = list(AGE_ADULT, AGE_MIDDLEAGED, AGE_OLD)
	tutorial = "You are the most experienced of the SULTAN's Soldiery, leading the MAMLUK in maintaining order and attending to threats and crimes below the PALACE's attention. \
				See to those under your command and fill in the gaps CATAPHRACTS leave in their wake. Obey the orders of your Marshal and the SULTAN."
	display_order = JDO_SERGEANT
	whitelist_req = TRUE
	round_contrib_points = 3
	social_rank = SOCIAL_RANK_YEOMAN

	outfit = /datum/outfit/job/roguetown/mamluksergeant
	advclass_cat_rolls = list(CTAG_MAMLUKSERGEANT = 20)

	give_bank_account = 50
	min_pq = 6
	max_pq = null
	cmode_music = 'sound/music/combat_desert1.ogg'
	job_traits = list(TRAIT_GUARDSMAN, TRAIT_STEELHEARTED, TRAIT_MEDIUMARMOR)
	job_subclasses = list(
		/datum/advclass/mamluksergeant/mamluksergeant
	)

/datum/outfit/job/roguetown/mamluksergeant
	job_bitflag = BITFLAG_GARRISON

/datum/job/roguetown/mamluksergeant/after_spawn(mob/living/L, mob/M, latejoin = TRUE)
	. = ..()
	if(ishuman(L))
		addtimer(CALLBACK(L, TYPE_PROC_REF(/mob, cloak_and_title_setup)), 50)

//All skills/traits are on the loadouts. All are identical. Welcome to the stupid way we have to make sub-classes...
/datum/outfit/job/roguetown/mamluksergeant
	armor = /obj/item/clothing/suit/roguetown/armor/chainmail/mamaluke
	pants = /obj/item/clothing/under/roguetown/chainlegs
	neck = /obj/item/clothing/neck/roguetown/bevor
	shoes = /obj/item/clothing/shoes/roguetown/shalal/reinforced
	belt = /obj/item/storage/belt/rogue/leather
	wrists = /obj/item/clothing/wrists/roguetown/bracers
	gloves = /obj/item/clothing/gloves/roguetown/plate/iron
	backr = /obj/item/storage/backpack/rogue/satchel
	head = /obj/item/clothing/head/roguetown/helmet/mamalukehelm
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy
	id = /obj/item/scomstone/garrison

//Rare-ish anti-armor two hander sword. Kinda alternative of a bastard sword type. Could be cool.
/datum/advclass/mamluksergeant/mamluksergeant
	name = "Sergeant-at-Arms"
	tutorial = "You are a not just anybody but the mamluksergeant-at-Arms of the Duchy's garrison. While you may have started as some peasant or mercenary, you have advanced through the ranks to that of someone who commands respect and wields it. Take up arms, mamluksergeant!"
	outfit = /datum/outfit/job/roguetown/mamluksergeant/mamluksergeant

	category_tags = list(CTAG_MAMLUKSERGEANT)
	subclass_stats = list(
		STATKEY_STR = 2,
		STATKEY_INT = 1,
		STATKEY_CON = 1,
		STATKEY_PER = 1, //Gets bow-skills, so give a SMALL tad of perception to aid in bow draw.
		STATKEY_WIL = 1,
	)
	subclass_skills = list(
		/datum/skill/combat/polearms = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/swords = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/axes = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/whipsflails = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/maces = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/shields = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/crossbows = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/bows = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/sneaking = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_MASTER,	// We are basically identical to a regular MAA, except having better athletics to help us manage our order usage better
		/datum/skill/misc/riding = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/tracking = SKILL_LEVEL_APPRENTICE,	//Decent tracking akin to Skirmisher.
	)

/datum/outfit/job/roguetown/mamluksergeant/mamluksergeant/pre_equip(mob/living/carbon/human/H)
	..()
	if(H.mind)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/order/movemovemove)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/order/takeaim)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/order/onfeet)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/order/hold)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/order/focustarget)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/self/convertrole/guard) // We'll just use Watchmen as sorta conscripts yeag?
	H.verbs |= list(/mob/living/carbon/human/proc/request_outlaw, /mob/proc/haltyell, /mob/living/carbon/human/mind/proc/setorders)
	backpack_contents = list(
		/obj/item/rogueweapon/huntingknife/idagger/steel/special = 1,
		/obj/item/rope/chain = 1,
		/obj/item/storage/keyring/guardsergeant = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1,
		/obj/item/reagent_containers/glass/bottle/rogue/healthpot = 1,
		)
	H.adjust_blindness(-3)
	if(H.mind)
		var/weapons = list("Rhomphaia","Whip & Shield","Glaive","Sabre & Crossbow")	//Bit more unique than footsman, you are a jack-of-all-trades + slightly more 'elite'.
		var/weapon_choice = input(H, "Choose your weapon.", "TAKE UP ARMS") as anything in weapons
		H.set_blindness(0)
		switch(weapon_choice)
			if("Rhomphaia")			//Rare-ish anti-armor two hander sword. Kinda alternative of a bastard sword type. Could be cool.
				backl = /obj/item/rogueweapon/scabbard/sword
				l_hand = /obj/item/rogueweapon/sword/long/rhomphaia
				beltr = /obj/item/rogueweapon/mace/cudgel
			if("Whip & Shield")	//Tower-shield, higher durability wood shield w/ more coverage. Plus a steel flail; maybe.. less broken that a steel mace?
				beltr = /obj/item/rogueweapon/flail/sflail
				backl = /obj/item/rogueweapon/shield/tower
			if("Glaive")			//Halberd - basically exact same as MAA. It's a really valid build. Spear thrust + sword chop + bash.
				r_hand = /obj/item/rogueweapon/halberd/glaive
				backl = /obj/item/rogueweapon/scabbard/gwstrap
				beltr = /obj/item/rogueweapon/mace/cudgel
			if("Sabre & Crossbow")	//Versetile skirmisher class. Considered other swords but sabre felt best without being too strong. (This one gets no cudgel, no space.)
				beltr = /obj/item/quiver/bolts
				backl = /obj/item/gun/ballistic/revolver/grenadelauncher/crossbow
				r_hand = /obj/item/rogueweapon/sword/sabre
				l_hand = /obj/item/rogueweapon/scabbard/sword


