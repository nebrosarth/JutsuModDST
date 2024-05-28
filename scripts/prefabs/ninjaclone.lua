local assets =
{
    Asset("ANIM", "anim/firetornado.zip"),
	Asset("ANIM", "anim/bubble.zip"),
}

local clonebrain = require("brains/clonebrain")

local function GetBBA(inst)
	local str = inst.GetDebugString and inst:GetDebugString()
	if str then
		local bank, build, anim = string.match(str, "AnimState: bank: (.*) build: (.*) anim: (.*)")
		for i in string.gmatch(anim, "%S+") do
			anim = i
			break
		end

		return bank, build
	end
end

local function GetTemperature(inst)
    if inst.components.temperature ~= nil then
        return inst.components.temperature:GetCurrent()
    elseif inst.player_classified ~= nil then
        return inst.player_classified.currenttemperature
    else
        return TUNING.STARTING_TEMP
    end
end

local function IsFreezing(inst)
    if inst.components.temperature ~= nil then
        return inst.components.temperature:IsFreezing()
    elseif inst.player_classified ~= nil then
        return inst.player_classified.currenttemperature < 0
    else
        return false
    end
end

local function IsOverheating(inst)
    if inst.components.temperature ~= nil then
        return inst.components.temperature:IsOverheating()
    elseif inst.player_classified ~= nil then
        return inst.player_classified.currenttemperature > TUNING.OVERHEAT_TEMP
    else
        return false
    end
end

local function GetMoisture(inst)
    if inst.components.moisture ~= nil then
        return inst.components.moisture:GetMoisture()
    elseif inst.player_classified ~= nil then
        return inst.player_classified.moisture:value()
    else
        return 0
    end
end

local function GetMaxMoisture(inst)
    if inst.components.moisture ~= nil then
        return inst.components.moisture:GetMaxMoisture()
    elseif inst.player_classified ~= nil then
        return inst.player_classified.maxmoisture:value()
    else
        return 100
    end
end

local function GetMoistureRateScale(inst)
    if inst.components.moisture ~= nil then
        return inst.components.moisture:GetRateScale()
    elseif inst.player_classified ~= nil then
        return inst.player_classified.moistureratescale:value()
    else
        return RATE_SCALE.NEUTRAL
    end
end

local function ShouldKnockout(inst)
    return DefaultKnockoutTest(inst) and not inst.sg:HasStateTag("yawn")
end

local function getplayer(inst)
	--local x,y,z = inst.Transform:GetWorldPosition()
	--local players = TheSim:FindEntities(x, y, z, 50, {"player"}, {"clone"})
	for k,player in pairs(Ents) do
		if player.userid ~= nil and player.userid == inst.ninjaid then
			return player
		end
	end
	return -1
end

local function retargetfn(inst)
    --Find things attacking leader
    local leader = inst.components.follower:GetLeader()
    return leader ~= nil
        and FindEntity(
            leader,
            TUNING.SHADOWWAXWELL_TARGET_DIST,
            function(enemy)
                return enemy ~= inst
                    and (enemy.components.combat:TargetIs(leader) or
                        enemy.components.combat:TargetIs(inst))
                    and inst.components.combat:CanTarget(enemy)
            end,
            { "_combat" }, -- see entityreplica.lua
            { "playerghost", "INLIMBO" }
        )
        or nil
end

local function keeptargetfn(inst, target)
	return inst.components.follower:IsNearLeader(20)
        and inst.components.combat:CanTarget(target)
		 and not (inst.components.follower ~= nil and
                (inst.components.follower.leader == target or inst.components.follower:IsLeaderSame(target)))
end

local function onattacked(inst, data)
	local clonemaker = getplayer(inst)
	
	if data.attacker == clonemaker then
		inst.components.health:Kill()
	else
		inst.components.combat:SetTarget(data.attacker)
		inst.components.combat:ShareTarget(data.attacker, 30, function(friend)
			return not friend.components.health:IsDead()
				and friend.components.follower ~= nil
				and friend.components.follower.leader == inst.components.follower.leader
		end, 10)
	end
		
end

local function doattack(inst, data)
	--inst.sg:GoToState("attack", data.target)
	
	if inst.components.health and not inst.components.health:IsDead() and (not inst.sg:HasStateTag("busy") or inst.sg:HasStateTag("hit")) then
		local buffered_attack = BufferedAction(inst, data.target, ACTIONS.ATTACK)
		inst:PushBufferedAction(buffered_attack)
	end
	
	if inst.components.chakra.current <= 0 then
		inst.components.health:Kill()
	end
end

