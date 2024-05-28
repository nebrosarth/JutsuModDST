local assets=
{
	Asset("ANIM", "anim/armor.zip"),
	Asset("ANIM", "anim/armor_ground.zip"),
	
	-- Inventory image and atlas file used for the item.
    Asset("ATLAS", "images/inventoryimages/armor.xml"),
    Asset("IMAGE", "images/inventoryimages/armor.tex"),
}

local function onequip(inst, owner) 
    owner.AnimState:OverrideSymbol("swap_body", "armor", "swap_body")
end

local function onunequip(inst, owner) 
    owner.AnimState:ClearOverrideSymbol("swap_body")
end

local function armor()
	local inst = CreateEntity()
    
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	
    MakeInventoryPhysics(inst)
    
    inst.AnimState:SetBank("torso_hawaiian")
    inst.AnimState:SetBuild("armor_ground")
    inst.AnimState:PlayAnimation("anim")
    
	--inst.foleysound = "dontstarve/movement/foley/logarmour"
	
	inst.entity:AddNetwork()
		
	if not TheWorld.ismastersim then
		return inst
	end
		
	inst.entity:SetPristine()
	
	inst:AddComponent("inspectable")
    
    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/armor.xml"
	inst.components.inventoryitem.imagename = "armor"

    inst:AddComponent("equippable")
    inst.components.equippable.equipslot = EQUIPSLOTS.BODY
	inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)
	inst.components.equippable.walkspeedmult = TUNING.armor_SPEED_BONUS

	inst:AddComponent("fuel")
    inst.components.fuel.fuelvalue = TUNING.LARGE_FUEL

    MakeSmallBurnable(inst, TUNING.SMALL_BURNTIME)
	
	inst:AddComponent("armor")
    inst.components.armor:InitCondition(750, .80)	
    
    inst.components.equippable:SetOnEquip( onequip )
    inst.components.equippable:SetOnUnequip( onunequip )
    
	MakeHauntableLaunch(inst)
	
    return inst
end

	
return Prefab( "common/inventory/armor", armor, assets) 
