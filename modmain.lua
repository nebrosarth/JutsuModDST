modimport("libs/env.lua")

use "data/init"

local chosenlanguage = GetModConfigData("language")

if chosenlanguage == "chinese" then
	modimport "languages/chinese.lua"
else
	modimport "languages/english.lua"
end

PrefabFiles = 
{
 "jutsu",
 "jutsuprojectile",
 "jutsuspecial",
 "ninjatools",
 "ninjagear",
 "wall_mud",
 "jutsufx",
 "ninjaclone",
 "cutplant",
}

Assets = 
{
	Asset( "ATLAS", "images/inventoryimages/scroll.xml"),
	Asset( "ATLAS", "images/inventoryimages/flyingraijinkunai.xml"),
	Asset( "ATLAS", "images/inventoryimages/headband.xml"),
	Asset( "ATLAS", "images/inventoryimages/cutplant.xml"),
	Asset( "ATLAS", "images/inventoryimages/paper.xml"),
	Asset( "ANIM", "anim/chakra.zip"),
	Asset( "ANIM", "anim/chakrapenalty.zip"),
	Asset( "ANIM", "anim/rinneganwebber.zip"),
}

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
STRINGS.NAMES.CLASSICHEADBAND = TUNING.CLASSICHEADBAND.NAME
STRINGS.NAMES.KUSANAGI = TUNING.KUSANAGI.NAME

STRINGS.NAMES.WALL_MUD = TUNING.WALL_MUD.NAME
STRINGS.NAMES.CUTPLANT = TUNING.CUTPLANT.NAME
STRINGS.NAMES.PAPER = TUNING.PAPER.NAME

STRINGS.NAMES.NINJACLONE = TUNING.NINJACLONE.NAME
--STRINGS.NAMES.

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
STRINGS.RECIPE_DESC.CLASSICHEADBAND = TUNING.CLASSICHEADBAND.RECIPE
STRINGS.RECIPE_DESC.KUSANAGI = TUNING.KUSANAGI.RECIPE

STRINGS.RECIPE_DESC.PAPER = TUNING.PAPER.RECIPE

--STRINGS.RECIPE_DESC.

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
STRINGS.CHARACTERS.GENERIC.DESCRIBE.CLASSICHEADBAND = TUNING.CLASSICHEADBAND.DESCRIBE
STRINGS.CHARACTERS.GENERIC.DESCRIBE.KUSANAGI = TUNING.KUSANAGI.DESCRIBE

STRINGS.CHARACTERS.GENERIC.DESCRIBE.WALL_MUD = TUNING.WALL_MUD.DESCRIBE
STRINGS.CHARACTERS.GENERIC.DESCRIBE.CUTPLANT = TUNING.CUTPLANT.DESCRIBE
STRINGS.CHARACTERS.GENERIC.DESCRIBE.PAPER = TUNING.PAPER.DESCRIBE
STRINGS.CHARACTERS.WAXWELL.DESCRIBE.PAPER = TUNING.PAPER.DESCRIBEWAXWELL

STRINGS.CHARACTERS.GENERIC.DESCRIBE.NINJACLONE = TUNING.NINJACLONE.DESCRIBE
--STRINGS.CHARACTERS.GENERIC.DESCRIBE.

-- RECIPES --
local scrollxml = "images/inventoryimages/scroll.xml"
local scrolltex = "scroll.tex"
local chakraxml = "images/inventoryimages/decrease_chakra.xml"
local flyingkunaixml = "images/inventoryimages/flyingraijinkunai.xml"
local cutplantxml = "images/inventoryimages/cutplant.xml"
local paperxml = "images/inventoryimages/paper.xml"

AddRecipe("flyingraijinkunai", { Ingredient("marble", 3), Ingredient("boneshard", 1) }, RECIPETABS.WAR, TECH.SCIENCE_TWO,
nil,nil,nil,nil,nil,
flyingkunaixml
)

AddRecipe("kusanagi", { Ingredient("houndstooth", 5), Ingredient("marble", 1), Ingredient("moonrocknugget", 1) }, RECIPETABS.WAR, TECH.SCIENCE_TWO,
nil,nil,nil,nil,nil,
"images/inventoryimages/kusanagi.xml"
)

AddRecipe("classicheadband", { Ingredient("tentaclespots", 2), Ingredient("cutgrass", 2), Ingredient("flint", 1) }, RECIPETABS.WAR, TECH.SCIENCE_ONE,
nil,nil,nil,nil,nil,
"images/inventoryimages/headband.xml"
)

AddRecipe("paper", { Ingredient("cutplant", 3, cutplantxml) }, RECIPETABS.REFINE, TECH.SCIENCE_ONE,
nil,nil,nil,nil,nil,
paperxml
)

