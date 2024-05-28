require "behaviours/faceentity"
require "behaviours/chaseandattack"
require "behaviours/panic"
require "behaviours/follow"
require "behaviours/leash"
require "behaviours/runaway"

local CloneBrain = Class(Brain, function(self, inst)
    Brain._ctor(self, inst)
end)

local MIN_FOLLOW_DIST = 0
local TARGET_FOLLOW_DIST = 6
local MAX_FOLLOW_DIST = 8

local START_FACE_DIST = 6
local KEEP_FACE_DIST = 8

local KEEP_WORKING_DIST = 14
local SEE_WORK_DIST = 10

local KEEP_DANCING_DIST = 3

local RUN_AWAY_DIST = 3
local STOP_RUN_AWAY_DIST = 5


local function GetLeader(inst)
	if inst.components.follower ~= nil then
		return inst.components.follower.leader
	else
		return nil
	end
end

local function GetLeaderPos(inst)
    return inst.components.follower.leader:GetPosition()
end

local function GetFaceTargetFn(inst)
    local target = FindClosestPlayerToInst(inst, START_FACE_DIST, true)
    return target ~= nil and not target:HasTag("notarget") and target or nil
end

local function KeepWorkingAction(inst, dist)
    local leader = GetLeader(inst)
    return leader ~= nil and inst:IsNear(leader, dist)
end

--[[local function FindEntityToWorkAction(inst, action, addtltags)
    local target = FindEntity(GetLeader(inst), SEE_WORK_DIST, nil, {action.id.."_workable"}, {"INLIMBO"}, addtltags)
    if target then
        return BufferedAction(inst, target, action) or nil
    end
end]]--
local function FindEntityToWorkAction(inst, action, addtltags)
    local leader = GetLeader(inst)
    if leader ~= nil then
        --Keep existing target?
        local target = inst.sg.statemem.target
        if target ~= nil and
            target:IsValid() and
            not target:IsInLimbo() and
            target.components.workable ~= nil and
            target.components.workable:CanBeWorked() and
            target.components.workable:GetWorkAction() == action and
            target.entity:IsVisible() and
            target:IsNear(leader, KEEP_WORKING_DIST) then
                
            if addtltags ~= nil then
                for i, v in ipairs(addtltags) do
                    if target:HasTag(v) then
                        return BufferedAction(inst, target, action)
                    end
                end
            else
                return BufferedAction(inst, target, action)
            end
        end

        --Find new target
        target = FindEntity(leader, SEE_WORK_DIST, nil, { action.id.."_workable" }, { "INLIMBO" }, addtltags)
        return target ~= nil and BufferedAction(inst, target, action) or nil
    end
end

local function KeepFaceTargetFn(inst, target)
    return not target:HasTag("notarget") and inst:IsNear(target, KEEP_FACE_DIST)
end

local function DanceParty(inst)
    inst:PushEvent("dance")
end

local function ShouldDanceParty(inst)
    local leader = GetLeader(inst)
    return leader ~= nil and leader.sg:HasStateTag("dancing")
end

function CloneBrain:OnStart()
    local root = PriorityNode(
    {
        --After my Brain code having a bunch of issues, or so I thought, I replaced it with shadow maxwell, only to find out the issue was the stategraph.
        IfNode(function() return ShouldDanceParty(self.inst) end, "Dance Party",
            PriorityNode({
                Leash(self.inst, GetLeaderPos, KEEP_DANCING_DIST, KEEP_DANCING_DIST),
                ActionNode(function() DanceParty(self.inst) end),
        }, .25)),
		
		IfNode(function() return self.inst.hand ~= nil and (self.inst.hand.prefab == "grass" or self.inst.hand.components.weapon ~= nil) and not (self.inst.hand:HasTag("CHOP_tool") or self.inst.hand:HasTag("MINE_tool") or self.inst.hand:HasTag("DIG_tool")) end, "Can Fight",
            PriorityNode({
                WhileNode(function() return self.inst.components.combat:HasTarget() and self.inst.components.combat:GetCooldown() > .5 end, "Dodge",
                    RunAway(self.inst, function() return self.inst.components.combat.target end, RUN_AWAY_DIST, STOP_RUN_AWAY_DIST)),
                ChaseAndAttack(self.inst),
        }, .25)),
		
        IfNode(function() return self.inst.hand ~= nil and self.inst.hand:HasTag("CHOP_tool") end, "Can Chop",
            WhileNode(function() return KeepWorkingAction(self.inst, KEEP_WORKING_DIST) end, "Keep Chopping",
                LoopNode{
                    DoAction(self.inst, function() return FindEntityToWorkAction(self.inst, ACTIONS.CHOP) end)
        })),

        IfNode(function() return self.inst.hand ~= nil and self.inst.hand:HasTag("MINE_tool") end, "Can Mine",
            WhileNode(function() return KeepWorkingAction(self.inst, KEEP_WORKING_DIST) end, "Keep Mining",
                LoopNode{
                    DoAction(self.inst, function() return FindEntityToWorkAction(self.inst, ACTIONS.MINE) end)
        })),

        IfNode(function() return self.inst.hand ~= nil and self.inst.hand:HasTag("DIG_tool") end, "Can Dig",
            WhileNode(function() return KeepWorkingAction(self.inst, KEEP_WORKING_DIST) end, "Keep Digging",
                DoAction(self.inst, function() return FindEntityToWorkAction(self.inst, ACTIONS.DIG, {"stump", "grave"}) end)
        )),
		
		IfNode(function() return not self.inst.components.combat:HasTarget() end, "Can Follow",
			Follow(self.inst, GetLeader, MIN_FOLLOW_DIST, TARGET_FOLLOW_DIST, MAX_FOLLOW_DIST)),

        IfNode(function() return GetLeader(self.inst) ~= nil end, "Has Leader",
            FaceEntity(self.inst, GetFaceTargetFn, KeepFaceTargetFn)),
    }, .25)

    self.bt = BT(self.inst, root)
end

return CloneBrain
