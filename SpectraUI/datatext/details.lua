local E = unpack(ElvUI)
local DT = E:GetModule("DataTexts")

--WoW API / Variables
local _G = _G
local IsAddOnLoaded = _G.C_AddOns and _G.C_AddOns.IsAddOnLoaded or _G.IsAddOnLoaded

local function OnEnter(self)
	DT.tooltip:ClearLines()
	DT.tooltip:AddDoubleLine(SpectraUI.Name, SpectraUI.Icon)
	DT.tooltip:AddDoubleLine("Version:", SpectraUI.Version)
	DT.tooltip:Show()
end

local function OnEvent(self, event, ...)
    local color = SpectraUI.Addons.Details and "|CFFFFFFFF" or "|CFFF63939"
    self.text:SetText(color .. "Details|r")
end

local function OnClick(self, event, ...)
  if SpectraUI.Addons.Details then
    SpectraUI:Print("I WILL HIDE DETAILS ... soon :D")
    SpectraUI:DetailsEmbeddedToggle()
  end
end

local function OnLeave(self)
	DT.tooltip:Hide()
end

DT:RegisterDatatext("SpectraUI_Details", SpectraUI.Name, nil, OnEvent, nil, OnClick, OnEnter, OnLeave, SpectraUI.Name .. " Details", nil, nil)
