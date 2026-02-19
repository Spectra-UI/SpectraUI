local E = unpack(ElvUI)
local L = SpectraUI.Locales

local GearTracker = SpectraUI:GetModule("GearTracker")

-- ------------------------------------------------------------
-- Constants / Helpers
-- ------------------------------------------------------------

-- Current released phase (keep at 0 until you ship T4/T5/T6 presets)
local CURRENT_PHASE = 0

-- Slot mapping (matches your preset numeric keys)
local SLOT = {
  head = 1,
  neck = 2,
  shoulder = 3,
  chest = 5,
  waist = 6,
  legs = 7,
  boots = 8,
  wrist = 9,
  hands = 10,
  finger1 = 11,
  finger2 = 12,
  trinket1 = 13,
  trinket2 = 14,
  back = 15,
  mainhand = 16,
  offhand = 17,
  ranged = 18,
}

local function IsTBC()
  local build = select(4, GetBuildInfo())
  return build > 20500 and build < 30000
end

local function GetCharKey()
  return GearTracker:GetCharKey()
end

local function GetDB()
  return GearTracker:GetDB()
end

local function GetTrackedSpecID()
  -- uses your new backend helper if present, else fall back
  if GearTracker.GetTrackedSpecID then
    return GearTracker:GetTrackedSpecID()
  end
  return GearTracker:GetSpecID()
end

local function IsManualSpec()
  local db = GetDB()
  local ck = GetCharKey()
  local v = db.trackedSpec and db.trackedSpec[ck]
  return type(v) == "number" and v > 0
end

local function GetSpecValues()
  local _, class = UnitClass("player")
  local map = GearTracker.SpecMap and GearTracker.SpecMap[class]
  if not map then
    return { [0] = "Auto" }
  end

  local values = {}
  values[0] = "|cffaaaaaaAuto|r"

  -- try to use talent tab names (localized)
  for tab = 1, _G.GetNumTalentTabs() do
    local tabName = GetTalentTabInfo(tab)
    local specID = map[tab]
    if specID then
      values[specID] = tabName or ("Spec " .. tab)
    end
  end

  return values
end

local function GetSpecName(specID)
  if not specID then return "Unknown" end
  local vals = GetSpecValues()
  return vals[specID] or tostring(specID)
end

local function GetTrackingStatusText()
  local specID = GetTrackedSpecID()
  if not specID then
    return "|cffaaaaaaTracking: —|r"
  end
  local mode = IsManualSpec() and "Manual" or "Auto"
  local name = GetSpecName(specID)
  return ("|cffaaaaaaTracking: %s (%s)|r"):format(name, mode)
end

local function GetActivePresetKey()
  local db = GetDB()
  local reg = GearTracker:GetPresetRegistry()
  local key = db.presetKey

  if key ~= "" and reg[key] then
    return key
  end

  local fallback = GearTracker:PickDefaultPresetKey()
  return fallback or ""
end

local function GetPresetValues()
  local reg = GearTracker:GetPresetRegistry()
  local values = {}

  for key, preset in pairs(reg) do
    if preset and preset.expansion == "TBC" then
      local label = preset.label or key
      if preset.phase and preset.phase > CURRENT_PHASE then
        label = ("|cff666666%s (Coming Soon)|r"):format(label)
      end
      values[key] = label
    end
  end

  return values
end

local function IsPresetDisabled(key)
  local reg = GearTracker:GetPresetRegistry()
  local p = reg and reg[key]
  if not p then return true end
  if p.expansion ~= "TBC" then return true end
  if (p.phase or 0) > CURRENT_PHASE then return true end
  return false
end

local function GetPresetItemForSlot(specID, slotIndex)
  local preset = GearTracker:GetActivePreset()
  if not preset or not preset.profiles then return nil end
  local profile = preset.profiles[specID]
  if not profile or not profile.items then return nil end
  return profile.items[slotIndex]
end