local function PeriodicChecks(inst)
	if inst.ninjaid ~= -1 then
		local clonemaker = getplayer(inst)
		
		if clonemaker ~= nil and clonemaker ~= -1 and not inst.components.health:IsDead() then
			inst.components.health:DoDelta(1)
			
			local currentbank, currentbuild = GetBBA(inst)
			local newbank, newbuild = GetBBA(clonemaker)
			
			local osx, osy, osz = inst.Transform:GetScale()
			local nsx, nsy, nsz = clonemaker.Transform:GetScale()
			
			if currentbuild ~= newbuild and newbuild ~= "werebeaver_build" then
				inst.AnimState:SetBuild(newbuild)--(clonemaker.prefab)
			end
			
			if osx ~= nsx or osy ~= nsy or osz ~= nsz then
				inst.Transform:SetScale(nsx, nsy, nsz)
			end
			
			if clonemaker.clones ~= nil and inst.components.chakra.max ~= (inst.basemaxchakra / clonemaker.clones) then
				inst.components.chakra:SetMaxChakra(inst.basemaxchakra / clonemaker.clones)
				inst.components.health.maxhealth = inst.basemaxhealth / clonemaker.clones
			end
			
			if inst.components.chakra.current > inst.components.chakra.max then
				inst.components.chakra:SetCurrentChakra(inst.components.chakra.max)
			end
			
			if inst.components.health.currenthealth > inst.components.health.maxhealth then
				inst.components.health.currenthealth = inst.components.health.maxhealth
			end
			
			if clonemaker.components.beard ~= nil then
				local growthsizes = {16, 8, 4}
				local beardarg1 = "beard"
				local beardarg2 = "beard"
				local size = "0"
				if clonemaker.prefab == "webber" then
					growthsizes = {9, 6, 3}
					beardarg1 = "beard_silk"
					beardarg2 = "beardsilk"
				end
				
				if clonemaker.components.beard.daysgrowth >= growthsizes[1] then
					size = "_long"
				elseif clonemaker.components.beard.daysgrowth >= growthsizes[2] then
					size = "_medium"
				elseif clonemaker.components.beard.daysgrowth >= growthsizes[3] then
					size = "_short"
				end
				
				if size ~= "0" then
					inst.AnimState:OverrideSymbol("beard", beardarg1, beardarg2 .. size)
				end
			end
			
			local hand = clonemaker.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
			
			if inst.hand ~= nil and hand ~= nil then
				if inst.hand.prefab == "grass" or (inst.hand.prefab ~= hand.prefab and not(inst.hand.prefab == "raijinkunai" and hand.prefab == "flyingraijinkunai") and not(inst.hand.prefab == "lucyclone" and hand.prefab == "lucy")) then
					--if inst.hand ~= nil then -- if hand is empty then there is nothing to remove
						inst.hand:Remove()--delete previous held item
					--end
					
					if hand.prefab == "flyingraijinkunai" then
					inst.components.inventory:Equip(SpawnPrefab("raijinkunai"))
					elseif hand.prefab == "lucy" then
						inst.components.inventory:Equip(SpawnPrefab("lucyclone"))
					else
						inst.components.inventory:Equip(SpawnPrefab(hand.prefab))
					end
					inst.hand = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
					
					if inst.hand.components.projectile ~= nil then
						inst.hand.components.projectile:SetOnHitFn(function(proj) proj:Remove() end)
					end
					
					inst.brain:Stop()
					inst.brain:Start()
				elseif inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS) == nil then
					if inst.hand ~= nil and not inst.hand:HasTag("catchable") then -- should be nil but just incase
						inst.hand:Remove()
					end
					inst.components.inventory:Equip(SpawnPrefab(hand.prefab))
					inst.hand = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
					
					if inst.hand.components.projectile ~= nil then
						inst.hand.components.projectile:SetOnHitFn(function(proj) proj:Remove() end)
					end
					
					--inst.brain:Stop()
					--inst.brain:Start()
				end
			end
			
			if clonemaker.components.chakra:GetPercentWithPenalty() < .2 or
				IsOverheating(inst) or
				IsFreezing(inst) or 
				clonemaker.components.health:GetPercent() < .15 or
				inst.components.chakra:GetPercent() < .1 or 
				newbuild == "werebeaver_build" or
				getplayer(inst) == -1 then
				
				inst.periodiccheck:Cancel()
				inst.components.health:Kill()
				
			end
		elseif clonemaker == nil or clonemaker == -1 then
			inst.periodiccheck:Cancel()
			inst.components.health:Kill()
		end
	end
end

