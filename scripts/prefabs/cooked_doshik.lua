local assets =
{
        Asset("ANIM", "anim/cooked_doshik.zip"),

	Asset("IMAGE", "images/inventoryimages/cooked_doshik.tex"),
	Asset("ATLAS", "images/inventoryimages/cooked_doshik.xml"),

	Asset("IMAGE", "images/inventoryimages/cooked_doshik_plus.tex"),
	Asset("ATLAS", "images/inventoryimages/cooked_doshik_plus.xml"),

	Asset("IMAGE", "images/inventoryimages/cooked_doshik_sousages.tex"),
	Asset("ATLAS", "images/inventoryimages/cooked_doshik_sousages.xml"),

	Asset("IMAGE", "images/inventoryimages/cooked_doshik_sousages_plus.tex"),
	Asset("ATLAS", "images/inventoryimages/cooked_doshik_sousages_plus.xml"),

	Asset("IMAGE", "images/inventoryimages/cooked_doshik_hot.tex"),
	Asset("ATLAS", "images/inventoryimages/cooked_doshik_hot.xml"),

	Asset("IMAGE", "images/inventoryimages/cooked_doshik_sousages_hot.tex"),
	Asset("ATLAS", "images/inventoryimages/cooked_doshik_sousages_hot.xml"),
}

local function food_fn(food)
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddNetwork()

	MakeInventoryPhysics(inst)

	inst.AnimState:SetBank(food)
	inst.AnimState:SetBuild("cooked_doshik")
	inst.AnimState:PlayAnimation("idle")
	
	inst:AddTag("preparedfood")

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end

	inst:AddComponent("edible")
        inst.components.edible.foodstate = "PREPARED"

	inst:AddComponent("stackable")
	inst.components.stackable.maxsize = TUNING.STACK_SIZE_MEDITEM

	inst:AddComponent("tradable")

	inst:AddComponent("inspectable")

	inst:AddComponent("perishable")
	inst.components.perishable:StartPerishing()
	inst.components.perishable.onperishreplacement = "spoiled_food"

	inst:AddComponent("inventoryitem")

	MakeHauntableLaunchAndPerish(inst)
	MakeSmallBurnable(inst, TUNING.SMALL_BURNTIME)
    MakeSmallPropagator(inst)
	
	return inst
end

local function cooked_doshik_fn()	
	local inst = food_fn("cooked_doshik")
	
	if not TheWorld.ismastersim then
        return inst
    end
	
    inst.components.edible.foodtype = FOODTYPE.VEGGIE
    inst.components.edible.healthvalue = 5
    inst.components.edible.sanityvalue = 0
    inst.components.edible.hungervalue = 30
	inst.components.edible.oneaten = function(inst, eater) 
		ConsoleCommandPlayer().components.chakra:UseAmount(-25)
	end
	
	inst.components.perishable:SetPerishTime(TUNING.PERISH_FAST)
	
    inst.components.inventoryitem.imagename = "cooked_doshik"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/cooked_doshik.xml"
	
	return inst
end

local function cooked_doshik_plus_fn()	
	local inst = food_fn("cooked_doshik_plus")
	
	if not TheWorld.ismastersim then
        return inst
    end
	
    inst.components.edible.foodtype = FOODTYPE.VEGGIE
    inst.components.edible.healthvalue = 25
    inst.components.edible.sanityvalue = 25
    inst.components.edible.hungervalue = 55
	inst.components.edible.oneaten = function(inst, eater) 
		ConsoleCommandPlayer().components.chakra:UseAmount(-35)
	end
	
	inst.components.perishable:SetPerishTime(TUNING.PERISH_FAST)
	
    inst.components.inventoryitem.imagename = "cooked_doshik_plus"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/cooked_doshik_plus.xml"
	
	return inst
end

local function cooked_doshik_sousages_fn()	
	local inst = food_fn("cooked_doshik_sousages")
	
	if not TheWorld.ismastersim then
        return inst
    end
	
    inst.components.edible.foodtype = FOODTYPE.MEAT
    inst.components.edible.healthvalue = 7
    inst.components.edible.sanityvalue = 0
    inst.components.edible.hungervalue = 50
	inst.components.edible.oneaten = function(inst, eater) 
		ConsoleCommandPlayer().components.chakra:UseAmount(-45)
	end
	
	inst.components.perishable:SetPerishTime(TUNING.PERISH_FAST)
	
    inst.components.inventoryitem.imagename = "cooked_doshik_sousages"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/cooked_doshik_sousages.xml"
	
	return inst
end

local function cooked_doshik_sousages_plus_fn()	
	local inst = food_fn("cooked_doshik_sousages_plus")
	
	if not TheWorld.ismastersim then
        return inst
    end
	
    inst.components.edible.foodtype = FOODTYPE.MEAT
    inst.components.edible.healthvalue = 30
    inst.components.edible.sanityvalue = 25
    inst.components.edible.hungervalue = 75
	inst.components.edible.oneaten = function(inst, eater) 
		ConsoleCommandPlayer().components.chakra:UseAmount(-60)
	end
	inst.components.perishable:SetPerishTime(TUNING.PERISH_FAST)
	
    inst.components.inventoryitem.imagename = "cooked_doshik_sousages_plus"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/cooked_doshik_sousages_plus.xml"
	
	return inst
end

local function cooked_doshik_hot_fn()	
	local inst = food_fn("cooked_doshik_hot")

	if not TheWorld.ismastersim then
        return inst
    end
	
    inst.components.edible.foodtype = FOODTYPE.VEGGIE
    inst.components.edible.healthvalue = 10
    inst.components.edible.sanityvalue = 0
    inst.components.edible.hungervalue = 40
    inst.components.edible.temperaturedelta = 50
    inst.components.edible.temperatureduration = 20
	inst.components.edible.oneaten = function(inst, eater) 
		ConsoleCommandPlayer().components.chakra:UseAmount(-45)
	end
	inst.components.perishable:SetPerishTime(TUNING.PERISH_FAST)
	
    inst.components.inventoryitem.imagename = "cooked_doshik_hot"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/cooked_doshik_hot.xml"
	
	return inst
end

local function cooked_doshik_sousages_hot_fn()	
	local inst = food_fn("cooked_doshik_sousages_hot")
	
	if not TheWorld.ismastersim then
        return inst
    end
	
    inst.components.edible.foodtype = FOODTYPE.MEAT
    inst.components.edible.healthvalue = 20
    inst.components.edible.sanityvalue = 0
    inst.components.edible.hungervalue = 65
    inst.components.edible.temperaturedelta = 50
    inst.components.edible.temperatureduration = 20
	inst.components.edible.oneaten = function(inst, eater) 
		ConsoleCommandPlayer().components.chakra:UseAmount(-60)
	end
	inst.components.perishable:SetPerishTime(TUNING.PERISH_FAST)
	
    inst.components.inventoryitem.imagename = "cooked_doshik_sousages_hot"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/cooked_doshik_sousages_hot.xml"
	
	return inst
end

return Prefab("cooked_doshik", cooked_doshik_fn, assets),
	Prefab("cooked_doshik_plus", cooked_doshik_plus_fn, assets),
	Prefab("cooked_doshik_sousages", cooked_doshik_sousages_fn, assets),
	Prefab("cooked_doshik_sousages_plus", cooked_doshik_sousages_plus_fn, assets),
	Prefab("cooked_doshik_hot", cooked_doshik_hot_fn, assets),
	Prefab("cooked_doshik_sousages_hot", cooked_doshik_sousages_hot_fn, assets)