-- ElvUI
local E = unpack(ElvUI)
local L = SpectraUI.Locales

-- Module
local StatusReport = SpectraUI:NewModule("StatusReport")

-- Lua
local wipe, sort = wipe, sort
local format = string.format
local next, pairs, ipairs, tinsert = next, pairs, ipairs, tinsert

-- WoW API
local CreateFrame = CreateFrame
local IsAddOnLoaded = (C_AddOns and C_AddOns.IsAddOnLoaded) or IsAddOnLoaded
local GetRealZoneText = GetRealZoneText
local GetAddOnMetadata = (C_AddOns and C_AddOns.GetAddOnMetadata) or GetAddOnMetadata
local UNKNOWN = UNKNOWN

-- Colors
local GOOD_COLOR = "43eb47"
local BAD_COLOR  = "ff5353"
local INFO_COLOR = "fbde29"

local FACTION_COLORS = {
	Alliance = "4A9EFF",
	Horde    = "E84C4C",
}

local CLIENT_COLORS = {
	["Classic Era"] = "fbde29",
	["TBC Anniversary"] = "a1e145",
	["Wrath of the Lich King"] = "69A9FF",
	["Mists of Pandaria"] = "00FF96",
}

-- Helpers: Coloring
local function ColorText(hex, text)
	return format("|cff%s%s|r", hex, text)
end

local function ValueColor(isGood)
	return isGood and GOOD_COLOR or BAD_COLOR
end


-- Helpers: Client detection
local function GetClientName()
	if E.Classic then
		return "Classic Era"
	elseif E.TBC then
		return "TBC Anniversary"
	elseif E.Wrath then
		return "Wrath of the Lich King"
	elseif E.Mists then
		return "Mists of Pandaria"
	end
	return UNKNOWN
end

-- Helpers: Normalize version strings
local function NormalizeVersion(version)
	if type(version) ~= "string" then
		return version
	end

	version = version:match("^%s*(.-)%s*$")
	version = version:gsub("^[Vv]ersion%s*", "")
	version = version:gsub("^[vV]", "")

	return version
end

-- Curated AddOn List
local TRACKED_ADDONS = {
	"ElvUI",
	"WeakAuras",
	"Details",
	"BigWigs",
	"LittleWigs",
	"Chattynator",
	"Platynator",
	"Auctionator",
	"ElvUI_ActionBarBuddy",
	"Baganator",
	"Leatrix_Plus",
	"Leatrix_Maps",
}

-- Class Names
local englishClassName = {
	DEATHKNIGHT = "Death Knight",
	DEMONHUNTER = "Demon Hunter",
	DRUID = "Druid",
	EVOKER = "Evoker",
	HUNTER = "Hunter",
	MAGE = "Mage",
	MONK = "Monk",
	PALADIN = "Paladin",
	PRIEST = "Priest",
	ROGUE = "Rogue",
	SHAMAN = "Shaman",
	WARLOCK = "Warlock",
	WARRIOR = "Warrior",
}

-- Helpers: Create content lines
function StatusReport:StatusReportCreateContent(num, width, parent, anchorTo, content)
	if not content then
		content = CreateFrame("Frame", nil, parent)
	end

	content:SetSize(width, (num * 20) + ((num - 1) * 5))
	content:SetPoint("TOP", anchorTo, "BOTTOM", 0, -5)

	for i = 1, num do
		if not content["Line" .. i] then
			local line = CreateFrame("Frame", nil, content)
			line:SetSize(width, 20)

			local text = line:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
			text:SetAllPoints()
			text:SetJustifyH("LEFT")
			text:SetJustifyV("MIDDLE")
			line.Text = text

			if i == 1 then
				line:SetPoint("TOP", content, "TOP")
			else
				line:SetPoint("TOP", content["Line" .. (i - 1)], "BOTTOM", 0, -5)
			end

			content["Line" .. i] = line
		end
	end

	return content
end

-- Helpers: Create section
function StatusReport:StatusReportCreateSection(width, height, headerWidth, headerHeight, parent, anchor1, anchorTo, anchor2, yOffset)
	local parentWidth, parentHeight = parent:GetSize()

	if width > parentWidth then parent:SetWidth(width + 25) end
	if height then parent:SetHeight(parentHeight + height) end

	local section = CreateFrame("Frame", nil, parent)
	section:SetSize(width, height or 0)
	section:SetPoint(anchor1, anchorTo, anchor2, 0, yOffset)

	local header = CreateFrame("Frame", nil, section)
	header:SetSize(headerWidth or width, headerHeight or 24)
	header:SetPoint("TOP", section)
	section.Header = header

	local text = header:CreateFontString(nil, "ARTWORK", "GameFontHighlightLarge")
	text:SetPoint("CENTER")
	header.Text = text

	local left = header:CreateTexture(nil, "ARTWORK")
	left:SetHeight(1)
	left:SetPoint("LEFT", header, "LEFT", 8, 0)
	left:SetPoint("RIGHT", text, "LEFT", -8, 0)
	left:SetColorTexture(1, 1, 1, 0.25)

	local right = header:CreateTexture(nil, "ARTWORK")
	right:SetHeight(1)
	right:SetPoint("RIGHT", header, "RIGHT", -8, 0)
	right:SetPoint("LEFT", text, "RIGHT", 8, 0)
	right:SetColorTexture(1, 1, 1, 0.25)

	return section
