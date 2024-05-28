modimport("libs/env.lua")

use "data/init"

local chosenlanguage = GetModConfigData("language")

if chosenlanguage == "russian" then
	modimport "languages/russian.lua"
else
	if chosenlanguage == "english" then
		modimport "languages/english.lua"
	else
		modimport "languages/chinese.lua"
	end
end

_G = GLOBAL

PrefabFiles = 
{
 "jutsu",
 "jutsuprojectile",
 "jutsuspecial",
 "ninjatools",
 "ninjagear",
 "ninjageard",
 "headbandfog",
 "wall_mud",
 "jutsufx",
 "ninjaclone",
 "cutplant",
 "madara",
 "madara_none",
 "naruto",
 "deidara",
 "armor",
 
 "doshik",
 "cooked_doshik",
 "flavoring",
 "hot_flav",
 
 "gnome_grenade",
 "gnomenade_fx",
 "gnomeringfx",
 "gnome_print",
 "clay",
}

Assets = 
{
	Asset( "ATLAS", "images/inventoryimages/scroll.xml"),
	Asset( "ATLAS", "images/inventoryimages/flyingraijinkunai.xml"),
	Asset( "ATLAS", "images/inventoryimages/headband.xml"),
	Asset( "ATLAS", "images/inventoryimages/headban.xml"),
	Asset( "ATLAS", "images/inventoryimages/cutplant.xml"),
	Asset( "ATLAS", "images/inventoryimages/paper.xml"),
	Asset( "ANIM", "anim/chakra.zip"),
	Asset( "ANIM", "anim/chakrapenalty.zip"),
	Asset( "ANIM", "anim/wend.zip"),
	Asset( "ANIM", "anim/rinneganabigail.zip"),
	Asset( "ANIM", "anim/crow_build.zip"),
	Asset( "IMAGE", "images/saveslot_portraits/naruto.tex" ),
    Asset( "ATLAS", "images/saveslot_portraits/naruto.xml" ),

    Asset( "IMAGE", "images/selectscreen_portraits/naruto.tex" ),
    Asset( "ATLAS", "images/selectscreen_portraits/naruto.xml" ),
	
    Asset( "IMAGE", "images/selectscreen_portraits/naruto_silho.tex" ),
    Asset( "ATLAS", "images/selectscreen_portraits/naruto_silho.xml" ),

    Asset( "IMAGE", "bigportraits/naruto.tex" ),
    Asset( "ATLAS", "bigportraits/naruto.xml" ),
	
	Asset( "IMAGE", "images/map_icons/naruto.tex" ),
	Asset( "ATLAS", "images/map_icons/naruto.xml" ),
	
	Asset( "IMAGE", "images/avatars/avatar_naruto.tex" ),
    Asset( "ATLAS", "images/avatars/avatar_naruto.xml" ),
	
	Asset( "IMAGE", "images/avatars/avatar_ghost_naruto.tex" ),
    Asset( "ATLAS", "images/avatars/avatar_ghost_naruto.xml" ),
	
	Asset( "IMAGE", "images/saveslot_portraits/madara.tex" ),
    Asset( "ATLAS", "images/saveslot_portraits/madara.xml" ),

    Asset( "IMAGE", "images/selectscreen_portraits/madara.tex" ),
    Asset( "ATLAS", "images/selectscreen_portraits/madara.xml" ),
	
    Asset( "IMAGE", "images/selectscreen_portraits/madara_silho.tex" ),
    Asset( "ATLAS", "images/selectscreen_portraits/madara_silho.xml" ),

    Asset( "IMAGE", "bigportraits/madara.tex" ),
    Asset( "ATLAS", "bigportraits/madara.xml" ),
	
	Asset( "IMAGE", "images/map_icons/madara.tex" ),
	Asset( "ATLAS", "images/map_icons/madara.xml" ),
	
	Asset( "IMAGE", "images/avatars/avatar_madara.tex" ),
    Asset( "ATLAS", "images/avatars/avatar_madara.xml" ),
	
	Asset( "IMAGE", "images/avatars/avatar_ghost_madara.tex" ),
    Asset( "ATLAS", "images/avatars/avatar_ghost_madara.xml" ),
	
	Asset( "IMAGE", "images/avatars/self_inspect_madara.tex" ),
    Asset( "ATLAS", "images/avatars/self_inspect_madara.xml" ),
	
	Asset( "IMAGE", "images/names_madara.tex" ),
    Asset( "ATLAS", "images/names_madara.xml" ),
	
    Asset( "IMAGE", "bigportraits/madara_none.tex" ),
    Asset( "ATLAS", "bigportraits/madara_none.xml" ),
	
	
	Asset( "IMAGE", "images/saveslot_portraits/deidara.tex" ),
    Asset( "ATLAS", "images/saveslot_portraits/deidara.xml" ),

    Asset( "IMAGE", "bigportraits/deidara.tex" ),
    Asset( "ATLAS", "bigportraits/deidara.xml" ),
	
	Asset( "IMAGE", "images/map_icons/deidara.tex" ),
	Asset( "ATLAS", "images/map_icons/deidara.xml" ),
	
	Asset( "IMAGE", "images/avatars/avatar_deidara.tex" ),
    Asset( "ATLAS", "images/avatars/avatar_deidara.xml" ),
	
	Asset( "IMAGE", "images/avatars/avatar_ghost_deidara.tex" ),
    Asset( "ATLAS", "images/avatars/avatar_ghost_deidara.xml" ),
	
	Asset( "IMAGE", "images/inventoryimages/armor.tex" ),
    Asset( "ATLAS", "images/inventoryimages/armor.xml" ),
	
	
	
	Asset("SOUND", "sound/exp.fsb"),
    Asset("SOUNDPACKAGE", "sound/exp.fev"),
	
	Asset("SOUND", "sound/gnomenade.fsb"),
    Asset("SOUNDPACKAGE", "sound/gnomenade.fev"),
	
    Asset("IMAGE", "images/inventoryimages/gnome_grenade.tex"),
    Asset("ATLAS", "images/inventoryimages/gnome_grenade.xml"),
	
	Asset("IMAGE", "images/inventoryimages/clay.tex"),
    Asset("ATLAS", "images/inventoryimages/clay.xml"),
}

