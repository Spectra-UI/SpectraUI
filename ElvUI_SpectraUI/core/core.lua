-- Create references to ElvUI internals
local E = unpack(ElvUI)
-- dont touch this ^

local IsAddOnLoaded = _G.C_AddOns and _G.C_AddOns.IsAddOnLoaded or _G.IsAddOnLoaded

-- Popup for our links
E.PopupDialogs.SPECTRAUI_EDITBOX = {
	text = SpectraUI.Media.icon .. " " .. SpectraUI.Name,
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
		if self:GetText() ~= self.temptxt then
			self:SetText(self.temptxt)
		end

		self:HighlightText()
	end,
	whileDead = 1,
	preferredIndex = 3,
	hideOnEscape = 1,
}

-- Creat a own print prompt
function SpectraUI:Print(...)
	local printName = SpectraUI.Media.icon .. " " .. SpectraUI.Name .. ":"
	print(printName, ...)
end

-- check if addons are loaded
function SpectraUI:CheckAddons()
	SpectraUI.Addons.BigWigs = IsAddOnLoaded("BigWigs")
	SpectraUI.Addons.CooldownTimeline2 = IsAddOnLoaded("CooldownTimeline2")
	SpectraUI.Addons.CooldownToGo = IsAddOnLoaded("CooldownToGo")
	SpectraUI.Addons.Details = IsAddOnLoaded("Details")
	SpectraUI.Addons.OmniCD = IsAddOnLoaded("OmniCD")
	SpectraUI.Addons.Scorpio = IsAddOnLoaded("Scorpio")
	SpectraUI.Addons.SylingTracker = IsAddOnLoaded("SylingTracker")
	SpectraUI.Addons.mMediaTag = IsAddOnLoaded("ElvUI_mMediaTag")
end

function SpectraUI:CheckProfile(layout)
	local privateProfileExists = (ElvPrivateDB and ElvPrivateDB.profiles and ElvPrivateDB.profiles["Spectra"] or ElvPrivateDB.profiles["Spectra V2"])
	local profileExists = (ElvDB and ElvDB.profiles and ElvDB.profiles.Spectra)

	local privateiIsSet = privateProfileExists and ElvPrivateDB.profileKeys[E.mynameRealm] == "Spectra" or ElvPrivateDB.profileKeys[E.mynameRealm] == "Spectra V2"
	local profileIsSet = profileExists and ElvDB.profileKeys[E.mynameRealm] == "Spectra"

	return privateProfileExists, profileExists, privateiIsSet, profileIsSet
end
