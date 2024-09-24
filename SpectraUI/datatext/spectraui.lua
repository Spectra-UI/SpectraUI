local E = unpack(ElvUI)
local DT = E:GetModule("DataTexts")

--WoW API / Variables
local _G = _G

local function OnEnter(self)
	DT.tooltip:ClearLines()
	DT.tooltip:AddDoubleLine(SpectraUI.Name, SpectraUI.Icon)
	DT.tooltip:AddDoubleLine("Version:", SpectraUI.Version)
	DT.tooltip:Show()
end

local function OnEvent(self, event, ...)
    self.text:SetText(SpectraUI.Name)
end

local function OnClick(self, event, ...)
    E:ToggleOptions("SpectraUI")
end

local function OnLeave(self)
	DT.tooltip:Hide()
end

DT:RegisterDatatext("SpectraUI_Menu", SpectraUI.Name, nil, OnEvent, nil, OnClick, OnEnter, OnLeave, SpectraUI.Name .. " Menu", nil, nil)
