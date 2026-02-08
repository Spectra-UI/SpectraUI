local E = unpack(ElvUI)
local L = SpectraUI.Locales

local UnitGUID = UnitGUID
local UnitIsAFK = UnitIsAFK
local UnitIsDND = UnitIsDND
local UnitIsConnected = UnitIsConnected
local UnitIsDead = UnitIsDead
local UnitIsGhost = UnitIsGhost

local classIconPath = "Interface\\Addons\\ElvUI_SpectraUI\\media\\class\\"
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

local CustomRaidTargetIcons = {
	[1] = "|TInterface\\Addons\\ElvUI_SpectraUI\\Media\\Icons\\TM01.tga:15:15|t",
	[2] = "|TInterface\\Addons\\ElvUI_SpectraUI\\Media\\Icons\\TM02.tga:15:15|t",
	[3] = "|TInterface\\Addons\\ElvUI_SpectraUI\\Media\\Icons\\TM03.tga:15:15|t",
	[4] = "|TInterface\\Addons\\ElvUI_SpectraUI\\Media\\Icons\\TM04.tga:15:15|t",
	[5] = "|TInterface\\Addons\\ElvUI_SpectraUI\\Media\\Icons\\TM05.tga:15:15|t",
	[6] = "|TInterface\\Addons\\ElvUI_SpectraUI\\Media\\Icons\\TM06.tga:15:15|t",
	[7] = "|TInterface\\Addons\\ElvUI_SpectraUI\\Media\\Icons\\TM07.tga:15:15|t",
	[8] = "|TInterface\\Addons\\ElvUI_SpectraUI\\Media\\Icons\\TM08.tga:15:15|t",
}

-- Modern class icons
E:AddTag("spectra:modern", "UNIT_NAME_UPDATE", function(unit, _, args)
	if not UnitIsPlayer(unit) then return end

	local _, class = UnitClass(unit)
	local icon = classIconPath .. "SpectraUI_Modern.tga"
	local size = strsplit(":", args or "")
	size = tonumber(size)
	size = (size and (size >= 16 and size <= 128)) and size or 64
	if icon and classIconStrings[class] then return format("|T%s:%s:%s:0:0:1024:1024:%s|t", icon, size, size, classIconStrings[class]) end
end)

E:AddTagInfo("spectra:modern", SpectraUI.Name, L["Modern class icons,"] .. " " .. L["The size can be set as follows"] .. " > spectra:modern{32}")

-- Modern class icons with outline
E:AddTag("spectra:modern:outline", "UNIT_NAME_UPDATE", function(unit, _, args)
	if not UnitIsPlayer(unit) then return end

	local _, class = UnitClass(unit)
	local icon = classIconPath .. "SpectraUI_Modern_Outline.tga"
	local size = strsplit(":", args or "")
	size = tonumber(size)
	size = (size and (size >= 16 and size <= 128)) and size or 64
	if icon and classIconStrings[class] then return format("|T%s:%s:%s:0:0:1024:1024:%s|t", icon, size, size, classIconStrings[class]) end
end)

E:AddTagInfo("spectra:modern:outline", SpectraUI.Name, L["Modern class icons with outline,"] .. " " .. L["The size can be set as follows"] .. " > spectra:modern:outline{32}")

-- Role icons
local roleIocns = {
	TANK = "Interface\\Addons\\ElvUI_SpectraUI\\media\\role\\Tank.tga",
	HEALER = "Interface\\Addons\\ElvUI_SpectraUI\\media\\role\\Healer.tga",
	DAMAGER = "Interface\\Addons\\ElvUI_SpectraUI\\media\\role\\DPS.tga",
}

E:AddTag("spectra:roleicon", "PLAYER_ROLES_ASSIGNED GROUP_ROSTER_UPDATE", function(unit, _, args)
	local UnitRole = (E.Retail or E.Cata) and UnitGroupRolesAssigned(unit)

	local icon = UnitRole and roleIocns[UnitRole]
	local size = strsplit(":", args or "")
	size = tonumber(size)
	size = (size and (size >= 16 and size <= 128)) and size or 64
	if icon then return format("|T%s:%s:%s|t", icon, size, size) end
end)

E:AddTagInfo("spectra:roleicon", SpectraUI.Name, L["Role Icons,"] .. " " .. L["The size can be set as follows"] .. " > spectra:roleicon{32}")

-- Role text
E:AddTag('spectra:roletext', 'UNIT_NAME_UPDATE PLAYER_ROLES_ASSIGNED GROUP_ROSTER_UPDATE', function(unit, _, args)
	local v = tonumber(args) or 1
	local role = UnitGroupRolesAssigned(unit)

	if v == 1 then
		local roleText = {
			HEALER = "|cff00ff96HEALER|r",
			TANK = "|cff00a5ffTANK|r"
		}
		return roleText[role]
	end
end)

E:AddTagInfo("spectra:roletext", SpectraUI.Name, L["Colored role text"])

-- Mana healeronly
E:AddTag('spectra:perpp:healeronly', 'UNIT_POWER_FREQUENT UNIT_MAXPOWER UNIT_DISPLAYPOWER UNIT_CONNECTION PLAYER_ROLES_ASSIGNED GROUP_ROSTER_UPDATE', function(unit)
    local role = UnitGroupRolesAssigned(unit)
    
    if role ~= "HEALER" then
        return nil
    end
    
    local status = UnitIsDead(unit) and L["Dead"] or UnitIsGhost(unit) and L["Ghost"] or not UnitIsConnected(unit) and L["Offline"]
    local powerType = UnitPowerType(unit)
    local cur = UnitPower(unit, powerType)
    local max = UnitPowerMax(unit, powerType)

    if status or (powerType ~= 0 and cur == 0) or max == 0 then
        return nil
    else
        return format("%.0f", (cur / max) * 100)
    end
end)

E:AddTagInfo("spectra:perpp:healeronly", SpectraUI.Name, L["Display percentage power if their role is set to healer"])

-- Statustimer
local unitStatus = {}
E:AddTag("spectra:statustimer", 1, function(unit)
	if not UnitIsPlayer(unit) then return end
	
	local guid = UnitGUID(unit)
	if not guid then return end
	
	local currentStatus = unitStatus[guid]
	local newStatusType
	
	if not UnitIsConnected(unit) then
		newStatusType = "Offline"
	elseif UnitIsDead(unit) or UnitIsGhost(unit) then
		newStatusType = "Dead"
	elseif UnitIsAFK(unit) then
		newStatusType = "AFK"
	elseif UnitIsDND(unit) then
		newStatusType = "DND"
	end
	
	if newStatusType then
		if not currentStatus or currentStatus[1] ~= newStatusType then
			unitStatus[guid] = { newStatusType, GetTime() }
		end
	else
		unitStatus[guid] = nil
		return
	end
	
	local timer = GetTime() - unitStatus[guid][2]
	local mins = floor(timer / 60)
	local secs = floor(timer % 60)
	return format("%01.f:%02.f", mins, secs)
end)

E:AddTagInfo("spectra:statustimer", SpectraUI.Name, L["Displays a timer for status events"])

-- TargetMarkers
E:AddTag("spectra:targetmarker", "RAID_TARGET_UPDATE", function(unit)
	local index = GetRaidTargetIndex(unit)
	return CustomRaidTargetIcons[index] or ""
end)

E:AddTagInfo("spectra:targetmarker", SpectraUI.Name, L["Display raid target marker"])