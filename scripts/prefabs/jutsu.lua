local assets =
{
    Asset("ATLAS", "images/inventoryimages/scroll.xml"),
	Asset("ANIM", "anim/pixel.zip"),
	Asset("ANIM", "anim/scroll.zip"),
    Asset("ANIM", "anim/swap_scroll.zip"),
}


--[[
PLANS:
Eventually do PROPER translations
]]--
--- USEFUL FUNCTIONS ---

local ghostprefix = TUNING.JUTSU.GHOST
local jtused = TUNING.JUTSU.USED

local function lighttarget(target, lightprefab)
	if target.emittinglight == nil then
		target.emittinglight = SpawnPrefab(lightprefab)
		target.emittinglight.AnimState:SetBank("pixel")
		target.emittinglight.AnimState:SetBuild("pixel")
		target.emittinglight.entity:SetParent(target.entity)
	end
	local timerlight = 0
	target.lighttask = target:DoPeriodicTask(1, function()
		if timerlight >= 3 then
			if target.emittinglight ~= nil then
				target.emittinglight:Remove()
				target.emittinglight = nil
				target.lighttask:Cancel()
			end
		else
			timerlight = timerlight + 1
		end
	end)
end

local function autoequip(jutsu, ninja)
	for key, samejutsu in pairs(ninja.components.inventory.itemslots) do
		if samejutsu.prefab == jutsu.prefab then
			if samejutsu.components.equippable ~= nil then
				ninja.components.inventory:Equip(samejutsu)
			end
		end
	end
end

local function sizechange(ninja, current, increment, final, overtime, boost)
	if ninja.expand == nil then
		if ninja.components.combat.damagemultiplier == nil then
			ninja.components.combat.damagemultiplier = 1
		end
		
		if current[1] < final[1] then
			ninja.sg:GoToState("powerup")
		else
			ninja.sg:GoToState("powerdown")
		end
		
		ninja.expand = ninja:DoPeriodicTask(overtime, 
		function()
			if current[1] ~= final[1] then
				ninja.Transform:SetScale(current[1] + increment, current[2] + increment, current[3] + increment)
				
				current[1] = current[1] + increment
				current[2] = current[2] + increment
				current[3] = current[3] + increment
			else
				ninja.components.combat.damagemultiplier = ninja.components.combat.damagemultiplier + boost
				ninja.components.hunger.hungerrate = ninja.components.hunger.hungerrate + (boost * 1.5)
				ninja.expand:Cancel()
				ninja.expand = nil
			end
		end)
	end
end

