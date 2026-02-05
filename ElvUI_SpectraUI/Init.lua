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
SpectraUI = E:NewModule("SpectraUI", "AceHook-3.0", "AceEvent-3.0", "AceTimer-3.0", "AceConsole-3.0")

-- Load Locales
SpectraUI.Locales = LibStub("AceLocale-3.0"):GetLocale("SpectraUI")
local L = SpectraUI.Locales

-- Name, Logo and Icon for your plugin.
SpectraUI.Name = "|CFFFFFFFFSpectra|r|CFF2AB6FFUI|r" --#2AB6FF #FFFFFF
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
		hex = "|CFF2AB6FF",
		rgb = { 0.1647, 0.7137, 1, 1 },
		color = { r = 0.1647, g = 0.7137, b = 1, a = 1, hex = "|CFF2AB6FF" },
	},
}

SpectraUI.Links = {
	WA = {
		spectra = {
			classic = "https://wago.io/A2fUaQ0bp",
			retail = "https://wago.io/uPWYrGAFW",
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
	L["|CFFFFFFFFHoffa|r - |CFF2AB6FFAuthor|r"],
	L["|CFF00A3FFB|r|CFF00B4FFl|r|CFF00C6FFi|r|CFF00D8FFn|r|CFF00EAFFk|r|CFF00F6FFi|r|CFF00F6FFi|r - Foundational Programming"],
	L["|CFF0DB1D0Dlarge|r - DE Localization"],
	L["|CFF0DB1D0ZamestoTV|r - RU Localization"],
	L["|CFFFF41CFmMediaTag|r - Original textures and icons, used with Author permission"],
	L["|CFFC7D377Lillekatt|r  - Creator and provider of the Role Icons"],
	L["|CFFB2F9FFEltreum|r  - Backstage Support"],
	L["|CFFC500FFRepooc|r - Technical Guidance"],
	L["|CFF0DB1D0J|r|cff18A2D2i|r|cff2494D4b|r|cff2F86D7e|r|cff3B78D9r|r|cff4669DBi|r|cff525BDEs|r|cff5D4DE0h|r - The Spark Behind the Project"],
}

-- example of donators if you want to add some
SpectraUI.DONATORS = {
	"|CFFA335EELysergic|r - |CFFFF8000Ascended Supporter|r",

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

	-- add chat commands
	SpectraUI:LoadCommands()

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
		SpectraUI.Profiles.DPS,
		SpectraUI.Profiles.Healer,
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