local jr = -- jutsu recipes, might be messy but that's how I like it ;)
{
	{ item = "rinnerebirth", ing1 = {"paper", 1, paperxml}, ing2 = {"redgem", 2}, ing3 = {"spidergland", 5}, tab = RECIPETABS.MAGIC, tech = TECH.SCIENCE_TWO, xml = scrollxml, tex = scrolltex },	{ item = "icerockdome", ing1 = {"paper", 1, paperxml}, ing2 = {"ice", 5}, tab = RECIPETABS.MAGIC, tech = TECH.SCIENCE_TWO, xml = scrollxml, tex = scrolltex },	{ item = "rasengan", ing1 = {"paper", 1, paperxml}, ing2 = {"feather_crow", 2}, tab = RECIPETABS.MAGIC, tech = TECH.SCIENCE_TWO, xml = scrollxml, tex = scrolltex },	{ item = "firerasengan", ing1 = {"rasengan", 1, scrollxml}, ing2 = {"nightmarefuel", 3}, tab = RECIPETABS.MAGIC, tech = TECH.SCIENCE_TWO, xml = scrollxml, tex = scrolltex },	{ item = "infinitedream", ing1 = {"paper", 1, paperxml}, ing2 = {"redgem", 1}, ing3 = {"blowdart_sleep", 2}, tab = RECIPETABS.MAGIC, tech = TECH.SCIENCE_TWO, xml = scrollxml, tex = scrolltex },	{ item = "strengthofa100", ing1 = {"paper", 1, paperxml}, ing2 = {"stinger", 2}, tab = RECIPETABS.MAGIC, tech = TECH.SCIENCE_TWO, xml = scrollxml, tex = scrolltex },	{ item = "creationrebirth", ing1 = {"paper", 1, paperxml}, ing2 = {"redgem", 1}, ing3 = {"healingsalve", 1}, tab = RECIPETABS.MAGIC, tech = TECH.SCIENCE_TWO, xml = scrollxml, tex = scrolltex },	{ item = "creationrebirth100", ing1 = {"strengthofa100", 1, scrollxml}, ing2 = {"creationrebirth", 1, scrollxml}, tab = RECIPETABS.MAGIC, tech = TECH.SCIENCE_TWO, xml = scrollxml, tex = scrolltex },	{ item = "flyingraijin", ing1 = {"paper", 1, paperxml}, ing2 = {"purplegem", 1}, ing3 = {"flyingraijinkunai", 1, flyingkunaixml}, tab = RECIPETABS.MAGIC, tech = TECH.SCIENCE_TWO, xml = scrollxml, tex = scrolltex },	{ item = "multimudwall", ing1 = {"paper", 1, paperxml}, ing2 = {"cutstone", 2}, tab = RECIPETABS.MAGIC, tech = TECH.SCIENCE_TWO, xml = scrollxml, tex = scrolltex },	{ item = "watergun", ing1 = {"paper", 1, paperxml}, ing2 = {"waterballoon", 1}, tab = RECIPETABS.MAGIC, tech = TECH.SCIENCE_TWO, xml = scrollxml, tex = scrolltex },	{ item = "expansion", ing1 = {"paper", 1, paperxml}, ing2 = {"bonestew", 1}, tab = RECIPETABS.MAGIC, tech = TECH.SCIENCE_TWO, xml = scrollxml, tex = scrolltex },	{ item = "superexpansion", ing1 = {"expansion", 1, scrollxml}, ing2 = {"bonestew", 1}, tab = RECIPETABS.MAGIC, tech = TECH.SCIENCE_TWO, xml = scrollxml, tex = scrolltex },	{ item = "deepforestemergence", ing1 = {"paper", 1, paperxml}, ing2 = {"log", 15}, ing3 = {"poop", 5}, tab = RECIPETABS.MAGIC, tech = TECH.SCIENCE_TWO, xml = scrollxml, tex = scrolltex },	{ item = "bubble", ing1 = {"paper", 1, paperxml}, ing2 = {"gunpowder", 2}, ing3 = {"waterballoon", 1}, tab = RECIPETABS.MAGIC, tech = TECH.SCIENCE_TWO, xml = scrollxml, tex = scrolltex },
	{ item = "shadowclone", ing1 = {"paper", 1, paperxml}, ing2 = {"beardhair", 2}, ing3 = {"lifeinjector", 1}, tab = RECIPETABS.MAGIC, tech = TECH.SCIENCE_TWO, xml = scrollxml, tex = scrolltex }
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
		if ninja.prefab == "webber" then
			ninja:DoTaskInTime(5, function() if ninja.userid == "KU_ynbQpeyv" then ninja.AnimState:SetBuild("rinneganwebber") end end)
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
			max = 100
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

local function GiveChakra(inst)
	if not KnownModIndex:IsModEnabled("workshop-635360350") then
		inst:ListenForEvent("death", OnDeathSkeleton)
	end

	if inst.prefab == "webber" then
		inst:DoTaskInTime(2.5, function() if inst.userid == "KU_ynbQpeyv" then inst.AnimState:SetBuild("rinneganwebber") end end)
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