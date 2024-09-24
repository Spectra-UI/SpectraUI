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

function SpectraUI:DetailsEmbedded()
	if not detailsEmbedded then
		local wide = E.db.SpectraUI.detailsEmbedded.size.wide
		local height = E.db.SpectraUI.detailsEmbedded.size.height
		local chatEmbedded = E.db.SpectraUI.detailsEmbedded.chatEmbedded
		local color = E.db.chat.panelColor
		if chatEmbedded ~= "NONE" then
			E.db.movers.SpectraUI_DetailsEmbedded_Mover = E.db.movers[chatEmbedded .. "Mover"]
			wide = E.db.chat.panelWidth - 2
			height = E.db.chat.panelHeight - 2
			_G[chatEmbedded .. "Panel"]:Hide()
		end

		detailsEmbedded = CreateFrame("Frame", "SpectraUI_DetailsEmbedded_Frame", UIParent)
		detailsEmbedded:SetFrameStrata("BACKGROUND")
		detailsEmbedded:SetWidth(wide)
		detailsEmbedded:SetHeight(height)
		detailsEmbedded:SetPoint("CENTER", 0, 0)
		detailsEmbedded:CreateBackdrop("Transparent")
		detailsEmbedded.backdrop:SetBackdropColor(color.r, color.g, color.b, color.a)
		detailsEmbedded:Show()

		E:CreateMover(detailsEmbedded, "SpectraUI_DetailsEmbedded_Mover", "SpectraUI_DetailsEmbedded_Frame", nil, nil, nil, "ALL", nil, "SpectraUI", nil)
	end

	--_G.Details.opened_windows
	if _G["DetailsBaseFrame1"] then
		_G["DetailsBaseFrame1"]:SetParent(detailsEmbedded)
		_G["DetailsRowFrame1"]:SetParent(detailsEmbedded)
		_G["Details_SwitchButtonFrame1"]:SetParent(detailsEmbedded)
		_G["DetailsBaseFrame1"]:ClearAllPoints()
		_G["DetailsBaseFrame1"]:SetPoint("TOPLEFT", detailsEmbedded, "TOPLEFT", 0, -20)
	end

	mMT:DebugPrintTable(detailsEmbedded)
	local child = _G.RightChatPanel:GetChildren()
	--mMT:DebugPrintTable(child)
end

function SpectraUI:DetailsEmbeddedToggle()
	local chatEmbedded = E.db.SpectraUI.detailsEmbedded.chatEmbedded
	if detailsEmbedded:IsShown() then
		detailsEmbedded:Hide()
		_G[chatEmbedded .. "Panel"]:Show()
	else
		detailsEmbedded:Show()
		_G[chatEmbedded .. "Panel"]:Hide()
	end
end

function SpectraUI:DetailsEmbeddedUpdateSize()
	if detailsEmbedded then
		local wide = E.db.SpectraUI.detailsEmbedded.size.wide
		local height = E.db.SpectraUI.detailsEmbedded.size.height
		local chatEmbedded = E.db.SpectraUI.detailsEmbedded.chatEmbedded
		if chatEmbedded ~= "NONE" then
			E.db.movers.SpectraUI_DetailsEmbedded_Mover = E.db.movers[chatEmbedded .. "Mover"]
			wide = E.db.chat.panelWidth - 2
			height = E.db.chat.panelHeight - 2
		end

		detailsEmbedded:SetWidth(wide)
		detailsEmbedded:SetHeight(height)
	end
end