STRINGS.NAMES.GNOME_GRENADE = "C3"
STRINGS.RECIPE_DESC.GNOME_GRENADE = "Сделана из \n особой глины."
STRINGS.NAMES.CLAY = "Взрывная глина"
STRINGS.RECIPE_DESC.CLAY = "Смесь глины и чакры."
STRINGS.CHARACTERS.GENERIC.DESCRIBE.CLAY = "Смесь глины и чакры."

STRINGS.NAMES.MAKERAIN = TUNING.MAKERAIN.NAME
STRINGS.NAMES.RINNEREBIRTH = TUNING.RINNEREBIRTH.NAME
STRINGS.NAMES.ICEROCKDOME = TUNING.ICEROCKDOME.NAME
STRINGS.NAMES.RASENGAN = TUNING.RASENGAN.NAME
STRINGS.NAMES.FIRERASENGAN = TUNING.FIRERASENGAN.NAME
STRINGS.NAMES.INFINITEDREAM = TUNING.INFINITEDREAM.NAME
STRINGS.NAMES.STRENGTHOFA100 = TUNING.STRENGTHOFA100.NAME
STRINGS.NAMES.CREATIONREBIRTH = TUNING.CREATIONREBIRTH.NAME
STRINGS.NAMES.CREATIONREBIRTH100 = TUNING.CREATIONREBIRTH100.NAME
STRINGS.NAMES.FLYINGRAIJIN = TUNING.FLYINGRAIJIN.NAME
STRINGS.NAMES.MULTIMUDWALL = TUNING.MULTIMUDWALL.NAME
STRINGS.NAMES.WATERGUN = TUNING.WATERGUN.NAME
STRINGS.NAMES.EXPANSION = TUNING.EXPANSION.NAME
STRINGS.NAMES.SUPEREXPANSION = TUNING.SUPEREXPANSION.NAME
STRINGS.NAMES.DEEPFORESTEMERGENCE = TUNING.DEEPFORESTEMERGENCE.NAME
STRINGS.NAMES.BUBBLE = TUNING.BUBBLE.NAME
STRINGS.NAMES.SHADOWCLONE = TUNING.SHADOWCLONE.NAME

STRINGS.NAMES.FLYINGRAIJINKUNAI = TUNING.FLYINGRAIJINKUNAI.NAME
STRINGS.NAMES.RAIJINKUNAI = TUNING.RAIJINKUNAI.NAME
STRINGS.NAMES.HEADBANDBLACKMISSING = TUNING.HEADBANDBLACKMISSING.NAME
STRINGS.NAMES.HEADBANDBLUE = TUNING.HEADBANDBLUE.NAME
STRINGS.NAMES.ARMOR = TUNING.ARMOR.NAME
STRINGS.NAMES.HEADBANDFOG = TUNING.HEADBANDFOG.NAME
STRINGS.NAMES.KUSANAGI = TUNING.KUSANAGI.NAME

STRINGS.NAMES.WALL_MUD = TUNING.WALL_MUD.NAME
STRINGS.NAMES.CUTPLANT = TUNING.CUTPLANT.NAME
STRINGS.NAMES.PAPER = TUNING.PAPER.NAME

STRINGS.NAMES.NINJACLONE = TUNING.NINJACLONE.NAME

STRINGS.RECIPE_DESC.DOSHIK = "Всё гениальное просто."
STRINGS.RECIPE_DESC.FLAVORING = "Сделает еду вкуснее."
STRINGS.RECIPE_DESC.CON_FLAV = "Добавит остроты."

STRINGS.NAMES.DOSHIK = "Пшеничная лапша"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.DOSHIK = "Лапша быстрого приготовления."

STRINGS.NAMES.FLAVORING = "Приправа"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.FLAVORING = "Приправа для рамена"

STRINGS.NAMES.CON_FLAV = "Концентрат"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.CON_FLAV = "Технически, это яд."

STRINGS.NAMES.HOT_FLAV = "Острая приправа"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.HOT_FLAV = "Приправа для рамена."

STRINGS.NAMES.COOKED_DOSHIK = "Приготовленный рамен"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.COOKED_DOSHIK = "Ням-ням."

STRINGS.NAMES.COOKED_DOSHIK_PLUS = "Приготовленный рамен с приправой"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.COOKED_DOSHIK_PLUS = "Ням-ням."

STRINGS.NAMES.COOKED_DOSHIK_SOUSAGES = "Приготовленный рамен с сосиской"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.COOKED_DOSHIK_SOUSAGES = "Ням-ням."

