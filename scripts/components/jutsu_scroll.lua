local Jutsu_scroll = Class(function(self, inst)
    self.inst = inst
    self.spell = nil
end)

function Jutsu_scroll:Cast()
    if self.spell then
        self.spell(self.inst)
    end
end

return Jutsu_scroll