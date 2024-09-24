local E, L, V, P, G = unpack(ElvUI)

local _G = _G
local path = "Interface\\Addons\\SpectraUI\\media\\class\\"
local detailsEmbedded

local styles = {
	border = {
		name = SpectraUI.Name .. "- Modern",
		texture = path .. "SpectraUI_Modern.tga",
	},
	classborder = {
		name = SpectraUI.Name .. "- Classic",
		texture = path .. "SpectraUI_Classic.tga",
	},
}

local dropdownIcon = "Interface\\AddOns\\SpectraUI\\media\\icon.tga"
function SpectraUI:SetupDetails()
	for _, data in next, styles do
		_G.Details:AddCustomIconSet(data.texture, data.name, false, dropdownIcon, { 0, 1, 0, 1 })
	end
end

local settings = {
	double = true,
}
function SpectraUI:DetailsEmbedded()
	if not detailsEmbedded then
		detailsEmbedded = CreateFrame("Frame", "SpectraUI_DetailsEmbedded_Frame", UIParent)
		detailsEmbedded:SetFrameStrata("BACKGROUND")
		detailsEmbedded:SetWidth(500)
		detailsEmbedded:SetHeight(200)
		detailsEmbedded:SetPoint("CENTER", 0, 0)
		detailsEmbedded:CreateBackdrop() -- for testing
		detailsEmbedded:Show()

		E:CreateMover(detailsEmbedded, "SpectraUI_DetailsEmbedded_Mover", "SpectraUI_DetailsEmbedded_Frame", nil, nil, nil, "ALL", nil, "SpectraUI", nil)
	end

	--_G.Details.opened_windows
	if _G["DetailsBaseFrame1"] then
		_G["DetailsBaseFrame1"]:SetParent(detailsEmbedded)
		_G["DetailsBaseFrame1"]:ClearAllPoints()
		_G["DetailsBaseFrame1"]:SetPoint("TOPLEFT", detailsEmbedded, "TOPLEFT", 0, -20)
	end

	mMT:DebugPrintTable(_G.Details, nil, true)
end

function SpectraUI:DetailsEmbeddedToggle()
	if detailsEmbedded:IsShown() then
		detailsEmbedded:Hide()
	else
		detailsEmbedded:Show()
	end
end