STRINGS.NAMES.COOKED_DOSHIK_SOUSAGES_PLUS = "Приготовленный рамен с приправой и сосиской"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.COOKED_DOSHIK_SOUSAGES_PLUS = "Ням-ням."

STRINGS.NAMES.COOKED_DOSHIK_HOT = "Приготовленный острый рамен"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.COOKED_DOSHIK_HOT = "Жгучий."

STRINGS.NAMES.COOKED_DOSHIK_SOUSAGES_HOT = "Приготовленный острый рамен с сосиской"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.COOKED_DOSHIK_SOUSAGES_HOT = "Ням-ням."
--STRINGS.NAMES.

STRINGS.RECIPE_DESC.MAKERAIN = TUNING.MAKERAIN.RECIPE
STRINGS.RECIPE_DESC.RINNEREBIRTH = TUNING.RINNEREBIRTH.RECIPE
STRINGS.RECIPE_DESC.ICEROCKDOME = TUNING.ICEROCKDOME.RECIPE
STRINGS.RECIPE_DESC.RASENGAN = TUNING.RASENGAN.RECIPE
STRINGS.RECIPE_DESC.FIRERASENGAN = TUNING.FIRERASENGAN.RECIPE
STRINGS.RECIPE_DESC.INFINITEDREAM = TUNING.INFINITEDREAM.RECIPE
STRINGS.RECIPE_DESC.STRENGTHOFA100 = TUNING.STRENGTHOFA100.RECIPE
STRINGS.RECIPE_DESC.CREATIONREBIRTH = TUNING.CREATIONREBIRTH.RECIPE
STRINGS.RECIPE_DESC.CREATIONREBIRTH100 = TUNING.CREATIONREBIRTH100.RECIPE
STRINGS.RECIPE_DESC.FLYINGRAIJIN = TUNING.FLYINGRAIJIN.RECIPE
STRINGS.RECIPE_DESC.MULTIMUDWALL = TUNING.MULTIMUDWALL.RECIPE
STRINGS.RECIPE_DESC.WATERGUN = TUNING.WATERGUN.RECIPE
STRINGS.RECIPE_DESC.EXPANSION = TUNING.EXPANSION.RECIPE
STRINGS.RECIPE_DESC.SUPEREXPANSION = TUNING.SUPEREXPANSION.RECIPE
STRINGS.RECIPE_DESC.DEEPFORESTEMERGENCE = TUNING.DEEPFORESTEMERGENCE.RECIPE
STRINGS.RECIPE_DESC.BUBBLE = TUNING.BUBBLE.RECIPE
STRINGS.RECIPE_DESC.SHADOWCLONE = TUNING.SHADOWCLONE.RECIPE

STRINGS.RECIPE_DESC.FLYINGRAIJINKUNAI = TUNING.FLYINGRAIJINKUNAI.RECIPE
STRINGS.RECIPE_DESC.HEADBANDFOG = TUNING.HEADBANDFOG.RECIPE
STRINGS.RECIPE_DESC.HEADBANDBLACKMISSING = TUNING.HEADBANDBLACKMISSING.RECIPE
STRINGS.RECIPE_DESC.HEADBANDBLUE = TUNING.HEADBANDBLUE.RECIPE
STRINGS.RECIPE_DESC.ARMOR = TUNING.ARMOR.RECIPE
STRINGS.RECIPE_DESC.KUSANAGI = TUNING.KUSANAGI.RECIPE

STRINGS.RECIPE_DESC.PAPER = TUNING.PAPER.RECIPE

--STRINGS.RECIPE_DESC.

STRINGS.CHARACTERS.GENERIC.DESCRIBE.MAKERAIN = TUNING.MAKERAIN.DESCRIBE
STRINGS.CHARACTERS.GENERIC.DESCRIBE.RINNEREBIRTH = TUNING.RINNEREBIRTH.DESCRIBE
STRINGS.CHARACTERS.GENERIC.DESCRIBE.ICEROCKDOME = TUNING.ICEROCKDOME.DESCRIBE
STRINGS.CHARACTERS.GENERIC.DESCRIBE.RASENGAN = TUNING.RASENGAN.DESCRIBE
STRINGS.CHARACTERS.GENERIC.DESCRIBE.FIRERASENGAN = TUNING.FIRERASENGAN.DESCRIBE
STRINGS.CHARACTERS.GENERIC.DESCRIBE.INFINITEDREAM = TUNING.INFINITEDREAM.DESCRIBE
STRINGS.CHARACTERS.GENERIC.DESCRIBE.STRENGTHOFA100 = TUNING.STRENGTHOFA100.DESCRIBE
STRINGS.CHARACTERS.GENERIC.DESCRIBE.CREATIONREBIRTH = TUNING.CREATIONREBIRTH.DESCRIBE
STRINGS.CHARACTERS.GENERIC.DESCRIBE.CREATIONREBIRTH100 = TUNING.CREATIONREBIRTH100.DESCRIBE
STRINGS.CHARACTERS.GENERIC.DESCRIBE.FLYINGRAIJIN = TUNING.FLYINGRAIJIN.DESCRIBE
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MULTIMUDWALL = TUNING.MULTIMUDWALL.DESCRIBE
STRINGS.CHARACTERS.GENERIC.DESCRIBE.WATERGUN = TUNING.WATERGUN.DESCRIBE
STRINGS.CHARACTERS.GENERIC.DESCRIBE.EXPANSION = TUNING.EXPANSION.DESCRIBE
STRINGS.CHARACTERS.GENERIC.DESCRIBE.SUPEREXPANSION = TUNING.SUPEREXPANSION.DESCRIBE
STRINGS.CHARACTERS.GENERIC.DESCRIBE.DEEPFORESTEMERGENCE = TUNING.DEEPFORESTEMERGENCE.DESCRIBE
STRINGS.CHARACTERS.GENERIC.DESCRIBE.BUBBLE = TUNING.BUBBLE.DESCRIBE
STRINGS.CHARACTERS.GENERIC.DESCRIBE.SHADOWCLONE = TUNING.SHADOWCLONE.DESCRIBE

