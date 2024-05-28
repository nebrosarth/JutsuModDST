local assets =
{
    Asset("ANIM", "anim/gnome_grenade.zip"),
}

local function PlayFXAnim(proxy)
    local inst = CreateEntity()
	inst.entity:AddLight()
	
	inst.Light:Enable(true)
    inst.Light:SetRadius(6.0)
    inst.Light:SetIntensity(.66)
    inst.Light:SetFalloff(1.8)
    inst.Light:SetColour(255 / 255, 0 / 255, 255 / 255)
	
    inst:AddTag("FX")
    --[[Non-networked entity]]
    inst.entity:SetCanSleep(false)
    inst.persists = false

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()

    inst.Transform:SetFromProxy(proxy.GUID)

    inst.AnimState:SetBank("gnome_grenade")
    inst.AnimState:SetBuild("gnome_grenade")
    inst.AnimState:PlayAnimation("explosion")
    inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
    inst.AnimState:SetLightOverride(1)
    inst.AnimState:SetFinalOffset(1)

    inst.SoundEmitter:PlaySound("gnomenade/fall/explode")
	inst.SoundEmitter:PlaySound("gnomenade/fall/laugh")
	inst.SoundEmitter:PlaySound("gnomenade/fall/farexp")

    inst:ListenForEvent("animover", inst.Remove)
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddNetwork()

    inst:AddTag("FX")
	
	if gexpsize == 6 then
		inst.Transform:SetScale(1.8, 1.8, 1.8)
	elseif gexpsize == 10 then
		inst.Transform:SetScale(3.0, 3.0, 3.0)
	end
	
    --Dedicated server does not need to spawn the local fx
    if not TheNet:IsDedicated() then
        --Delay one frame so that we are positioned properly before starting the effect
        --or in case we are about to be removed
        inst:DoTaskInTime(0, PlayFXAnim)
    end

	
	
    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

	inst.persists = false
	inst:DoTaskInTime(1, inst.Remove)
    return inst
end

return Prefab("gnomenade_fx", fn, assets)