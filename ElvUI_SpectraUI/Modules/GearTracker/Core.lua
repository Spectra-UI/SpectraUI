local E = unpack(ElvUI)
local L = SpectraUI.Locales

local GearTracker = SpectraUI:NewModule("GearTracker")
SpectraUI.GearTracker = GearTracker

-- Lua
local next, pairs, type = next, pairs, type
local format = string.format

-- WoW API
local UnitName = UnitName
local UnitClass = UnitClass
local GetNormalizedRealmName = GetNormalizedRealmName
local GetRealmName = GetRealmName
local GetBuildInfo = GetBuildInfo
local GetNumTalentTabs = _G.GetNumTalentTabs
local GetTalentTabInfo = _G.GetTalentTabInfo

-- WeakAuras
local WeakAuras = WeakAuras


-- Expansion Detection
local function IsTBC()
    local build = select(4, GetBuildInfo())
    return build > 20500 and build < 30000
end

-- TBC Spec Mapping (Talent Tab → SpecID)
GearTracker.SpecMap = {
    WARRIOR = { [1] = 161, [2] = 164, [3] = 163 },
    PALADIN = { [1] = 382, [2] = 383, [3] = 381 },
    HUNTER  = { [1] = 361, [2] = 363, [3] = 362 },
    ROGUE   = { [1] = 182, [2] = 181, [3] = 183 },
    PRIEST  = { [1] = 201, [2] = 202, [3] = 203 },
    SHAMAN  = { [1] = 261, [2] = 263, [3] = 262 },
    MAGE    = { [1] = 81,  [2] = 41,  [3] = 61  },
    WARLOCK = { [1] = 302, [2] = 303, [3] = 301 },
    DRUID   = { [1] = 283, [2] = 281, [3] = 282 },
}

-- Character / Spec Helpers
function GearTracker:GetCharKey()
    local name = UnitName("player") or "Unknown"
    local realm = GetNormalizedRealmName() or GetRealmName() or "UnknownRealm"
    return name .. "-" .. realm
end

function GearTracker:GetSpecID()
    if not IsTBC() then return nil end

    local bestTab, bestPoints = nil, -1

    for tab = 1, GetNumTalentTabs() do
        local points = select(5, GetTalentTabInfo(tab))
        if points and points > bestPoints then
            bestPoints = points
            bestTab = tab
        end
    end

    if not bestTab then return nil end

    local _, class = UnitClass("player")
    local map = self.SpecMap[class]
    return map and map[bestTab]
end

function GearTracker:GetTrackedSpecID()
    if not IsTBC() then return nil end

    self:EnsureDB()

    local db = self:GetDB()
    local charKey = self:GetCharKey()

    local override = db.trackedSpec and db.trackedSpec[charKey]
    if type(override) == "number" and override > 0 then
        return override -- Manual override
    end

    return self:GetSpecID()
end

function GearTracker:GetSpecNameByID(specID)
    if not specID then return "Unknown" end

    local preset = self:GetActivePreset()
    if not preset or not preset.profiles then
        return tostring(specID)
    end

    local profile = preset.profiles[specID]
    if profile and profile.specName then
        return profile.specName
    end

    return tostring(specID)
end

-- Database
function GearTracker:GetDB()
    -- Ensure base addon DB exists
    E.db.SpectraUI = E.db.SpectraUI or {}

    -- Ensure GearTracker container exists
    E.db.SpectraUI.gearTracker = E.db.SpectraUI.gearTracker or {
        custom = {},
        useCustom = {},
        presetKey = "",
        trackedSpec = {},
    }

    return E.db.SpectraUI.gearTracker
end

function GearTracker:EnsureDB()
    local db = self:GetDB()

    db.custom = db.custom or {}
    db.useCustom = db.useCustom or {}
    db.presetKey = db.presetKey or ""
    db.trackedSpec = db.trackedSpec or {}

    local charKey = self:GetCharKey()

    db.custom[charKey] = db.custom[charKey] or {}
    db.useCustom[charKey] = db.useCustom[charKey] or {}
end

function GearTracker:EnsureSpec()
    self:EnsureDB()

    local db = self:GetDB()
    local charKey = self:GetCharKey()
    local specID = self:GetTrackedSpecID()
    if not specID then return end

    -- Default behavior: preset unless user explicitly enables custom
    if db.useCustom[charKey][specID] == nil then
        db.useCustom[charKey][specID] = false
    end

    -- Custom container exists when needed
    db.custom[charKey][specID] = db.custom[charKey][specID] or {
        items = {},
        suffixes = {},
    }
