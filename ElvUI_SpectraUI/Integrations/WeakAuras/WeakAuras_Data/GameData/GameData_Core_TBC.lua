local SpectraUI = _G.SpectraUI
SpectraUI.Data = SpectraUI.Data or {}
SpectraUI.Data.TBC = SpectraUI.Data.TBC or {}

local TBC = SpectraUI.Data.TBC

local function ColorizeTag(tag)
  local info = TBC.InstanceTagInfo and TBC.InstanceTagInfo[tag]

  if info then
    if info.color then
      return "|cff" .. info.color .. info.abbr .. "|r"
    end
    return info.abbr
  end

  if tag == "VND" then
    return "|cff66cc33Vendor|r"
  end
  if tag == "CRF" then
    return "|cffffd100Craft|r"
  end

  return tag
end

local function NormalizeInstanceName(name)
  return name or ""
end

local function NormalizeBossName(name)
  if not name or name == "" then
    return ""
  end

  return name
end

local function ColorizeDifficulty(diff)
  if not diff then
    return nil
  end
  if diff == "H" or diff == "HC" or diff == "Heroic" then
    return "|cffff4040(H)|r"
  end
  if diff == "N" or diff == "NM" or diff == "Normal" then
    return "|cff40ff40(N)|r"
  end
  if diff == "NH" then
    return "|cff40ff40(N|r/|cffff4040H)|r"
  end
  if diff == "C" or diff == "CELESTIAL" or diff == "Celestrial" then
    return "|cff80cfff(C)|r"
  end
  return diff
end

local NO_DIFFICULTY_INSTANCES = {
  ["Karazhan"] = true,
  ["ZulAman"] = true,
  ["MagtheridonsLair"] = true,
  ["GruulsLair"] = true,
  ["SerpentshrineCavern"] = true,
  ["HyjalSummit"] = true,
  ["BlackTemple"] = true,
  ["SunwellPlateau"] = true,
}

local function StripDifficultyIfNotUsed(s)
  if not s or not s.instance then
    return s
  end
  local inst = NormalizeInstanceName(s.instance)
  if NO_DIFFICULTY_INSTANCES[inst] then
    s.difficulty = nil
  end
  return s
end

local function GetBossDiffLabel(state, bossKey, diff)
  if diff == "" then
    diff = nil
  end

  local st = state[bossKey]
  if not st then
    return diff
  end

  if st.hasN and st.hasH then
    return "NH"
  end

  if st.hasNil then
    return nil
  end

  return diff
end

