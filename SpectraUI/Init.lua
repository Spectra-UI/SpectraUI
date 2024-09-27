local addon, ns = ...
GetAddOnMetadata = _G.C_AddOns and _G.C_AddOns.GetAddOnMetadata or _G.GetAddOnMetadata
local Version = GetAddOnMetadata(addon, "Version")

-- Cache Lua / WoW API
local format = string.format
local ReloadUI = ReloadUI
local tconcat = _G.table.concat
local IsAddOnLoaded = _G.C_AddOns and _G.C_AddOns.IsAddOnLoaded or _G.IsAddOnLoaded
local path = "Interface\\AddOns\\SpectraUI\\media\\"
local InstallerData = {}

-- Change this line and use a unique name for your plugin.
local MyPluginName = "SpectraUI"

-- Create references to ElvUI internals
local E, _, V, P, G = unpack(ElvUI)
local PI = E:GetModule("PluginInstaller")

-- Create reference to LibElvUIPlugin
local EP = LibStub("LibElvUIPlugin-1.0")

-- Create a new ElvUI module so ElvUI can handle initialization when ready
SpectraUI = E:NewModule(MyPluginName, "AceHook-3.0", "AceEvent-3.0", "AceTimer-3.0")

-- settings
SpectraUI.Locales = LibStub("AceLocale-3.0"):GetLocale("SpectraUI")

-- Name, Logo and Icon for your plugin.
SpectraUI.Name = "|CFFFFFFFFSpectra|r |CFF03FA6EUI|r" --#03FA6E #FFFFFF
SpectraUI.Version = Version
SpectraUI.UIColor = { r = 0, g = 0.98, b = 0.44, a = 1, hex = "|CFF03FA6E" }
SpectraUI.Icon = "|TInterface\\AddOns\\SpectraUI\\media\\icon.tga:14:14|t"
SpectraUI.Logo = "Interface\\AddOns\\SpectraUI\\media\\logo.tga"
SpectraUI.LogoText = "Interface\\AddOns\\SpectraUI\\media\\logo_text.tga"
SpectraUI.DicordLogo = "|TInterface\\AddOns\\SpectraUI\\media\\discord_logo.tga:14:14|t"
SpectraUI.Addons = {}
SpectraUI.InstallerData = {}
SpectraUI.Options = {}

local L = SpectraUI.Locales

-- example of credits if you want to add some
SpectraUI.CREDITS = {
	L["|CFF03FA6EHoffa|r  - Author"], --#16F5EE
	L["|CFF00A3FFB|r|CFF00B4FFl|r|CFF00C6FFi|r|CFF00D8FFn|r|CFF00EAFFk|r|CFF00F6FFi|r|CFF00F6FFi|r - Programming"],
	L["|CFFC7D377Lillekatt|r  - Creator and provider of the Role Icons"],
	"|cffc500ffRepooc|r",
	"|cff0DB1D0J|r|cff18A2D2i|r|cff2494D4b|r|cff2F86D7e|r|cff3B78D9r|r|cff4669DBi|r|cff525BDEs|r|cff5D4DE0h|r",
	"|cff0DB1D0Dlarge|r - Localization",
}

-- example of donators if you want to add some
SpectraUI.DONATORS = {
	-- "EXAMPLE",
}



function SpectraUI:Setup_mMediaTag()
	if not IsAddOnLoaded("ElvUI_mMediaTag") then return end

	SpectraUI:AddPortraitsTextures()

	local textureCoords = {
		WARRIOR = { 0, 0, 0, 0.125, 0.125, 0, 0.125, 0.125 },
		MAGE = { 0.125, 0, 0.125, 0.125, 0.25, 0, 0.25, 0.125 },
		ROGUE = { 0.25, 0, 0.25, 0.125, 0.375, 0, 0.375, 0.125 },
		DRUID = { 0.375, 0, 0.375, 0.125, 0.5, 0, 0.5, 0.125 },
		EVOKER = { 0.5, 0, 0.5, 0.125, 0.625, 0, 0.625, 0.125 },
		HUNTER = { 0, 0.125, 0, 0.25, 0.125, 0.125, 0.125, 0.25 },
		SHAMAN = { 0.125, 0.125, 0.125, 0.25, 0.25, 0.125, 0.25, 0.25 },
		PRIEST = { 0.25, 0.125, 0.25, 0.25, 0.375, 0.125, 0.375, 0.25 },
		WARLOCK = { 0.375, 0.125, 0.375, 0.25, 0.5, 0.125, 0.5, 0.25 },
		PALADIN = { 0, 0.25, 0, 0.375, 0.125, 0.25, 0.125, 0.375 },
		DEATHKNIGHT = { 0.125, 0.25, 0.125, 0.375, 0.25, 0.25, 0.25, 0.375 },
		MONK = { 0.25, 0.25, 0.25, 0.375, 0.375, 0.25, 0.375, 0.375 },
		DEMONHUNTER = { 0.375, 0.25, 0.375, 0.375, 0.5, 0.25, 0.5, 0.375 },
	}

	mMT:AddClassIcons("SpectraUI_Classic", path .. "class\\SpectraUI_Classic.tga", textureCoords, "SpectraUI Classic")
	mMT:AddClassIcons("SpectraUI_Modern", path .. "class\\SpectraUI_Modern.tga", textureCoords, "SpectraUI Modern")
end

local function CheckAddons()
	SpectraUI.Addons.BigWigs = IsAddOnLoaded("BigWigs")
	SpectraUI.Addons.CooldownTimeline2 = IsAddOnLoaded("CooldownTimeline2")
	SpectraUI.Addons.CooldownToGo = IsAddOnLoaded("CooldownToGo")
	SpectraUI.Addons.Details = IsAddOnLoaded("Details")
	SpectraUI.Addons.OmniCD = IsAddOnLoaded("OmniCD")
	SpectraUI.Addons.SylingTracker = IsAddOnLoaded("SylingTracker")
	SpectraUI.Addons.mMediaTag = IsAddOnLoaded("ElvUI_mMediaTag")
end

-- load our options table
local function LoadOptions()
	for _, func in pairs(SpectraUI.Options) do
		func()
	end
end


-- This function will handle initialization of the addon
function SpectraUI:Initialize()
	-- Initiate installation process if ElvUI install is complete and our plugin install has not yet been run
	if E.private.install_complete and E.db[MyPluginName].install_version == nil then PI:Queue(InstallerData) end

	-- check wich addons are loaded
	CheckAddons()

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
