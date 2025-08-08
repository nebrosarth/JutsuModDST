name = "Jutsu Mod"
description = "chakra and jutsu"
author = "nebrosarth"
version = "37"

forumthread = ""

api_version = 10

all_clients_require_mod = true

--dont_starve_compatible = false
--reign_of_giants_compatible = false
dst_compatible = true

icon_atlas = "modicon.xml"
icon = "modicon.tex"

configuration_options =
{
	{
		name = "language",
		label = "Language",
		options =	{
						{description = "Russian", data = "russian"},
						{description = "English", data = "english"},
						{description = "Chinese", data = "chinese"}
					},

		default = "english",
	
	},
    
}

server_filter_tags = {"Naruto", "Chakra", "Jutsu", "Ninja", "Deidara", "Madara", "Kusanagi", "Armor", "Kunai"}