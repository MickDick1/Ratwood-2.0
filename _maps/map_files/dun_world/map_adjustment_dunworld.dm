/*
			< ATTENTION >
	If you need to add more map_adjustment, check 'map_adjustment_include.dm'
	These 'map_adjustment.dm' files shouldn't be included in 'dme'
*/

/datum/map_adjustment/template/dunworld
	map_file_name = "dun_world.dmm"
	realm_name = "Rotwood Vale"
	blacklist = list(//I had wanted the map variable in the roles themselves to bar them from non-desert maps but it still shows up in the Latejoin menu so I'm doing this just to keep it clear)
		/datum/job/roguetown/sultan,
		/datum/job/roguetown/cataphract,
		/datum/job/roguetown/vizier,

		/datum/job/roguetown/headslave,
		/datum/job/roguetown/sheikh,

		/datum/job/roguetown/janissary,
		/datum/job/roguetown/janissarysergeant,
		/datum/job/roguetown/azeb,
		/datum/job/roguetown/azebagha,
		/datum/job/roguetown/slavemaster,
		
		/datum/job/roguetown/slave,
		/datum/job/roguetown/dtprince,
		/datum/job/roguetown/dtshophand,
		
		/datum/job/roguetown/adventurer/courtslave,
		
		/datum/job/roguetown/vanguard,
		/datum/job/roguetown/guardsman,
		/datum/job/roguetown/rookie)
	slot_adjust = list(
		/datum/job/roguetown/warden = 6,
	)
	title_adjust = list(
	)
	tutorial_adjust = list(
	)
	species_adjust = list()
	sexes_adjust = list()

	//Threat regions is used for displaying specific regions on notice boards
	threat_regions = list(
		THREAT_REGION_AZURE_BASIN,
		THREAT_REGION_AZURE_GROVE,
		THREAT_REGION_TERRORBOG,
		THREAT_REGION_AZUREAN_COAST,
		THREAT_REGION_MOUNT_DECAP
	)
