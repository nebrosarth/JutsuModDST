local assets =
{
    Asset("ANIM", "anim/doshik.zip"),
    Asset("ATLAS", "images/inventoryimages/doshik.xml"),
    Asset("IMAGE", "images/inventoryimages/doshik.tex"),
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
	
    inst.AnimState:SetBank("doshik")
    inst.AnimState:SetBuild("doshik")
    inst.AnimState:PlayAnimation("idle")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("edible")
    inst.components.edible.foodtype = FOODTYPE.VEGGIE
    inst.components.edible.hungervalue = 10
	inst.components.edible.oneaten = function(inst, eater) 
		ConsoleCommandPlayer().components.chakra:UseAmount(-5) 
	end
    inst.components.edible.healthvalue = 0

    inst:AddComponent("stackable")
    inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

    inst:AddComponent("tradable")

    inst:AddComponent("inspectable")

    inst:AddComponent("perishable")
    inst.components.perishable:SetPerishTime(TUNING.PERISH_SUPERSLOW*1.5)
    inst.components.perishable:StartPerishing()
    inst.components.perishable.onperishreplacement = "spoiled_food"

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.imagename = "doshik"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/doshik.xml"
   
    MakeHauntableLaunchAndPerish(inst)

    return inst
end

return Prefab("doshik", fn, assets, prefabs)