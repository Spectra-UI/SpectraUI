-- Create references to ElvUI internals
local E, _, V, P, G = unpack(ElvUI)
-- dont touch this ^

-- Popup for our links
E.PopupDialogs.SPECTRAUI_EDITBOX = {
	text = SpectraUI.Icon .. " " .. SpectraUI.Name,
	button1 = OKAY,
	hasEditBox = 1,
	OnShow = function(self, data)
		self.editBox:SetAutoFocus(false)
		self.editBox.width = self.editBox:GetWidth()
		self.editBox:Width(280)
		self.editBox:AddHistoryLine("text")
		self.editBox.temptxt = data
		self.editBox:SetText(data)
		self.editBox:SetJustifyH("CENTER")
	end,
	OnHide = function(self)
		self.editBox:Width(self.editBox.width or 50)
		self.editBox.width = nil
		self.temptxt = nil
	end,
	EditBoxOnEnterPressed = function(self)
		self:GetParent():Hide()
	end,
	EditBoxOnEscapePressed = function(self)
		self:GetParent():Hide()
	end,
	EditBoxOnTextChanged = function(self)
		if self:GetText() ~= self.temptxt then self:SetText(self.temptxt) end

		self:HighlightText()
	end,
	whileDead = 1,
	preferredIndex = 3,
	hideOnEscape = 1,
}

-- Creat a own print prompt
function SpectraUI:Print(...)
	local printName = SpectraUI.Icon .. " " .. SpectraUI.Name .. ":"
	print(printName, ...)
end
