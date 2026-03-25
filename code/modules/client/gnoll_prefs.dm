/datum/gnoll_prefs
	var/gnoll_name = ""
	var/gnoll_pronouns = HE_HIM
	var/pelt_type = "firepelt"
	var/list/genitals = list(
		"penis" = FALSE,
		"vagina" = FALSE,
		"breasts" = FALSE
	)

/datum/gnoll_prefs/New()
	. = ..()
	if(!gnoll_name)
		gnoll_name = "[pick(GLOB.wolf_prefixes)] [pick(GLOB.wolf_suffixes)]"

/datum/gnoll_prefs/proc/gnoll_show_ui(mob/user)
	if(!user.client)
		return

	var/list/dat = list()
	dat += "<html><head><title>Gnoll Customization</title></head><body>"
	dat += "<center><h2>Gnoll Customization</h2></center><br>"

	// Name section
	dat += "<b>Name:</b> [gnoll_name] "
	dat += "<a href='?_src_=gnoll_prefs;action=set_name'>Set Custom Name</a> | "
	dat += "<a href='?_src_=gnoll_prefs;action=random_name'>Random Name</a><br><br>"

	// Pronouns section
	dat += "<b>Pronouns:</b> "
	var/list/pronoun_options = list(HE_HIM, SHE_HER, THEY_THEM, IT_ITS)
	for(var/pronoun in pronoun_options)
		if(gnoll_pronouns == pronoun)
			dat += "<b>[pronoun]</b> "
		else
			dat += "<a href='?_src_=gnoll_prefs;action=set_pronouns;pronouns=[pronoun]'>[pronoun]</a> "
	dat += "<br><br>"

	// Pelt type section
	dat += "<b>Pelt Type:</b> "
	var/list/pelt_options = list("firepelt", "rotpelt", "whitepelt", "bloodpelt", "nightpelt", "darkpelt")
	for(var/pelt in pelt_options)
		if(pelt_type == pelt)
			dat += "<b>[pelt]</b> "
		else
			dat += "<a href='?_src_=gnoll_prefs;action=set_pelt;pelt=[pelt]'>[pelt]</a> "
	dat += "<br><br>"

	// Genitals section
	dat += "<b>Genitals:</b><br>"
	var/list/genital_types = list("penis", "vagina", "breasts")
	for(var/genital in genital_types)
		var/status = genitals[genital] ? "Yes" : "No"
		var/toggle_action = genitals[genital] ? "disable" : "enable"
		dat += "&nbsp;&nbsp;[genital]: [status] "
		dat += "<a href='?_src_=gnoll_prefs;action=toggle_genital;genital=[genital];toggle=[toggle_action]'>[toggle_action == "enable" ? "Enable" : "Disable"]</a><br>"
	dat += "<br>"

	dat += "<center><a href='?_src_=gnoll_prefs;action=close'>Close</a></center>"
	dat += "</body></html>"

	var/datum/browser/popup = new(user, "gnoll_prefs", "Gnoll Customization", 500, 600)
	popup.set_content(dat.Join())
	popup.open()

/datum/gnoll_prefs/proc/gnoll_process_link(mob/user, list/href_list)
	if(!user || !user.client)
		return

	var/action = href_list["action"]
	switch(action)
		if("set_name")
			var/new_name = input(user, "Enter a custom name for your gnoll:", "Gnoll Name", gnoll_name) as text|null
			if(new_name)
				gnoll_name = sanitize_name(new_name)
				gnoll_show_ui(user)

		if("random_name")
			gnoll_name = "[pick(GLOB.wolf_prefixes)] [pick(GLOB.wolf_suffixes)]"
			gnoll_show_ui(user)

		if("set_pronouns")
			var/new_pronouns = href_list["pronouns"]
			if(new_pronouns in list(HE_HIM, SHE_HER, THEY_THEM, IT_ITS))
				gnoll_pronouns = new_pronouns
				gnoll_show_ui(user)

		if("set_pelt")
			var/new_pelt = href_list["pelt"]
			var/list/valid_pelts = list("firepelt", "rotpelt", "whitepelt", "bloodpelt", "nightpelt", "darkpelt")
			if(new_pelt in valid_pelts)
				pelt_type = new_pelt
				gnoll_show_ui(user)

		if("toggle_genital")
			var/genital = href_list["genital"]
			var/toggle = href_list["toggle"]
			if(genital in genitals)
				genitals[genital] = (toggle == "enable")
				gnoll_show_ui(user)

		if("close")
			user << browse(null, "window=gnoll_prefs")

	return TRUE