local function FormatSourcesGrouped(sources, maxEntries)
  if not sources or #sources == 0 then
    return ""
  end

  local grouped = {}
  local order = {}

  local seenPair = {}
  local totalUniquePairs = 0

  -- state[bossKey] = { hasNil, hasN, hasH, other }
  local state = {}

  for i = 1, #sources do
    local s = StripDifficultyIfNotUsed(sources[i])
    local inst = NormalizeInstanceName(s.instance)
    local boss = NormalizeBossName(s.boss)

    if inst ~= "" and boss ~= "" then
      local diff = s.difficulty
      local bossKey = inst .. "||" .. boss

      local st = state[bossKey]
      if not st then
        st = { hasNil = false, hasN = false, hasH = false, other = false }
        state[bossKey] = st
      end

      if not diff then
        st.hasNil = true
      else
        if diff == "N" or diff == "NM" or diff == "Normal" then
          st.hasN = true
        elseif diff == "H" or diff == "HC" or diff == "Heroic" then
          st.hasH = true
        else
          st.other = true
        end
      end
    end
  end

  -- Pass 2: build output with final knowledge
  for i = 1, #sources do
    local s = StripDifficultyIfNotUsed(sources[i])
    local inst = NormalizeInstanceName(s.instance)
    local boss = NormalizeBossName(s.boss)

    if inst ~= "" and boss ~= "" then
      local diff = s.difficulty
      local bossKey = inst .. "||" .. boss
      local showDiff = GetBossDiffLabel(state, bossKey, diff)

      -- If we don't show diff, treat all entries as the same pair (no diff in key)
      local key
      if showDiff and showDiff ~= "NH" then
        key = inst .. "||" .. boss .. "||" .. showDiff
      else
        key = inst .. "||" .. boss
      end

      if not seenPair[key] then
        seenPair[key] = true
        totalUniquePairs = totalUniquePairs + 1

        local bucket = grouped[inst]
        if not bucket then
          bucket = { bosses = {}, seenBoss = {} }
          grouped[inst] = bucket
          order[#order + 1] = inst
        end

        local label = boss
        if showDiff then
          local cd = ColorizeDifficulty(showDiff)
          if cd then
            label = string.format("%s %s", boss, cd)
          end
        end

        if not bucket.seenBoss[label] then
          bucket.seenBoss[label] = true
          bucket.bosses[#bucket.bosses + 1] = label
        end
      end
    end
  end

  if #order == 0 then
    return ""
  end

  local parts = {}
  local usedPairs = 0

  for i = 1, #order do
    local inst = order[i]
    local bucket = grouped[inst]
    local bosses = bucket and bucket.bosses or {}

    if #bosses > 0 then
      local take = #bosses
      if maxEntries then
        local remaining = maxEntries - usedPairs
        if remaining <= 0 then
          break
        end
        if take > remaining then
          take = remaining
        end
      end

      local bossText
      if take == #bosses then
        bossText = table.concat(bosses, ", ")
      else
        local tmp = {}
        for j = 1, take do
          tmp[#tmp + 1] = bosses[j]
        end
        bossText = table.concat(tmp, ", ")
      end

      local instOut = ColorizeTag(inst)
      parts[#parts + 1] = string.format("%s: %s", instOut, bossText)

      usedPairs = usedPairs + take
      if maxEntries and usedPairs >= maxEntries then
        break
      end
    end
  end

  if #parts == 0 then
    return ""
  end

  if maxEntries and totalUniquePairs > usedPairs then
    parts[#parts + 1] = string.format("+%d more", totalUniquePairs - usedPairs)
  end

  return table.concat(parts, " | ")
end

local function GetEquipSlotKey(itemID)
  if not itemID or itemID == 0 then
    return nil
  end

  local equipLoc
  if GetItemInfoInstant then
    local _, _, _, loc = GetItemInfoInstant(itemID)
    equipLoc = loc
  end

  if not equipLoc or equipLoc == "" then
    return nil
  end

  -- Map WoW equipLoc to our tier token slot keys
  local map = TBC.EquipLocToTierSlot
    or {
      INVTYPE_HEAD = "HEAD",
      INVTYPE_SHOULDER = "SHOULDER",
      INVTYPE_CHEST = "CHEST",
      INVTYPE_ROBE = "CHEST",
      INVTYPE_HAND = "HANDS",
      INVTYPE_LEGS = "LEGS",
    }

  return map[equipLoc] or equipLoc
end

local function ParseVendorPriceString(priceStr)
  if not priceStr or priceStr == "" then
    return nil
  end

  local out = {}
  for key, amount in priceStr:gmatch("([^:]+):(%d+)") do
    out[#out + 1] = { key = key, amount = tonumber(amount) or 0 }
  end

  return out
end

local function FormatVendorSource(itemID)
  local prices = TBC.VendorPrices
  if not prices then
    return ""
  end

  local priceStr = prices[itemID]
  if not priceStr then
    return ""
  end

  local parsed = ParseVendorPriceString(priceStr)
  if not parsed or #parsed == 0 then
    return ""
  end

  local keyInfo = TBC.VendorPriceKeyInfo or {}
  local parts = {}

  for i = 1, #parsed do
    local p = parsed[i]
    local info = keyInfo[p.key]
    local name = (info and info.name) or p.key
    local abbr = (info and info.abbr) or name
    local color = (info and info.color) or nil

    local piece
    if p.key == "money" then
      if GetCoinTextureString then
        piece = GetCoinTextureString(p.amount)
      else
        local gold = math.floor(p.amount / 10000)
        local silver = math.floor((p.amount % 10000) / 100)
        local copper = p.amount % 100
        piece = string.format("%dg %ds %dc", gold, silver, copper)
      end
    else
      piece = string.format("%s x%d", abbr, p.amount)
    end

    if color then
      piece = string.format("|cff%s%s|r", color, piece)
    end

    parts[#parts + 1] = piece
  end

  local tag = ColorizeTag("VND")
  return string.format("%s: %s", tag, table.concat(parts, ", "))
end

local function FormatProfessionSource(itemID)
  local craft = TBC.ProfessionCraft
  if not craft then
    return ""
  end

  local profIDs = craft[itemID]
  if not profIDs or #profIDs == 0 then
    return ""
  end

  local profInfo = TBC.ProfessionInfo or {}
  local parts = {}

  for i = 1, #profIDs do
    local id = profIDs[i]
    local info = profInfo[id]
    local abbr = (info and info.abbr) or tostring(id)
    local color = (info and info.color) or nil
    local piece = abbr
    if color then
      piece = string.format("|cff%s%s|r", color, piece)
    end
    parts[#parts + 1] = piece
  end

  local tag = ColorizeTag("CRF")
  return string.format("%s: %s", tag, table.concat(parts, ", "))
end

local function ResolveTierTokenSources(itemID)
  local itemToSet = TBC.ItemToSet
  local setTier = TBC.SetTierBySetID
  local tierTokens = TBC.TierTokenItems
  local sourceDB = TBC.ItemSourceDB

  if not itemToSet or not setTier or not tierTokens or not sourceDB then
    return nil
  end

  local setID = itemToSet[itemID]
  if not setID then
    return nil
  end

  local tierKey = setTier[setID]
  if not tierKey then
    return nil
  end
  local slotKey = GetEquipSlotKey(itemID)
  if not slotKey then
    return nil
  end

  local tokenByItem = TBC.TierTokenByItemID
  local tokenListByItem = tokenByItem and tokenByItem[itemID]
  if tokenListByItem then
    local tokenList = type(tokenListByItem) == "table" and tokenListByItem or { tokenListByItem }

    local out = {}
    for i = 1, #tokenList do
      local tokenID = tokenList[i]
      local src = sourceDB[tokenID]
      if src and #src > 0 then
        for j = 1, #src do
          out[#out + 1] = src[j]
        end
      end
    end

    if #out > 0 then
      return out
    end
  end

  local tokenList = tierTokens[tierKey] and tierTokens[tierKey][slotKey]
  if not tokenList or #tokenList == 0 then
    local overrideByTier = TBC.TierSourceOverrideByTier and TBC.TierSourceOverrideByTier[tierKey]
    local override = overrideByTier and overrideByTier[slotKey]
    if override and #override > 0 then
      return override
    end
    return nil
  end

  local out = {}
  for i = 1, #tokenList do
    local tokenID = tokenList[i]
    local src = sourceDB[tokenID]
    if src and #src > 0 then
      for j = 1, #src do
        out[#out + 1] = src[j]
      end
    end
  end

  return out
end

function TBC.GetItemDropString(itemID)
  if type(itemID) ~= "number" then
    return ""
  end

  local sourceDB = TBC.ItemSourceDB or {}

  local direct = sourceDB[itemID]

  local sources = direct

  if not sources or #sources == 0 then
    local tierSources = ResolveTierTokenSources(itemID)
    if tierSources and #tierSources > 0 then
      sources = tierSources
    end
  end

  local outParts = {}

  local lootText = ""
  if sources and #sources > 0 then
    lootText = FormatSourcesGrouped(sources, 50)
    if lootText ~= "" then
      outParts[#outParts + 1] = lootText
    end
  end

  local faction = TBC.FactionSourceDB and TBC.FactionSourceDB[itemID]
  if faction then
    local factionName = GetFactionInfoByID(faction.factionID)
    local repName = TBC.REPUTATION_NAMES[faction.reputation] or "Unknown"
    if factionName then
      return string.format("%s (%s)", factionName, repName)
    end
  end

  local vendorText = FormatVendorSource(itemID)
  if vendorText ~= "" then
    outParts[#outParts + 1] = vendorText
  end

  local profText = FormatProfessionSource(itemID)
  if profText ~= "" then
    outParts[#outParts + 1] = profText
  end

  if #outParts == 0 then
    return ""
  end

  return table.concat(outParts, " | ")
end

-- Public Resolver Entry
function SpectraUI.Data.GetItemDropString(itemID)
    if SpectraUI.Data.TBC and SpectraUI.Data.TBC.GetItemDropString then
        return SpectraUI.Data.TBC.GetItemDropString(itemID)
    end
    return ""
end