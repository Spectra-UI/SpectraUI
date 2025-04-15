-- Create references to ElvUI internals
local E, _, V, P, G = unpack(ElvUI)
local addon, ns = ...
-- dont touch this ^

-- Create reference to LibElvUIPlugin
local EP = LibStub("LibElvUIPlugin-1.0")

-- Cache Lua / WoW API
local _G = _G
local GetAddOnMetadata = _G.C_AddOns and _G.C_AddOns.GetAddOnMetadata or _G.GetAddOnMetadata

-- Create a new ElvUI module so ElvUI can handle initialization when ready
SpectraUI = E:NewModule("SpectraUI", "AceHook-3.0", "AceEvent-3.0", "AceTimer-3.0")

-- Load Locales
SpectraUI.Locales = LibStub("AceLocale-3.0"):GetLocale("SpectraUI")
local L = SpectraUI.Locales

-- Name, Logo and Icon for your plugin.
SpectraUI.Name = "|CFFFFFFFFSpectra|r|CFF03FA6EUI|r" --#03FA6E #FFFFFF
SpectraUI.Version = GetAddOnMetadata(addon, "Version")

SpectraUI.Media = {
	mediaPath = "Interface\\AddOns\\ElvUI_SpectraUI\\media\\",
	icon = "|TInterface\\AddOns\\ElvUI_SpectraUI\\media\\icon.tga:14:14|t",
	logo = "Interface\\AddOns\\ElvUI_SpectraUI\\media\\logo.tga",
	logoText = "Interface\\AddOns\\ElvUI_SpectraUI\\media\\logo_text.tga",
	discordLogo = "|TInterface\\AddOns\\ElvUI_SpectraUI\\media\\discord_logo.tga:14:14|t",
}

SpectraUI.Color = {
	ui = {
		hex = "|CFF03FA6E",
		rgb = { 0, 0.98, 0.44, 1 },
		color = { r = 0, g = 0.98, b = 0.44, a = 1, hex = "|CFF03FA6E" },
	},
}

SpectraUI.Links = {
	WA = {
		spectra = {
			classic = "https://wago.io/3k0v1a2b4",
			retail = "https://wago.io/3k0v1a2b4",
		},
		nova = {
			classic = "https://cdn.discordapp.com/attachments/1358749159980793956/1359761882847776798/NOVA_Weakaura.txt?ex=67fdee70&is=67fc9cf0&hm=080bc5ed7e3c58eeaa4cf444c6c259f2e939f69a735c6b723ba1e630542051f3&",
			retail = "https://cdn.discordapp.com/attachments/1358749159980793956/1359761882847776798/NOVA_Weakaura.txt?ex=67fdee70&is=67fc9cf0&hm=080bc5ed7e3c58eeaa4cf444c6c259f2e939f69a735c6b723ba1e630542051f3&",
		},
	},
}

SpectraUI.Profiles = {
	spectra = {
		private = nil,
		profile = nil,
		privateIsSet = nil,
		profileIsSet = nil,
	},
	spectraV2 = {
		private = nil,
		profile = nil,
		privateIsSet = nil,
		profileIsSet = nil,
	},
	nova = {
		private = nil,
		profile = nil,
		privateIsSet = nil,
		profileIsSet = nil,
	},
}

-- other global settings
SpectraUI.Addons = {}
SpectraUI.InstallerData = {}
SpectraUI.Options = {}

-- example of credits if you want to add some
SpectraUI.CREDITS = {
	L["|CFF03FA6EHoffa|r - Author"], --#16F5EE
	L["|CFF00A3FFB|r|CFF00B4FFl|r|CFF00C6FFi|r|CFF00D8FFn|r|CFF00EAFFk|r|CFF00F6FFi|r|CFF00F6FFi|r - Programming"],
	L["|cff0DB1D0Dlarge|r - Localization"],
	L["|CFFC7D377Lillekatt|r  - Creator and provider of the Role Icons"],
	"|cffc500ffRepooc|r",
	"|cff0DB1D0J|r|cff18A2D2i|r|cff2494D4b|r|cff2F86D7e|r|cff3B78D9r|r|cff4669DBi|r|cff525BDEs|r|cff5D4DE0h|r",
}

-- example of donators if you want to add some
SpectraUI.DONATORS = {
	"|CFF03FA6EMérica|r - |CFFA335EEEpic Supporter|r",
	"|CFF03FA6ERipper|r - |CFFFF8000Legendary Supporter|r",
	"|CFF03FA6EEzdeath|r - |CFFA335EEEpic Supporter|r",
	"|CFF03FA6ERazorfold|r - |CFFA335EEEpic Supporter|r",
	"|CFF03FA6ELee|r - |CFFFF8000Legendary Supporter|r",
	"|CFF03FA6ELysergic|r - |CFFFF8000Legendary Supporter|r",
	"|CFF03FA6EXayn|r - |CFFFF8000Legendary Supporter|r",
	"|CFF03FA6ECalarc|r - |CFFA335EEEpic Supporter|r",
	"|CFF03FA6EFenix|r - |CFFA335EEEpic Supporter|r",
	"|CFF03FA6EI R Salo|r - |CFFA335EEEpic Supporter|r",
	"|CFF03FA6EMattIzHypd|r - |CFFA335EEEpic Supporter|r",
	"|CFF03FA6EQuizle|r - |CFFA335EEEpic Supporter|r",
}

-- load our options table
local function LoadOptions()
	E.Options.name =
		format("%s + %s %s |cff99ff33%s|r", E.Options.name, SpectraUI.Media.icon, SpectraUI.Name, SpectraUI.Version)
	E.Options.args.SpectraUI = SpectraUI.options
end

-- This function will handle initialization of the addon
function SpectraUI:Initialize()
	SpectraUI:CheckSkippedInstallers()

	-- check wich addons are loaded
	SpectraUI:CheckAddons()

	-- add textures to mMT
	SpectraUI:Setup_mMediaTag()

	-- do this only if details is loaded
	if SpectraUI.Addons.Details then
		-- details embedded feature
		if E.db.SpectraUI.detailsEmbedded.style ~= "DISABLE" then
			SpectraUI:DetailsEmbedded()
		end

		-- add class icons to details
		SpectraUI:SetupDetails()
	end

	if E.db.SpectraUI.playerPortraitHide and not SpectraUI.eventRegistered then
		self:RegisterEvent("PLAYER_ENTERING_WORLD")
		SpectraUI.eventRegistered = true
	end

	-- Insert our options table when ElvUI config is loaded
	EP:RegisterPlugin(addon, LoadOptions)

	-- run the installer
	SpectraUI:CheckProfile()

	local profiles = {
		SpectraUI.Profiles.nova,
		SpectraUI.Profiles.spectra,
		SpectraUI.Profiles.spectraV2,
	}

	local function needsForceInstall(profile)
		return profile.private and profile.profile and not (profile.privateIsSet and profile.profileIsSet)
	end

	local forceInstall = false
	for _, profile in ipairs(profiles) do
		if needsForceInstall(profile) then
			forceInstall = true
			break
		end
	end

	if E.db.SpectraUI.install_version == nil or (forceInstall and not E.db.SpectraUI.profile_change_skip) then
		SpectraUI:RunInstaller()

		-- only popup one time for profile change, prevent spam
		if forceInstall then
			E.db.SpectraUI.profile_change_skip = true
		end
	end
end

function SpectraUI:PLAYER_ENTERING_WORLD(event)
	E:Delay(5, SpectraUI.PlayerPortrait)
end

-- Register module with callback so it gets initialized when ready
E:RegisterModule(SpectraUI:GetName())
