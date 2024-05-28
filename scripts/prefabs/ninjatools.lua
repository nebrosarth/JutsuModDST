local assets =
{
	Asset("ANIM", "anim/kunai.zip"),
	Asset("ANIM", "anim/swap_kunai.zip"),
	Asset("ANIM", "anim/kusanagi.zip"),
    Asset("ANIM", "anim/swap_kusanagi.zip"), --default
	Asset("ANIM", "anim/swap_kusanagi2.zip"), --yellow
	Asset("ANIM", "anim/swap_kusanagi3.zip"), --light blue
	Asset("ANIM", "anim/swap_kusanagi4.zip"), -- dark blue
	Asset("ANIM", "anim/lucy_axe.zip"),
    Asset("ANIM", "anim/swap_lucy_axe.zip"),
	Asset("ATLAS", "images/inventoryimages/kusanagi.xml"),
	Asset("ATLAS", "images/inventoryimages/flyingraijinkunai.xml"),	
	
}
--- COMMON FUNCTIONS ---

local function autoequip(wep, ninja)
	for key, samewep in pairs(ninja.components.inventory.itemslots) do
		if samewep.prefab == wep.prefab then
			if samewep.components.equippable ~= nil then
				ninja.components.inventory:Equip(samewep)
			end
		end
	end
end

--- FLYING RAIJIN KUNAI FUNCTIONS ---

local function onhitflyingraijin(kunai, ninja, target)
	kunai.Physics:CollidesWith(COLLISION.WORLD)
	kunai.AnimState:SetOrientation(ANIM_ORIENTATION.Default)
	kunai.AnimState:PlayAnimation("idle")
	autoequip(kunai, ninja)
end

local function onpickupflyingraijin(kunai, ninja)
	if ninja ~= nil then
		kunai.lastninja = ninja.userid
	end
end

local function ondroppedflyingraijin(kunai)
	local ninjaid = kunai.lastninja
	if ninjaid ~=nil then
		if kunai.tagged ~= nil then
			kunai:RemoveTag(kunai.tagged)
		end
		kunai:AddTag(ninjaid)
		kunai.tagged = ninjaid
	end
end

local function OnLoad(kunai, data)
	local ninjaid = nil
	if data ~= nil then
		ninjaid = data.taggedid
	end
	if ninjaid ~=nil then
		if kunai.tagged ~= nil then
			kunai:RemoveTag(kunai.tagged)
		end
		kunai:AddTag(ninjaid)
		kunai.tagged = ninjaid
	end
end

local function OnSave(kunai, data)
	 local ninjaid = kunai.tagged
	 if ninjaid ~= nil then
		data.taggedid = ninjaid
	 end
end

--- SWORD OF KUSANAGI FUNCTIONS ---

