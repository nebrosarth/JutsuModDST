local Chakra = Class(function(self, inst)
    self.inst = inst
	if inst ~= nil then
		if inst:HasTag("madara") then
			self.max = 200 else 
			if inst:HasTag("deidara") then
			self.max = 150 else 
				self.max = 100
			end
		end
	end
    self.min = 0
    self.current = self.max
	self.penalty = 0
	self.infinite = false

end,
nil,
{})



local function SetReplicaMaxChakra(self, maxchakra)
	self.inst.replica.chakra:SetMax(maxchakra)
end
--[[The 2 functions(above and below) are Copyright ( c ) 2015 of Kzisor/Ysovuka	]]
local function SetReplicaCurrentChakra(self, current)
	if self.inst.replica.chakra ~= nil then
		self.inst.replica.chakra:SetCurrent(current)
	end
end

local function SetReplicaPenalty(self, penalty)
	self.inst.replica.chakra:SetPenalty(penalty)
end

function Chakra:OnRemoveFromEntity()
    self:StopCharge()
end

function Chakra:SetInfinite(val, showmsg)
	if val == nil then
		self.infinite = not self.infinite
	else
		self.infinite = val
	end
	
	if showmsg == nil then
		showmsg = true
	end
	
    if showmsg then
		if self:IsInfinite() then
			print("Now Skipping Chakra Costs...")
			self:DoDelta(self.max)
			self:DoDelta(0)
		else
			print("Now Obeying Chakra Costs...")
		end
	else
		if self:IsInfinite() then
			self:DoDelta(self.max)
			self:DoDelta(0)
		end
	end
end

function Chakra:OnSave()
    return
    {
        currentchakra = self.current,
		maxchakra = self.max,
		infinite = self.infinite
    }
end

function Chakra:OnLoad(data)
    if data.infinite ~= nil then 
        self.infinite = data.infinite
		self:DoDelta(0)
    end
	if data.maxchakra ~= nil then
		self.max = data.maxchakra
		self:DoDelta(0)
	end
    if data.currentchakra ~= nil then
        self.current = data.currentchakra
        self:DoDelta(0)
    elseif data.percent ~= nil then
        self:SetPercent(data.percent, true, "file_load")
        self:DoDelta(0)
    end
end

local function DoCharge(inst, self)
	self:DoDelta(self.charge.amount, true, "charge")
	if self.inst:HasTag("idle") then
        self:StartCharge(self.charge.amount, 3/2)
	else
		self:StartCharge(self.charge.amount, 3)
	end
end

function Chakra:StartCharge(amount, period, interruptcurrentcharge)
    -- We don't always do this just for backwards compatibility sake. While unlikely, it's possible some modder was previously relying on
    -- the fact that StartCharge didn't stop the existing task. If they want to continue using that behavior, they now just need to add
    -- a "false" flag as the last parameter of their StartCharge call. Generally, we want to restart the task, though.
    if interruptcurrentcharge == nil or interruptcurrentcharge == true then
        self:StopCharge()
    end

    if self.charge == nil then
        self.charge = {}
    end
    self.charge.amount = amount
    self.charge.period = period

    if self.charge.task == nil then
        self.charge.task = self.inst:DoPeriodicTask(self.charge.period, DoCharge, nil, self)
    end
end

function Chakra:SetChargeAmount(amount)
    if amount ~= nil then
        self.charge.amount = amount
	end
end

function Chakra:StopCharge()
    if self.charge ~= nil then
        if self.charge.task ~= nil then
            self.charge.task:Cancel()
            self.charge.task = nil
        end
        self.charge = nil
    end
end

function Chakra:GetPercent()
    return self.current / self.max
end

function Chakra:GetCurrent()
    return self.current
end

function Chakra:GetMax()
    return self.max
end

function Chakra:GetPenalty()
    return self.penalty
end

function Chakra:GetMaxWithPenalty()
    return self.max - self.max * self.penalty
end

function Chakra:GetPercentWithPenalty()
    return self.current / (self.max - self.max * self.penalty)
end


function Chakra:IsInfinite()
    return self.infinite
end

function Chakra:GetDebugString()
    local s = string.format("%2.2f / %2.2f", self.current, self.max, self.penalty, self:GetMaxWithPenalty())
    if self.charge ~= nil then
        s = s..string.format(", charge %.2f every %.2fs", self.charge.amount, self.charge.period)
    end
    return s
