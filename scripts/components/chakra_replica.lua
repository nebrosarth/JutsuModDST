local Chakra = Class(function(self, inst)
    self.inst = inst

    if TheWorld.ismastersim then
        self.classified = inst.player_classified
    elseif self.classified == nil and inst.player_classified ~= nil then
        self:AttachClassified(inst.player_classified)
    end
end)

--------------------------------------------------------------------------

function Chakra:OnRemoveFromEntity()
    if self.classified ~= nil then
        if TheWorld.ismastersim then
            self.classified = nil
        else
            self.inst:RemoveEventCallback("onremove", self.ondetachclassified, self.classified)
            self:DetachClassified()
        end
    end
end

Chakra.OnRemoveEntity = Chakra.OnRemoveFromEntity

function Chakra:AttachClassified(classified)
    self.classified = classified
    self.ondetachclassified = function() self:DetachClassified() end
    self.inst:ListenForEvent("onremove", self.ondetachclassified, classified)
end

function Chakra:DetachClassified()
    self.classified = nil
    self.ondetachclassified = nil
end

--------------------------------------------------------

local function Set( netvar, value )
	netvar:set(value)
end

function Chakra:SetCurrent(current)
    Set(self.inst.currentchakra, current)
end

function Chakra:SetMax(maxchakra)
    Set(self.inst.maxchakra, maxchakra)
end

function Chakra:SetPenalty(penalty)
    Set(self.inst.penaltychakra, penalty)
end

function Chakra:Max()
    if self.inst.components.chakra ~= nil then
        return self.inst.components.chakra.max
    else
        return self.inst.maxchakra:value()
    end
end

function Chakra:GetPercent()
    if self.inst.components.chakra ~= nil then
        return self.inst.components.chakra:GetPercent()
    else
        return self.inst.currentchakra:value() / self.inst.maxchakra:value()
    end
end

function Chakra:GetCurrent()
    if self.inst.components.chakra ~= nil then
        return self.inst.components.chakra.current
    else 
        return self.inst.currentchakra:value()
    end
end

function Chakra:GetPenalty()
    if self.inst.components.chakra ~= nil then
        return self.inst.components.chakra.penalty
    else 
        return self.inst.penaltychakra:value()
    end
end

function Chakra:GetMaxWithPenalty()
    if self.inst.components.chakra ~= nil then
        return self.inst.components.chakra:GetMaxWithPenalty()
    else 
        return self.inst.maxchakra:value() - self.inst.maxchakra:value() * self.inst.penaltychakra:value()
    end
end

function Chakra:GetPercentWithPenalty()
	if self.inst.components.chakra ~= nil then
		return self.inst.components.chakra:GetPercentWithPenalty()
	else
		return self.inst.currentchakra:value() / (self.inst.maxchakra:value() - self.inst.maxchakra:value() * self.inst.penaltychakra:value())
	end
end

function Chakra:IsPartial()
    if self.inst.components.chakra ~= nil then
        return self.inst.components.chakra:IsPartial()
    elseif self.classified ~= nil then
        return self.inst.currentchakra:value() < self.inst.maxchakra:value()
    else
        return false
    end
end

return Chakra
