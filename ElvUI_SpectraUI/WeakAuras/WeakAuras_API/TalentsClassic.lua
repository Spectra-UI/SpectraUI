---@diagnostic disable-next-line: undefined-global
local GetNumTalentTabs, GetNumTalents, GetTalentInfo = GetNumTalentTabs, GetNumTalents, GetTalentInfo

Spectra = Spectra or {}
Spectra.PlayerTalents = {}

local class = select(2, UnitClass("player")) -- Get player's class
local isHealer = false -- Initialize healer status

local WAScanEvents = function(...)
---@diagnostic disable-next-line: undefined-global
  if not WeakAuras then
    return
  end
---@diagnostic disable-next-line: undefined-global
  WeakAuras.ScanEvents(...)
end

-- Healer talent definitions for each class
local healerTalents = {
  SHAMAN = {
    { tree = 3, tier = 5, column = 3 },
    { tree = 3, tier = 7, column = 2 },
    { tree = 3, tier = 5, column = 1 },
  },
  PALADIN = {
    { tree = 1, tier = 5, column = 2 },
    { tree = 1, tier = 6, column = 3 },
    { tree = 1, tier = 7, column = 2 },
  },
  DRUID = {
    { tree = 3, tier = 5, column = 3 },
    { tree = 3, tier = 7, column = 2 },
  },
  PRIEST = {
    { tree = 1, tier = 7, column = 2 },
    { tree = 2, tier = 5, column = 2 },
    { tree = 2, tier = 7, column = 2 },
  },
}

-- Function to check if player matches a given spec talent definition
function Spectra.CheckSpecByTalents(specTalents)
  -- Ensure specTalents is a valid table
  if not specTalents or type(specTalents) ~= "table" then
    return false
  end

  -- Ensure there's a talent table for the player's class
  local classTalents = specTalents[class]
  if not classTalents or type(classTalents) ~= "table" then
    return true
  end

  -- Loop through the talents for the player's class
  for _, talent in ipairs(classTalents) do
    local tree, tier, column = talent.tree, talent.tier, talent.column

    -- Check if the corresponding talent in the player's talents is active
    if
      Spectra.PlayerTalents[tree]
      and Spectra.PlayerTalents[tree][tier]
      and Spectra.PlayerTalents[tree][tier][column]
      and Spectra.PlayerTalents[tree][tier][column] > 0
    then
      return true -- A matching talent was found
    end
  end

  return false -- No matching talents found
end

-- Function to record player's talents
local function RecordPlayerTalents()
  local classTalents = {}
  for tree = 1, GetNumTalentTabs() do
    classTalents[tree] = {}
    for j = 1, GetNumTalents(tree) do
---@diagnostic disable-next-line: missing-parameter
      local _, _, tier, column, rank = GetTalentInfo(tree, j)
      if rank > 0 then
        if not classTalents[tree][tier] then
          classTalents[tree][tier] = {}
        end
        classTalents[tree][tier][column] = rank
      end
    end
  end
  Spectra.PlayerTalents = classTalents
  WAScanEvents("Spectra_TALENTS_CHANGED")
end

-- Function to handle talent updates and update healer status
local function UpdateHealerStatus()
  local newIsHealer = healerTalents[class] and Spectra.CheckSpecByTalents(healerTalents)

  if newIsHealer ~= isHealer then
    isHealer = newIsHealer
    WAScanEvents("WA_HEALER_STATE_CHANGED", isHealer)
  end
end

-- Interface function to check if the player is a healer
function Spectra.IsPlayerHealer()
  return isHealer
end

-- Initialize event handling
local function InitializeTalentTracking()
  local frame = CreateFrame("Frame")

  frame:SetScript("OnEvent", function(self, event, ...)
    if event == "PLAYER_TALENT_UPDATE" or event == "CHARACTER_POINTS_CHANGED" or event == "PLAYER_ENTERING_WORLD" then
      RecordPlayerTalents()
      UpdateHealerStatus()
    end
  end)

  frame:RegisterEvent("PLAYER_TALENT_UPDATE")
  frame:RegisterEvent("CHARACTER_POINTS_CHANGED")
  frame:RegisterEvent("PLAYER_ENTERING_WORLD")
end

-- Call the initializer when the addon loads
InitializeTalentTracking()
