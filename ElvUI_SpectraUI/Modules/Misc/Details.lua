local E = unpack(ElvUI)
local L = SpectraUI.Locales

local _G = _G
local path = "Interface\\Addons\\ElvUI_SpectraUI\\media\\class\\"
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

local dropdownIcon = "Interface\\AddOns\\ElvUI_SpectraUI\\media\\icon.tga"
function SpectraUI:SetupDetails()
	for _, data in next, styles do
		_G.Details:AddCustomIconSet(data.texture, data.name, false, dropdownIcon, { 0, 1, 0, 1 })
	end
end

function SpectraUI:DetailsEmbedded()
    if detailsEmbedded then return end

    local config = E.db.SpectraUI.detailsEmbedded
    local chat = _G[config.chatEmbedded .. "Panel"]
	if not chat then return end
    local chatHeight, chatWidth = chat:GetHeight(), chat:GetWidth()

    detailsEmbedded = CreateFrame("Frame", "SpectraUI_DetailsEmbedded_Frame", UIParent, "BackdropTemplate")
    detailsEmbedded:SetFrameStrata("BACKGROUND")
    detailsEmbedded:SetSize(chatWidth, chatHeight)
    detailsEmbedded:SetBackdrop(chat.backdrop:GetBackdrop())
    detailsEmbedded:SetBackdropBorderColor(chat.backdrop:GetBackdropBorderColor())
    detailsEmbedded:SetBackdropColor(chat.backdrop:GetBackdropColor())

    for i = 1, chat:GetNumPoints() do
        local point, _, relativePoint, xOfs, yOfs = chat:GetPoint(i)
        detailsEmbedded:SetPoint(point, chat, relativePoint, xOfs, yOfs)
    end

    if config.style ~= "one" then
        local window_a = CreateFrame("Frame", "SpectraUI_DetailsEmbedded_Window_A", detailsEmbedded)
        local window_b = CreateFrame("Frame", "SpectraUI_DetailsEmbedded_Window_B", detailsEmbedded)
        local isTwoSide = (config.style == "two_side")

        window_a:SetSize(isTwoSide and (chatWidth / 2) - 1 or chatWidth, isTwoSide and chatHeight or (chatHeight / 2) - 1)
        window_b:SetSize(window_a:GetSize())
        window_a:SetPoint(isTwoSide and "LEFT" or "TOP", detailsEmbedded, isTwoSide and "LEFT" or "TOP")
        window_b:SetPoint(isTwoSide and "RIGHT" or "BOTTOM", detailsEmbedded, isTwoSide and "RIGHT" or "BOTTOM")

        detailsEmbedded.window_a, detailsEmbedded.window_b = window_a, window_b
    end

    chat:Hide()
    detailsEmbedded:Show()

    local function setupDetailsWindow(instanceID, parentFrame)
        local detailsWindow = Details:GetInstance(instanceID)
        if not detailsWindow or not (detailsWindow and detailsWindow.baseframe) then return end


        detailsWindow:UngroupInstance()
        detailsWindow.baseframe:SetParent(parentFrame)
        detailsWindow.baseframe:ClearAllPoints()
        detailsWindow.rowframe:SetParent(detailsWindow.baseframe)
        detailsWindow.rowframe:SetAllPoints()
        detailsWindow.windowSwitchButton:SetParent(detailsWindow.baseframe)
        detailsWindow.windowSwitchButton:SetAllPoints()

        local topOffset = detailsWindow.toolbar_side == 1 and -20 or 0
        local bottomOffset = (detailsWindow.show_statusbar and 14 or 0) + (detailsWindow.toolbar_side == 2 and 20 or 0)
        detailsWindow.baseframe:SetPoint("topleft", parentFrame, "topleft", 0, topOffset + Details.chat_tab_embed.y_offset)
        detailsWindow.baseframe:SetPoint("bottomright", parentFrame, "bottomright", Details.chat_tab_embed.x_offset, bottomOffset)

        detailsWindow:LockInstance(true)
        detailsWindow:SaveMainWindowPosition()
    end

    setupDetailsWindow(2, config.style == "one" and detailsEmbedded or detailsEmbedded.window_a)
    if config.style ~= "one" then
        setupDetailsWindow(1, detailsEmbedded.window_b)
    end
end


function SpectraUI:DetailsEmbeddedToggle()
	if detailsEmbedded then
		local chatEmbedded = E.db.SpectraUI.detailsEmbedded.chatEmbedded
		local chat = _G[chatEmbedded .. "Panel"]

		if detailsEmbedded:IsShown() then
			detailsEmbedded:Hide()
			chat:Show()
		else
			detailsEmbedded:Show()
			chat:Hide()
		end
	else
		SpectraUI:Print(format(L["|CFFF63939Error|r: Embedded System is disabled, you can enable it in the %s settings."], SpectraUI.Name))
	end
end
