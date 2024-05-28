local assets =
{
    Asset("ANIM", "anim/wall.zip"),
    Asset("ANIM", "anim/wall_stone.zip"),
}

local function OnIsPathFindingDirty(inst)
    if inst._ispathfinding:value() then
        if inst._pfpos == nil then
            inst._pfpos = inst:GetPosition()
            TheWorld.Pathfinder:AddWall(inst._pfpos:Get())
        end
    elseif inst._pfpos ~= nil then
        TheWorld.Pathfinder:RemoveWall(inst._pfpos:Get())
        inst._pfpos = nil
    end
end

local function InitializePathFinding(inst)
    inst:ListenForEvent("onispathfindingdirty", OnIsPathFindingDirty)
    OnIsPathFindingDirty(inst)
end

local function makeobstacle(inst)
    inst.Physics:SetActive(true)
    inst._ispathfinding:set(true)
end

local function clearobstacle(inst)
    inst.Physics:SetActive(false)
    inst._ispathfinding:set(false)
end

local anims =
{
    { threshold = 0, anim = "broken" },
    { threshold = 0.25, anim = "onequarter" },
    { threshold = 0.5, anim = "half" },
    { threshold = 0.75, anim = "threequarter" }, 
    { threshold = 1, anim = { "fullA", "fullB", "fullC" } },
}

local function resolveanimtoplay(inst, percent)
    for i, v in ipairs(anims) do
        if percent <= v.threshold then
            if type(v.anim) == "table" then
                -- get a stable animation, by basing it on world position
                local x, y, z = inst.Transform:GetWorldPosition()
                local x = math.floor(x)
                local z = math.floor(z)
                local q1 = #v.anim + 1
                local q2 = #v.anim + 4
                local t = ( ((x%q1)*(x+3)%q2) + ((z%q1)*(z+3)%q2) )% #v.anim + 1
                return v.anim[t]
            else
                return v.anim
            end
        end
    end
end

local function onhealthchange(inst, old_percent, new_percent)
    local anim_to_play = resolveanimtoplay(inst, new_percent)
    if new_percent > 0 then
        if old_percent <= 0 then
            makeobstacle(inst)
        end
        inst.AnimState:PlayAnimation(anim_to_play.."_hit")
        inst.AnimState:PushAnimation(anim_to_play, false)
    else
        if old_percent > 0 then
            clearobstacle(inst)
        end
        inst.AnimState:PlayAnimation(anim_to_play)
    end
end

local function onload(inst)
    if inst.components.health:IsDead() then
        clearobstacle(inst)
    end
end

local function oninit(inst)
	clearobstacle(inst)
    inst.AnimState:PlayAnimation(resolveanimtoplay(inst, inst.components.health:GetPercent()))
end

local function onremove(inst)
    inst._ispathfinding:set_local(false)
    OnIsPathFindingDirty(inst)
end

local function onfinishpost(wall)
	local plustask = 0
	wall.posttask = wall:DoPeriodicTask(1, function()
		if plustask < 4 then
		wall.components.health:DoDelta(-100)
		wall.SoundEmitter:PlaySound("dontstarve/common/destroy_stone")
		plustask = plustask + 1
		else
			wall.posttask:Cancel()
			wall:Remove()
		end
	
	end)
end

local function onfinishpre(wall)
	wall:DoTaskInTime(8, onfinishpost, wall)
end

local function onsummoned(wall)
	wall:AddComponent("colourtweener")
	wall.components.colourtweener:StartTween({0.8,0.5,0.25,1}, 0)
	wall:DoTaskInTime(1.5, function()
		local plustask = 0
		wall.pretask = wall:DoPeriodicTask(1, function()
			if plustask < 4 then
			wall.components.health:DoDelta(100)
			wall.SoundEmitter:PlaySound("dontstarve/common/place_structure_stone")
			plustask = plustask + 1
			else
				wall.pretask:Cancel()
				onfinishpre(wall)
			end
		
		end)
	end)
end

local function onhit(inst)
	inst.SoundEmitter:PlaySound("dontstarve/common/destroy_stone")
		local healthpercent = inst.components.health:GetPercent()
		
        if healthpercent > 0 then
            local anim_to_play = resolveanimtoplay(inst, healthpercent)
            inst.AnimState:PlayAnimation(anim_to_play.."_hit")
            inst.AnimState:PushAnimation(anim_to_play, false)
        end
end

local function wallfn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    inst.Transform:SetEightFaced()
	
	MakeObstaclePhysics(inst, .5)
	inst.Physics:SetDontRemoveOnSleep(true)
    
    --inst.Transform:SetScale(1.3,1.3,1.3)

    inst:AddTag("wall")
    inst:AddTag("noauradamage")

    inst.AnimState:SetBank("wall")
    inst.AnimState:SetBuild("wall_stone")
    inst.AnimState:PlayAnimation("fullA", false)

    MakeSnowCoveredPristine(inst)

    inst._pfpos = nil
    inst._ispathfinding = net_bool(inst.GUID, "_ispathfinding", "onispathfindingdirty")
    makeobstacle(inst)
    --Delay this because makeobstacle sets pathfinding on by default
    --but we don't to handle it until after our position is set
    inst:DoTaskInTime(0, InitializePathFinding)

    inst.OnRemoveEntity = onremove

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")

    inst:AddComponent("combat")
    inst.components.combat.onhitfn = onhit

    inst:AddComponent("health")
    inst.components.health:SetMaxHealth(TUNING.STONEWALL_HEALTH)
    inst.components.health:SetCurrentHealth(0)
    inst.components.health.ondelta = onhealthchange
    inst.components.health.nofadeout = true
    inst.components.health.canheal = true

    inst.OnLoad = onload

    inst:DoTaskInTime(0, oninit)

    MakeSnowCovered(inst)

	onsummoned(inst)
	
    return inst
end

return Prefab("wall_mud", wallfn, assets, prefabs)