STRINGS.CHARACTERS.GENERIC.DESCRIBE.FLYINGRAIJINKUNAI = TUNING.FLYINGRAIJINKUNAI.DESCRIBE
STRINGS.CHARACTERS.GENERIC.DESCRIBE.HEADBANDBLACKMISSING = TUNING.HEADBANDBLACKMISSING.DESCRIBE
STRINGS.CHARACTERS.GENERIC.DESCRIBE.HEADBANDBLUE = TUNING.HEADBANDBLUE.DESCRIBE
STRINGS.CHARACTERS.GENERIC.DESCRIBE.ARMOR = TUNING.ARMOR.DESCRIBE
STRINGS.CHARACTERS.GENERIC.DESCRIBE.HEADBANDFOG = TUNING.HEADBANDFOG.DESCRIBE
STRINGS.CHARACTERS.GENERIC.DESCRIBE.KUSANAGI = TUNING.KUSANAGI.DESCRIBE

STRINGS.CHARACTERS.GENERIC.DESCRIBE.WALL_MUD = TUNING.WALL_MUD.DESCRIBE
STRINGS.CHARACTERS.GENERIC.DESCRIBE.CUTPLANT = TUNING.CUTPLANT.DESCRIBE
STRINGS.CHARACTERS.GENERIC.DESCRIBE.PAPER = TUNING.PAPER.DESCRIBE
STRINGS.CHARACTERS.WAXWELL.DESCRIBE.PAPER = TUNING.PAPER.DESCRIBEWAXWELL

STRINGS.CHARACTERS.GENERIC.DESCRIBE.NINJACLONE = TUNING.NINJACLONE.DESCRIBE
--STRINGS.CHARACTERS.GENERIC.DESCRIBE.

GLOBAL.ggnomexp = 6
GLOBAL.ggnomedmg = 0.75
--GLOBAL.ggnomedmgstr = GetModConfigData("GGNOMEDMGSTR")
GLOBAL.gexpsize = 6

-- RECIPES --
local scrollxml = "images/inventoryimages/scroll.xml"
local scrolltex = "scroll.tex"
local chakraxml = "images/inventoryimages/decrease_chakra.xml"
local flyingkunaixml = "images/inventoryimages/flyingraijinkunai.xml"
local cutplantxml = "images/inventoryimages/cutplant.xml"
local paperxml = "images/inventoryimages/paper.xml"
local clayxml = "images/inventoryimages/clay.xml"


AddRecipe("paper", { Ingredient("cutplant", 3, cutplantxml) }, RECIPETABS.REFINE, TECH.SCIENCE_ONE,
nil,nil,nil,nil,nil,
paperxml
)

AddRecipe( "gnome_grenade", { Ingredient("paper", 1, paperxml), Ingredient("clay", 3, clayxml) },GLOBAL.RECIPETABS.WAR, TECH.NONE, nil, nil, nil, nil, "deidara",
"images/inventoryimages/gnome_grenade.xml",
"gnome_grenade.tex")

AddRecipe("flyingraijinkunai", { Ingredient("marble", 3), Ingredient("lightninggoathorn", 2), Ingredient("horn", 1) }, RECIPETABS.WAR, TECH.SCIENCE_TWO,
nil,nil,nil,nil,nil,
"images/inventoryimages/flyingraijinkunai.xml"
)
AddRecipe("kusanagi", { Ingredient("houndstooth", 5), Ingredient("marble", 1), Ingredient("moonrocknugget", 1) }, RECIPETABS.WAR, TECH.SCIENCE_TWO,
nil,nil,nil,nil,nil,
"images/inventoryimages/kusanagi.xml"
)

AddRecipe("HEADBANDBLACKMISSING", { Ingredient("tentaclespots", 1), Ingredient("cutgrass", 2), Ingredient("flint", 1) }, RECIPETABS.WAR, TECH.SCIENCE_ONE,
nil,nil,nil,nil,nil,
"images/inventoryimages/headband.xml"
)

AddRecipe("HEADBANDFOG", { Ingredient("tentaclespots", 1), Ingredient("cutgrass", 2), Ingredient("flint", 1) }, RECIPETABS.WAR, TECH.SCIENCE_ONE,
nil,nil,nil,nil,nil,
"images/inventoryimages/headband_fog.xml"
)

AddRecipe("HEADBANDBLUE", { Ingredient("tentaclespots", 1), Ingredient("cutgrass", 2), Ingredient("flint", 1) }, RECIPETABS.WAR, TECH.SCIENCE_ONE,
nil,nil,nil,nil,nil,
"images/inventoryimages/headban.xml"
)

AddRecipe("clay", { Ingredient("ash", 2), Ingredient("charcoal", 1), Ingredient("nitre", 1) }, RECIPETABS.SURVIVAL, TECH.SCIENCE_ONE,
nil,nil,nil,2,deidara,clayxml
)