end

-- Presets Registry + Selection
function GearTracker:GetPresetRegistry()
    return SpectraUI.GearTrackerPresets or {}
end

function GearTracker:PickDefaultPresetKey()
    
    local reg = self:GetPresetRegistry()

    local bestKey, bestOrder
    for key, preset in pairs(reg) do
        if preset and preset.expansion == "TBC" then
            local order = preset.order or 999
            if not bestOrder or order < bestOrder then
                bestOrder = order
                bestKey = key
            end
        end
    end

    return bestKey
end

function GearTracker:GetActivePreset()
    local db = self:GetDB()
    local reg = self:GetPresetRegistry()

    local key = db.presetKey
    if key ~= "" and reg[key] then
        return reg[key]
    end

    -- fallback to best available
    local fallbackKey = self:PickDefaultPresetKey()
    if fallbackKey and reg[fallbackKey] then
        return reg[fallbackKey]
    end

    return nil
end

-- Public API
function GearTracker:GetActiveData()
    if not IsTBC() then return nil end

    self:EnsureSpec()

    local db = self:GetDB()
    local charKey = self:GetCharKey()
    local specID = self:GetTrackedSpecID()
    if not specID then return nil end

    -- Load preset first
    local preset = self:GetActivePreset()
    if not preset or not preset.profiles then return nil end

    local p = preset.profiles[specID]
    if not p then return nil end

    -- If custom enabled and has overrides, merge per-slot over preset
    if db.useCustom[charKey][specID] == true then
        local c = db.custom[charKey][specID]
        if c and c.items and next(c.items) ~= nil then
            local merged = { items = {}, suffixes = {} }

            -- Start from preset
            if p.items then
                for slot, id in pairs(p.items) do
                    merged.items[slot] = id
                end
            end
            if p.suffixes then
                for k, v in pairs(p.suffixes) do
                    merged.suffixes[k] = v
                end
            end

            -- Overlay custom overrides
            for slot, id in pairs(c.items) do
                merged.items[slot] = id
            end
            for k, v in pairs(c.suffixes or {}) do
                merged.suffixes[k] = v
            end

            return merged
        end
    end

    return p
end

-- Explicit toggle
function GearTracker:SetUseCustom(enabled)
    if enabled ~= true and enabled ~= false then return end
    if not IsTBC() then return end

    self:EnsureSpec()

    local db = self:GetDB()
    local charKey = self:GetCharKey()
    local specID = self:GetTrackedSpecID()
    if not specID then return end

    db.useCustom[charKey][specID] = enabled
    self:NotifyUpdate()
end

-- Later: wowsims/json importer can call this
function GearTracker:SetCustomData(itemsTable, suffixesTable)
    if not IsTBC() then return end

    self:EnsureSpec()

    local db = self:GetDB()
    local charKey = self:GetCharKey()
    local specID = self:GetTrackedSpecID()
    if not specID then return end

    local c = db.custom[charKey][specID]
    c.items = type(itemsTable) == "table" and itemsTable or {}
    c.suffixes = type(suffixesTable) == "table" and suffixesTable or {}

    -- If they set custom data, it’s reasonable to auto-enable custom.
    db.useCustom[charKey][specID] = true

    self:NotifyUpdate()
end

-- WeakAura Bridge
function GearTracker:NotifyUpdate()
    if WeakAuras and WeakAuras.ScanEvents then
        WeakAuras.ScanEvents("SPECTRA_GEARTRACKER_UPDATED")
    end
end

-- Events
function GearTracker:PLAYER_ENTERING_WORLD()
    self:EnsureSpec()
    self:NotifyUpdate()
end

function GearTracker:PLAYER_TALENT_UPDATE()
    self:EnsureSpec()
    self:NotifyUpdate()
end


-- Initialize
function GearTracker:Initialize()
    if not IsTBC() then return end

    self:EnsureDB()
    self:EnsureSpec()

    self:RegisterEvent("PLAYER_ENTERING_WORLD")
    self:RegisterEvent("PLAYER_TALENT_UPDATE")

    -- Fire once so WeakAuras populates immediately on login
    self:NotifyUpdate()
end