local function onkusanagiattack(wep, ninja, target)
	local canuse = ninja.components.chakra:CheckEnough(10)
	if target.oncooldown == nil and wep.chakraon and canuse and not target:HasTag("lightningrod") then
		ninja.components.chakra:UseAmount(30)

		local duration = 3 --DURATION OF PARALYSES
		local scale = 1--SCALE OF THUNDER FX
		target.oncooldown = 6
		local light = 2 -- RADIUS OF THUNDER FX LIGHT
		local targetisdead = false --^ These are changed depending on creature size
		if target:HasTag("smallcreature") then
			duration = 4.5
			target.oncooldown = 8
			scale = 0.5
			light = 1
		elseif target:HasTag("largecreature") or target:HasTag("tentacle_pillar") then
			duration = 1.5
			target.oncooldown = 4
			scale = 2
			light = 3
		end
		
		local x, y, z = target.Transform:GetWorldPosition()
		
		local lightningfx = SpawnPrefab("thunder")
		lightningfx.Transform:SetPosition(x, y+0.1, z)
		lightningfx.Transform:SetScale(scale, scale, scale)
		lightningfx.Light:SetRadius(light)
		
		if target.components.combat ~= nil then
			if target:HasTag("wet") or (target.components.moisture ~= nil and target.components.moisture:IsWet()) then
				target.components.combat:GetAttacked(ninja, 15, nil)
			end
		end
		
		if target.brain ~= nil then
			target.brain:Stop()
		end		
		
		if target.components.combat ~= nil then
			target.components.combat:CancelAttack()
			target.components.combat:SetTarget(nil)
		end
		
		if target.components.locomotor ~= nil then
			target.components.locomotor:Stop()
		end
		
		target.deathtask = wep:DoPeriodicTask(1, 
		function() 
			if target.components.health ~= nil and target.components.health:IsDead() then 
				lightningfx:Remove()
				targetisdead = true
				target.deathtask:Cancel()
			end 
		end)

		target:DoTaskInTime(target.oncooldown, function() target.oncooldown = nil end)
		
		wep:DoTaskInTime(duration, 
		function()
			if not targetisdead then
				lightningfx:Remove() 
				if target.brain ~= nil then
					target.brain:Start()
				end
				if target.components.combat ~= nil then
					--if (target.components.sleeper ~= nil and not target.components:IsAsleep()) then
					target.components.combat:BlankOutAttacks(0.3)
					target.components.combat:SuggestTarget(ninja)
				end
			end
		end)
	elseif wep.chakraon and canuse and target:HasTag("lightningrod") then
		ninja.components.chakra:UseAmount(30)
		if target:HasTag("charged") then
			target.components.health:DoDelta(60)
		end
	end
end

local function onswitchkusanagi(wep)
	if not wep.chakraon then--IF OFF TURN ON
		wep:AddTag("chakraon")
		wep:RemoveTag("chakraoff")
		local ninja = wep.components.inventoryitem.owner
		local loop = 0
		
		if wep.components.tool == nil then
			wep:AddComponent("tool")
			wep.components.tool:SetAction(ACTIONS.CHOP, 20)
			wep.components.tool:SetAction(ACTIONS.MINE, 20)
			wep.components.tool:SetAction(ACTIONS.HAMMER, 20)
		end
		
		wep.components.weapon:SetElectric()
		
		wep.animtask = wep:DoPeriodicTask(0.11,
		function()
			if loop == 0 then
				ninja.AnimState:OverrideSymbol("swap_object", "swap_kusanagi2", "swap_kusanagi")
				loop = 1
			elseif loop == 1 then
				ninja.AnimState:OverrideSymbol("swap_object", "swap_kusanagi3", "swap_kusanagi")
				loop = 2
			elseif loop == 2 then
				ninja.AnimState:OverrideSymbol("swap_object", "swap_kusanagi4", "swap_kusanagi")
				loop = 1
			end
		end)
		
		wep.chakraon = true
		wep.chakratask = wep:DoPeriodicTask(1, 
		function() 
			
			if ninja.components.chakra ~= nil then
				local canuse = ninja.components.chakra:CheckEnough(10)
				if not canuse then
					ninja.components.talker:Say(TUNING.KUSANAGI.NOCHAKRA)
					wep.chakraon = true
					onswitchkusanagi(wep)
				end
			else
				wep.chakraon = true
				onswitchkusanagi(wep)
			end
		end)
		
	else--IF NOT OFF TURN OFF
		wep.chakraon = false
		wep:AddTag("chakraoff")
		wep:RemoveTag("chakraon")
		if wep.components.tool ~= nil then
			wep:RemoveComponent("tool")
		end
		
		if wep.animtask ~= nil then
			wep.animtask:Cancel()
			wep.animtask = nil
		end	
		
		wep.components.weapon.stimuli = nil
		
		if wep.components.equippable:IsEquipped() then
			local ninja = wep.components.inventoryitem.owner
			ninja.AnimState:OverrideSymbol("swap_object", "swap_kusanagi2", "swap_kusanagi")
			wep:DoTaskInTime(0.5, function() ninja.AnimState:OverrideSymbol("swap_object", "swap_kusanagi", "swap_kusanagi") end)
			wep:DoTaskInTime(1, function() ninja.AnimState:OverrideSymbol("swap_object", "swap_kusanagi2", "swap_kusanagi") end)
			wep:DoTaskInTime(1.5, function() ninja.AnimState:OverrideSymbol("swap_object", "swap_kusanagi", "swap_kusanagi") end)
		end
		
		if wep.chakratask ~= nil then
			wep.chakratask:Cancel()
			wep.chakratask = nil
		end
		
		
	end
	wep:RemoveComponent("useableitem")
	wep:AddComponent("useableitem")
	wep.components.useableitem:SetOnUseFn(onswitchkusanagi)