end

-- Create main frame
function StatusReport:StatusReportCreate()
	local statusFrame = CreateFrame("Frame", "SpectraUIStatusReport", E.UIParent)
	statusFrame:SetPoint("CENTER")
	statusFrame:SetFrameStrata("DIALOG")
	statusFrame:SetClampedToScreen(true)
	statusFrame:SetMovable(true)
	statusFrame:EnableMouse(true)
	statusFrame:RegisterForDrag("LeftButton")
	statusFrame:SetScript("OnDragStart", statusFrame.StartMoving)
	statusFrame:SetScript("OnDragStop", statusFrame.StopMovingOrSizing)
	statusFrame:SetSize(430, 100)
	statusFrame:Hide()

	statusFrame:CreateBackdrop("Transparent")
	statusFrame:CreateCloseButton()

	-- Logo Header
	local header = CreateFrame("Frame", nil, statusFrame, "TitleDragAreaTemplate")
	header:SetPoint("TOP", statusFrame, "TOP", 0, -12)
	header:SetSize(240, 32)
	statusFrame.Header = header
	
	local logo = header:CreateTexture(nil, "ARTWORK")
	logo:SetPoint("CENTER", header, "CENTER", 0, -9)
	logo:SetTexture(SpectraUI.Media.logo)
	logo:SetSize(300, 150)
	
	logo:SetBlendMode("ADD")
	logo:SetAlpha(0.4)
	
	header.Logo = logo

	-- AddOn Frame
	local addOnFrame = CreateFrame("Frame", nil, statusFrame)
	addOnFrame:SetPoint("TOPLEFT", statusFrame, "TOPRIGHT", 12, 0)
	addOnFrame:SetFrameStrata("DIALOG")
	addOnFrame:SetSize(300, 25)
	addOnFrame:CreateBackdrop("Transparent")
	statusFrame.AddOnFrame = addOnFrame

	local mainSectionWidth = 400
	local mainSectionPadding = 40
	local sideSectionWidth = 280

	-- Sections
	statusFrame.Section1 = self:StatusReportCreateSection(mainSectionWidth, (5 * 30) + 5, nil, 30, statusFrame, "TOP", header, "BOTTOM", -15)
	statusFrame.Section2 = self:StatusReportCreateSection(mainSectionWidth, (3 * 30) + 15, nil, 30, statusFrame, "TOP", statusFrame.Section1, "BOTTOM", -5)
	statusFrame.Section3 = self:StatusReportCreateSection(mainSectionWidth, (5 * 30) + 15, nil, 30, statusFrame, "TOP", statusFrame.Section2, "BOTTOM", -5)
	addOnFrame.SectionA = self:StatusReportCreateSection(sideSectionWidth, nil, nil, 30, addOnFrame, "TOP", addOnFrame, "TOP", -10)

	statusFrame.Section1.Content = self:StatusReportCreateContent(5, mainSectionWidth - mainSectionPadding, statusFrame.Section1, statusFrame.Section1.Header)
	statusFrame.Section2.Content = self:StatusReportCreateContent(3, mainSectionWidth - mainSectionPadding, statusFrame.Section2, statusFrame.Section2.Header)
	statusFrame.Section3.Content = self:StatusReportCreateContent(5, mainSectionWidth - mainSectionPadding, statusFrame.Section3, statusFrame.Section3.Header)

	return statusFrame
end

