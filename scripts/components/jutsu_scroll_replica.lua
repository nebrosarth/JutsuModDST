local Jutsu_scroll = Class(function(self, inst)
    self.inst = inst
end)

function Jutsu_scroll:Cast()
    self.inst:PushEvent("castjutsu_scroll_request", {jutsu_scroll = self.inst})
end

return Jutsu_scroll