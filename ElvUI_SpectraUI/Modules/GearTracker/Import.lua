SpectraUI.GearTrackerImport = SpectraUI.GearTrackerImport or {}

local WOWSIM_INDEX_TO_SLOT = {
  [1]  = 1, -- Head
  [2]  = 2, -- Neck
  [3]  = 3, -- Shoulders
  [4]  = 15, -- Back
  [5]  = 5, -- Chest
  [6]  = 9, -- Wrist
  [7]  = 10, -- Hands
  [8]  = 6, -- Belt
  [9]  = 7, -- Legs
  [10] = 8, -- Boots
  [11] = 11, -- Finger 1
  [12] = 12, -- Finger 2
  [13] = 13, -- Trinket 1
  [14] = 14, -- Trinket 2
  [15] = 16, -- Main Hand
  [16] = 17, -- Off Hand
  [17] = 18, -- Ranged/Relic
}

function SpectraUI.GearTrackerImport:Parse(raw)
    if not raw or raw == "" then
        return nil
    end

    if not C_EncodingUtil or not C_EncodingUtil.DeserializeJSON then
        return nil
    end

    local ok, data = pcall(C_EncodingUtil.DeserializeJSON, raw)
    if not ok or type(data) ~= "table" then
        return nil
    end

    local equipment = data.player
        and data.player.equipment
        and data.player.equipment.items

    if type(equipment) ~= "table" then
        return nil
    end

    local items = {}
    local suffixes = {}

    for index, entry in ipairs(equipment) do
        local slotID = WOWSIM_INDEX_TO_SLOT[index]

        if slotID and entry and entry.id then
            items[slotID] = entry.id

            if entry.randomSuffix then
                suffixes[slotID] = entry.randomSuffix
            end
        end
    end

    return items, suffixes
end