local function GetCustomItemsTable(specID)
  GearTracker:EnsureSpec()
  local db = GetDB()
  local ck = GetCharKey()
  db.custom[ck][specID] = db.custom[ck][specID] or { items = {}, suffixes = {} }
  db.custom[ck][specID].items = db.custom[ck][specID].items or {}
  return db.custom[ck][specID].items
end

local function HasAnyOverrides(itemsTable)
  if not itemsTable then return false end
  for _, _ in pairs(itemsTable) do
    return true
  end
  return false
end

local function NormalizeItemInputToItemID(text)
  if not text or text == "" then return nil end

  -- Item link contains item:<id>
  local id = text:match("item:(%d+)")
  if id then return tonumber(id) end

  -- Raw number
  local n = tonumber(text)
  if n and n > 0 then return n end

  return nil
end

local function GetItemLabel(itemID)
  if not itemID then return nil end
  local name, link = GetItemInfo(itemID)
  return link or name or ("ItemID: " .. tostring(itemID))
end

local function GetDropString(itemID)
  if not itemID then return "" end
  if SpectraUI.Data and SpectraUI.Data.GetItemDropString then
    return SpectraUI.Data.GetItemDropString(itemID) or ""
  end
  return ""
end

local function IsSlotOverridden(specID, slotIndex)
  local items = GetCustomItemsTable(specID)
  return items and items[slotIndex] ~= nil
end

local function RefreshCustomToggle(specID)
  local db = GetDB()
  local ck = GetCharKey()
  local items = GetCustomItemsTable(specID)

  local any = HasAnyOverrides(items)
  db.useCustom[ck][specID] = any and true or false
end

local function SetSlotValue(slotIndex, text)
  if not IsTBC() then return end

  local specID = GetTrackedSpecID()
  if not specID then return end

  GearTracker:EnsureSpec()

  local db = GetDB()
  local ck = GetCharKey()

  local items = GetCustomItemsTable(specID)

  local newID = NormalizeItemInputToItemID(text)

  -- If empty input => remove override
  if not newID then
    items[slotIndex] = nil
    RefreshCustomToggle(specID)
    GearTracker:NotifyUpdate()
    return
  end

  -- If equals preset => don't store override
  local presetID = GetPresetItemForSlot(specID, slotIndex)
  if presetID and newID == presetID then
    items[slotIndex] = nil
    RefreshCustomToggle(specID)
    GearTracker:NotifyUpdate()
    return
  end

  -- Store override and auto-enable custom
  items[slotIndex] = newID
  db.useCustom[ck][specID] = true

  GearTracker:NotifyUpdate()
end

local function GetSlotDisplayValue(slotIndex)
  if not IsTBC() then return "" end
  local specID = GetTrackedSpecID()
  if not specID then return "" end

  GearTracker:EnsureSpec()

  local items = GetCustomItemsTable(specID)

  -- show override if present, else show nothing (placeholder comes from desc/tooltip)
  local v = items and items[slotIndex]
  return v and tostring(v) or ""
end

local function SlotNameWithOverride(label, slotIndex)
    local specID = GetTrackedSpecID()
    if not specID then return label end

    if not IsSlotOverridden(specID, slotIndex) then
        return label
    end

    local items = GetCustomItemsTable(specID)
    local itemID = items and items[slotIndex]
    if not itemID then return label end

    local itemName, _, quality = GetItemInfo(itemID)
    if not itemName then
        return label
    end

    local color = ITEM_QUALITY_COLORS[quality]
    if color and color.hex then
        itemName = color.hex .. itemName .. "|r"
    end

    return label .. " - " .. itemName
end

