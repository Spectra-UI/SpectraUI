-- Create references to ElvUI internals
local E = unpack(ElvUI)
local S = E:GetModule("Skins")
local _G = _G
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

-- Check if AddOns are loaded
function SpectraUI:CheckAddons()
    SpectraUI.Addons = SpectraUI.Addons or {}

    SpectraUI.Addons.BigWigs = IsAddOnLoaded("BigWigs")
    SpectraUI.Addons.Details = IsAddOnLoaded("Details")
    SpectraUI.Addons.WeakAuras = IsAddOnLoaded("WeakAuras")
    SpectraUI.Addons.Chattynator = IsAddOnLoaded("Chattynator")
    SpectraUI.Addons.Platynator = IsAddOnLoaded("Platynator")
    SpectraUI.Addons.Baganator = IsAddOnLoaded("Baganator")
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
			private = CheckForProfile(privateProfiles, "SpectraUI"),
			privateIsSet = E.charSettings:GetCurrentProfile() == "SpectraUI",
			dps = {
				private = CheckForProfile(privateProfiles, "SpectraUI"),
				profile = CheckForProfile(profiles, "SUI DPS/Tank"),
				privateIsSet = E.charSettings:GetCurrentProfile() == "SpectraUI",
				profileIsSet = E.data:GetCurrentProfile() == "SUI DPS/Tank",
			},
			healer = {
				private = CheckForProfile(privateProfiles, "SpectraUI"),
				profile = CheckForProfile(profiles, "SUI Healer"),
				privateIsSet = E.charSettings:GetCurrentProfile() == "SpectraUI",
				profileIsSet = E.data:GetCurrentProfile() == "SUI Healer",
			}
		}
	end
end

-- SpectraUI Unified Game Menu Integration
-- Disable ElvUI GameMenu Button
if E.SetupGameMenu then
    E.SetupGameMenu = function() end
end

if E.PositionGameMenuButton then
    E.PositionGameMenuButton = function() end
end

-- Helpers
local function IsStoreEnabled()
    return C_StorePublic and C_StorePublic.IsEnabled and C_StorePublic.IsEnabled()
end

-- TBC / Mists spacing table
local gameMenuLastButtons = {}

if _G.GAMEMENU_EXTERNALEVENT then
    gameMenuLastButtons.SpectraUI = IsStoreEnabled() and 3 or 2
    gameMenuLastButtons[_G.GAMEMENU_EXTERNALEVENT] = 1
    gameMenuLastButtons[_G.GAMEMENU_OPTIONS] = 2
    gameMenuLastButtons[_G.BLIZZARD_STORE] = 3
else
    gameMenuLastButtons.SpectraUI = IsStoreEnabled() and 2 or 1
    gameMenuLastButtons[_G.GAMEMENU_OPTIONS] = 1
    gameMenuLastButtons[_G.BLIZZARD_STORE] = 2
end

-- TBC / Mists positioning
local function Spectra_PositionGameMenu_Retail()
    if not GameMenuFrame.buttonPool then return end

    local offset = E.TBC and 20 or 35

    for button in GameMenuFrame.buttonPool:EnumerateActive() do
        local text = button:GetText()
        GameMenuFrame.MenuButtons[text] = button

        local lastIndex = gameMenuLastButtons[text]
        if lastIndex == gameMenuLastButtons.SpectraUI and GameMenuFrame.SpectraUI then
            GameMenuFrame.SpectraUI:ClearAllPoints()
            GameMenuFrame.SpectraUI:Point("TOPLEFT", button, "BOTTOMLEFT", 1, 10)
            GameMenuFrame.SpectraUI:NudgePoint(nil, -offset)
        elseif not lastIndex then
            button:NudgePoint(nil, -offset)
        end
    end

    GameMenuFrame:Height(GameMenuFrame:GetHeight() + offset)
end

