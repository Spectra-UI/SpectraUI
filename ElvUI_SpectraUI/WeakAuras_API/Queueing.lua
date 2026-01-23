Spectra = Spectra or {}
Spectra.DungeonBars = Spectra.DungeonBars or {}

local GetDifficultyFormatted = function(difficultyID, dungeonName)
  if difficultyID == 1 then
    return "|cff1eff00(" .. GetDifficultyInfo(difficultyID) .. ")|r " .. dungeonName
  elseif difficultyID == 2 then
    return "|cff0070dd(" .. GetDifficultyInfo(difficultyID) .. ")|r " .. dungeonName
  elseif difficultyID == 237 then
    return "|cffa335ee(" .. GetDifficultyInfo(difficultyID) .. ")|r " .. dungeonName
  end
end

function Spectra.SetDungeonButtonTemplate(aura_env, dungeonID, isRandom)
  if not aura_env or not dungeonID then
    return
  end

  local dungeonName = GetLFGDungeonInfo(dungeonID)
  local difficultyID = select(12, GetLFGDungeonInfo(dungeonID))
  local difficultyName = GetDifficultyInfo(difficultyID)
  local formattedName = GetDifficultyFormatted(difficultyID, dungeonName)

  aura_env.dungeonID = dungeonID
  aura_env.dungeonName = dungeonName
  aura_env.difficultyID = difficultyID
  aura_env.difficultyName = difficultyName

---@diagnostic disable-next-line: undefined-global
  Spectra.DungeonBars[dungeonID] = LFGEnabledList[dungeonID]

  local SetDungeonEnabled = function(dungeonID, isEnabled)
---@diagnostic disable-next-line: undefined-global
    LFGEnabledList[dungeonID] = isEnabled
    Spectra.DungeonBars[dungeonID] = isEnabled
    SetLFGDungeonEnabled(dungeonID, isEnabled)
  end

  aura_env.CreateButton = function()
    if not aura_env.button then
      aura_env.button = CreateFrame("Button", nil, aura_env.region, "BackdropTemplate")
      aura_env.button:SetAllPoints(aura_env.region)
    end
  end

  aura_env.ShowButton = function()
    if aura_env.button then
      aura_env.button:Show()
    end
  end

  aura_env.HideButton = function()
    if aura_env.button then
      aura_env.button:Hide()
    end
  end

  aura_env.ShowTooltip = function(reason)
    if not aura_env.button then
      return
    end

    local tooltipText = (not reason and formattedName) or formattedName .. "\n|cffff4040" .. reason .. "|r"

    aura_env.button:SetScript("OnEnter", function(self)
      GameTooltip:SetOwner(self, "ANCHOR_CURSOR")
      GameTooltip:SetText(tooltipText, 1, 1, 1)
      GameTooltip:Show()
    end)

    aura_env.button:SetScript("OnLeave", function()
      GameTooltip:Hide()
    end)
  end

  aura_env.HideTooltip = function()
    if not aura_env.button then
      return
    end
    aura_env.button:SetScript("OnEnter", nil)
    aura_env.button:SetScript("OnLeave", nil)
  end

  aura_env.AddClick = function()
    if not aura_env.button then
      return
    end
    aura_env.button:RegisterForClicks("AnyUp", "AnyDown")

    aura_env.button:SetScript("OnClick", function(_, button)
      if button == "LeftButton" then
        if isRandom then
          for dungID in pairs(Spectra.DungeonBars) do
            SetDungeonEnabled(dungID, false)
          end

          local lockStateReason = Spectra.UnavailableDungeons[dungeonID]
          if not lockStateReason then
            Spectra.DungeonBars[dungeonID] = true
          end
        else
          for _, dungID in ipairs({ 463, 462, 3034 }) do
            Spectra.DungeonBars[dungID] = false
          end

          local lockStateReason = Spectra.UnavailableDungeons[dungeonID]
          if not lockStateReason then
            SetDungeonEnabled(dungeonID, true)
          end
        end

---@diagnostic disable-next-line: undefined-global
        WeakAuras.ScanEvents("Spectra_DUNGEON_BUTTON_UPDATE")
      elseif button == "RightButton" then
        SetDungeonEnabled(dungeonID, false)
---@diagnostic disable-next-line: undefined-global
        WeakAuras.ScanEvents("Spectra_DUNGEON_BUTTON_UPDATE")
      end
    end)
  end

  aura_env.RemoveClick = function()
    if not aura_env.button then
      return
    end
    aura_env.button:SetScript("OnClick", nil)
  end
end