local function SlotTooltip(label, slotIndex)
    local specID = GetTrackedSpecID()
    if not specID then return "" end

    local presetID = GetPresetItemForSlot(specID, slotIndex)
    local presetLabel = GetItemLabel(presetID) or "—"
    local presetDrop = GetDropString(presetID)
    if presetDrop ~= "" then
        presetDrop = "\n|cffaaaaaaSource:|r " .. presetDrop
    end

    local items = GetCustomItemsTable(specID)
    local overrideID = items and items[slotIndex]
    local overrideLabel = overrideID and (GetItemLabel(overrideID) or tostring(overrideID)) or nil
    local overrideDrop = overrideID and GetDropString(overrideID) or ""
    if overrideDrop ~= "" then
        overrideDrop = "\n|cffaaaaaaSource:|r " .. overrideDrop
    end

    if overrideID then
        return ("Preset: %s%s\n\nOverride: %s%s\n\nTip: Paste an item link or type an ItemID.")
            :format(presetLabel, presetDrop, overrideLabel, overrideDrop)
    end

    return ("Preset: %s%s\n\nTip: Paste an item link or type an ItemID.")
        :format(presetLabel, presetDrop)
end

local function ResetAllOverrides()
  if not IsTBC() then return end

  local specID = GetTrackedSpecID()
  if not specID then return end

  GearTracker:EnsureSpec()

  local db = GetDB()
  local ck = GetCharKey()

  db.custom[ck][specID].items = {}
  db.custom[ck][specID].suffixes = {}
  db.useCustom[ck][specID] = false

  GearTracker:NotifyUpdate()
end

-- ------------------------------------------------------------
-- Import (soft integration)
-- ------------------------------------------------------------
local function DoImport(raw)
  if not raw or raw == "" then return end

  -- If you add an importer elsewhere later, we auto-detect it:
  -- SpectraUI.GearTrackerImport.Parse(raw) -> itemsTable, suffixesTable
  local importer = SpectraUI.GearTrackerImport
  if importer and importer.Parse then
    local ok, items, suffixes = pcall(importer.Parse, importer, raw)
    if ok and type(items) == "table" then
      GearTracker:SetCustomData(items, type(suffixes) == "table" and suffixes or {})
      return
    end
  end

  E:Print("GearTracker Import: No importer available yet. Add SpectraUI.GearTrackerImport:Parse(raw).")
end

-- ------------------------------------------------------------
-- Wire into your existing Options foundation
-- ------------------------------------------------------------
function SpectraUI:InjectGearTrackerOptions()
  if not SpectraUI.options
    or not SpectraUI.options.args
    or not SpectraUI.options.args.armory
    or not SpectraUI.options.args.armory.args
    or not SpectraUI.options.args.armory.args.tracking
  then
    return
  end

  local tracking = SpectraUI.options.args.armory.args.tracking.args
  local import = SpectraUI.options.args.armory.args.import.args

  -- Preset / Phase select (add just under descBox if you want; using existing foundation nodes)
  tracking.presetSelect = {
    order = 2.5,
    type = "select",
    name = "Progression",
    width = "full",
    values = GetPresetValues,
    get = function()
      return GetActivePresetKey()
    end,
    set = function(_, v)
      if not v or v == "" then return end
      if IsPresetDisabled(v) then return end
      local db = GetDB()
      db.presetKey = v
      GearTracker:NotifyUpdate()
    end,
    disabled = function()
      return not IsTBC()
    end,
  }

