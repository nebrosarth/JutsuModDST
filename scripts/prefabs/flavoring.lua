local assets =
{
    Asset("ANIM", "anim/flavoring.zip"),
    Asset("ATLAS", "images/inventoryimages/flavoring.xml"),
    Asset("IMAGE", "images/inventoryimages/flavoring.tex"),
}


local prefabs =
{
    "spoiled_food",
}

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)
	
    inst.AnimState:SetBank("flavoring")
    inst.AnimState:SetBuild("flavoring")
    inst.AnimState:PlayAnimation("idle")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("edible")
    inst.components.edible.foodtype = FOODTYPE.VEGGIE
    inst.components.edible.hungervalue = 8
    inst.components.edible.healthvalue = 6

    inst:AddComponent("stackable")
    inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

    inst:AddComponent("tradable")

    inst:AddComponent("inspectable")

    inst:AddComponent("perishable")
    inst.components.perishable:SetPerishTime(TUNING.PERISH_SUPERSLOW*0.5)
    inst.components.perishable:StartPerishing()
    inst.components.perishable.onperishreplacement = "spoiled_food"

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.imagename = "flavoring"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/flavoring.xml"

    MakeHauntableLaunchAndPerish(inst)

    return inst
end

return Prefab("flavoring", fn, assets, prefabs)