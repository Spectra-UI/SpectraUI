-- Create references to ElvUI internals
local E, _, V, P, G = unpack(ElvUI)
local L = SpectraUI.Locales
-- dont touch this ^

function SpectraUI:Setup_mMediaTag()
	if not SpectraUI.Addons.mMediaTag then return end
	local path = SpectraUI.Media.mediaPath

	SpectraUI:AddPortraitsTextures()

	local textureCoords = {
		WARRIOR = { 0, 0, 0, 0.125, 0.125, 0, 0.125, 0.125 },
		MAGE = { 0.125, 0, 0.125, 0.125, 0.25, 0, 0.25, 0.125 },
		ROGUE = { 0.25, 0, 0.25, 0.125, 0.375, 0, 0.375, 0.125 },
		DRUID = { 0.375, 0, 0.375, 0.125, 0.5, 0, 0.5, 0.125 },
		EVOKER = { 0.5, 0, 0.5, 0.125, 0.625, 0, 0.625, 0.125 },
		HUNTER = { 0, 0.125, 0, 0.25, 0.125, 0.125, 0.125, 0.25 },
		SHAMAN = { 0.125, 0.125, 0.125, 0.25, 0.25, 0.125, 0.25, 0.25 },
		PRIEST = { 0.25, 0.125, 0.25, 0.25, 0.375, 0.125, 0.375, 0.25 },
		WARLOCK = { 0.375, 0.125, 0.375, 0.25, 0.5, 0.125, 0.5, 0.25 },
		PALADIN = { 0, 0.25, 0, 0.375, 0.125, 0.25, 0.125, 0.375 },
		DEATHKNIGHT = { 0.125, 0.25, 0.125, 0.375, 0.25, 0.25, 0.25, 0.375 },
		MONK = { 0.25, 0.25, 0.25, 0.375, 0.375, 0.25, 0.375, 0.375 },
		DEMONHUNTER = { 0.375, 0.25, 0.375, 0.375, 0.5, 0.25, 0.5, 0.375 },
	}

	mMT:AddClassIcons("SpectraUI_Classic", path .. "class\\SpectraUI_Classic.tga", textureCoords, "SpectraUI Classic")
	mMT:AddClassIcons("SpectraUI_Modern", path .. "class\\SpectraUI_Modern.tga", textureCoords, "SpectraUI Modern")
end
