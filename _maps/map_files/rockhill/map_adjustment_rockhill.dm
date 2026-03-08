/*
			< ATTENTION >
	If you need to add more map_adjustment, check 'map_adjustment_include.dm'
	These 'map_adjustment.dm' files shouldn't be included in 'dme'
*/

/datum/map_adjustment/template/rockhill
	map_file_name = "rockhill.dmm"
	realm_name = "Rockhill"
	blacklist = list(//I had wanted the map variable in the roles themselves to bar them from non-desert maps but it still shows up in the Latejoin menu so I'm doing this just to keep it clear)
		/datum/job/roguetown/dtvillager,

		/datum/job/roguetown/sultan,
		/datum/job/roguetown/cataphract,
		/datum/job/roguetown/vizier,

		/datum/job/roguetown/headslave,
		/datum/job/roguetown/sheikh,
		/datum/job/roguetown/dtmagician,

		/datum/job/roguetown/mamluk,
		/datum/job/roguetown/janissary,
		/datum/job/roguetown/JanissaryAgha,
		/datum/job/roguetown/slavemaster,
		
		/datum/job/roguetown/slave,
		/datum/job/roguetown/dtprince,
		/datum/job/roguetown/dtshophand,
		/datum/job/roguetown/dtvillager,
		/datum/job/roguetown/dtshophand,
		
		/datum/job/roguetown/adventurer/courtslave,)
	// slot_adjust = list(
	// 	/datum/job/roguetown/villager = 42,
	// // 	/datum/job/roguetown/adventurer = 69
	// )
	title_adjust = list(
		/datum/job/roguetown/physician = list(display_title = "Court Physician"),
		/datum/job/roguetown/niteman = list(display_title = "Nightmaster", f_title = "Nightmistress"),
		/datum/job/roguetown/nightmaiden = list(display_title = "Nightswain", f_title = "Nightmaiden"),
		// /datum/job/roguetown/bogguardsman = list(display_title = "Vanguard"),
	)
	tutorial_adjust = list(
		/datum/job/roguetown/physician = "You are a master physician, trusted by the Duke themself to administer expert care to the Royal family, the court, \
		its protectors and its subjects. While primarily a resident of the keep in the manors medical wing, you also have access \
		 to the local hightown clinic, where lesser licensed apothecaries ply their trade under your occasional passing tutelage.",
		/datum/job/roguetown/bogguardsman = "Typically a denizen of the sparsely populated mountains and swamps surrounding Rockhill, you volunteered up with the wardens\
				-a group of ranger types who keep a vigil over Lowtown and the untamed wilderness. \
				While typically under less supervision than the Men at Arms stationed in hightown, you will be called upon as members of the garrison by the Marshal or the Crown. \
				Serve their will as the first line of defence from threats beyond the borders of civilisation, hold the vanguard fortress, and try to survive another day."
		// /datum/job/roguetown/archivist = "CHANGE THIS!! - Teach people skills, whether DIRECTLY or by writing SKILLBOOKS. You and the Veteran next door teach people shit."
	)
	// species_adjust = list()
	// sexes_adjust = list()
	//Threat regions is used for displaying specific regions on notice boards
	threat_regions = list(
		THREAT_REGION_ROCKHILL_BASIN,
		THREAT_REGION_ROCKHILL_BOG_NORTH,
		THREAT_REGION_ROCKHILL_BOG_WEST,
		THREAT_REGION_ROCKHILL_BOG_SOUTH,
		THREAT_REGION_ROCKHILL_BOG_SUNKMIRE,
		THREAT_REGION_ROCKHILL_WOODS_NORTH,
		THREAT_REGION_ROCKHILL_WOODS_SOUTH
	)
