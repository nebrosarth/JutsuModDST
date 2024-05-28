local assets =
{
    Asset("ANIM", "anim/firetornado.zip"),
	Asset("ANIM", "anim/bubble.zip"),
	Asset("ANIM", "anim/bubble2.zip"),
	Asset("ANIM", "anim/bubble3.zip"),
}

local ANGLE_VARIANCE = 10
local firetornadobrain = require("brains/tornadobrain")

local function onfiretornadolifetime(firetornado)
    firetornado.sg:GoToState("despawn")
end

local function DoDirectionChange(inst, data)

    if not inst.entity:IsAwake() then return end

    if data and data.angle and inst.components.blowinwind then
        if inst.angle == nil then
            inst.angle = math.clamp(GetRandomWithVariance(data.angle, ANGLE_VARIANCE), 0, 360)
            inst.components.blowinwind:Start(inst.angle)
        else
            inst.angle = math.clamp(GetRandomWithVariance(data.angle, ANGLE_VARIANCE), 0, 360)
            inst.components.blowinwind:ChangeDirection(inst.angle)
        end
    end
end

local function OnExplodeFn(inst)
    inst.SoundEmitter:KillSound("hiss")
	local explosion = SpawnPrefab("explode_small")
	explosion.Transform:SetPosition(inst.Transform:GetWorldPosition())
	explosion.Transform:SetScale(inst.scale, inst.scale, inst.scale)
end



local function common(file, animpre, anim)
    local inst = CreateEntity()
	
	inst:AddTag("FX")
	
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	
	
    inst.AnimState:SetBank(file)
	
	if file == "bubble" then
		local bubbles = {"bubble", "bubble2", "bubble3"}
		file = bubbles[math.random(1,3)]
	end
	
    inst.AnimState:SetBuild(file)
    inst.AnimState:PlayAnimation(animpre)
    inst.AnimState:PushAnimation(anim, true)
    
	
	inst:AddTag("jutsuspecial")

	MakeInventoryPhysics(inst)
	RemovePhysicsColliders(inst)
	
    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst.ninja = nil

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

local function firetornado()
	local inst = common("firetornado", "firetornado_pre", "firetornado_loop")
	
	
	inst.SoundEmitter:PlaySound("dontstarve_DLC001/common/tornado", "spinLoop")
	
	inst:DoTaskInTime(TUNING.TORNADO_LIFETIME, onfiretornadolifetime)

    inst:AddComponent("knownlocations")

	inst.Physics:CollidesWith(COLLISION.WORLD)
	
    inst:AddComponent("locomotor")
    inst.components.locomotor.walkspeed = TUNING.TORNADO_WALK_SPEED * 0.33
    inst.components.locomotor.runspeed = TUNING.TORNADO_WALK_SPEED

    inst:SetStateGraph("SGfiretornado")
	inst.sg:GoToState("spawn")
    inst:SetBrain(firetornadobrain)
	
	lightfn(inst, 215, 235, 255, 2)
	
    return inst
end

local function bubble()
	local inst = common("bubble", "appear", "float")
	
	local randomnum = math.random(-1, 1)
	local scale = 0.75 + (0.25 * randomnum)-- -1 = 0.5 | 0 = 0.75 | 1 = 1

	inst.scale = scale
	inst:AddComponent("locomotor")
    inst.components.locomotor.walkspeed = TUNING.WILSON_WALK_SPEED / 4
	
	inst:AddComponent("explosive")
    inst.components.explosive:SetOnExplodeFn(OnExplodeFn)
    inst.components.explosive.explosivedamage = TUNING.GUNPOWDER_DAMAGE / 4--(200/4)
	inst.components.explosive.explosiverange = 3 * scale
    inst.components.explosive.buildingdamage = 10 * scale
	
	inst:SetStateGraph("SGbubble")
	
	inst:AddComponent("blowinwind")
	inst.components.blowinwind.averageSpeed = TUNING.WILSON_WALK_SPEED / 4
	inst.components.blowinwind.minSpeedMult = .3
	inst.components.blowinwind.maxSpeedMult = .6
	inst.angle = (TheWorld and TheWorld.components.worldwind) and TheWorld.components.worldwind:GetWindAngle() or nil
    inst:ListenForEvent("windchange", function(world, data)
        DoDirectionChange(inst, data)
    end, TheWorld)
    if inst.angle ~= nil then
        inst.angle = math.clamp(GetRandomWithVariance(inst.angle, ANGLE_VARIANCE), 0, 360)
        inst.components.blowinwind:Start(inst.angle)
    end
	
	inst.Transform:SetScale(scale, scale, scale)
	
	inst.loopcount = 0
	inst:DoPeriodicTask(1.5, 
	function()
		local x,y,z = inst.Transform:GetWorldPosition()
		inst.loopcount = inst.loopcount + 1
		
		local EntitiesInRange = TheSim:FindEntities(x, y, z, 1 + scale, nil , { "player", "playerghost", "INLIMBO", "FX", "clone"})
		local entitynum = #EntitiesInRange
		
		if scale >= .75 then
			for k,v in pairs(EntitiesInRange) do
				if v.components.inventoryitem ~= nil then
					entitynum = entitynum - 1
				end
			end
		end
		
		if entitynum > 0 or inst.loopcount > 10 then -- loopcounter 10 x 1.5s = 15s for auto pop
			inst.components.blowinwind:Stop()
			inst.sg:GoToState("pop")
		end
	end)
	
    return inst
end

return Prefab("firetornado", firetornado, assets),
		Prefab("explosivebubble", bubble, assets)
