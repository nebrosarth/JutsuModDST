local assets =
{
    Asset("ANIM", "anim/con_flav.zip"),
    Asset("ATLAS", "images/inventoryimages/con_flav.xml"),
    Asset("IMAGE", "images/inventoryimages/con_flav.tex"),

    Asset("ATLAS", "images/inventoryimages/hot_flav.xml"),
    Asset("IMAGE", "images/inventoryimages/hot_flav.tex"),
}

local function hot_fn()
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("hot_flav")
    inst.AnimState:SetBuild("con_flav")
    inst.AnimState:PlayAnimation("idle")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("edible")
    inst.components.edible.foodtype="VEGGIE"
    inst.components.edible.hungervalue=10
    inst.components.edible.healthvalue=-60
    inst.components.edible.sanityvalue=-10
    inst.components.edible.temperaturedelta = 50
    inst.components.edible.temperatureduration = 60

    inst:AddComponent("stackable")
    inst.components.stackable.maxsize=20

    inst:AddComponent("tradable")

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname="images/inventoryimages/hot_flav.xml"
    inst.components.inventoryitem.imagename="hot_flav"
    return inst
end

local function con_fn()
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("con_flav")
    inst.AnimState:SetBuild("con_flav")
    inst.AnimState:PlayAnimation("idle")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("perishable")
    inst.components.perishable:SetPerishTime(TUNING.PERISH_SUPERSLOW*0.02)
    inst.components.perishable:StartPerishing()
    inst.components.perishable.onperishreplacement = "hot_flav"

    inst:AddComponent("edible")
    inst.components.edible.foodtype="VEGGIE"
    inst.components.edible.hungervalue=50
    inst.components.edible.healthvalue=-200
    inst.components.edible.sanityvalue=0

    inst:AddComponent("stackable")
    inst.components.stackable.maxsize=20

    inst:AddComponent("tradable")

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname="images/inventoryimages/con_flav.xml"
    inst.components.inventoryitem.imagename="con_flav"

    return inst
end
return Prefab("con_flav", con_fn, assets, prefabs),
        Prefab("hot_flav", hot_fn, assets, prefabs)