local function OnSummoned(inst)
	--print("Clonemaker ID: " .. inst.ninjaid)
	if inst.ninjaid ~= -1 then
	local clonemaker = getplayer(inst)
		if clonemaker ~= nil then
		
			inst.components.follower:SetLeader(clonemaker)
			inst.components.follower:StartLeashing()
			if clonemaker.prefab == "webber" then
				inst:AddTag("spiderwhisperer")
			end
			SpawnPrefab("smoke").Transform:SetPosition(inst.Transform:GetWorldPosition())
			
			local bank, build = GetBBA(clonemaker)
			inst.AnimState:SetBank(bank)--("wilson")
			inst.AnimState:SetBuild(build)--(clonemaker.prefab)
			inst.AnimState:PlayAnimation("idle", true)
			
			local allclothing = clonemaker.components.skinner:GetClothing()
			for k,v in pairs(allclothing) do
				inst.components.skinner:SetClothing(v)
			end

			inst.components.named:SetName(clonemaker.name)
			
			inst.basemaxhealth = clonemaker.components.health.maxhealth * .75
			inst.basemaxchakra = clonemaker.components.chakra.max / 2 --normally 50
			local maxhealth = 0
			local maxchakra = 0
			if clonemaker.clones ~= nil and clonemaker.clones > 0 then
				maxhealth = inst.basemaxhealth / clonemaker.clones
				maxchakra = inst.basemaxchakra / clonemaker.clones
			else
				maxchakra = inst.basemaxchakra
				maxhealth = inst.basemaxhealth
			end
			inst.components.health.maxhealth = maxhealth
			--inst.components.chakra.max = inst.maxchakra
			inst.components.chakra:SetMaxChakra(maxchakra)
			inst.components.chakra:SetCurrentChakra(maxchakra)
			
			local head = clonemaker.components.inventory:GetEquippedItem(EQUIPSLOTS.HEAD)
			local body = clonemaker.components.inventory:GetEquippedItem(EQUIPSLOTS.BODY)
			local hand = clonemaker.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
			
			if head then
				inst.components.inventory:Equip(SpawnPrefab(head.prefab))
				inst.head = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HEAD)
			end
			if body then
				inst.components.inventory:Equip(SpawnPrefab(body.prefab))
				inst.body = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.BODY)
			end
			if hand then
				if hand.prefab == "flyingraijinkunai" then
					inst.components.inventory:Equip(SpawnPrefab("raijinkunai"))
				elseif hand.prefab == "lucy" then
					inst.components.inventory:Equip(SpawnPrefab("lucyclone"))
				else
					inst.components.inventory:Equip(SpawnPrefab(hand.prefab))
				end
				inst.hand = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
				if inst.hand.components.projectile ~= nil then
					inst.hand.components.projectile:SetOnHitFn(function() inst.hand:Remove() end)
				end
				--inst.hand:ListenForEvent("ondropped", function() inst.hand:DoTaskInTime(2, function() inst.hand:Remove() end) end)
			else
				local handitem = SpawnPrefab("cutgrass")
				inst.components.inventory:GiveItem(handitem)
				inst.hand = handitem
			end
			
			PeriodicChecks(inst)
		end	
	end
end

