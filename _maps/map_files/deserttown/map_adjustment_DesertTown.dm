/*
			< ATTENTION >
	If you need to add more map_adjustment, check 'map_adjustment_include.dm'
	These 'map_adjustment.dm' files shouldn't be included in 'dme'
*/

/datum/map_adjustment/template/deserttown
	map_file_name = "deserttown.dmm"
	realm_name = "Al-Ashur"
	slot_adjust = list(
		/datum/job/roguetown/mercenary = 7, //haha fuck you one less slot!!
	// 	/datum/job/roguetown/adventurer = 69
	)
	title_adjust = list(
		/datum/job/roguetown/marshal = list(display_title = "Mayor"),
		/datum/job/roguetown/priest =  list(display_title = "High Priest", f_title = "High Priestess")
	)
	tutorial_adjust = list(
		/datum/job/roguetown/marshal = "CHANGE THIS LATER. Manage the town outside of the palace. Hang out in the mayor building.."
	)
	/// Jobs that this map won't use
	blacklist = list(
		
		// /datum/job/roguetown/adventurer//Adventurers (Could rename which are 'foreigners but who cares)'
		// /datum/job/roguetown/wretch,
		// /datum/job/roguetown/bandit,
		// /datum/job/roguetown/pilgrim, //well since they're foreigners... no need to change...
		// /datum/job/roguetown/trader,
		// /datum/job/roguetown/assassin,

		/datum/job/roguetown/lord,// sultan
		/datum/job/roguetown/knight,// cataphract
		/datum/job/roguetown/hand,// vizier
		// /datum/job/roguetown/suitor,
		// /datum/job/roguetown/steward,
		// /datum/job/roguetown/consort,
		// /datum/job/roguetown/captain,
		// /datum/job/roguetown/bailiff,

		//church. Fine as is

		/datum/job/roguetown/butler,// headslave
		/datum/job/roguetown/councillor,// sheikh
		/datum/job/roguetown/magician,// palace magician
		/datum/job/roguetown/jester, //are jesters really a desert thing? Maybe ought to push people into playing slaves instead..?
		// /datum/job/roguetown/physician,

		/datum/job/roguetown/manorguard,//  mamaluk
		/datum/job/roguetown/guardsman,//  mamaluk
		/datum/job/roguetown/bogguardsman,//  jannissary
		/datum/job/roguetown/dungeoneer,// Slavemaster
		// /datum/job/roguetown/sergeant,
		// /datum/job/roguetown/squire,
		// /datum/job/roguetown/veteran,

		//trader (probably fine to keep as it is)

		/datum/job/roguetown/crier, //would be fun to integrate in with the arena? Reimplement when building is added
		// /datum/job/roguetown/archivist,
		// /datum/job/roguetown/barkeep,
		// /datum/job/roguetown/guildmaster,
		// /datum/job/roguetown/guildsman,
		// /datum/job/roguetown/merchant,
		// /datum/job/roguetown/niteman,
		// /datum/job/roguetown/tailor,
		// /datum/job/roguetown/elder,
		
		/datum/job/roguetown/villager,
		// /datum/job/roguetown/farmer,
		// /datum/job/roguetown/prisonerb,
		// /datum/job/roguetown/prisonerr,
		// /datum/job/roguetown/hostage,
		// /datum/job/roguetown/nightmaiden, // Current ones are probably fine?
		// /datum/job/roguetown/cook,
		/datum/job/roguetown/knavewench, //maybe after expanding the tavern for it
		// /datum/job/roguetown/lunatic,


		//inquisition. Fine as is

		//mercenaries. Fine as is
		
		/datum/job/roguetown/servant,//slave
		// /datum/job/roguetown/apothecary,
		// /datum/job/roguetown/churchling,
		// /datum/job/roguetown/clerk,
		// /datum/job/roguetown/wapprentice,
		// /datum/job/roguetown/orphan,
		/datum/job/roguetown/prince,//dtprince
		/datum/job/roguetown/shophand,//dtshophand
		
	)

//list to blacklist for other maps (update as new replacements are added)
		// /datum/job/roguetown/dtvillager,

		// /datum/job/roguetown/sultan,
		// /datum/job/roguetown/cataracht,
		// /datum/job/roguetown/vizier,

		// /datum/job/roguetown/headslave,
		// /datum/job/roguetown/sheikh,
		// /datum/job/roguetown/magician,

		// /datum/job/roguetown/mamluk,
		// /datum/job/roguetown/janissary,
		// /datum/job/roguetown/JanissaryAgha,
		// /datum/job/roguetown/slavemaster,
		
		// /datum/job/roguetown/dtslave,
		// /datum/job/roguetown/dtprince,
		// /datum/job/roguetown/dtshophand,
