--[[	Copyright (c) 2015 Kzisor/Ysovuka	]]

local function MakeChakraBadge( self, badge_name, bank, build, background_build)

		local ChakraBadge = require "widgets/chakrabadge"
		self[badge_name] = self:AddChild(ChakraBadge(self.owner, bank, build, background_build))

		if KnownModIndex:IsModEnabled("workshop-376333686") then			
			self[badge_name]:SetPosition(61, -126, 0)
		else-- MOVE THINGS IF THE COMBINED STATUS MOD IS ENABLED (no movement atm)
	    	self[badge_name]:SetPosition(41, -171, 0)
		    --self.brain:SetPosition(-40,-55,0)
		   	--self.moisturemeter:SetPosition(0,-120,0)
		end

		local function chakradelta( data )
			
			self[badge_name]:SetPercent( data.newpercent, data.currentchakra, data.maxchakra, data.penaltychakra )

		end

		local function OnSetPlayerMode( self )
			if self["onchakradelta"] == nil then
				self["onchakradelta"] = function( owner, data ) chakradelta( data ) end
				self.inst:ListenForEvent( "chakradelta", self["onchakradelta"], self.owner )
				if self.owner.replica.chakra then
					chakradelta( 
					  { newpercent = self.owner.replica.chakra:GetPercent(),
						currentchakra = self.owner.replica.chakra:GetCurrent(),
						maxchakra = self.owner.replica.chakra:Max(),
						penaltychakra = self.owner.replica.chakra:GetPenalty() })
				end
			end
		end

		local function OnSetGhostMode( self )

			if self["onchakradelta"] ~= nil then

				self.inst:RemoveEventCallback( "chakradelta", self["onchakradelta"], self.owner )

				self["onchakradelta"] = nil

			end

		end

		self.__SetGhostMode = self.SetGhostMode

		function self:SetGhostMode( ghostmode )
			self.__SetGhostMode( self, ghostmode )
			if ghostmode then
				self[badge_name]:Hide()
				OnSetGhostMode( self )
			else
				self[badge_name]:Show()
				OnSetPlayerMode( self )
			end
		end

		OnSetPlayerMode( self )



	return self

end

local function StatusDisplaysPostInit( self )
	MakeChakraBadge( self, "chakra", "chakra", "chakra", "chakra", true, true)
end

AddClassPostConstruct( "widgets/statusdisplays", StatusDisplaysPostInit)