local function clonemain()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
	inst.entity:AddDynamicShadow()
	inst.entity:AddLightWatcher()
    inst.entity:AddNetwork()

    inst.AnimState:SetBank("scroll")
    inst.AnimState:SetBuild("scroll")
    inst.AnimState:PlayAnimation("idle", false)
	
	inst.AnimState:Hide("ARM_carry")
    inst.AnimState:Hide("HAT")
    inst.AnimState:Hide("HAT_HAIR")
    inst.AnimState:Show("HAIR_NOHAT")
    inst.AnimState:Show("HAIR")
    inst.AnimState:Show("HEAD")
    inst.AnimState:Hide("HEAD_HAT")
	
	inst.AnimState:OverrideSymbol("fx_wipe", "wilson_fx", "fx_wipe")
    inst.AnimState:OverrideSymbol("fx_liquid", "wilson_fx", "fx_liquid")
    inst.AnimState:OverrideSymbol("shadow_hands", "shadow_hands", "shadow_hands")

    --Additional effects symbols for hit_darkness animation
    inst.AnimState:AddOverrideBuild("player_hit_darkness")
    inst.AnimState:AddOverrideBuild("player_receive_gift")
    inst.AnimState:AddOverrideBuild("player_actions_uniqueitem")
	
	inst.DynamicShadow:Enable(true)
	inst.DynamicShadow:SetSize(1.3, .6)
	
	inst.Transform:SetFourFaced()
	
	-----
	
	MakeCharacterPhysics(inst, 75, .5)
	
	-----
	
	inst:AddTag("_named")
	
	-----
	
	inst.entity:SetPristine()

	inst.persists = false
	
    if not TheWorld.ismastersim then
        return inst
    end
	
	-----
	inst:RemoveTag("_named")
	
	-----
	
	inst:AddComponent("rider") -- required for stategraph
	inst:AddComponent("skinner")
	inst:AddComponent("catcher") -- catch le boomerganerinos
	
	inst:AddComponent("health")
    inst.components.health:SetMaxHealth(TUNING.WILSON_HEALTH/2)
	
	inst:AddComponent("sanity")
	inst.components.sanity:SetMax(9999)
	
	inst:AddComponent("hunger")
	inst.components.hunger:SetMax(9999)
	
	--inst:AddComponent("chakra")
	
	inst:AddComponent("combat")
    inst.components.combat:SetDefaultDamage(TUNING.UNARMED_DAMAGE)
    --inst.components.combat.GetGiveUpString = giveupstring
    --inst.components.combat.GetBattleCryString = battlecrystring
    inst.components.combat.hiteffectsymbol = "torso"
	inst.components.combat:SetAttackPeriod(TUNING.SHADOWWAXWELL_ATTACK_PERIOD)
    inst.components.combat:SetRange(2)
    inst.components.combat:SetKeepTargetFunction(keeptargetfn)
	inst.components.combat:SetRetargetFunction(2, retargetfn)
	
	inst:AddComponent("follower")
	
	inst:ListenForEvent("attacked", onattacked)
	inst:ListenForEvent("doattack", doattack)
	
	--inst.components.skinner:SetSkinMode("normal_skin")
    
	inst:AddComponent("inspectable")
	
	inst:AddComponent("inventory")
	inst.components.inventory:DisableDropOnDeath()
	
	inst:AddComponent("locomotor")
	inst.components.locomotor:SetSlowMultiplier(0.6)
    inst.components.locomotor.pathcaps = { ignorecreep = true } -- 'player' cap not actually used, just useful for testing
    inst.components.locomotor.runspeed = TUNING.SHADOWWAXWELL_SPEED -- 6
    inst.components.locomotor.fasteronroad = true
    inst.components.locomotor:SetTriggersCreep(not inst:HasTag("spiderwhisperer"))

	inst:AddComponent("temperature")
    inst.components.temperature.usespawnlight = true
	
	inst:AddComponent("moisture")
	
	inst:AddComponent("grogginess")
    inst.components.grogginess:SetResistance(3)
    inst.components.grogginess:SetKnockOutTest(ShouldKnockout)
	
	MakeMediumBurnableCharacter(inst, "torso")
    inst.components.burnable:SetBurnTime(TUNING.PLAYER_BURN_TIME)

    MakeHugeFreezableCharacter(inst, "torso")
    inst.components.freezable:SetDefaultWearOffTime(TUNING.PLAYER_FREEZE_WEAR_OFF_TIME)
	
	-----
	
	inst:AddTag("clone")
	inst:AddTag("character")
	
	-----
	
	inst.GetTemperature = GetTemperature 
    inst.IsFreezing = IsFreezing 
    inst.IsOverheating = IsOverheating 
    inst.GetMoisture = GetMoisture 
    inst.GetMaxMoisture = GetMaxMoisture 
    inst.GetMoistureRateScale = GetMoistureRateScale 
        
	-----
	
	inst:SetStateGraph("SGclone")
	
	-----
	
	inst:AddComponent("named")
	inst.components.named:SetName("Shadow Clone")
	-----
	
	inst:ListenForEvent("death", 
		function()
			if inst.brain ~= nil then
				inst.brain:Stop()
			end
			if inst.periodiccheck ~= nil then
				inst.periodiccheck:Cancel()
			end
			if inst.head then inst.head:Remove() end
			if inst.body then inst.body:Remove() end
			if inst.hand then inst.hand:Remove() end
			local clonemaker = getplayer(inst)
			if clonemaker ~= -1 then
				clonemaker.components.chakra:PenaltyDelta(-clonemaker.components.chakra.max * (20/100))-- 20 will be configurable
				clonemaker.clones = clonemaker.clones - 1
				if clonemaker.clones == 0 then
					clonemaker.clones = nil
				end
			end
			inst:DoTaskInTime(0.5, function() SpawnPrefab("smoke").Transform:SetPosition(inst.Transform:GetWorldPosition()) end)
		end)
	
	-----
	
	inst.ninjaid = inst.ninjaid or -1
	--inst.deathcause = "Poof" -- had to declare this so it doesnt crash on death
	
	------
	inst:SetBrain(clonebrain)
	
	inst:DoTaskInTime(0.1, function() OnSummoned(inst) end)
	
	inst.periodiccheck = inst:DoPeriodicTask(1, function() PeriodicChecks(inst) end)
	
	inst:DoTaskInTime(300, function() inst.periodiccheck:Cancel() inst.components.health:Kill() end)-- kill clone after 5 mins

    return inst
end

return Prefab("ninjaclone", clonemain, assets)