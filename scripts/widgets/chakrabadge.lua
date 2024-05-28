local Badge = require "widgets/badge"
local UIAnim = require "widgets/uianim"
local Text = require "widgets/text"

return Class(Badge, function(self, owner, bank, build, background_build)
	Badge._ctor(self, background_build, owner)
	-- Start updating the widget.  
    self:StartUpdating()

	self.topperanim = self.underNumber:AddChild(UIAnim())
    self.topperanim:GetAnimState():SetBank("chakrapenalty")
    self.topperanim:GetAnimState():SetBuild("chakrapenalty")
    self.topperanim:GetAnimState():PlayAnimation("anim")
    self.topperanim:SetClickable(false)
	
	self.chakraarrow = self.underNumber:AddChild(UIAnim())
	self.chakraarrow:GetAnimState():SetBank("sanity_arrow")
	self.chakraarrow:GetAnimState():SetBuild("sanity_arrow")
	self.chakraarrow:GetAnimState():PlayAnimation("neutral")
	self.chakraarrow:SetClickable(false)
	
	self.anim:GetAnimState():Hide("frame")
	
	self.num = self:AddChild(Text(BODYTEXTFONT, 33))
    self.num:SetHAlign(ANCHOR_MIDDLE)
    self.num:SetPosition(3.5, 1, 0)
    self.num:Hide()
	
	function self:SetPercent(pct, current, max, penalty)
		current = current or self.tcurrent or 0
		max = max or self.tmax or 100
		pct = pct or (current / max)
		penalty = penalty or self.tpenalty or 0
		Badge.SetPercent(self, pct, max)	
		
		--self.anim:GetAnimState():SetPercent("anim", 1 - pct)
		self.topperanim:GetAnimState():SetPercent("anim", penalty)
		
		self.num:SetString(tostring(math.ceil(pct * max)))
		
		if KnownModIndex:IsModEnabled("workshop-376333686") then
			self.num:Show()
			self.num:SetPosition(2, -40, 0)
			self.num:SetScale(.75, .75, .75)
			if self.show_progress then
				if self.show_remaining then
					self.maxnum:SetString(tostring(math.floor(pct * 100)))
				end
			else
		    		self.maxnum:SetString(tostring(max or 100))
			end
		else
			self.num:SetPosition(3.5, 1, 0)
		end
		
		self.tcurrent = current
		self.tmax = max
		self.tpenalty = penalty
	
	end

	function self:OnUpdate(dt)
	
		if self.owner.replica.chakra ~= nil then
			if self.owner.replica.chakra:GetPercent() <= .2 then
				self:StartWarning(0, 145/255, 1, 1)
			else
				self:StopWarning()
			end
		end
		
		local up = self.owner ~= nil and
			self.owner.replica.chakra ~= nil and
			self.owner.replica.chakra:GetPercentWithPenalty() < 1

		local anim = up and "arrow_loop_increase" or "neutral"
		if self.arrowdir ~= anim then
			self.arrowdir = anim
			self.chakraarrow:SetPosition(0, -4, 0)
			self.chakraarrow:GetAnimState():PlayAnimation(anim, true)
		end
		
		if self.owner.replica.chakra ~= nil then
			self:SetPercent(
			self.owner.replica.chakra:GetPercent(),
			self.owner.replica.chakra:GetCurrent(),
			self.owner.replica.chakra:Max(),
			self.owner.replica.chakra:GetPenalty())
		end
	end
end)