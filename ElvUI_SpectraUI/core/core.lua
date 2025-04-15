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

local function CheckForProfile(db, name)
	if db then
		for i = 1, #db do
			if db[i] == name then
				return true
			end
		end
	end
end

function SpectraUI:CheckProfile()
	local privateProfiles = E.charSettings and E.charSettings:GetProfiles()
	local profiles = E.data and E.data:GetProfiles()

	if privateProfiles and profiles then
		SpectraUI.Profiles = {
			private = CheckForProfile(privateProfiles, "Spectra"),
			privateIsSet = E.charSettings:GetCurrentProfile() == "Spectra",
			spectra = {
				private = CheckForProfile(privateProfiles, "Spectra"),
				profile = CheckForProfile(profiles, "Spectra"),
				privateIsSet = E.charSettings:GetCurrentProfile() == "Spectra",
				profileIsSet = E.data:GetCurrentProfile() == "Spectra",
			},
			spectraV2 = {
				private = CheckForProfile(privateProfiles, "Spectra"),
				profile = CheckForProfile(profiles, "Spectra V2"),
				privateIsSet = E.charSettings:GetCurrentProfile() == "Spectra",
				profileIsSet = E.data:GetCurrentProfile() == "Spectra V2",
			},
			nova = {
				private = CheckForProfile(privateProfiles, "Spectra"),
				profile = CheckForProfile(profiles, "Nova"),
				privateIsSet = E.charSettings:GetCurrentProfile() == "Spectra",
				profileIsSet = E.data:GetCurrentProfile() == "Nova",
			},
		}
	end
end
