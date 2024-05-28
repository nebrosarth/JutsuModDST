local assets =
{
	Asset("ANIM", "anim/rays.zip"),
	Asset("ANIM", "anim/watergun.zip"),
	Asset("ANIM", "anim/thunder.zip"),
	Asset("ANIM", "anim/structure_collapse_fx.zip"),
}

local function fn(bank, build, anim, loop, bloom)
    local inst = CreateEntity()

    inst.entity:AddTransform()
	inst.entity:AddAnimState()
    inst.entity:AddNetwork()
    inst.entity:AddSoundEmitter()

	inst.AnimState:SetBank(bank)
    inst.AnimState:SetBuild(build)
    inst.AnimState:PlayAnimation(anim, loop)

	if bloom ~= nil then
        inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
    end
	
    inst.Transform:SetFourFaced()
	
    inst:AddTag("FX")
	inst:AddTag("NOCLICK")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end	
	
    inst.entity:SetCanSleep(false)
    inst.persists = false
    

    return inst
end

local function lightfn(inst, x, y, z, r)

    inst.entity:AddLight()
	
	inst:AddTag("HASHEATER")
	
    inst.Light:SetRadius(r)
    inst.Light:SetFalloff(1)
    inst.Light:SetIntensity(.5)
    inst.Light:SetColour(x / 255, y / 255, z / 255)
    inst.Light:Enable(true)
	
    inst.entity:SetPristine()
    inst.persists = false

    return inst
end

local function greenray()
	local inst = fn("rays", "rays", "shine", true, "shaders/anim.ksh")
	inst.AnimState:SetLightOverride(1)
	inst.Transform:SetScale(2.5, 2.5, 2.5)
	inst:DoTaskInTime(4, inst.Remove)
	
	return inst
end

local function watergunsplash()
	local inst = fn("watergun", "watergun", "watergun_splash", false)
	inst.Transform:SetScale(2.5, 2.5, 2.5)
	
	inst:ListenForEvent("animover", inst.Remove)
	return inst
end

local function thunder()
	local inst = fn("tornado", "thunder", "tornado_loop", true)
	lightfn(inst, 185, 230, 255, 1.5)
	
	inst:DoTaskInTime(10, inst.Remove)
	return inst
end
local function smoke()
	local inst = fn("collapse", "structure_collapse_fx", "collapse_small", false)
	
	inst:DoTaskInTime(1, inst.Remove)
	return inst
end

return Prefab("greenray", greenray, assets),
		Prefab("watersplash", watergunsplash, assets),
		Prefab("thunder", thunder, assets),
		Prefab("smoke", smoke, assets)