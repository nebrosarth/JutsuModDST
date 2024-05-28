local assets =
{
    Asset("ANIM", "anim/cutgrass.zip"),
	Asset("ANIM", "anim/cutplant.zip"),
	Asset("ANIM", "anim/papyrus.zip"),
	Asset("ANIM", "anim/paper.zip"),
}

local function commonfn(build, bank)
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank(bank)
    inst.AnimState:SetBuild(build)
    inst.AnimState:PlayAnimation("idle")

	inst.Transform:SetScale(.75,.75,.75)
	
    inst:AddTag("cattoy")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/" .. build .. ".xml"
	inst.components.inventoryitem.imagename = build
	
    inst:AddComponent("stackable")
    inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

    inst:AddComponent("inspectable")

	if build == "cutplant" then
		inst:AddComponent("edible")
		inst.components.edible.foodtype = FOODTYPE.ROUGHAGE
		inst.components.edible.woodiness = 1
		inst.components.edible.healthvalue = TUNING.HEALING_TINY/2
		inst.components.edible.hungervalue = TUNING.CALORIES_TINY/4
	end
	
    inst:AddComponent("fuel")
    inst.components.fuel.fuelvalue = TUNING.SMALL_FUEL/2

    MakeSmallBurnable(inst, TUNING.SMALL_BURNTIME)
    MakeSmallPropagator(inst)

    MakeHauntableLaunchAndIgnite(inst)

    return inst
end

local function plant()
	local inst = commonfn("cutplant", "cutgrass")
	return inst
end

local function paper()
	local inst = commonfn("paper", "papyrus")
	return inst
end

return Prefab("cutplant", plant, assets),
		Prefab("paper", paper, assets)
