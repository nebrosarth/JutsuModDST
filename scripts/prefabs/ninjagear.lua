local assets =
{
	Asset("ANIM", "anim/headband.zip"),
    --Asset("ANIM", "anim/swap_kunai.zip"),
	Asset("ATLAS", "images/inventoryimages/headband.xml"),
	
}
--- USEFUL FUNCTIONS ---

local function autoequip(headband, ninja)
	for key, sameband in pairs(ninja.components.inventory.itemslots) do
		if sameband.prefab == headband.prefab then
			if sameband.components.equippable ~= nil then
				ninja.components.inventory:Equip(sameband)
			end
		end
	end
end

--- ON USE FUNCTIONS ---

local function chakrachange(inst, owner, chargeamount)
	if owner.components.chakra ~= nil then
		owner.components.chakra:StartCharge(chargeamount, 3/2)
	end
end

---------MAIN FUNCTION---------

local function commonfn(anim, atlas)

    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	
    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank(anim)
    inst.AnimState:SetBuild(anim)
    inst.AnimState:PlayAnimation("anim")
	
	
    --[[if tags ~= nil then
        for i, v in ipairs(tags) do
            inst:AddTag(v)
        end
    end]]
	
    inst.entity:SetPristine()
    
    if not TheWorld.ismastersim then
        return inst
    end
	
	MakeHauntableLaunch(inst)
    -------   
	
    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/" .. atlas .. ".xml"
	
	inst:AddComponent("equippable")
	inst.components.equippable.equipslot = EQUIPSLOTS.HEAD
	
	inst.components.equippable:SetOnEquip(function(inst, owner) 
		owner.AnimState:OverrideSymbol("swap_hat", anim, "swap_hat")
		owner.AnimState:Show("HAT")
		if owner:HasTag("madara") then
			owner.components.chakra.max = 250 else
			if owner:HasTag("deidara") then
				owner.components.chakra.max = 200 else
				owner.components.chakra.max = 150
			end
		end
		chakrachange(inst, owner, 2)
	end)
	
    inst.components.equippable:SetOnUnequip(function(inst, owner) 
		owner.AnimState:Hide("HAT")
			if owner:HasTag("madara") then
				owner.components.chakra.max = 200 else
				if owner:HasTag("deidara") then
					owner.components.chakra.max = 150 else
					owner.components.chakra.max = 100
				end
			end
		chakrachange(inst, owner, 1)
	end)
	
    inst:AddComponent("inspectable")
	
	inst:AddComponent("armor")
        inst.components.armor:InitCondition(750, .80)
	
    return inst
end

---------PREFAB FUNCTIONS---------

local function headbandblackmissing()
    local inst = commonfn("headband", "headband")
	
    return inst
end

return Prefab("headbandblackmissing", headbandblackmissing, assets)
	