end

function Chakra:SetCurrentChakra(amount)
	if amount > self:GetMaxWithPenalty() then
		amount = self:GetMaxWithPenalty()
	elseif amount < self.min then
		amount = self.min
	end
	if self.current ~= amount then
		self.current = amount
		SetReplicaCurrentChakra(self, amount)
	end
end

function Chakra:SetMaxChakra(amount)
    self.max = amount
	SetReplicaMaxChakra(self, amount)
end

function Chakra:SetPenalty(penalty)
    --Penalty should never be less than 0% or ever above 80%.
    self.penalty = math.clamp(penalty, 0, 0.877)
	SetReplicaPenalty(self, self.penalty)
	
	self:DoDelta(0)
end

function Chakra:SetMinChakra(amount)
    self.min = amount
end

function Chakra:IsMax()
    return self.current == self.max
end

function Chakra:IsPartial()
    return self.current < self.max
end

function Chakra:Deplete()
	if not self.infinite and self.current > 0 then
        self:DoDelta(-self.current)
	end
end

function Chakra:IsExhausted()
    return self.current <= 0
end

function Chakra:SetPercent(percent, overtime, cause)
    self:SetCurrentChakra(self.max * percent)
    self:DoDelta(0, overtime, cause, true, nil)
end

function Chakra:PenaltyDelta(delta)
	if delta > 1 or delta < -1 then -- allows for both 0-1 and 0-100(but you can't increase by 1)
		if self.max == 150 then
			if delta > 0 then delta = 0.134
			else delta =-0.134
			end
		end	
		
		if self.max == 100 then
			if delta > 0 then delta = 0.2
			else delta =-0.2
			end
		end
		
		if self.max == 200 then
			if delta > 0 then delta = 0.1
			else delta = -0.1
			end
		end
		
	end
    self:SetPenalty(self.penalty + delta)
end

function Chakra:CanPenaltyDelta(delta)
	if delta > 1 then -- allows for both 0-1 and 0-100(but you can't increase by 1)
		delta = delta / 100
	end
	local newpenalty = self.penalty + delta
	if newpenalty > 0.877 then
		return false -- if the new penalty is bigger than 80% 
	else
		return true
	end
end

function Chakra:UseAmount(amount)
	if not self.infinite then
		local penalty = self.current - amount
		self:DoDelta(-amount)
		if penalty < 0 then
			local current_sanity = self.inst.components.sanity and self.inst.components.sanity.current or 0
			self.inst.components.sanity:DoDelta(penalty)
			if current_sanity <= -penalty then
				penalty = penalty + current_sanity
				local current_hunger = self.inst.components.hunger and self.inst.components.hunger.current or 0
				self.inst.components.hunger:DoDelta(penalty)
				if current_hunger <= -penalty then
					penalty = penalty + current_hunger
					if self.inst.components.health ~= nil then
						self.inst.components.health:DoDelta(penalty, nil, "chakra")
					end
				end
			end
		end
	end
end

function Chakra:CheckEnough(amount)
	if not self:IsExhausted() and self.current >= amount then
		return true
	elseif self:IsInfinite() then
		return true
	else
		return false
	end
end

function Chakra:DoDelta(amount, overtime, cause, ignore_infinite, afflicter)
    if self.redirect ~= nil then
        if self.redirect(self.inst, amount, overtime, cause) then
            return
        end
    end

    if not ignore_infinite and self.inst.is_teleporting == true then
        return
    end
	local penalty = self:GetPenalty()
    local old_percent = self:GetPercent()
    self:SetCurrentChakra(self.current + amount)--, cause, afflicter)
    local new_percent = self:GetPercent()
	
	self.inst:PushEvent("chakradelta", { oldpercent = old_percent, newpercent = self:GetPercent(), overtime = overtime, cause = cause, afflicter = afflicter, amount = amount, penalty = penalty })

    if self.ondelta ~= nil then
        self.ondelta(self.inst, old_percent, self:GetPercent())
    end
end

function Chakra:Respawn(chakra)
	if self:IsInfinite() then
		self:DoDelta(self.max)
	else
		self:DoDelta(chakra or 39)	
	end
	self:StartCharge(1, 3)
end

function Chakra:Death(chakra)
	self:StopCharge()
	self:DoDelta(-self.current)
end

return Chakra