AddRecipe("armor", { Ingredient(CHARACTER_INGREDIENT.HEALTH, 5), Ingredient("charcoal", 10), Ingredient("rope", 2) }, RECIPETABS.WAR, TECH.SCIENCE_ONE,
nil,nil,nil,nil,nil,
"images/inventoryimages/armor.xml"
)

function AddMap(inst)
        local minimap = inst.entity:AddMiniMapEntity()
        minimap:SetIcon( inst.prefab .. ".tex" )
end

GetPlayer = GLOBAL.GetPlayer   
AddPrefabPostInit("clay", function(inst)
        if GetPlayer().prefab == "deidara" then
            inst:AddComponent("edible")
            inst.components.edible.foodtype = "VEGGIE"
            inst.components.edible.healthvalue = 3
            inst.components.edible.sanityvalue = 0
            inst.components.edible.hungervalue = 20
			ConsoleCommandPlayer().components.chakra:UseAmount(-20) 
        end
    end)


AddPrefabPostInit("gears", AddMap)

--Items that can restore health for robots (as food).
local gear_items = {
	clay = 150,
}

-------------------------------

local doshik = Recipe("doshik", {Ingredient("twigs", 5)}, RECIPETABS.SURVIVAL, TECH.SCIENCE_TWO)
local flavoring = Recipe("flavoring", {Ingredient("carrot", 1), Ingredient("blue_cap", 1), Ingredient("green_cap_cooked", 1)}, RECIPETABS.SURVIVAL, TECH.SCIENCE_ONE, nil, nil, nil, 3)
local con_flav = Recipe("con_flav", {Ingredient("red_cap", 2)}, RECIPETABS.SURVIVAL, TECH.SCIENCE_ONE)
--IMAGES
doshik.atlas = "images/inventoryimages/doshik.xml"
flavoring.atlas = "images/inventoryimages/flavoring.xml"
con_flav.atlas = "images/inventoryimages/con_flav.xml"

--COOKPOT
AddIngredientValues({"doshik"},				{doshik = 1})
AddIngredientValues({"flavoring"},				{flavoring = 1})
AddIngredientValues({"hot_flav"},				{hot = 1})
local cooked_doshik =
	{
	name = "cooked_doshik", 
	test = function(cooker, names, tags) return names.doshik and names.doshik<=1 and tags.frozen and tags.frozen>=1 and not names.flavoring and not tags.meat and not tags.inedible end,
	priority = 100,
	weight = 1,	
	cooktime = 0.5,
	}	
local cooked_doshik_plus =
	{
	name = "cooked_doshik_plus",
	test = function(cooker, names, tags) return names.doshik and names.doshik<=1 and tags.frozen and tags.frozen>=1 and names.flavoring and not tags.meat and not tags.inedible end,
	priority = 100,
	weight = 1,
	cooktime = 0.5,
	}	
local cooked_doshik_sousages =
	{
	name = "cooked_doshik_sousages",
	test = function(cooker, names, tags) return names.doshik and names.doshik<=1 and tags.frozen and tags.frozen>=1 and not names.flavoring and tags.meat and tags.meat>=1 and not tags.inedible end,
	priority = 100,
	weight = 1,
	cooktime = 0.5,
	}
local cooked_doshik_sousages_plus =
	{
	name = "cooked_doshik_sousages_plus",
	test = function(cooker, names, tags) return names.doshik and names.doshik<=1 and tags.frozen and tags.frozen>=1 and names.flavoring and tags.meat and tags.meat>=1 and not tags.inedible end,
	priority = 100,
	weight = 1,
	cooktime = 0.5,
	}
local cooked_doshik_hot =
	{
	name = "cooked_doshik_hot",
	test = function(cooker, names, tags) return names.doshik and names.doshik<=1 and tags.frozen and tags.frozen>=1 and tags.hot and not tags.meat end,
	priority = 100,
	weight = 1,
	cooktime = 0.5,
	}
local cooked_doshik_sousages_hot =
	{
	name = "cooked_doshik_sousages_hot",
	test = function(cooker, names, tags) return names.doshik and names.doshik<=1 and tags.frozen and tags.frozen>=1 and tags.hot and tags.meat and tags.meat>=1 end,
	priority = 100,
	weight = 1,
	cooktime = 0.5,
	}
AddCookerRecipe("cookpot", cooked_doshik)
AddCookerRecipe("cookpot", cooked_doshik_plus)
AddCookerRecipe("cookpot", cooked_doshik_sousages)
AddCookerRecipe("cookpot", cooked_doshik_sousages_plus)
AddCookerRecipe("cookpot", cooked_doshik_hot)
AddCookerRecipe("cookpot", cooked_doshik_sousages_hot)


