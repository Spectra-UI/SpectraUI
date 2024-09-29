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
SpectraUI.Name = "|CFFFFFFFFSpectra|r |CFF03FA6EUI|r" --#03FA6E #FFFFFF
SpectraUI.Version = GetAddOnMetadata(addon, "Version")

SpectraUI.Media = {
	mediaPath = "Interface\\AddOns\\SpectraUI\\media\\",
	icon = "|TInterface\\AddOns\\SpectraUI\\media\\icon.tga:14:14|t",
	logo = "Interface\\AddOns\\SpectraUI\\media\\logo.tga",
	logoText = "Interface\\AddOns\\SpectraUI\\media\\logo_text.tga",
	discordLogo = "|TInterface\\AddOns\\SpectraUI\\media\\discord_logo.tga:14:14|t",
}

SpectraUI.Color = {
	ui = {
		hex = "|CFF03FA6E",
		rgb = { 0, 0.98, 0.44, 1},
		color = { r = 0, g = 0.98, b = 0.44, a = 1, hex = "|CFF03FA6E" },
	}
}

SpectraUI.Links = {
	WA = {
		frames = {
				classic = "https://wago.io/TKMI9EwrP",
				retail = "https://wago.io/Kqz6loIke",
		},
		elements = {
			classic = "https://wago.io/Kgw3rnboZ",
			retail = "https://wago.io/MBm1s8QQa",
		}
	}
}

-- other global settings
SpectraUI.Addons = {}
SpectraUI.InstallerData = {}
SpectraUI.Options = {}

-- example of credits if you want to add some
SpectraUI.CREDITS = {
	L["|CFF03FA6EHoffa|r  - Author"], --#16F5EE
	L["|CFF00A3FFB|r|CFF00B4FFl|r|CFF00C6FFi|r|CFF00D8FFn|r|CFF00EAFFk|r|CFF00F6FFi|r|CFF00F6FFi|r - Programming"],
	L["|cff0DB1D0Dlarge|r - Localization"],
	L["|CFFC7D377Lillekatt|r  - Creator and provider of the Role Icons"],
	"|cffc500ffRepooc|r",
	"|cff0DB1D0J|r|cff18A2D2i|r|cff2494D4b|r|cff2F86D7e|r|cff3B78D9r|r|cff4669DBi|r|cff525BDEs|r|cff5D4DE0h|r",
}

-- example of donators if you want to add some
SpectraUI.DONATORS = {
	-- "EXAMPLE",
}

-- load our options table
local function LoadOptions()
	for _, func in pairs(SpectraUI.Options) do
		func()
	end
end


-- This function will handle initialization of the addon
function SpectraUI:Initialize()
	-- Initiate installation process if ElvUI install is complete and our plugin install has not yet been run
	if E.private.install_complete and E.db.SpectraUI.install_version == nil then SpectraUI:RunInstaller() end

	-- check wich addons are loaded
	SpectraUI:CheckAddons()

	-- add textures to mMT
	SpectraUI:Setup_mMediaTag()

	-- do this only if details is loaded
	if SpectraUI.Addons.Details then
		-- details embedded feature
		if E.db.SpectraUI.detailsEmbedded.chatEmbedded ~= "DISABLE" then SpectraUI:DetailsEmbedded() end

		-- add class icons to details
		SpectraUI:SetupDetails()
	end

	-- Insert our options table when ElvUI config is loaded
	EP:RegisterPlugin(addon, LoadOptions)
end

-- Register module with callback so it gets initialized when ready
E:RegisterModule(SpectraUI:GetName())
