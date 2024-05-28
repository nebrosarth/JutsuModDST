local assets =
{
    Asset("ANIM", "anim/gnomeringfx.zip"),
}

local function PlayRingAnim(proxy)
    local inst = CreateEntity()

    inst:AddTag("FX")
    --[[Non-networked entity]]
    inst.entity:SetCanSleep(false)
    inst.persists = false

    inst.entity:AddTransform()
    inst.entity:AddAnimState()

    inst.Transform:SetFromProxy(proxy.GUID)
    
    inst.AnimState:SetBank("gnomeringfx")
    inst.AnimState:SetBuild("gnomeringfx")
    inst.AnimState:PlayAnimation("idle")
	inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
    inst.AnimState:SetFinalOffset(-1)

    inst.AnimState:SetOrientation( ANIM_ORIENTATION.OnGround )
    inst.AnimState:SetLayer( LAYER_BACKGROUND )
    inst.AnimState:SetSortOrder( 3 )

    inst:ListenForEvent("animover", inst.Remove)
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddNetwork()

    inst:AddTag("FX")

	
	if gexpsize == 6 then
		inst.Transform:SetScale(0.7, 0.7, 0.7)
	elseif gexpsize == 10 then
		inst.Transform:SetScale(0.95, 0.95, 0.95)
	end
	
	
	
    --Dedicated server does not need to spawn the local fx
    if not TheNet:IsDedicated() then
        --Delay one frame so that we are positioned properly before starting the effect
        --or in case we are about to be removed
        inst:DoTaskInTime(0, PlayRingAnim)
    end

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst.persists = false
    inst:DoTaskInTime(3, inst.Remove)

    return inst
end

return Prefab("gnomeringfx", fn, assets) 
