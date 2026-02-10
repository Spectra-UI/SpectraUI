Spectra.RP = {
  cooldowns = {},
}

Spectra.GetCDTime = function(ID)
  if Spectra.RP.cooldowns[ID] and Spectra.RP.cooldowns[ID].expirationTime then
    return Spectra.RP.cooldowns[ID].expirationTime - GetTime()
  end
  return 0
end

Spectra.SaveCD = function(cooldown)
  if cooldown and cooldown.ID then
    local ID = cooldown.ID
    Spectra.RP.cooldowns[ID] = Spectra.RP.cooldowns[ID] or {}
    Spectra.RP.cooldowns[ID].expirationTime = cooldown.expirationTime
  end
end

Spectra.IsBossModOn = function()
  if C_AddOns.IsAddOnLoaded("BigWigs") then
    return true
  end
end
