local CharacterSpecific = Class(function(self, inst)
    self.inst = inst

    self.character = nil
    self.storable = false
    self.comment = "Это не моё."
end)

function CharacterSpecific:CanPickUp(doer)
	if doer and doer.prefab ~= self.character then
		return false
	end

	return true
end

function CharacterSpecific:SetOwner(name)
    self.character = name
end

function CharacterSpecific:IsStorable()
	return self.storable
end

function CharacterSpecific:SetStorable(value)
	self.storable = value
end

function CharacterSpecific:GetComment()
	return self.comment
end

function CharacterSpecific:SetComment(comment)
	self.comment = comment
end

return CharacterSpecific