-- Update content
function StatusReport:StatusReportUpdate()
	local statusFrame = self.StatusReportFrame
	local addOnFrame = statusFrame.AddOnFrame

	statusFrame.Section1.Header.Text:SetText("|cff2ab6ffA|rDDON INFO")
	statusFrame.Section2.Header.Text:SetText("|cff2ab6ffW|rOW INFO")
	statusFrame.Section3.Header.Text:SetText("|cff2ab6ffC|rHARACTER INFO")
	
	local pixelScale = tonumber(E:PixelBestSize()) or 0
	local uiScale = tonumber(E.global.general.UIScale) or 0
	local scaleMatch = math.abs(uiScale - pixelScale) < 0.001

	local res = E.resolution or ""
	local width, height = res:match("^(%d+)x(%d+)$")
	width = tonumber(width) or 0
	height = tonumber(height) or 0
	local goodResolution = height >= 1440

	local clientName = GetClientName()
	local clientColor = CLIENT_COLORS[clientName] or GOOD_COLOR

	local classColor = RAID_CLASS_COLORS[E.myclass]
	local classHex = classColor and classColor:GenerateHexColor():sub(3) or GOOD_COLOR

	local factionHex = FACTION_COLORS[E.myfaction] or GOOD_COLOR

	-- AddOn Info
	statusFrame.Section1.Content.Line1.Text:SetFormattedText("Version of %s: %s",SpectraUI.Name,ColorText(GOOD_COLOR, SpectraUI.Version or UNKNOWN))
	statusFrame.Section1.Content.Line2.Text:SetFormattedText("Client: %s",ColorText(clientColor, clientName))
	statusFrame.Section1.Content.Line3.Text:SetFormattedText("Pixel Perfect Scale: %s",ColorText(GOOD_COLOR, pixelScale))
	statusFrame.Section1.Content.Line4.Text:SetFormattedText("Your UI Scale: %s",ColorText(ValueColor(scaleMatch), uiScale))
	statusFrame.Section1.Content.Line5.Text:SetFormattedText("UI Scale Match: %s",ColorText(ValueColor(scaleMatch), scaleMatch and "Yes" or "No"))

	-- WoW Info
	statusFrame.Section2.Content.Line1.Text:SetFormattedText("Version of WoW: %s (build %s)",ColorText(GOOD_COLOR, E.wowpatch or UNKNOWN),ColorText(GOOD_COLOR, E.wowbuild or UNKNOWN))
	statusFrame.Section2.Content.Line2.Text:SetFormattedText("Display Mode: %s",ColorText(GOOD_COLOR, (E.GetDisplayMode and E:GetDisplayMode()) or UNKNOWN))
	statusFrame.Section2.Content.Line3.Text:SetFormattedText("Resolution: %s",ColorText(ValueColor(goodResolution), res ~= "" and res or UNKNOWN))

	-- Character Info
	statusFrame.Section3.Content.Line1.Text:SetFormattedText("Faction: %s",ColorText(factionHex, E.myfaction or UNKNOWN))
	statusFrame.Section3.Content.Line2.Text:SetFormattedText("Race: %s",ColorText(factionHex, E.myrace or UNKNOWN))
	statusFrame.Section3.Content.Line3.Text:SetFormattedText("Class: %s",ColorText(classHex, englishClassName[E.myclass] or UNKNOWN))
	statusFrame.Section3.Content.Line4.Text:SetFormattedText("Level: %s",ColorText(INFO_COLOR, E.mylevel or UNKNOWN))
	statusFrame.Section3.Content.Line5.Text:SetFormattedText("Zone: %s",ColorText(INFO_COLOR, GetRealZoneText() or UNKNOWN))

	-- AddOns
	local AddOnSection = addOnFrame.SectionA
	AddOnSection.Header.Text:SetText("|cff2ab6ffA|rDDONS")

	local addOnData = {}

	for _, addonName in ipairs(TRACKED_ADDONS) do
		if IsAddOnLoaded(addonName) then
			local title = GetAddOnMetadata(addonName, "Title") or addonName
			local version = GetAddOnMetadata(addonName, "Version") or UNKNOWN

			if addonName == "ElvUI" then
				version = E.versionString or version
			elseif addonName == "Details" and Details and Details.GetVersionString
			then
				title = "Details"
				local detailsVersion = Details:GetVersionString()
				version = detailsVersion:match("(%d+%.%d+%.%d+)") or detailsVersion
			elseif addonName == "WeakAuras" then
				version = version:match("^[^-]+") or version
			end

			version = NormalizeVersion(version)
			tinsert(addOnData, { name = title, version = version })
		end
	end

	sort(addOnData, function(a, b) return a.name < b.name end)

	local count = #addOnData
	AddOnSection.Content = self:StatusReportCreateContent(count, AddOnSection:GetWidth() - 20, AddOnSection, AddOnSection.Header)

	for i = 1, count do
		AddOnSection.Content["Line" .. i].Text:SetFormattedText(
			"%s: %s",
			addOnData[i].name,
			ColorText(GOOD_COLOR, addOnData[i].version)
		)
	end

	AddOnSection:SetHeight((count * 25) + 40)
	addOnFrame:SetHeight(AddOnSection:GetHeight() + 19)
	addOnFrame:Show()

	statusFrame:SetHeight(502)
end

-- Toggle
function StatusReport:ToggleStatusReport()
	if not self.StatusReportFrame then
		self.StatusReportFrame = self:StatusReportCreate()
	end

	if not self.StatusReportFrame:IsShown() then
		self:StatusReportUpdate()
		self.StatusReportFrame:Show()
		self.StatusReportFrame.AddOnFrame:Show()
	else
		self.StatusReportFrame:Hide()
		self.StatusReportFrame.AddOnFrame:Hide()
	end
end

