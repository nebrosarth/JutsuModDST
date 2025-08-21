local Jutsu_scroll = Class(function(self, inst)
    self.inst = inst
    self.spell = nil
    self.cooldown = 0
end)

function Jutsu_scroll:Cast()
    if self.spell then
        self.spell(self.inst)
    end
end

function Jutsu_scroll:SetCooldown(cooldown)
    self.cooldown = cooldown
    self.inst.replica.jutsu_scroll.cooldown:set(self.cooldown)
end

function Jutsu_scroll:GetCooldown()
    return self.cooldown
end

function Jutsu_scroll:Ready()
    if self.cooldown and self.cooldown > 0 then
        return false
    end
    return true
end

function Jutsu_scroll:Precheck()
    if self.precheck then
        return self.precheck(self.inst)
    end
    return true
end

return Jutsu_scroll