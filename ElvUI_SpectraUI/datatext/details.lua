local E = unpack(ElvUI)
local L = SpectraUI.Locales

local DT = E:GetModule("DataTexts")

--WoW API / Variables
local _G = _G
local Details = _G.Details

local function OnEnter(self)
	DT.tooltip:ClearLines()
	DT.tooltip:AddDoubleLine(SpectraUI.Name, SpectraUI.Media.icon)
	DT.tooltip:AddLine(" ")
	if Details then
	DT.tooltip:AddDoubleLine(L["|CFFFFFFFFLeft click:|r"], L["Toggle Details"])
	DT.tooltip:AddDoubleLine(L["|CFFFFFFFFRight click:|r"], L["Open Settings"])
	else
		DT.tooltip:AddLine(L["|CFFF63939Details not found!|r |CFFFFFFFF(details is not installed or enabled)|r"])
	end
	DT.tooltip:Show()
end

local function OnEvent(self)
	local color = SpectraUI.Addons.Details and "|CFFFFFFFF" or "|CFFF63939"
	self.text:SetText(color .. "Details|r")
end

local function OnClick(_, button)
	if Details then
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
end

local function OnLeave(self)
	DT.tooltip:Hide()
end

DT:RegisterDatatext("SpectraUI_Details", SpectraUI.Name, nil, OnEvent, nil, OnClick, OnEnter, OnLeave, SpectraUI.Name .. " Details", nil, nil)