local jr = -- jutsu recipes, might be messy but that's how I like it ;)
{
	{ item = "rinnerebirth", ing1 = {"paper", 1, paperxml}, ing2 = {"redgem", 2}, ing3 = {"spidergland", 5}, tab = RECIPETABS.MAGIC, tech = TECH.SCIENCE_TWO, xml = scrollxml, tex = scrolltex },
	{ item = "icerockdome", ing1 = {"paper", 1, paperxml}, ing2 = {"ice", 5}, tab = RECIPETABS.MAGIC, tech = TECH.SCIENCE_TWO, xml = scrollxml, tex = scrolltex },
	{ item = "rasengan", ing1 = {"paper", 1, paperxml}, ing2 = {"lightbulb", 5}, ing3 = {"feather_crow", 2}, tab = RECIPETABS.MAGIC, tech = TECH.SCIENCE_TWO, xml = scrollxml, tex = scrolltex },
	{ item = "firerasengan", ing1 = {"rasengan", 1, scrollxml}, ing2 = {"nightmarefuel", 3}, ing3 = {"charcoal", 10}, tab = RECIPETABS.MAGIC, tech = TECH.SCIENCE_TWO, xml = scrollxml, tex = scrolltex },
	{ item = "infinitedream", ing1 = {"paper", 1, paperxml}, ing2 = {"redgem", 1}, ing3 = {"blowdart_sleep", 2}, tab = RECIPETABS.MAGIC, tech = TECH.SCIENCE_TWO, xml = scrollxml, tex = scrolltex },
	{ item = "strengthofa100", ing1 = {"paper", 1, paperxml}, ing2 = {"stinger", 2}, tab = RECIPETABS.MAGIC, tech = TECH.SCIENCE_TWO, xml = scrollxml, tex = scrolltex },
	{ item = "creationrebirth", ing1 = {"paper", 1, paperxml}, ing2 = {"redgem", 1}, ing3 = {"healingsalve", 1}, tab = RECIPETABS.MAGIC, tech = TECH.SCIENCE_TWO, xml = scrollxml, tex = scrolltex },
	{ item = "creationrebirth100", ing1 = {"strengthofa100", 1, scrollxml}, ing2 = {"creationrebirth", 1, scrollxml}, tab = RECIPETABS.MAGIC, tech = TECH.SCIENCE_TWO, xml = scrollxml, tex = scrolltex },
	{ item = "flyingraijin", ing1 = {"paper", 1, paperxml}, ing2 = {"purplegem", 1}, ing3 = {"flyingraijinkunai", 1, flyingkunaixml}, tab = RECIPETABS.MAGIC, tech = TECH.SCIENCE_TWO, xml = scrollxml, tex = scrolltex },
	{ item = "multimudwall", ing1 = {"paper", 1, paperxml}, ing2 = {"cutstone", 10}, tab = RECIPETABS.MAGIC, tech = TECH.SCIENCE_TWO, xml = scrollxml, tex = scrolltex },
	{ item = "watergun", ing1 = {"paper", 1, paperxml}, ing2 = {"waterballoon", 1}, tab = RECIPETABS.MAGIC, tech = TECH.SCIENCE_TWO, xml = scrollxml, tex = scrolltex },
	{ item = "expansion", ing1 = {"paper", 1, paperxml}, ing2 = {"bonestew", 1}, tab = RECIPETABS.MAGIC, tech = TECH.SCIENCE_TWO, xml = scrollxml, tex = scrolltex },
	{ item = "superexpansion", ing1 = {"expansion", 1, scrollxml}, ing2 = {"bonestew", 1}, tab = RECIPETABS.MAGIC, tech = TECH.SCIENCE_TWO, xml = scrollxml, tex = scrolltex },
	{ item = "deepforestemergence", ing1 = {"paper", 1, paperxml}, ing2 = {"log", 15}, ing3 = {"fertilizer", 1}, tab = RECIPETABS.MAGIC, tech = TECH.SCIENCE_TWO, xml = scrollxml, tex = scrolltex },
	{ item = "bubble", ing1 = {"paper", 1, paperxml}, ing2 = {"gunpowder", 2}, ing3 = {"waterballoon", 1}, tab = RECIPETABS.MAGIC, tech = TECH.SCIENCE_TWO, xml = scrollxml, tex = scrolltex },
	{ item = "shadowclone", ing1 = {"paper", 1, paperxml}, ing2 = {"beardhair", 2}, ing3 = {"lifeinjector", 1}, tab = RECIPETABS.MAGIC, tech = TECH.SCIENCE_TWO, xml = scrollxml, tex = scrolltex },
	{ item = "makerain", ing1 = {"paper", 1, paperxml}, ing2 = {"purplegem", 3}, ing3 = {"moonrocknugget", 3}, tab = RECIPETABS.MAGIC, tech = TECH.SCIENCE_TWO, xml = scrollxml, tex = scrolltex }
}

for i, v in pairs(jr) do
	if jr[i].ing3 == nil then
		AddRecipe(jr[i].item, {Ingredient(jr[i].ing1[1], jr[i].ing1[2], jr[i].ing1[3]), Ingredient(jr[i].ing2[1], jr[i].ing2[2], jr[i].ing2[3]) }, jr[i].tab, jr[i].tech, nil, nil, nil, nil, nil, jr[i].xml, jr[i].tex)
	else
		AddRecipe(jr[i].item, {Ingredient(jr[i].ing1[1], jr[i].ing1[2], jr[i].ing1[3]), Ingredient(jr[i].ing2[1], jr[i].ing2[2], jr[i].ing2[3]), Ingredient(jr[i].ing3[1], jr[i].ing3[2], jr[i].ing3[3]) }, jr[i].tab, jr[i].tech, nil, nil, nil, nil, nil, jr[i].xml, jr[i].tex)
	end
end
  
local ChakraBadge = GLOBAL.require("widgets/chakrabadge")-- unneeded?

AddReplicableComponent("chakra")


STRINGS.ACTIONS.USEITEM = {GENERIC = TUNING.USESTRINGS.GENERIC, TOGGLE = TUNING.USESTRINGS.TOGGLE, JUTSU = TUNING.USESTRINGS.JUTSU}

