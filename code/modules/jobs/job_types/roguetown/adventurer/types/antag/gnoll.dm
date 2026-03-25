/datum/job/roguetown/gnoll
	title = "Gnoll"
	flag = GNOLL
	antag_job = TRUE // whoever wrote this, I'm- gghrhhah!
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	allowed_races = RACES_NO_CONSTRUCT
	tutorial = "You have proven yourself worthy to Graggar, and he's granted you his blessing most divine. Now you hunt for worthy opponents, seeking out those strong enough to make you bleed."
	outfit = null
	outfit_female = null
	display_order = JDO_GNOLL
	show_in_credits = TRUE
	min_pq = 30 //Same as wretches for now
	max_pq = null
	allowed_patrons = list(/datum/patron/inhumen/graggar)

	obsfuscated_job = TRUE

	advclass_cat_rolls = list(CTAG_GNOLL = 20)
	PQ_boost_divider = 10
	round_contrib_points = 2

	announce_latejoin = FALSE
	wanderer_examine = TRUE
	advjob_examine = TRUE
	always_show_on_latechoices = TRUE
	job_reopens_slots_on_death = FALSE
	same_job_respawn_delay = 1 MINUTES
	virtue_restrictions = list(/datum/virtue/utility/noble) //Are you for real?
	job_subclasses = list(
		/datum/advclass/gnoll/berserker,
		/datum/advclass/gnoll/knight,
		/datum/advclass/gnoll/templar,
		/datum/advclass/gnoll/shaman,
	)

/datum/job/roguetown/gnoll/after_spawn(mob/living/L, mob/M, latejoin = TRUE)
	..()
	if(L)
		var/mob/living/carbon/human/H = L
		// Assign wretch antagonist datum so wretches appear in antag list
		if(H.mind && !H.mind.has_antag_datum(/datum/antagonist/gnoll))
			var/datum/antagonist/new_antag = new /datum/antagonist/gnoll()
			H.mind.add_antag_datum(new_antag)
			H.verbs |= /mob/living/carbon/human/proc/gnoll_inspect_skin

/mob/living/carbon/human/proc/apply_gnoll_preferences()
	if(!client?.prefs?.gnoll_prefs)
		return

	var/datum/gnoll_prefs/prefs = client.prefs.gnoll_prefs

	if(prefs.gnoll_name)
		real_name = prefs.gnoll_name

	if(prefs.gnoll_pronouns)
		pronouns = prefs.gnoll_pronouns

	if(prefs.pelt_type)
		icon_state = prefs.pelt_type
		dna?.species?.custom_base_icon = prefs.pelt_type

	var/wants_penis = !!prefs.genitals["penis"]
	var/wants_vagina = !!prefs.genitals["vagina"]
	var/wants_breasts = !!prefs.genitals["breasts"]

	var/obj/item/organ/penis/penis = getorganslot(ORGAN_SLOT_PENIS)
	if(wants_penis)
		if(!penis)
			penis = new()
			penis.Insert(src, TRUE, FALSE)
		var/obj/item/organ/testicles/testicles = getorganslot(ORGAN_SLOT_TESTICLES)
		if(!testicles)
			testicles = new()
			testicles.Insert(src, TRUE, FALSE)
	else if(penis)
		penis.Remove(src)
		qdel(penis)
		var/obj/item/organ/testicles/testicles = getorganslot(ORGAN_SLOT_TESTICLES)
		if(testicles)
			testicles.Remove(src)
			qdel(testicles)

	var/obj/item/organ/vagina/vagina = getorganslot(ORGAN_SLOT_VAGINA)
	if(wants_vagina)
		if(!vagina)
			vagina = new()
			vagina.Insert(src, TRUE, FALSE)
	else if(vagina)
		vagina.Remove(src)
		qdel(vagina)

	var/obj/item/organ/breasts/breasts = getorganslot(ORGAN_SLOT_BREASTS)
	if(wants_breasts)
		if(!breasts)
			breasts = new()
			breasts.Insert(src, TRUE, FALSE)
	else if(breasts)
		breasts.Remove(src)
		qdel(breasts)

	update_body()

/datum/outfit/job/roguetown/gnoll/proc/don_pelt(mob/living/carbon/human/H)
	if(H.mind)
		H.apply_gnoll_preferences()
		H.set_blindness(0)
		H.regenerate_icons()
		H.AddSpell(new /obj/effect/proc_holder/spell/self/claws/gnoll)
		H.AddSpell(new /obj/effect/proc_holder/spell/self/howl/gnoll)
		H.AddComponent(/datum/component/gnoll_combat_tracker)

		var/obj/effect/proc_holder/spell/invoked/gnoll_sniff/F = new()
		var/obj/effect/proc_holder/spell/invoked/invisibility/gnoll/I = new()
		I.sniff_spell = F // Link them

		var/obj/effect/proc_holder/spell/invoked/abduct/S = new /obj/effect/proc_holder/spell/invoked/abduct()
		S.destination_turf = get_turf(H) // Set the anchor to where they spawn/don the outfit
		H.AddSpell(S)
		H.AddSpell(F)
		H.AddSpell(I)

		var/mode = SSgnoll_scaling.get_gnoll_scaling()
		if(mode == GNOLL_SCALING_DYNAMIC)
			to_chat(H, span_bignotice("I can expect to be joined by my pack this week. I should wait for them and group up."))
		else
			to_chat(H, span_bignotice("Isolated from my pack, I am likely a lone soul this week. I should especially avoid getting killed, and look for my pack next week."))
		to_chat(H, span_bignotice("Graggar is patient, and values good strategy. I mustn't be hasty, especially if my marks prove difficult to isolate.\n Perhaps there is merit in forging alliances, or setting up camp."))

/mob/living/carbon/human/proc/gnoll_inspect_skin()
	set name = "Inspect Pelt"
	set category = "Gnoll"
	set desc = "Examine your gnoll skin armor"
	if(!istype(skin_armor, /obj/item/clothing/suit/roguetown/armor/regenerating/skin/gnoll_armor))
		to_chat(src, span_warning("You don't have any gnoll skin armor to inspect!"))
		return
	var/obj/item/clothing/suit/roguetown/armor/regenerating/skin/gnoll_armor/GA = skin_armor
	GA.Topic(null, list("inspect" = "1"), src)
