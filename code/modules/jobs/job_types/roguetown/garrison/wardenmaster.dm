/datum/job/roguetown/wardenmaster
	title = "Master Warden"
	flag = BOGMASTER
	department_flag = GARRISON
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = ACCEPTED_RACES
	allowed_ages = list(AGE_MIDDLEAGED, AGE_OLD)
	tutorial = "You are the most experienced of the Crown's Soldiery, leading the Wardens in maintaining order and attending to threats and crimes below the court's attention. \
				See to those under your command and fill in the gaps knights leave in their wake. Obey the orders of your Marshal and the Crown."
	display_order = JDO_BOGMASTER
	whitelist_req = TRUE
	round_contrib_points = 3
	social_rank = SOCIAL_RANK_YEOMAN

	outfit = /datum/outfit/job/roguetown/wardenmaster
	advclass_cat_rolls = list(CTAG_BOGMASTER = 20)

	give_bank_account = 50
	min_pq = 6
	max_pq = null
	cmode_music = 'sound/music/combat_blackoak.ogg'
	job_traits = list(TRAIT_OUTDOORSMAN, TRAIT_STEELHEARTED, TRAIT_MEDIUMARMOR, TRAIT_WOODSMAN, TRAIT_SURVIVAL_EXPERT, TRAIT_FUSILIER)
	job_subclasses = list(
		/datum/advclass/wardenmaster/wardenmaster
	)

/datum/outfit/job/roguetown/wardenmaster
	job_bitflag = BITFLAG_GARRISON

//All skills/traits are on the loadouts. All are identical. Welcome to the stupid way we have to make sub-classes...
/datum/outfit/job/roguetown/wardenmaster
	head = /obj/item/clothing/head/roguetown/helmet/bascinet/antler
	neck = /obj/item/clothing/neck/roguetown/bevor
	cloak = /obj/item/clothing/cloak/darkcloak/bear/wardenmaster
	armor = /obj/item/clothing/suit/roguetown/armor/leather/studded/warden/upgraded
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy
	wrists = /obj/item/clothing/wrists/roguetown/bracers
	gloves = /obj/item/clothing/gloves/roguetown/plate/iron
	belt = /obj/item/storage/belt/rogue/leather
	pants = /obj/item/clothing/under/roguetown/chainlegs
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather/reinforced
	wrists = /obj/item/clothing/wrists/roguetown/bracers
	backr = /obj/item/storage/backpack/rogue/satchel
	beltl = /obj/item/rogueweapon/stoneaxe/woodcut/wardenpick
	id = /obj/item/scomstone/garrison

//Rare-ish anti-armor two hander sword. Kinda alternative of a bastard sword type. Could be cool.
/datum/advclass/wardenmaster/wardenmaster
	name = "Master Warden"
	tutorial = "You are a not just anybody but the Master Warden of the lowtown fortress. While you may have started as some peasant or mercenary, you have advanced through the ranks to that of someone who commands respect and wields it. Take up arms, WARDENMASTER!"
	outfit = /datum/outfit/job/roguetown/wardenmaster/wardenmaster

	category_tags = list(CTAG_BOGMASTER)
	subclass_stats = list(
		STATKEY_STR = 1,
		STATKEY_SPE = 1,
		STATKEY_INT = 1,
		STATKEY_PER = 1, 
		STATKEY_CON = 1, 
		STATKEY_WIL = 1,
	)
	subclass_skills = list(
		/datum/skill/combat/polearms = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/swords = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/axes = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/whipsflails = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/maces = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/shields = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/crossbows = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/firearms = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/bows = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/wrestling = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/tanning = SKILL_LEVEL_APPRENTICE,
		/datum/skill/labor/butchering = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/crafting = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/swimming = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/sneaking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,	// We are basically identical to a regular MAA, except having better athletics to help us manage our order usage better
		/datum/skill/misc/riding = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/tracking = SKILL_LEVEL_EXPERT,	//Decent tracking akin to Skirmisher.
	)

/datum/outfit/job/roguetown/wardenmaster/wardenmaster/pre_equip(mob/living/carbon/human/H)
	..()
	if(H.mind)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/order/movemovemove)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/order/takeaim)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/order/onfeet)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/order/hold)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/order/focustarget)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/self/convertrole/vanguard)
	H.verbs |= list(/mob/living/carbon/human/proc/request_outlaw, /mob/proc/haltyell, /mob/living/carbon/human/mind/proc/setorders)
	backpack_contents = list(
		/obj/item/rogueweapon/huntingknife/idagger/steel/special = 1,
		/obj/item/rope/chain = 1,
		/obj/item/storage/keyring/guardsergeant = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1,
		/obj/item/reagent_containers/glass/bottle/rogue/healthpot = 1,
		/obj/item/flashlight/flare/torch/lantern = 1,
		/obj/item/signal_horn = 1
		)
	H.adjust_blindness(-3)
	if(H.mind)
		var/weapons = list("Greataxe","Javelins & Shield","Blackhorn Longbow","Arquebus")	//competent at both sides of wardenry so it's more a matter of what weapon you start with
		var/weapon_choice = input(H, "Choose your weapon.", "TAKE UP ARMS") as anything in weapons
		H.set_blindness(0)
		switch(weapon_choice)//feel it'd be nice to have a sword version for a real Jeor Mormont?
			if("Greataxe")			
				backl = /obj/item/rogueweapon/scabbard/gwstrap
				l_hand = /obj/item/rogueweapon/greataxe/steel
			if("Javelins & Shield")
				beltr = /obj/item/quiver/javelin/steel
				backl = /obj/item/rogueweapon/shield/tower/
			if("Blackhorn Longbow")
				beltr = /obj/item/quiver/arrows
				backl = /obj/item/gun/ballistic/revolver/grenadelauncher/bow/longbow/warden
			if("Arquebus")//okay I can remove this later but I think it would be... just... so based
				r_hand = /obj/item/gun/ballistic/firearm/arquebus
				l_hand = /obj/item/powderflask
				beltr = /obj/item/quiver/bullet/lead

/obj/effect/proc_holder/spell/self/convertrole/vanguard
	name = "Recruit Vanguard"
	new_role = "Vanguard"
	overlay_state = "recruit_guard"
	recruitment_faction = "Vanguard"
	recruitment_message = "Serve the vanguard, %RECRUIT!"
	accept_message = "FOR THE CROWN!"
	refuse_message = "I refuse."