local function getrandomprefab(spawnlocation)	
	local randomnum = 0
	local uncommon = 0
	local rare = 0
	local superrare = 0
	local prefabs = nil
	local hasmushrooms = 0
	if spawnlocation == 6 then--GRASSLANDS
		uncommon = 4
		rare = 7
		superrare = 9
		prefabs = { [1] = "grass", [2] = "sapling", [3] = "pinecone_sapling", [4] = "flower", [5] = "twiggy_nut_sapling", [6] = "acorn_sapling", [7] = "berrybush", [8] = "red_mushroom", [9] = "mandrake_planted"	}
		hasmushrooms = 8
	elseif spawnlocation == 7 then--FOREST
		uncommon = 4
		rare = 6
		superrare = 9
		prefabs = { [1] = "sapling", [2] = "lumpy_sapling", [3] = "pinecone_sapling", [4] = "flower_evil",  [5] = "twiggy_nut_sapling", [6] = "berrybush", [7] = "berrybush2", [8] = "red_mushroom", [9] = "berrybush_juicy" }
		hasmushrooms = 8
	elseif spawnlocation == 30 then --DECIDUOUS FOREST
		uncommon = 4
		rare = 7
		superrare = 8
		prefabs = { [1] = "sapling", [2] = "acorn_sapling", [3] = "grass", [4] = "berrybush", [5] = "flower",  [6] = "twiggy_nut_sapling", [7] = "red_mushroom", [8] = "berrybush_juicy" }
		hasmushrooms = 7
	elseif spawnlocation == 8 then --MARSH
		uncommon = 3
		prefabs = { [1] = "marsh_bush", [2] = "marsh_tree", [3] = "reeds" }
	elseif spawnlocation == 5 then -- SAVANNA
		prefabs = { [1] = "grass" }
	elseif spawnlocation == 15 then -- CAVE: GRASS
		uncommon = 5
		rare = 5
		superrare = 7
		prefabs = { [1] = "grass", [2] = "sapling", [3] = "pinecone_sapling", [4] = "cave_fern", [5] = "berrybush", [6] = "red_mushroom", [7] = "flower_cave", [8] = "flower_cave_double" }
		hasmushrooms = 5
	elseif spawnlocation == 13 or spawnlocation == 16 or spawnlocation == 17 then -- CAVE: ALL BUT GRASS/RUINS/FUNGUS
		uncommon = 2
		rare = 3
		superrare = 7
		prefabs = { [1] = "cave_fern", [2] = "flower_cave", [3] = "red_mushroom", [4] = "flower_cave_double", [5] = "wormlight_plant", [6] = "lichen", [7] = "cave_banana_tree" }
		if spawnlocation == 13 then
			prefabs[3] = "cave_fern"
		else
			hasmushrooms = 3
		end
	elseif spawnlocation == 14 or spawnlocation == 24 or spawnlocation == 25 then -- CAVE: FUNGUS COLORS
		rare = 4
		superrare = 5
		prefabs = { [1] = "cave_fern", [2] = "red_mushroom", [3] = "flower_cave", [4] = "flower_cave_double", [5] = "flower_cave_triple" }
		if spawnlocation == 25 then
			prefabs[2] = "green_mushroom"
		elseif spawnlocation == 14 then
			prefabs[2] = "blue_mushroom"
		end
		-- no "hasmushrooms" because we dont modify the mushroom depending on daycycle but depending on spawnlocation.
	end
	
	randomnum = math.random(1,#prefabs)

	for i=0, 3, 1 do--the FOR loop is for rerolling a number for to the rarity system
		if superrare ~= 0 and randomnum >= superrare then -- if we hit the SUPERRARE table
			if i < 3 then--if its not on the last loop, then reroll a number and redo the for loop
				randomnum = math.random(1,#prefabs)
			else -- if on iteration 3			
				return prefabs[randomnum]
			end
		elseif rare ~=0 and randomnum >= rare then -- if we hit the RARE table
			if i < 2 then
				randomnum = math.random(1,#prefabs)
			else -- if on iteration 2
				if hasmushrooms ~= 0 and randomnum == hasmushrooms then--if the spawnable prefabs list can spawn mushrooms, we make sure to spawn the correct 1 according to time
					if TheWorld.state.isday or TheWorld.state.iscaveday then
						prefabs[hasmushrooms] = "red_mushroom"
					elseif TheWorld.state.isdusk or TheWorld.state.iscavedusk then
						prefabs[hasmushrooms] = "green_mushroom"
					elseif TheWorld.state.isnight or TheWorld.state.iscavenight then
						prefabs[hasmushrooms] = "blue_mushroom"
					end
				end
				return prefabs[randomnum]
			end
		elseif uncommon ~= 0 and randomnum >= uncommon then -- if we hit the UNCOMMON table
			if i < 1 then
				randomnum = math.random(1,#prefabs)
			else -- if on iteration 1	
				return prefabs[randomnum]
			end
		else -- if we hit the COMMON table
			return prefabs[randomnum]
		end
	end
end

local function depletejutsu(jutsu, ninja)
	if not jutsu.components.stackable or not jutsu.components.stackable:IsStack() then
		jutsu:Remove()
		if ninja then
			autoequip(jutsu, ninja)
		end
	else
		jutsu.components.stackable:SetStackSize(jutsu.components.stackable:StackSize() - 1)
	end
end

--- ACTUAL JUTSU FUNCTIONS ---
local jutsu_variables =
{
    {
----- RINNE REBIRTH JUTSU -----
        name = "rinnerebirth",
		chakra = 100,
		health = 30,
		strings = { use = TUNING.RINNEREBIRTH.USE, using = TUNING.RINNEREBIRTH.USING, noghosts = TUNING.RINNEREBIRTH.NOGHOSTS },
		tags = {"globalreincarnation", "utility"},
		hauntable = true,
        onuse = function(jutsu, haunter, ninja)
			local jv = jutsu.vars
			local deadplayers = 0
			ninja = jutsu.components.inventoryitem.owner or ninja
			local HasInfiniteChakra = (ninja ~= nil and ninja.components.chakra:IsInfinite()) or (haunter ~= nil and haunter.components.chakra:IsInfinite())
			local consumejutsu = true
			local valid = false
			local canuse = ninja and ninja.components.chakra ~= nil
			local respawnmsg = ""
			
			
			for k,player in pairs(Ents) do
				if player:HasTag("playerghost") then
					deadplayers = deadplayers + 1
				end
			end
			
			if deadplayers ~= 0 then
				if ninja == nil then
					TheNet:Announce(ghostprefix .. haunter.name .. ": " .. jv.strings.use)
					print(haunter.name .. jtused .. jv.strings.use)
					respawnmsg = ghostprefix .. haunter.name .. jv.strings.using
					valid = true
				elseif canuse then
					ninja.components.talker:Say(jv.strings.use)
					TheNet:Announce(ninja.name .. ": " .. jv.strings.use)
					print(ninja.name .. jtused .. jv.strings.use)
					respawnmsg = ninja.name .. jv.strings.using
					valid = true
				end
				
				if valid then
					for k,player in pairs(Ents) do
						if player:HasTag("playerghost") then
							local skeletonfound = false
							for k,skeleton in pairs(Ents) do
								if skeleton.prefab == "skeleton_player" and skeleton.playername == player.name then
									print(player.name .. " возрождён техникой Божественного Воскрешения!")
									local x, y, z = skeleton.Transform:GetWorldPosition()
									player.Transform:SetPosition(x, y, z)
									player:PushEvent("respawnfromghost", { source = { name = respawnmsg,  components = {} }  })
									local rayfx = SpawnPrefab("greenray")
									rayfx.Transform:SetPosition(x, y-0.1, z)
									skeleton:DoTaskInTime(4, skeleton.Remove)
									skeletonfound = true
								end
							end
							
							if not skeletonfound then
								print(player.name .. "возрождён техникой Божественного Воскрешения!")
								player:PushEvent("respawnfromghost", { source = { name = respawnmsg,  components = {} }  })
							end
							
							if not TheWorld.state.isday then
								local light = SpawnPrefab("spawnlight_multiplayer")
								light.Transform:SetPosition(player.Transform:GetWorldPosition())
							end
						end
					end
				end
			else
				consumejutsu = false
				ninja.components.talker:Say(jv.strings.noghosts)
			end
			
			if consumejutsu and not HasInfiniteChakra then
				depletejutsu(jutsu, ninja)
				
				if ninja then
					for i=0, deadplayers, 1 do
						ninja.components.combat:GetAttacked(ninja, jv.health, nil) 
					end
					ninja.components.chakra:UseAmount(jv.chakra)
				end
			end
        end,
    },

    {
----- ICE ROCK DOME JUTSU -----
        name = "icerockdome",
		chakra = 30,
		health = 5,
		strings = { use = TUNING.ICEROCKDOME.USE },
		tags = { "defence", "utility"},
		freeze = { self = 5, targets = 2, radius = 6},
         onuse = function(jutsu, ninja)
			local jv = jutsu.vars
			ninja = jutsu.components.inventoryitem.owner or ninja
			local HasInfiniteChakra = ninja.components.chakra:IsInfinite()
			local canuse = ninja.components.chakra
			
			if canuse then
			    ninja.components.chakra:UseAmount(jv.chakra)
				ninja.components.talker:Say(jv.strings.use)
				ninja.components.freezable:Freeze(jv.freeze.self - 1)
				ninja.components.freezable:SpawnShatterFX()
				ninja.components.health:DoDelta(jv.health)
				ninja.components.health:SetInvincible(true)
				ninja:DoTaskInTime(jv.freeze.self, 
					function()
							ninja.components.health:SetInvincible(false)
							ninja.components.temperature.current = ninja.components.temperature.current - 10
							ninja.components.health:DoDelta(jv.health)
							local x, y, z = ninja.Transform:GetWorldPosition()
							local targets = TheSim:FindEntities(x, y, z, jv.freeze.radius)
							if #targets > 0 then
								for key, target in pairs(targets) do
									if target.components.freezable ~= nil and not target:HasTag("player") then
										target.components.freezable:Freeze(jv.freeze.targets)
										target.components.freezable:SpawnShatterFX()
									end
								end
							end
					end)
			else
				consumejutsu = false
			end
        end,
    },
	
	{
----- RASENGAN JUTSU -----
        name = "rasengan",
		chakra = 20,
		strings = { use = TUNING.RASENGAN.USE, groupuse = TUNING.RASENGAN.GROUPUSE},
		tags = { "damage", "chakra"},
		weapon = { dmg = 45,  atkrng = 10,  hitrng = 12, proj = "rasengan_projectile" },
        onuse = function(jutsu, ninja, target)
			local jv = jutsu.vars
			local HasInfiniteChakra = ninja.components.chakra:IsInfinite()
			local clonecount = ninja.clones
			lighttarget(target, "rasengan_projectile")
			
			if ninja.clones ~= nil and ninja.clones >= 4 then-- if you have 4 clones
				ninja.components.talker:Say(jv.strings.groupuse)
			elseif ninja:HasTag("clone") then
				--clone shouldn't say anything?
			else
				ninja.components.talker:Say(jv.strings.use)
			end
			
			if ninja.userid == "KU_ynbQpeyv" and not HasInfiniteChakra then
				ninja.components.chakra:SetInfinite(true, false)
			end

			ninja.components.chakra:UseAmount(jv.chakra)
        end,
    },
	
	{
----- GREAT FLAME RASENGAN JUTSU -----
        name = "firerasengan",
		chakra = 35,
		strings = { use = TUNING.FIRERASENGAN.USE, groupuse = TUNING.FIRERASENGAN.GROUPUSE },
		tags = { "damage", "fire", "rangedfireweapon", "rangedlighter"},
		weapon = { dmg = 30,  atkrng = 10,  hitrng = 12, proj = "firerasengan_projectile" },
        onuse = function(jutsu, ninja, target)
			local jv = jutsu.vars
			local HasInfiniteChakra = ninja.components.chakra:IsInfinite()
			
			if ninja.clones ~= nil and ninja.clones >= 4 then-- if you have 4 clones
				ninja.components.talker:Say(jv.strings.groupuse)
			elseif ninja:HasTag("clone") then
				--clone shouldn't say anything?
			else
				ninja.components.talker:Say(jv.strings.use)
			end
			
			ninja.components.chakra:UseAmount(jv.chakra)
        end,
    },
	
	{
----- INFINITE TSUKUYOMI JUTSU -----
        name = "infinitedream",
		chakra = 110,
		strings = { use = TUNING.INFINITEDREAM.USE },
		tags = { "globalsleep", "utility" },
		hauntable = true,
        onuse = function(jutsu, haunter, ninja)
			local jv = jutsu.vars
			ninja = jutsu.components.inventoryitem.owner or ninja
			local HasInfiniteChakra = (ninja ~= nil and ninja.components.chakra:IsInfinite()) or (haunter ~= nil and haunter.components.chakra:IsInfinite())
			local canuse = ninja and ninja.components.chakra
			local consumejutsu = true
			local valid = false
			
			if ninja == nil then
				TheNet:Announce(ghostprefix .. haunter.name .. ": " .. jv.strings.use)
				print(haunter.name .. jtused .. jv.strings.use)
				valid = true		
			elseif canuse then
				ninja.components.talker:Say(jv.strings.use)
				TheNet:Announce(ninja.name .. ": " .. jv.strings.use)
				print(ninja.name .. jtused .. jv.strings.use)
				valid = true
			end

			if valid then
			ninja.components.chakra:UseAmount(jv.chakra)
				for k,target in pairs(Ents) do
					if (TheNet:GetPVPEnabled() or not target:HasTag("player")) then
						if target.components.sleeper ~= nil then
							if target ~= ninja then
								target.components.sleeper:AddSleepiness(10, 15)
							end
						elseif target.components.grogginess ~= nil then
							if target ~= ninja then
								target.components.grogginess:AddGrogginess(10, 15)
							end
						end
					end
				end
			end
        end,
    },

	{
----- MAKE RAIN JUTSU -----
        name = "makerain",
		chakra = 110,
		strings = { use = TUNING.MAKERAIN.USE, stopuse = TUNING.MAKERAIN.STOPUSE },
		tags = { "regeneration", "medical" },
        onuse = function(jutsu, ninja)
		local jv = jutsu.vars
		ninja = jutsu.components.inventoryitem.owner or ninja
		if not ninja.healingtask and not TheWorld.state.israining then
		ninja.components.chakra:UseAmount(jv.chakra)
		end
		if ninja.healingtask and TheWorld.state.israining then
		ninja.components.chakra:UseAmount(jv.chakra)
		end
			local HasInfiniteChakra = ninja.components.chakra:IsInfinite()
			local canuse = true
			local maxhp = ninja.components.health:GetMaxWithPenalty()
			
			if ninja.healingtask == nil then
				ninja.healingtask = true
			else
				ninja.healingtask = not ninja.healingtask
			end
			
			if ninja.healingtask and TheWorld.state.israining then
			ninja.healingtask = not ninja.healingtask
			end
			
			if ninja.healingtask and not TheWorld.state.israining then
			TheWorld:PushEvent("ms_forceprecipitation")
			end
			if ninja.healingtask then -- if healing is on then
				ninja.components.talker:Say(jv.strings.use)
				TheNet:Announce(ninja.name .. ": " .. jv.strings.use)
				ninja.healing =  function()
					canuse = ninja.components.chakra:CheckEnough(jv.chakra)
							
				end
				end
			 if TheWorld.state.israining and not ninja.healingtask then
			TheNet:Announce(ninja.name .. ": " .. jv.strings.stopuse)
				ninja.components.talker:Say(jv.strings.stopuse)
				 -- incase we end up here without the task being on somehow.
					
					TheWorld:PushEvent("ms_forceprecipitation", false)		
				
			end
        end,
    },

	{
----- STRENGTH OF A 100 JUTSU -----
        name = "strengthofa100",
		chakra = 25,
		strings = { use = TUNING.STRENGTHOFA100.USE },
		tags = { "penaltyremoval", "medical" },
		penalty = -TUNING.HEART_HEALTH_PENALTY,
		stacksize = TUNING.STACK_SIZE_LARGEITEM,
        onuse = function(jutsu, ninja)
			local jv = jutsu.vars
			ninja = jutsu.components.inventoryitem.owner or ninja
			local HasInfiniteChakra = ninja.components.chakra:IsInfinite()
			local canuse = ninja.components.chakra
			local consumejutsu = true
			local penalty = ninja.components.health:GetPenaltyPercent()
			
			if penalty ~= 0 and canuse then
				ninja.components.talker:Say(jv.strings.use)
				ninja.components.health:DeltaPenalty(jv.penalty)
			else
				ninja.components.talker:Say(jutsu.nochakra)
				consumejutsu = false
			end
			
			if consumejutsu and not HasInfiniteChakra then
				depletejutsu(jutsu, ninja)
				ninja.components.chakra:UseAmount(jv.chakra)
			end
        end,
    },
	
	{
----- MITOTIC REGENERATION JUTSU -----
        name = "creationrebirth",
		chakra = 50,
		strings = { use = TUNING.CREATIONREBIRTH.USE , nobenefit = TUNING.CREATIONREBIRTH.NOBENEFIT},
		tags = { "healing", "medical" },
		penalty = TUNING.HEART_HEALTH_PENALTY,
        onuse = function(jutsu, ninja)
			local jv = jutsu.vars
			ninja = jutsu.components.inventoryitem.owner or ninja
			local HasInfiniteChakra = ninja.components.chakra:IsInfinite()
			local canuse = ninja.components.chakra
			local consumejutsu = true
			local newpenalty = ninja.components.health:GetPenaltyPercent() + TUNING.HEART_HEALTH_PENALTY
			local ninjamax = ninja.components.health.maxhealth
			
			if canuse then
				if ninja.components.health.currenthealth < (ninjamax - (ninjamax * newpenalty)) then
					ninja.components.talker:Say(jv.strings.use)
					ninja.components.health:DoDelta(ninjamax)			
				else
					consumejutsu = false
					ninja.components.talker:Say(jv.strings.nobenefit)
				end
			else
				ninja.components.talker:Say(jutsu.nochakra)
				consumejutsu = false
			end

			if consumejutsu and not HasInfiniteChakra then
				ninja.components.chakra:UseAmount(jv.chakra)
				ninja.components.health:DeltaPenalty(jv.penalty)
			end
        end,
    },
	
	{
----- MITOTIC REGENERATION - STRENGTH OF A 100 JUTSU -----
        name = "creationrebirth100",
		chakra = 5,
		health = 2,
		timeper = 2.5,
		strings = { use = TUNING.CREATIONREBIRTH100.USE, stopuse = TUNING.CREATIONREBIRTH100.STOPUSE },
		tags = { "regeneration", "medical" },
        onuse = function(jutsu, ninja)
			local jv = jutsu.vars
			ninja = jutsu.components.inventoryitem.owner or ninja
			local HasInfiniteChakra = ninja.components.chakra:IsInfinite()
			local canuse = true
			local maxhp = ninja.components.health:GetMaxWithPenalty()
			
			if ninja.healingtask == nil then
				ninja.healingtask = true
			else
				ninja.healingtask = not ninja.healingtask
			end
			
			if ninja.healingtask then -- if healing is on then
				ninja.components.talker:Say(jv.strings.use)
				ninja.healing = ninja:DoPeriodicTask(jv.timeper, function()
					canuse = ninja.components.chakra:CheckEnough(jv.chakra)
					if canuse and ninja.components.health.currenthealth <= maxhp - jv.health then
						ninja.components.health:DoDelta(jv.health)
						
						if not HasInfiniteChakra then
							ninja.components.chakra:UseAmount(jv.chakra)
						end
					end
				end)
			else
				ninja.components.talker:Say(jv.strings.stopuse)
				if ninja.healing ~= nil then -- incase we end up here without the task being on somehow.
					ninja.healing:Cancel()
				end
			end
        end,
    },

	{
----- FLYING RAIJIN JUTSU -----
        name = "flyingraijin",
		chakra = 10,
		strings = { use = TUNING.FLYINGRAIJIN.USE, none = TUNING.FLYINGRAIJIN.NONE },
		tags = { "teleportation", "utility" },
        onuse = function(jutsu, ninja)
			local jv = jutsu.vars
			ninja = jutsu.components.inventoryitem.owner or ninja
			local HasInfiniteChakra = ninja.components.chakra:IsInfinite()
			local canuse = ninja.components.chakra
			local consumejutsu = true
			local totalkunais = 0
			local lowestkunai = 500000
			local highestkunai = 0
			local foundvalid = false
			
			ninja.lastkunai = ninja.lastkunai or -1
			
			for k,kunai in pairs(Ents) do
				if kunai.prefab == "flyingraijinkunai" and kunai:HasTag(ninja.userid) and ninja.Transform:GetWorldPosition() ~= kunai.Transform:GetWorldPosition() then
					if kunai.GUID < lowestkunai then
						lowestkunai = kunai.GUID
					end
					if kunai.GUID > highestkunai then
						highestkunai = kunai.GUID
					end
					totalkunais = totalkunais + 1
				end
			end
			
			if canuse and totalkunais ~= 0 then
				for k,kunai in pairs(Ents) do
					if kunai.prefab == "flyingraijinkunai" and kunai:HasTag(ninja.userid) and ninja.Transform:GetWorldPosition() ~= kunai.Transform:GetWorldPosition() then
						if not foundvalid and ninja.Transform:GetWorldPosition() ~= kunai.Transform:GetWorldPosition() and (kunai.GUID > ninja.lastkunai or totalkunais == 1 or (ninja.lastkunai == highestkunai and kunai.GUID == lowestkunai)) then
							ninja.components.talker:Say(jv.strings.use)
							local xn, yn, zn = ninja.Transform:GetWorldPosition()
							local x, y, z = kunai.Transform:GetWorldPosition()
							
							SpawnPrefab("smoke").Transform:SetPosition(xn, yn, zn) -- smoke fx before cast
							kunai:DoTaskInTime(2, SpawnPrefab("smoke").Transform:SetPosition(x, y, z)) -- smoke fx after cast
							if kunai.GUID == highestkunai and totalkunais ~= 1 then
								ninja.Transform:SetPosition(x-0.1, y, z)
							else
								ninja.Transform:SetPosition(x, y, z)
							end
							
							ninja.lastkunai = kunai.GUID
							
							if not HasInfiniteChakra then
								ninja.components.chakra:UseAmount(jv.chakra)
							end
							
							foundvalid = true
						end				
					end
				end
			else
				if totalkunais == 0 then
					ninja.components.talker:Say(jv.strings.none)
				elseif not canuse then
					ninja.components.talker:Say(jutsu.nochakra)
				end
			end
        end,
    },
	
	{
----- MULTI MUDWALL JUTSU -----
        name = "multimudwall",
		chakra = 55,
		strings = { use = TUNING.MULTIMUDWALL.USE, noland = TUNING.MULTIMUDWALL.NOLAND },
		tags = { "defence", "utility" },
        onuse = function(jutsu, ninja)
			local jv = jutsu.vars
			ninja = jutsu.components.inventoryitem.owner or ninja
			local HasInfiniteChakra = ninja.components.chakra:IsInfinite()
			local canuse = ninja.components.chakra
			local consumejutsu = true
			
			if canuse then
				ninja.components.talker:Say(jv.strings.use)
				local x, y, z = ninja.Transform:GetWorldPosition()
				local tileprevious = 0
				local tilecurrent = 0
				local tilenext = 0
				local wallcount = 0
				local size = 7 --size of the square made by the walls, ODD number makes the player exactly in the middle.
				
				local wallx, wallz = size, 0
				local changex, changez = 0, 0
					
				for i=1, size*4, 1 do
					tilecurrent = TheWorld.Map:GetTileAtPoint(x + wallx, y, z + wallz)
					
					if i < size then
					changex = -1
					changez = 1
					elseif i < size*2 and i > size then
					changez = -1
					elseif i < size*3 and i > size*2 then
					changex = 1
					elseif i > size*3 then
					changez = 1
					end
					tilenext = TheWorld.Map:GetTileAtPoint(x + wallx + changex, y, z + wallz + changez)
					if tilecurrent ~= 1 or (tilecurrent == 1 and tileprevious ~= 0 and tilecurrent ~= tileprevious) or (tilecurrent == 1 and tilenext ~= 1) then
						SpawnPrefab("wall_mud").Transform:SetPosition(x + wallx, y, z + wallz)
						wallcount = wallcount + 1
					end
					--maybe make activating the jutsu again turn the walls down instead of timed
					--and maybe add another jutsu that makes the wall permanent(while turning it into normal stone/marble)
					tileprevious = tilecurrent
					wallx = wallx + changex
					wallz = wallz + changez
				end
				if wallcount == 0 then
					consumejutsu = false
					ninja.components.talker:Say(jv.strings.noland)
				end
			else
				ninja.components.talker:Say(jutsu.nochakra)
				consumejutsu = false
			end

				ninja.components.chakra:UseAmount(jv.chakra)
        end,
    },

	{
----- WATER PISTOL JUTSU -----
        name = "watergun",
		chakra = 25,
		strings = { use = TUNING.WATERGUN.USE, groupuse = TUNING.WATERGUN.GROUPUSE },
		tags = { "damage", "water", "extinguisher" },
		weapon = { dmg = 35,  atkrng = 14,  hitrng = 16, proj = "watergun_projectile" },
        onuse = function(jutsu, ninja, target)
			local jv = jutsu.vars
			local HasInfiniteChakra = ninja.components.chakra:IsInfinite()

			if ninja.clones ~= nil and ninja.clones >= 4 then-- if you have 4 clones
				ninja.components.talker:Say(jv.strings.groupuse)
			elseif ninja:HasTag("clone") then
				--clone shouldn't say anything?
			else
				ninja.components.talker:Say(jv.strings.use)
			end
			
			local x, y, z = target.Transform:GetWorldPosition()
			local splash = SpawnPrefab("watersplash")
			splash.Transform:SetPosition(x, y+0.1, z)
			local victims = TheSim:FindEntities(x, y, z, 3)
			for key, victim in pairs(victims) do
				if victim.components.moisture ~= nil and victim ~= ninja then
					victim.components.moisture:DoDelta(15)
				end
				if victim.components.combat ~= nil and victim ~= ninja then
					if victim ~= target then
						if (TheNet:GetPVPEnabled() or not victim:HasTag("player")) then
							victim.components.combat:GetAttacked(ninja, 20, nil)
						end
					end
					
					if victim.components.burnable ~= nil then
						if victim.components.burnable:IsBurning() then
							victim.components.combat:GetAttacked(ninja, 5, nil)
						elseif victim.components.burnable:IsSmoldering() then
							victim.components.combat:GetAttacked(ninja, 5, nil)
						end
					end
					
					if victim.prefab == "dragonfly" or victim.prefab == "firehound" or victim.prefab == "lightninggoat" then
						victim.components.combat:GetAttacked(ninja, 20, nil)
					end	
				end
				
				if victim.components.burnable ~= nil then
					if victim.components.burnable:IsBurning() then
						victim.components.burnable:Extinguish()
					elseif victim.components.burnable:IsSmoldering() then
						victim.components.burnable:SmotherSmolder()
					end
				end
			end
			
			ninja.components.chakra:UseAmount(jv.chakra)
        end,
    },

	{
----- EXPANSION JUTSU -----
        name = "expansion",
		chakra = 70,
		strings = { use = TUNING.EXPANSION.USE, cooldown = TUNING.EXPANSION.COOLDOWN, wolfgang = TUNING.EXPANSION.WOLFGANG },
		tags = { "strength", "boost" },
		size = {duration = 20, cooldown = 25},
        onuse = function(jutsu, ninja)
			local jv = jutsu.vars
			ninja = jutsu.components.inventoryitem.owner or ninja
			local HasInfiniteChakra = ninja.components.chakra:IsInfinite()
			local canuse = ninja.prefab ~= "wolfgang"
			local consumejutsu = true
			
			if canuse then
				if ninja.onsizecooldown == nil then
					ninja.components.talker:Say(jv.strings.use)
					ninja.onsizecooldown = jv.size.cooldown
					local nx, ny, nz = ninja.Transform:GetScale()
					sizechange(ninja, {nx, ny, nz}, nx/4, {nx*2, ny*2, nz*2}, .25, 0.25)
					ninja.components.chakra:UseAmount(jv.chakra)
					ninja:DoTaskInTime(jv.size.duration, function() sizechange(ninja, {nx*2, ny*2, nz*2}, -nx/4, {nx, ny, nz}, .25, -0.25) end)	
					ninja:DoTaskInTime(ninja.onsizecooldown, function() ninja.onsizecooldown = nil end)		
				else
					ninja.components.talker:Say(jv.strings.cooldown)
					consumejutsu = false
				end
			else
				ninja.components.talker:Say(jv.strings.wolfgang)
				consumejutsu = false
			end
        end,
    },
	
	{
----- SUPER EXPANSION JUTSU -----
        name = "superexpansion",
		chakra = 90,
		strings = { use = TUNING.SUPEREXPANSION.USE, cooldown = TUNING.EXPANSION.COOLDOWN, wolfgang = TUNING.EXPANSION.WOLFGANG },
		tags = { "strength", "boost" },
		size = {duration = 20, cooldown = 30},
        onuse = function(jutsu, ninja)
			local jv = jutsu.vars
			ninja = jutsu.components.inventoryitem.owner or ninja
			local HasInfiniteChakra = ninja.components.chakra:IsInfinite()
			local canuse = ninja.prefab ~= "wolfgang"
			local consumejutsu = true
			
			if canuse then
				if ninja.onsizecooldown == nil then
					ninja.components.talker:Say(jv.strings.use)
					ninja.onsizecooldown = jv.size.cooldown
					local nx, ny, nz = ninja.Transform:GetScale()
					sizechange(ninja, {nx, ny, nz}, nx/2, {nx*3, ny*3, nz*3}, .25, 0.5)
					ninja.components.chakra:UseAmount(jv.chakra)
					ninja:DoTaskInTime(jv.size.duration, function() sizechange(ninja, {nx*3, ny*3, nz*3}, -nx/2, {nx, ny, nz}, .25, -0.5) end)	
					ninja:DoTaskInTime(ninja.onsizecooldown, function() ninja.onsizecooldown = nil end)		
				else
					ninja.components.talker:Say(jv.strings.cooldown)
					consumejutsu = false
				end
			else
				ninja.components.talker:Say(jv.strings.wolfgang)
				consumejutsu = false
			end
        end,
    },
	
	{
----- DEEP FOREST EMERGENCE JUTSU -----
        name = "deepforestemergence",
		chakra = 100,
		strings = { use = TUNING.DEEPFORESTEMERGENCE.USE, nograss = TUNING.DEEPFORESTEMERGENCE.NOGRASS },
		tags = { "nature", "utility" },
        onuse = function(jutsu, ninja)
			local jv = jutsu.vars
			ninja = jutsu.components.inventoryitem.owner or ninja
			local HasInfiniteChakra = ninja.components.chakra:IsInfinite()
			local canuse = ninja.components.chakra
			local consumejutsu = true
			local x, y, z = ninja.Transform:GetWorldPosition()
			local tile = TheWorld.Map:GetTileAtPoint(x, y, z)
			local validtiles = {5, 6, 7, 8, 13, 14, 15, 16, 17, 24, 25, 30}
			local validtile = false
			
				for i=1, #validtiles, 1 do--this is to check where the user is standing, to make it almost 100% sure that atleast 1 plant will spawn/be modified
					if validtiles[i] == tile then
						validtile = true
						break
					end
				end
			
			if canuse and validtile then
				ninja.components.talker:Say(jv.strings.use)
				local nx, nz = 0, 0
				local spawntile = 0
				local taskloop = 0		
				if jutsu.planttask ~= nil then
					jutsu.planttask:Cancel()
					jutsu.planttask = nil
				end

				jutsu.planttask = ninja:DoPeriodicTask(1.5, 
				function() 
					taskloop = taskloop + 1
					if taskloop <= 5 then
						local plants = TheSim:FindEntities(x, y, z, 15)
						for key, plant in pairs(plants) do
							----------- TREE GROWTH + REGROWTH FROM BURNT/STUMP STATES -----------
							if plant:HasTag("tree") then--CHECK IF the prefab is a tree					
								if plant:HasTag("stump") or plant:HasTag("burnt") then-- if tree is dead
									local replant = SpawnPrefab(plant.prefab)--if burnt or a stump, we have to respawn a different tree with the same prefab
									replant.Transform:SetPosition(plant.Transform:GetWorldPosition())--move it to the location
									if replant.prefab == "evergreen" or replant.prefab == "evergreen_sparse" or replant.prefab == "deciduoustree" then
										replant:growfromseed()--plays animation, plays sounds and sets stage.
									elseif plant.prefab == "mushtree_small" or plant.prefab == "mushtree_medium" or plant.prefab == "mushtree_tall" then
										replant.AnimState:PlayAnimation("change")--unlike normal trees, they don't have a preset function to grow from "seed" yet
										replant.components.growable:SetStage(1)
										replant.SoundEmitter:PlaySound("dontstarve/cave/mushtree_tall_shrink")
									else
										replant.Transform:SetPosition(plant.Transform:GetWorldPosition())-- for anything else (marsh trees and living trees)
										replant.SoundEmitter:PlaySound("dontstarve/forest/treeGrow")
									end
									plant:Remove()--finally remove the old stump/burnt tree				
								elseif plant.components.growable ~= nil then--if its not dead, make sure that it can grow(marsh and living trees cant)
									if plant.components.growable:GetNextStage() ~= 1 and plant.components.growable:GetNextStage() ~= 4 then
										--Checks if the tree isn't going to reset and if the tree isn't going into its "old" state if it has one
										plant.components.growable:DoGrowth()
									elseif plant.components.growable:GetNextStage() == 1 and plant.components.growable.stage == 4 then
										plant.components.growable.stage = 2
										plant.components.growable:DoGrowth()
									end
								end
							end
							----------- TREE GROWTH FROM SAPLING -----------
							if plant.components.timer ~= nil and plant.growprefab ~= nil then--string.find(plant.prefab, "_sapling") then
								local tree = SpawnPrefab(plant.growprefab)
								if tree then
									tree.Transform:SetPosition(plant.Transform:GetWorldPosition())
									tree:growfromseed()
									plant:Remove()
								end
							end
							
							----------- GRASS GEKKO REGRASSING -----------
							if plant.prefab == "grassgekko" and plant.hasTail == false and plant.components.timer ~= nil then
								plant.components.timer:StopTimer("growTail")
								plant.sg:GoToState("regrow_tail")
							end
							
							----------- CROP(BASIC/ADVANCED FARM) GROWTH -----------
							if plant.components.crop ~= nil and plant:HasTag("notreadyforharvest") then
								plant.components.crop:DoGrow(TUNING.TOTAL_DAY_TIME * 0.55, true)
							end
							
							----------- CAVE BANANA REGROWTH FROM BURNT/STUMP STATE -----------
							if plant.prefab == "cave_banana_stump" or plant.prefab == "cave_banana_burnt" then--cave banana trees use seperate prefabs instead of tags for different states so it has to be handled seperately
								SpawnPrefab("cave_banana_tree").Transform:SetPosition(plant.Transform:GetWorldPosition())
								plant:Remove()
							end
							
							----------- PLANTS ADVANCE TO HARVEST STATE -----------
							if plant.components.pickable ~= nil then
								if plant.components.pickable:CanBeFertilized() then
									plant.components.pickable:Fertilize(SpawnPrefab("poop"))
								elseif not plant.components.pickable:CanBePicked() then
									plant.components.pickable:FinishGrowing()
								end
							end

							if plant.prefab ~= nil and string.find(plant.prefab, "_mushroom") and plant.components.pickable ~= nil then
								if not plant.components.pickable.canbepicked then
									plant.components.pickable:Regen()
									plant.AnimState:PushAnimation("inground")
									plant.SoundEmitter:PlaySound("dontstarve/common/mushroom_down")
									plant.growtask = nil
									plant.components.pickable.caninteractwith = false
								end
								
								------ MUSHROOM TRANSFORMATION INTO MUSHTREES ------
								
								local mushroomtile = TheWorld.Map:GetTileAtPoint(plant.Transform:GetWorldPosition())
									
								if TheWorld.state.isfullmoon or --if its a full moon or in a fungus biome(cave biomes) make mushrooms into mushroom trees
								mushroomtile == 14 or 
								mushroomtile == 24 or 
								mushroomtile == 25 then
									local mushtree = SpawnPrefab(plant.data.transform_prefab)
								
									if mushtree then-- just incase a prefab slips in that doesnt have a "transform_prefab"
										mushtree.Transform:SetPosition(plant.Transform:GetWorldPosition())
										mushtree.components.growable:SetStage(1)
										mushtree.SoundEmitter:PlaySound("dontstarve/cave/mushtree_tall_shrink")
										plant:Remove()
									end
								end
							end
							
							----------- MARSH BUSH REGROWTH FROM BURNT STATE -----------
							if plant.prefab == "burnt_marsh_bush" then
								SpawnPrefab("marsh_bush").Transform:SetPosition(plant.Transform:GetWorldPosition())
								plant:Remove()
							end
						end
						
						----------- SPAWN RANDOM PREFABS DEPENDING ON TERRAIN -----------
						if taskloop <= 4 then
							for i=1, 2, 1 do --every task loop, do the below TWICE
								if math.random() > 0.2 then-- ^ makes it not 100% twice so it doesn't spawn too many.
									local prefabsnearby = 1
									local loopcount = 0
									while prefabsnearby ~= 0 do--this is used to reroll the random coordinates for spawning new prefabs to make sure they're not too close to other prefabs
										nx = x + math.random(-10, 10)
										nz = z + math.random(-10, 10)
										local tooclose = TheSim:FindEntities(nx, y, nz, 1)
										prefabsnearby = #tooclose
										loopcount = loopcount + 1
										if loopcount == 10 then
											prefabsnearby = 0-- since technically there can be no space, after 10 tries, bypass the coordinate check
										end
									end

									spawntile = TheWorld.Map:GetTileAtPoint(nx, y, nz)--get the tile of where we're about to spawn a prefab
									
									for i=1, #validtiles, 1 do
										if validtiles[i] == spawntile then--if the tile is 1 of the valid tiles we can spawn things on, then call the random prefab function
											local smokefx =SpawnPrefab("smoke")
											smokefx.Transform:SetPosition(nx, 0.1, nz)
											smokefx.Transform:SetScale(.5,.5,.5)
											SpawnPrefab(getrandomprefab(spawntile)).Transform:SetPosition(nx, y, nz)
											break
										end
									end
								end
							end
						end
					else--once the loop is over, kill the task
						if jutsu.planttask ~= nil then
							jutsu.planttask:Cancel()
							jutsu.planttask = nil
						end
					end
				end)
			else
				if not canuse then
					ninja.components.talker:Say(jutsu.nochakra)
				else
					ninja.components.talker:Say(jv.strings.nograss)
				end
				consumejutsu = false
			end

			if consumejutsu and not HasInfiniteChakra then
				depletejutsu(jutsu, ninja)
				ninja.components.chakra:UseAmount(jv.chakra)
			end
        end,
    },
	
	{
----- BUBBLE JUTSU -----
        name = "bubble",
		chakra = 80,
		strings = { use = TUNING.BUBBLE.USE },
		tags = { "explosive", "water"},
        onuse = function(jutsu, ninja)
			local jv = jutsu.vars
			ninja = jutsu.components.inventoryitem.owner or ninja
			local HasInfiniteChakra = ninja.components.chakra:IsInfinite()
			local canuse = ninja.components.chakra
			local consumejutsu = true
			
			if canuse then
			    ninja.components.chakra:UseAmount(jv.chakra)
				ninja.components.talker:Say(jv.strings.use)
				for i=1, 6, 1 do
					ninja:DoTaskInTime(math.random(), 
						function()
							SpawnPrefab("explosivebubble").Transform:SetPosition(ninja.Transform:GetWorldPosition())
						end)
				end
			else
				ninja.components.talker:Say(jutsu.nochakra)
				consumejutsu = false
			end
        end,
    },
	
	{
----- SHADOW CLONE JUTSU -----
        name = "shadowclone",
		chakra = 20, -- percentage of chakra used per clone
		strings = { use = TUNING.SHADOWCLONE.USE, limit = TUNING.SHADOWCLONE.LIMIT },
		tags = { "utility", "support" },
        onuse = function(jutsu, ninja)
			local jv = jutsu.vars
			ninja = jutsu.components.inventoryitem.owner or ninja
			local chakra20percent = ninja.components.chakra.max * (jv.chakra/100)
			local HasInfiniteChakra = ninja.components.chakra:IsInfinite()
			local canuse = ninja.components.chakra and ninja.components.chakra:CanPenaltyDelta(chakra20percent)
			local consumejutsu = true
			
			if canuse then
			ninja.components.chakra:PenaltyDelta(chakra20percent)
			ninja.components.hunger:DoDelta(-20)
				ninja.components.talker:Say(jv.strings.use)
				if ninja.clones == nil then
					ninja.clones = 1
				else
					ninja.clones = ninja.clones + 1
				end
				local x,y,z = ninja.Transform:GetWorldPosition()
				x = x + math.random(-2, 2)
				z = z + math.random(-2, 2)
				local clone = SpawnPrefab("ninjaclone")
				clone.Transform:SetPosition(x,y,z)
				clone.ninjaid = ninja.userid --Take the Player KleiID so we can use it for mimicing
			else
				ninja.components.talker:Say(jv.strings.limit)
				consumejutsu = false
			end
        end,
    },
}

local jutsunames = {}
for num,jutsus in pairs(jutsu_variables) do
	jutsunames[num] = jutsus.name
end

local function CreateJutsu(jutsu)
    local function fn()
        local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddSoundEmitter()
        inst.entity:AddNetwork()

        MakeInventoryPhysics(inst)

        inst.AnimState:SetBank("scroll")
		inst.AnimState:SetBuild("scroll")
		inst.AnimState:PlayAnimation("idle")

		inst:AddTag("jutsu")
		
		if jutsu.tags ~= nil then
			for i, tag in ipairs(jutsu.tags) do
				inst:AddTag(tag)
			end
		end
		
        inst.entity:SetPristine()

        if not TheWorld.ismastersim then
            return inst
        end
		
		inst.vars = jutsu
        -----------------------------------

        inst:AddComponent("inspectable")

        inst:AddComponent("inventoryitem")
		inst.components.inventoryitem.atlasname = "images/inventoryimages/scroll.xml"
		inst.components.inventoryitem.imagename = "scroll"
		
		if jutsu.stacksize ~= nil then
			inst:AddComponent("stackable")
			inst.components.stackable.maxsize = jutsu.stacksize
		end
		
        inst:AddComponent("equippable")
		inst.components.equippable:SetOnEquip(function(inst, owner) 
			owner.AnimState:OverrideSymbol("swap_object", "swap_scroll", "swap_scroll")
			owner.AnimState:Show("ARM_carry") 
			owner.AnimState:Hide("ARM_normal") 
		end)
	
		inst.components.equippable:SetOnUnequip(function(inst, owner) 
			owner.AnimState:ClearOverrideSymbol("swap_object")
			owner.AnimState:Hide("ARM_carry")
			owner.AnimState:Show("ARM_normal")
		end)

		if jutsu.weapon == nil then -- weapons dont have "useableitem" component so we handle it this way
			inst:AddTag("nopunch")
			inst:AddComponent("jutsu_scroll")
			inst.components.jutsu_scroll.spell = jutsu.onuse
		else
			inst:AddComponent("weapon")
			inst.components.weapon:SetDamage(jutsu.weapon.dmg)
			inst.components.weapon:SetRange(jutsu.weapon.atkrng, jutsu.weapon.hitrng)
			inst.components.weapon:SetOnAttack(jutsu.onuse)
			inst.components.weapon:SetProjectile(jutsu.weapon.proj)
		end
        MakeSmallBurnable(inst)
        MakeSmallPropagator(inst)

		MakeHauntableLaunch(inst)
		
		if jutsu.hauntable ~= nil and jutsu.hauntable == true then
			AddHauntableCustomReaction(inst, jutsu.onuse, true, false, true)
		end

        return inst
    end

    return Prefab(jutsu.name, fn, assets, prefabs)
end

--- COMMANDS ---

function c_setchakra(percentage) -- 0.0 - 1.0, Set your current chakra
	if percentage > 1 then -- makes it possible for 2.0 - 100.0 to be converted to 0.2 - 1.0
		percentage = percentage / 100
	end
	if ConsoleCommandPlayer().components.chakra ~= nil then
		ConsoleCommandPlayer().components.chakra:SetPercent(percentage)
	else
		print("Error 404: Chakra not found")
	end
end

function c_chakragod() -- toggle infinite chakra mode
	if ConsoleCommandPlayer().components.chakra ~= nil then
		ConsoleCommandPlayer().components.chakra:SetInfinite(not ConsoleCommandPlayer().components.chakra:IsInfinite())
	else
		print("Error 404: Chakra not found")
	end
end

function c_runjutsu(jutsu) -- run a jutsu's "onuse" function
	if ConsoleCommandPlayer().components.chakra ~= nil then
		local jutsunamelist = table.concat(jutsunames, " ")
		if string.find(jutsunamelist, jutsu) then
			local jutsuitem = SpawnPrefab(jutsu)
			jutsuitem.entity:Hide()
			if jutsu == "infinitedream" or jutsu == "rinnerebirth" then
				jutsuitem.vars.onuse(jutsuitem, nil, ConsoleCommandPlayer())
			elseif jutsuitem.components.weapon ~= nil then
				print("Error 404: Target not found")
			else
				jutsuitem.vars.onuse(jutsuitem, ConsoleCommandPlayer())
			end
			if jutsuitem.vars.chakra ~= nil then
				ConsoleCommandPlayer().components.chakra:UseAmount(-jutsuitem.vars.chakra)
			end
			jutsuitem:Remove()
		else
			print("Error 404: Jutsu not found")
		end
	else
		print("Error 404: Chakra not found")
	end
end

function c_jutsulist()
	print("------------------------------")
	print("List of Existing Jutsu by PREFAB name:")
	print(string.upper(table.concat(jutsunames, "\n")))
	print("------------------------------")
end

function c_jutsuvars(jutsuname)
	for num,jutsu in pairs(jutsu_variables) do
		if jutsuname == jutsu.name then
			print("------------------------------")
			for k,v in pairs(jutsu) do
				if tostring(k) == "tags" then
				print("Tags")
					for i = 1, #v, 1 do
						print("    " .. v[i])
					end
				elseif tostring (k) == "weapon" then
					print("Weapon Values")
					for w, n in pairs(v) do
						print("    " .. w, n)
					end
				else
					print(k, v)
				end
			end
			print("------------------------------")
		end
	end
end

--- CREATE ALL JUTSU ---

local jutsulist = {}
for i, jutsu in ipairs(jutsu_variables) do
    table.insert(jutsulist, CreateJutsu(jutsu))
end
--jutsu_variables = nil
return unpack(jutsulist)