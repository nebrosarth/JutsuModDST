local assets=
{
    Asset("ANIM", "anim/clay.zip"),						-- Animation Zip
    Asset("ATLAS", "images/inventoryimages/clay.xml"),	-- Atlas for inventory TEX
    Asset("IMAGE", "images/inventoryimages/clay.tex"),	-- TEX for inventory
}

local function fn(Sim)
	-- Create a new entity
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	MakeInventoryPhysics(inst)
	inst.entity:AddNetwork()
	
	

	-- Set animation info
	inst.AnimState:SetBuild("clay")
	inst.AnimState:SetBank("clay")
	inst.AnimState:PlayAnimation("idle")

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst.entity:SetPristine()

	-- Make it stackable
	inst:AddComponent("stackable")
	inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM
	
	-- Make it inspectable
	inst:AddComponent("inspectable")

	inst:AddComponent("edible")
    inst.components.edible.foodtype = FOODTYPE.MEAT
    inst.components.edible.healthvalue = 6
    inst.components.edible.hungervalue = 30
    inst.components.edible.sanityvalue = -10
	inst.components.edible.oneaten = function(inst, eater) 
		ConsoleCommandPlayer().components.chakra:UseAmount(-20)
	end
	
	-- Make it an inventory item
	inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.imagename = "clay"	-- Use our TEX sprite
    inst.components.inventoryitem.atlasname = "images/inventoryimages/clay.xml"	-- here's the atlas for our tex
	
	-- It can burn!
	MakeSmallBurnable(inst)
	
	-- This makes it so fire can spread to/from this object
	MakeSmallPropagator(inst)        

		
	return inst
end

-- Return our prefab
return Prefab( "common/inventory/clay", fn, assets)