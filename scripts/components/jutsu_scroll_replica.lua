local Jutsu_scroll = Class(function(self, inst)
    self.inst = inst
    self.cooldown = net_uint(inst.GUID, "cooldown", "cooldowndirty")
end)

function Jutsu_scroll:Precheck()
    if self.cooldown:value() == 0 then
        return true
    end
    return false
end

return Jutsu_scroll