tracking.presetHint = {
  order = 2.6,
  type = "description",
  width = "full",
  name = function()

    local reg = GearTracker:GetPresetRegistry()
    local currentPhase = CURRENT_PHASE or 0

    local count = 0
    local labels = {}

    for _, preset in pairs(reg) do
      if preset.expansion == "TBC" and preset.phase <= currentPhase then
        count = count + 1
        labels[#labels + 1] = preset.label
      end
    end

    table.sort(labels)

    local labelString = table.concat(labels, " | ")

    return string.format(
      "Available Phases: |cff40ff40%d|r | %s",
      count,
      labelString ~= "" and labelString or "None"
    )
  end,
}

-- Spacer ONLY between sections
tracking.sectionSpacer = {
  order = 2.7,
  type = "description",
  name = "\n",
  width = "full",
}

-- Spec dropdown (Auto + specNames, class colored)
local function GetSpecValues()
    local t = {}
    local _, class = UnitClass("player")
    local map = GearTracker.SpecMap[class]
    local c = RAID_CLASS_COLORS[class]

    local function Color(text)
        if not c then return text end
        return string.format(
            "|cff%02x%02x%02x%s|r",
            c.r * 255,
            c.g * 255,
            c.b * 255,
            text
        )
    end

    -- Auto always exists
    t[0] = "|cff2ab6ffAuto|r"

    if map then
        for _, specID in pairs(map) do
            local name = GearTracker:GetSpecNameByID(specID)
            t[specID] = Color(name)
        end
    end

    return t
end

tracking.specSelect.values = GetSpecValues

tracking.specSelect.get = function()
    local db = GetDB()
    local ck = GetCharKey()
    local v = db.trackedSpec and db.trackedSpec[ck]
    if type(v) == "number" and v > 0 then
        return v
    end
    return 0
end

tracking.specSelect.set = function(_, v)
    local db = GetDB()
    local ck = GetCharKey()
    db.trackedSpec = db.trackedSpec or {}

    if tonumber(v) and tonumber(v) > 0 then
        db.trackedSpec[ck] = tonumber(v) -- Manual
    else
        db.trackedSpec[ck] = nil -- Auto
    end

    GearTracker:EnsureSpec()
    GearTracker:NotifyUpdate()
end

tracking.specSelect.disabled = function()
    return not IsTBC()
end

  -- Status string
tracking.specStatus.name = function()
    local db = GetDB()
    local ck = GetCharKey()
    local manual = db.trackedSpec and db.trackedSpec[ck]

    local activeSpecID = GearTracker:GetTrackedSpecID()
    local specName = GearTracker:GetSpecNameByID(activeSpecID) or "Unknown"

    -- Class color for spec name
    local _, class = UnitClass("player")
    local c = RAID_CLASS_COLORS[class]

    if c then
        specName = string.format(
            "|cff%02x%02x%02x%s|r",
            c.r * 255,
            c.g * 255,
            c.b * 255,
            specName
        )
    end

    local mode
    if manual then
        mode = "(|cffffcc00Manual|r)"
    else
        mode = "(|cff2ab6ffAuto|r)"
    end

    return string.format("Tracking: %s %s", specName, mode)
end


  -- Slot wiring (A–E behavior)
  local slots = tracking.slots.args

  local function WireSlot(key, label)
    local idx = SLOT[key]
    if not idx or not slots[key] then return end
    ---@diagnostic disable-next-line: assign-type-mismatch
    slots[key].name = function()
      return SlotNameWithOverride(label, idx)
    end

    slots[key].get = function()
      return GetSlotDisplayValue(idx)
    end

    slots[key].set = function(_, val)
      SetSlotValue(idx, val)
    end

    slots[key].desc = function()
      return SlotTooltip(label, idx)
    end

    slots[key].disabled = function()
      return not IsTBC() or IsPresetDisabled(GetActivePresetKey())
    end
  end

  WireSlot("head", "Head")
  WireSlot("hands", "Hands")
  WireSlot("neck", "Neck")
  WireSlot("waist", "Waist")
  WireSlot("shoulder", "Shoulder")
  WireSlot("legs", "Legs")
  WireSlot("back", "Back")
  WireSlot("boots", "Boots")
  WireSlot("chest", "Chest")
  WireSlot("finger1", "Finger 1")
  WireSlot("wrist", "Wrist")
  WireSlot("finger2", "Finger 2")
  WireSlot("mainhand", "Main Hand")
  WireSlot("trinket1", "Trinket 1")
  WireSlot("offhand", "Off Hand")
  WireSlot("trinket2", "Trinket 2")
  WireSlot("ranged", "Ranged")

  -- Reset button
  tracking.reset.func = ResetAllOverrides
  tracking.reset.disabled = function()
    return not IsTBC()
  end

  -- Import tab
  import.importBox.get = function()
    local db = GetDB()
    db._import = db._import or ""
    return db._import
  end
  import.importBox.set = function(_, v)
    local db = GetDB()
    db._import = v or ""
  end
  import.importButton.func = function()
    local db = GetDB()
    DoImport(db._import or "")
  end
  import.importButton.disabled = function()
    return not IsTBC()
  end
end
