local E, L, V, P, G = unpack(ElvUI)

local classIconPath = "Interface\\Addons\\SpectraUI\\media\\class\\"
local classIconStrings = {
	WARRIOR = "0:128:0:128",
	MAGE = "128:256:0:128",
	ROGUE = "256:384:0:128",
	DRUID = "384:512:0:128",
	EVOKER = "512:640:0:128",
	HUNTER = "0:128:128:256",
	SHAMAN = "128:256:128:256",
	PRIEST = "256:384:128:256",
	WARLOCK = "384:512:128:256",
	PALADIN = "0:128:256:384",
	DEATHKNIGHT = "128:256:256:384",
	MONK = "256:384:256:384",
	DEMONHUNTER = "384:512:256:384",
}

E:AddTag("spectra:modern", "UNIT_NAME_UPDATE", function(unit, _, args)
	if not UnitIsPlayer(unit) then return end

	local _, class = UnitClass(unit)
	local icon = classIconPath .. "SpectraUI_Modern.tga"
	local size = strsplit(":", args or "")
	size = tonumber(size)
	size = (size and (size >= 16 and size <= 128)) and size or 64
	if icon and classIconStrings[class] then return format("|T%s:%s:%s:0:0:1024:1024:%s|t", icon, size, size, classIconStrings[class]) end
end)

E:AddTagInfo("spectra:modern", SpectraUI.Name .. " " .. L["Icons"], L["Class Icons."])

E:AddTag("spectra:classic", "UNIT_NAME_UPDATE", function(unit, _, args)
	if not UnitIsPlayer(unit) then return end

	local _, class = UnitClass(unit)
	local icon = classIconPath .. "SpectraUI_Classic.tga"
	local size = strsplit(":", args or "")
	size = tonumber(size)
	size = (size and (size >= 16 and size <= 128)) and size or 64
	if icon and classIconStrings[class] then return format("|T%s:%s:%s:0:0:1024:1024:%s|t", icon, size, size, classIconStrings[class]) end
end)

E:AddTagInfo("spectra:classic", SpectraUI.Name .. " " .. L["Icons"], L["Class Icons."] .. " " .. L["The size can be set as follows"] .. " > spectra:styl{32}")