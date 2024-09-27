local E = unpack(ElvUI)
local L = SpectraUI.Locales

local DT = E:GetModule("DataTexts")
local M = E:GetModule('Minimap')

--WoW API / Variables
local _G = _G
local format = string.format
local ReloadUI = ReloadUI
local IsShiftKeyDown = IsShiftKeyDown

local function OnEnter(self)
	DT.tooltip:ClearLines()
	DT.tooltip:AddDoubleLine(SpectraUI.Name, SpectraUI.Media.icon)
	DT.tooltip:AddDoubleLine("Version:", SpectraUI.Version)
	DT.tooltip:AddLine(" ")
	DT.tooltip:AddDoubleLine("|CFFFFFFFFLeft click:|r", format("open %s Settings", SpectraUI.Name))
	DT.tooltip:AddDoubleLine("|CFFFFFFFFRight click:|r", "open Menu")
	DT.tooltip:AddDoubleLine(SpectraUI.UIColor.hex .. "SHIFT|r " .. "|CFFFFFFFFLeft click:|r", "ReloadUI (/rl)")
	DT.tooltip:Show()
end

local function OnEvent(self, event, ...)
	self.text:SetText(SpectraUI.Name)
end

local function OnClick(_, button)
	if button == "LeftButton" then
		if IsShiftKeyDown() then
			ReloadUI()
		else
			E:ToggleOptions("SpectraUI")
		end
	elseif button == "RightButton" then
		M:Minimap_OnMouseDown("MiddleButton")
	end
end

local function OnLeave(self)
	DT.tooltip:Hide()
end

DT:RegisterDatatext("SpectraUI_Menu", SpectraUI.Name, nil, OnEvent, nil, OnClick, OnEnter, OnLeave, SpectraUI.Name .. " Menu", nil, nil)