-- Classic ERA positioning
local function Spectra_PositionGameMenu_Classic()
    local btn = GameMenuFrame.SpectraUI
    if not btn then return end

    btn:ClearAllPoints()

    local addons = _G.GameMenuButtonAddons
    if addons then
        btn:SetPoint("TOPLEFT", addons, "BOTTOMLEFT", 0, -1)
    end

    local logout = _G.GameMenuButtonLogout
    if logout then
        local _, _, _, _, offY = logout:GetPoint()
        logout:ClearAllPoints()
        logout:SetPoint("TOPLEFT", btn, "BOTTOMLEFT", 0, offY)
    end

    GameMenuFrame:SetHeight(
        GameMenuFrame:GetHeight() + btn:GetHeight() - 4
    )
end

-- Unified setup
local function Spectra_SetupGameMenu()
    if GameMenuFrame.SpectraUI then return end

    local isRetail = E.Retail or E.TBC
    local template = isRetail
        and "MainMenuFrameButtonTemplate"
        or "GameMenuButtonTemplate"

    local button = CreateFrame(
        "Button",
        "SpectraUI_GameMenuButton",
        GameMenuFrame,
        template
    )

    -- Branding
    button:SetText("SpectraUI")
    button:GetFontString():SetText(SpectraUI.Name)

    -- Skin
    S:HandleButton(button, nil, nil, nil, true)

    -- Click behavior
    button:SetScript("OnClick", function()
        if InCombatLockdown() then return end
        E:ToggleOptions()
        HideUIPanel(GameMenuFrame)
    end)

    -- Client specific setup
    if isRetail then
        button:SetSize(E.TBC and 142 or 198, E.TBC and 21 or 35)
        GameMenuFrame.MenuButtons = {}
        hooksecurefunc(GameMenuFrame, "Layout", Spectra_PositionGameMenu_Retail)
    else
        local logout = _G.GameMenuButtonLogout
        if logout then
            button:SetSize(logout:GetSize())
        end

        hooksecurefunc("GameMenuFrame_UpdateVisibleButtons", Spectra_PositionGameMenu_Classic)
        GameMenuFrame:HookScript("OnShow", Spectra_PositionGameMenu_Classic)
    end

    GameMenuFrame.SpectraUI = button
end

-- AddOn loaded print
function SpectraUI:PrintLoginMessage()
	local addonName = "ElvUI_SpectraUI"

	local title = (C_AddOns and C_AddOns.GetAddOnMetadata(addonName, "Title"))
		or GetAddOnMetadata(addonName, "Title")

	local version = (C_AddOns and C_AddOns.GetAddOnMetadata(addonName, "Version"))
		or GetAddOnMetadata(addonName, "Version")

	title = title or SpectraUI.Name
	version = version or "Unknown"

	E.global.SpectraUI = E.global.SpectraUI or {}
	local previousVersion = E.global.SpectraUI.lastVersion

	local isFirstInstall = not previousVersion
	local isUpdate = previousVersion and previousVersion ~= version

	-- LINE 1 (always prints)
	if isUpdate then
		print(title .. " |cff43eb47New Version|r |cff2AB6FF" .. version .. "|r loaded.")
	else
		print(title .. " |cff2AB6FF" .. version .. "|r loaded.")
	end

	-- LINE 2 (state specific)
	if isFirstInstall then
		print("Type |cff2ab6ff/sui|r to open Spectra|cff2ab6ffUI|r options. If the installer did not launch automatically, Type |cff2ab6ff/sui install|r.")

	elseif isUpdate then
        SpectraUI:Print("has been updated |cff43eb47successfully|r.")
    	end

	E.global.SpectraUI.lastVersion = version
end

-- Init
local init = CreateFrame("Frame")
init:RegisterEvent("PLAYER_ENTERING_WORLD")
init:SetScript("OnEvent", function(self, event, isInitialLogin, isReloadingUi)
	if GameMenuFrame then
		Spectra_SetupGameMenu()
	end

	-- Only print on login or reload (not zoning)
	if isInitialLogin or isReloadingUi then
		SpectraUI:PrintLoginMessage()
	end
end)