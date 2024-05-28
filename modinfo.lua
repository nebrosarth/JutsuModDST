name = "Jutsu Mod"
description = "Become a Shinobi and Master all Jutsu!"
author = "Aquaterion"
version = "v1.4.4"

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
                        {description = "English", data = "english"},
						{description = "简体中文", data = "chinese"},	--simplified chinese
					},

		default = "english",
	
	},
    
}

server_filter_tags = {"Naruto", "Chakra", "Jutsu", "Ninja"}