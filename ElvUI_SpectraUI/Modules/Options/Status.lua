-- ElvUI
local E = unpack(ElvUI)

-- Module
local Status = SpectraUI:NewModule("Status")

-- Lua
local format = string.format
local tinsert = table.insert
local tconcat = table.concat

-- Colors
local GOOD_COLOR = "43eb47"
local BAD_COLOR  = "ff5353"
local SEPARATOR  = "|cffa5a2a5 | |r"
local LABEL_COLOR = "ffffff"

local function ColorText(hex, text)
	return format("|cff%s%s|r", hex, text)
end

local function Label(text)
	return format("|cff%s%s|r", LABEL_COLOR, text)
end

local function NormalizeScale(value)
	return tonumber(format("%.2f", value))
end

-- UI Scale Match
function Status:GetUIScaleStatus()
	local pixelScale = tonumber(E:PixelBestSize()) or 0
	local uiScale = tonumber(E.global.general.UIScale) or 0

	local match = NormalizeScale(uiScale) == NormalizeScale(pixelScale)
	local color = match and GOOD_COLOR or BAD_COLOR

	return ColorText(color, match and "Yes" or "No")
end

-- Resolution Status
function Status:GetResolutionStatus()
	local res = E.resolution or ""
	local _, height = res:match("^(%d+)x(%d+)$")
	height = tonumber(height) or 0

	local is1440p = height >= 1440
	local color = is1440p and GOOD_COLOR or BAD_COLOR

	return ColorText(
		color,
		is1440p and "1440p" or (height > 0 and height .. "p" or "Unknown")
	)
end

-- Version
function Status:GetVersionStatus()
	local version = SpectraUI.Version or UNKNOWN
	return ColorText(GOOD_COLOR, version)
end

-- Summary for Dashboard Header
function Status:GetSummary()
	local parts = {}

	tinsert(parts, SpectraUI.Name .. " " .. self:GetVersionStatus())
	tinsert(parts, Label("Resolution: ") .. self:GetResolutionStatus())
    tinsert(parts, Label("UI Scale Match: ") .. self:GetUIScaleStatus())

	return tconcat(parts, SEPARATOR)
end
