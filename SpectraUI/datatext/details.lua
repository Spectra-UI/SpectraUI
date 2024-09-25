local E = unpack(ElvUI)
local DT = E:GetModule("DataTexts")

--WoW API / Variables
local _G = _G
local IsAddOnLoaded = _G.C_AddOns and _G.C_AddOns.IsAddOnLoaded or _G.IsAddOnLoaded
local Details = _G.Details

local function OnEnter(self)
	DT.tooltip:ClearLines()
	DT.tooltip:AddDoubleLine(SpectraUI.Name, SpectraUI.Icon)
	DT.tooltip:AddLine(" ")
	DT.tooltip:AddDoubleLine("|CFFFFFFFFLeft click:|r", "toggle Details")
	DT.tooltip:AddDoubleLine("|CFFFFFFFFRight click:|r", "open Settings")
	DT.tooltip:Show()
end

local function OnEvent(self, event, ...)
	local color = SpectraUI.Addons.Details and "|CFFFFFFFF" or "|CFFF63939"
	self.text:SetText(color .. "Details|r")
end

local function OnClick(_, button)
	if button == "LeftButton" and SpectraUI.Addons.Details then
		SpectraUI:DetailsEmbeddedToggle()
	else
		if _G.DetailsOptionsWindow then
			if _G.DetailsOptionsWindow:IsShown() then
				_G.DetailsOptionsWindow:Hide()
				return
			end
		end

		local lower_instance = Details:GetLowerInstanceNumber()
		if not lower_instance then
			local instance = Details:GetInstance(1)
			Details.CriarInstancia(_, _, 1)
			Details:OpenOptionsWindow(instance)
		else
			Details:OpenOptionsWindow(Details:GetInstance(lower_instance))
		end
	end
end

local function OnLeave(self)
	DT.tooltip:Hide()
end

DT:RegisterDatatext("SpectraUI_Details", SpectraUI.Name, nil, OnEvent, nil, OnClick, OnEnter, OnLeave, SpectraUI.Name .. " Details", nil, nil)
