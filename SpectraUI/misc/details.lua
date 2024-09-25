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
		local chatEmbedded = E.db.SpectraUI.detailsEmbedded.chatEmbedded
		local chat = _G[chatEmbedded .. "Panel"]

		detailsEmbedded = CreateFrame("Frame", "SpectraUI_DetailsEmbedded_Frame", UIParent, "BackdropTemplate")
		detailsEmbedded:SetFrameStrata("BACKGROUND")

		local chatHeight = chat:GetHeight()
		local chatWidth = chat:GetWidth()
		print(chatHeight, chatWidth)

		local backdrop = chat.backdrop:GetBackdrop()
		detailsEmbedded:SetBackdrop(backdrop)

		local r, g, b, a = chat.backdrop:GetBackdropBorderColor()
		detailsEmbedded:SetBackdropBorderColor(r, g, b, a)

		r, g, b, a = chat.backdrop:GetBackdropColor()
		detailsEmbedded:SetBackdropColor(r, g, b, a)

		detailsEmbedded:SetWidth(chatWidth)
		detailsEmbedded:SetHeight(chatHeight)

		for i = 1, chat:GetNumPoints() do
			local point, _, relativePoint, xOfs, yOfs = chat:GetPoint(i)
			detailsEmbedded:SetPoint(point, chat, relativePoint, xOfs, yOfs)
		end

		chat:Hide()
		detailsEmbedded:Show()
	end

	local detailsBaseFrame = _G["DetailsBaseFrame1"]
	if detailsBaseFrame then
		detailsBaseFrame:SetParent(detailsEmbedded)
		detailsBaseFrame:ClearAllPoints()
		detailsBaseFrame:SetPoint("TOPLEFT", detailsEmbedded, "TOPLEFT", 0, -20)
		_G["DetailsRowFrame1"]:SetParent(detailsEmbedded)
		_G["Details_SwitchButtonFrame1"]:SetParent(detailsEmbedded)
	end
end

function SpectraUI:DetailsEmbeddedToggle()
	local chatEmbedded = E.db.SpectraUI.detailsEmbedded.chatEmbedded
	local chat = _G[chatEmbedded .. "Panel"]

	if detailsEmbedded:IsShown() then
		detailsEmbedded:Hide()
		chat:Show()
	else
		detailsEmbedded:Show()
		chat:Hide()
	end
end