end

---------MAIN FUNCTIONS---------

local function flyingraijinkunai()
	local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	
    MakeInventoryPhysics(inst)
	
    inst.AnimState:SetBank("kunai")
    inst.AnimState:SetBuild("kunai")
    inst.AnimState:PlayAnimation("idle")


    inst.entity:SetPristine()
    
    if not TheWorld.ismastersim then
        return inst
    end

    -------   
	
	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/flyingraijinkunai.xml"
	inst.components.inventoryitem.imagename = "flyingraijinkunai"
	
	inst.components.inventoryitem:SetOnPickupFn(onpickupflyingraijin)
	inst.components.inventoryitem:SetOnDroppedFn(function() 
		inst.AnimState:PlayAnimation("idle")
		ondroppedflyingraijin(inst)
	end)
	
	 inst:AddComponent("inspectable")
	
	inst:AddComponent("equippable")

	inst.components.equippable:SetOnEquip(function(inst, owner) 
		owner.AnimState:OverrideSymbol("swap_object", "swap_kunai", "swap_kunai")
		owner.AnimState:Show("ARM_carry") 
		owner.AnimState:Hide("ARM_normal")
	end)
	
	inst.components.equippable:SetOnUnequip(function(inst, owner) 
		owner.AnimState:ClearOverrideSymbol("swap_object")
		owner.AnimState:Hide("ARM_carry")
		owner.AnimState:Show("ARM_normal")
	end)
	
	inst:AddComponent("weapon")
	inst.components.weapon:SetDamage(24)
	inst.components.weapon:SetRange(14, 16)
	
   inst:AddComponent("projectile")
    inst.components.projectile:SetSpeed(50)
    inst.components.projectile:SetOnThrownFn(function() 	
		inst.AnimState:PlayAnimation("thrown")
		inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
		
		inst.Physics:ClearCollisionMask()
	end)
    inst.components.projectile:SetOnHitFn(onhitflyingraijin)
		
	inst.OnSave = OnSave
    inst.OnLoad = OnLoad
	
	MakeHauntableLaunch(inst)
	
	return inst
end

local function raijinkunai()
	local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	
    MakeInventoryPhysics(inst)
	
    inst.AnimState:SetBank("kunai")
    inst.AnimState:SetBuild("kunai")
    inst.AnimState:PlayAnimation("idle")

    inst.entity:SetPristine()
    
    if not TheWorld.ismastersim then
        return inst
    end

    -------   
	
	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/flyingraijinkunai.xml"
	inst.components.inventoryitem.imagename = "flyingraijinkunai"
	
	inst.components.inventoryitem:SetOnPickupFn(onpickupflyingraijin)
	inst.components.inventoryitem:SetOnDroppedFn(function() 
		inst.AnimState:PlayAnimation("idle")
		ondroppedflyingraijin(inst)
	end)
	
	inst:AddComponent("inspectable")
	
	inst:AddComponent("equippable")

	inst.components.equippable:SetOnEquip(function(inst, owner) 
		owner.AnimState:OverrideSymbol("swap_object", "swap_kunai", "swap_kunai")
		owner.AnimState:Show("ARM_carry") 
		owner.AnimState:Hide("ARM_normal")
	end)
	
	inst.components.equippable:SetOnUnequip(function(inst, owner) 
		owner.AnimState:ClearOverrideSymbol("swap_object")
		owner.AnimState:Hide("ARM_carry")
		owner.AnimState:Show("ARM_normal")
	end)
	
	inst:AddComponent("weapon")
	inst.components.weapon:SetDamage(24)
	--inst.components.weapon:SetRange(14, 16)

	return inst
