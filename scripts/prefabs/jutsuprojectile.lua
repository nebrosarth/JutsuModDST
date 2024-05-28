local assets =
{
    Asset("ANIM", "anim/rasengan.zip"),
	Asset("ANIM", "anim/firerasengan.zip"),
	Asset("ANIM", "anim/watergun.zip"),
}

local function getspawnlocation(jutsu, target)
    local tarPos = target:GetPosition()
    local pos = jutsu:GetPosition()
    local vec = tarPos - pos
    vec = vec:Normalize()
    local dist = pos:Dist(tarPos)
    return pos + (vec * (dist * .15))
end

local function spawnfiretornado(jutsu, ninja, target)
    local firetornado = SpawnPrefab("firetornado")
    firetornado.ninja = ninja
    local spawnPos = jutsu:GetPosition() + TheCamera:GetDownVec()
    local totalRadius = target.Physics and target.Physics:GetRadius() or 0.5 + firetornado.Physics:GetRadius() + 0.5
    local targetPos = target:GetPosition() + (TheCamera:GetDownVec() * totalRadius)
    firetornado.Transform:SetPosition(getspawnlocation(jutsu, target):Get())
    firetornado.components.knownlocations:RememberLocation("target", targetPos)

    jutsu:Remove()
end

local function common(file, anim, bloom)
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)
    RemovePhysicsColliders(inst)

    inst.AnimState:SetBank(file)
    inst.AnimState:SetBuild(file)
    inst.AnimState:PlayAnimation(anim, true)
    if bloom ~= nil then
        inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
    end

    inst:AddTag("projectile")
	inst:AddTag("jutsuprojectile")

    inst.entity:SetPristine()

	inst.persists = false
	
    if not TheWorld.ismastersim then
        return inst
    end

    return inst
end

local function lightfn(inst, x, y, z, r)
    --local inst = CreateEntity()

    inst.entity:AddLight()

    inst:AddTag("FX")
	
	inst:AddTag("HASHEATER")
	
    inst.Light:SetRadius(r)
    inst.Light:SetFalloff(1)
    inst.Light:SetIntensity(.5)
    inst.Light:SetColour(x / 255, y / 255, z / 255)
    inst.Light:Enable(true)
	
    inst.entity:SetPristine()

    return inst
end

local function rasengan()
	local inst = common("rasengan", "rasengan_loop", "shaders/anim.ksh")
	
	inst:AddComponent("projectile")
	inst.components.projectile:SetSpeed(35)
    inst.components.projectile:SetOnHitFn(inst.Remove)
    inst.components.projectile:SetOnMissFn(inst.Remove)
	
	lightfn(inst, 215, 235, 255, 2)
	
    return inst
end

local function firerasengan()
	local inst = common("firerasengan", "firerasengan_loop", "shaders/anim.ksh")
	
	inst:AddComponent("projectile")
	inst.components.projectile:SetSpeed(35)
    inst.components.projectile:SetOnHitFn(spawnfiretornado)
    inst.components.projectile:SetOnMissFn(inst.Remove)
	
	lightfn(inst, 255, 235, 205, 2)
	
    return inst
end

local function watergun()
	local inst = common("watergun", "watergun_loop")
	inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
	inst.Transform:SetScale(1.25, 1.25, 1.25)
	inst:AddComponent("projectile")
	inst.components.projectile:SetSpeed(50)
    inst.components.projectile:SetOnHitFn(inst.Remove)
    inst.components.projectile:SetOnMissFn(inst.Remove)
	
    return inst
end

return Prefab("rasengan_projectile", rasengan, assets),
		Prefab("firerasengan_projectile", firerasengan, assets),
		Prefab("watergun_projectile", watergun, assets)