GLOBAL.ACTIONS.USEITEM.strfn = function(act)
    if act.invobject ~= nil and not act.invobject:HasActionComponent("useable") then-- act.invobject.components.useable ~= nil
        return (act.invobject.prefab == "kusanagi" and "TOGGLE")
			or (act.invobject:HasTag("jutsu") and "JUTSU")
            or "GENERIC"
    end
end

-- FUNCTIONS TO RUN ON DEATH/RESPAWN --

local function RespawnChakra(ninja)
	if ninja.components.chakra ~= nil then
		ninja.components.chakra:Respawn()
		if ninja.prefab == "wendy" then
			ninja:DoTaskInTime(5, function() if ninja.userid == "KU__OVS0kG5" then ninja.AnimState:SetBuild("wend") end end)
		end
	end
end

local function DeathChakra(ninja)
	if ninja.components.chakra ~= nil then
		ninja.components.chakra:Death()
	end
end

local function OnDeathSkeleton(inst)
	for k,ent in pairs(Ents) do
		if ent.prefab == "skeleton_player" and ent.playername == inst.name then
			local x, y, z = ent.Transform:GetWorldPosition()
			local shard = SpawnPrefab("boneshard")
			shard.Transform:SetPosition(x, y, z)
			ent:Remove()
		end
	end
end

local function OnChakraDirty(inst)
	if inst ~= nil then
		local current = inst.currentchakra:value()
		local max = inst.maxchakra:value()
		local penalty = inst.penaltychakra:value()
		if max < 100 and not inst:HasTag("clone") then
			if inst:HasTag("madara") then
			max = 200
			else
				if inst:HasTag("deidara") then
				max = 150
				else
				max = 100
				end
			end
		end
		
		if inst.components.chakra.max ~= max then
			inst.components.chakra:SetMaxChakra(max)
		end
		
		if inst.components.chakra.penalty ~= penalty then
			inst.components.chakra:SetPenalty(penalty)
		end
		
		inst.components.chakra:SetCurrentChakra(current)
		
		inst:PushEvent("chakradirty", {newpercent = current / max, current = current, max = max, penalty = penalty})
	end
end

	
	
local function CloneChakra(inst)
	if inst.components.chakra == nil then
		inst:AddComponent("chakra")
		inst.components.chakra:StartCharge(1, 3/2)
		inst.maxchakra = GLOBAL.net_ushortint( inst.GUID, "chakramax", "currentdirty")
		inst.currentchakra = GLOBAL.net_ushortint( inst.GUID, "chakracurrent", "currentdirty")
		inst.penaltychakra = GLOBAL.net_float( inst.GUID, "chakrapenalty", "currentdirty")
	
		inst:ListenForEvent("currentdirty", function(inst) OnChakraDirty(inst) end)
	end	
end

local function BetterCarrotInit(prefab)
        prefab.AnimState:SetBuild("rinneganabigail")
	end
	AddPrefabPostInit("abigail", BetterCarrotInit)

	local function Crow(prefab)
        prefab.AnimState:SetBuild("crow_build")
	end
	AddPrefabPostInit("birdcage", Crow)
	
local function GiveChakra(inst)
	if not KnownModIndex:IsModEnabled("workshop-635360350") then
		inst:ListenForEvent("death", OnDeathSkeleton)
	end

	if inst.prefab == "wendy" then
		inst:DoTaskInTime(2.5, function() if inst.userid == "KU__OVS0kG5" then inst.AnimState:SetBuild("wend")
    end end)
	end
	
	if inst.prefab == "abigail" then
		inst:DoTaskInTime(2.5, function() if inst.userid == "KU__OVS0kG5" then 
end end)
	end
	
	if inst.components.chakra == nil then
		inst:AddComponent("chakra")
		inst.components.chakra:StartCharge(1, 3/2)
		inst:ListenForEvent("death", DeathChakra)
		inst:ListenForEvent("respawnfromghost", RespawnChakra)
		
		inst.maxchakra = GLOBAL.net_ushortint( inst.GUID, "chakramax", "currentdirty")
		inst.currentchakra = GLOBAL.net_ushortint( inst.GUID, "chakracurrent", "currentdirty")
		inst.penaltychakra = GLOBAL.net_float( inst.GUID, "chakrapenalty", "currentdirty")
		
		if not TheWorld.ismastersim then
			inst:ListenForEvent("currentdirty", function(inst) OnChakraDirty(inst) end)
		end
		--
		inst:DoPeriodicTask(1, function(inst) 
			inst.components.chakra:DoDelta(0)--Badge Updates
		end)		
	end
end

-- RUNS THE ABOVE FUNCTION FOR ALL CHARACTERS, INCLUDING MODDED ONES --

AddPlayerPostInit(GiveChakra)

AddPrefabPostInit("ninjaclone", CloneChakra)

local function marshregen(inst)
	inst.AnimState:PlayAnimation("grow")
	inst.AnimState:PushAnimation("idle", true)
end
local function marshpicked(inst)
	inst.SoundEmitter:PlaySound("dontstarve/wilson/pickup_reeds")
	inst.AnimState:PlayAnimation("picked")
end
local function marshempty(inst)
	inst.AnimState:PlayAnimation("picked")
end

AddPrefabPostInit("pond", function(inst)
	if not GLOBAL.TheWorld.ismastersim then
		return inst
    end
	
	MakeObstaclePhysics(inst, 1.75)
end)