end

local function lucyclone() -- lucy was being sassy with clones
	local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	
    MakeInventoryPhysics(inst)
	
    inst.AnimState:SetBank("kunai")
    inst.AnimState:SetBuild("kunai")
    inst.AnimState:PlayAnimation("idle")
	
	inst:AddTag("sharp")

    inst.entity:SetPristine()
    
    if not TheWorld.ismastersim then
        return inst
    end
	
	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.imagename = "lucy"
	
	inst:AddComponent("weapon")
	inst.components.weapon:SetDamage(TUNING.AXE_DAMAGE * .5)

	inst:AddComponent("inspectable")
	
	inst:AddComponent("equippable")

	inst.components.equippable:SetOnEquip(function(inst, owner) 
		owner.AnimState:OverrideSymbol("swap_object", "swap_Lucy_axe", "swap_Lucy_axe")
		owner.AnimState:Show("ARM_carry") 
		owner.AnimState:Hide("ARM_normal")
	end)
	
	inst.components.equippable:SetOnUnequip(function(inst, owner) 
		owner.AnimState:ClearOverrideSymbol("swap_object")
		owner.AnimState:Hide("ARM_carry")
		owner.AnimState:Show("ARM_normal")
	end)
	
    inst:AddComponent("tool")
    inst.components.tool:SetAction(ACTIONS.CHOP, 2)

	return inst
end

local function kusanagi()
	local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	
    MakeInventoryPhysics(inst)
	
    inst.AnimState:SetBank("kusanagi")
    inst.AnimState:SetBuild("kusanagi")
    inst.AnimState:PlayAnimation("idle")
	
	inst:AddTag("sharp")

    inst.entity:SetPristine()
    
    if not TheWorld.ismastersim then
        return inst
    end
	
	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/kusanagi.xml"
	inst.components.inventoryitem.imagename = "kusanagi"
	
	inst:AddComponent("inspectable")
	
	inst:AddComponent("equippable")	
	inst.components.equippable:SetOnEquip(function(inst, owner) 
		owner.AnimState:OverrideSymbol("swap_object", "swap_kusanagi", "swap_kusanagi")
		owner.AnimState:Show("ARM_carry") 
		owner.AnimState:Hide("ARM_normal")
	end)
	
	inst.components.equippable:SetOnUnequip(function(inst, owner) 
		owner.AnimState:ClearOverrideSymbol("swap_object")
		owner.AnimState:Hide("ARM_carry")
		owner.AnimState:Show("ARM_normal")
		inst.chakraon = true
		onswitchkusanagi(inst)
	end)
	
	inst:AddTag("chakraoff")
	
	inst.components.inventoryitem:SetOnDroppedFn(function(inst) 
		inst.chakraon = true
		onswitchkusanagi(inst)
	end)
	
	inst:AddComponent("weapon")
	inst.components.weapon:SetDamage(50)
	inst.components.weapon:SetOnAttack(onkusanagiattack)
	
	inst:AddComponent("useableitem")
    inst.components.useableitem:SetOnUseFn(onswitchkusanagi)
	
	inst:AddComponent("finiteuses")
    inst.components.finiteuses:SetMaxUses(50)
    inst.components.finiteuses:SetUses(50)
	inst.components.finiteuses:SetConsumption(ACTIONS.CHOP, 2)
    inst.components.finiteuses:SetConsumption(ACTIONS.MINE, 2)
	inst.components.finiteuses:SetConsumption(ACTIONS.HAMMER, 2)
    inst.components.finiteuses:SetOnFinished(inst.Remove)
	
	inst.chakratask = nil
	inst.chakraon = false
	
	return inst
end

return Prefab("flyingraijinkunai", flyingraijinkunai, assets),
		Prefab("raijinkunai", raijinkunai, assets),
		Prefab("lucyclone", lucyclone, assets),
		Prefab("kusanagi", kusanagi, assets)	