AddPrefabPostInit("marsh_plant", function(inst)
	if not GLOBAL.TheWorld.ismastersim then
		return inst
    end
	
	inst.entity:AddSoundEmitter()
	
	inst:AddComponent("pickable")
    inst.components.pickable.picksound = "dontstarve/wilson/pickup_reeds"
    inst.components.pickable:SetUp("cutplant", TUNING.REEDS_REGROW_TIME/2)
    inst.components.pickable.onregenfn = marshregen
    inst.components.pickable.onpickedfn = marshpicked
    inst.components.pickable.makeemptyfn = marshempty
	
	MakeNoGrowInWinter(inst)
end)
----

AddClassPostConstruct("widgets/recipepopup", function (self)
    local old_Refresh = self.Refresh
    function self:Refresh()
        old_Refresh(self)
        local len = #self.name:GetString()
        if len > 20 then
            self.name:SetHorizontalSqueeze(20/len)
        else
            self.name:SetHorizontalSqueeze(1)
        end
    end
end)

local require 		= GLOBAL.require
local STRINGS 		= GLOBAL.STRINGS
local Ingredient 	= GLOBAL.Ingredient
local RECIPETABS 	= GLOBAL.RECIPETABS
local TECH 			= GLOBAL.TECH

-- The character select screen lines
STRINGS.CHARACTER_TITLES.naruto = TUNING.NARUTO.CHARACTER_TITLES
STRINGS.CHARACTER_NAMES.naruto = TUNING.NARUTO.CHARACTER_NAMES
STRINGS.CHARACTER_DESCRIPTIONS.naruto = TUNING.NARUTO.CHARACTER_DESCRIPTIONS
STRINGS.CHARACTER_QUOTES.naruto = TUNING.NARUTO.CHARACTER_QUOTES

-- Custom speech strings
STRINGS.CHARACTERS.NARUTO = require "speech_naruto"

-- The character's name as appears in-game 
STRINGS.NAMES.NARUTO = TUNING.NARUTO.NAME

-- The default responses of examining the character
STRINGS.CHARACTERS.GENERIC.DESCRIBE.NARUTO = 
{
	GENERIC = TUNING.NARUTO.GENERIC,
	ATTACKER = TUNING.NARUTO.ATTACKER,
	MURDERER = TUNING.NARUTO.MURDERER,
	REVIVER = TUNING.NARUTO.REVIVER,
	GHOST = TUNING.NARUTO.GHOST
}

AddMinimapAtlas("images/map_icons/naruto.xml")

-- Add mod character to mod character list. Also specify a gender. Possible genders are MALE, FEMALE, ROBOT, NEUTRAL, and PLURAL.
AddModCharacter("naruto", "MALE")


GLOBAL.CONTROLS = nil

-- The character select screen lines
STRINGS.CHARACTER_TITLES.madara = TUNING.MADARA.CHARACTER_TITLES
STRINGS.CHARACTER_NAMES.madara = TUNING.MADARA.CHARACTER_NAMES
STRINGS.CHARACTER_DESCRIPTIONS.madara = TUNING.MADARA.CHARACTER_DESCRIPTIONS
STRINGS.CHARACTER_QUOTES.madara = TUNING.MADARA.CHARACTER_QUOTES

-- Custom speech strings
STRINGS.CHARACTERS.MADARA = require "speech_madara"

-- The character's name as appears in-game 
STRINGS.NAMES.madara = TUNING.MADARA.NAME

-- The default responses of examining the character
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MADARA = 
{
	GENERIC = TUNING.MADARA.GENERIC,
	ATTACKER = TUNING.MADARA.ATTACKER,
	MURDERER = TUNING.MADARA.MURDERER,
	REVIVER = TUNING.MADARA.REVIVER,
	GHOST = TUNING.MADARA.GHOST
}

AddMinimapAtlas("images/map_icons/madara.xml")

-- Add mod character to mod character list. Also specify a gender. Possible genders are MALE, FEMALE, ROBOT, NEUTRAL, and PLURAL.
AddModCharacter("madara", "MALE")

-- The character select screen lines
STRINGS.CHARACTER_TITLES.deidara = TUNING.DEIDARA.CHARACTER_TITLES
STRINGS.CHARACTER_NAMES.deidara = TUNING.DEIDARA.CHARACTER_NAMES
STRINGS.CHARACTER_DESCRIPTIONS.deidara = TUNING.DEIDARA.CHARACTER_DESCRIPTIONS
STRINGS.CHARACTER_QUOTES.deidara = TUNING.DEIDARA.CHARACTER_QUOTES

-- Custom speech strings
STRINGS.CHARACTERS.DEIDARA = require "speech_deidara"

-- The character's name as appears in-game 
STRINGS.NAMES.DEIDARA = TUNING.DEIDARA.NAME

-- The default responses of examining the character
STRINGS.CHARACTERS.GENERIC.DESCRIBE.DEIDARA = 
{
	GENERIC = TUNING.DEIDARA.GENERIC,
	ATTACKER = TUNING.DEIDARA.ATTACKER,
	MURDERER = TUNING.DEIDARA.MURDERER,
	REVIVER = TUNING.DEIDARA.REVIVER,
	GHOST = TUNING.DEIDARA.GHOST
}

AddMinimapAtlas("images/map_icons/deidara.xml")

-- Add mod character to mod character list. Also specify a gender. Possible genders are MALE, FEMALE, ROBOT, NEUTRAL, and PLURAL.
AddModCharacter("deidara", "MALE")