local configRegistry = {}

Spectra = Spectra or {}

local function Log(message)
  --DEFAULT_CHAT_FRAME:AddMessage("|cffffcc00[SpectraConfig]|r " .. tostring(message))
end

function Spectra.SetConfig(configName, configTable)
  if type(configName) ~= "string" then
    Log("Invalid configName passed to SetConfig")
    return
  end
  if type(configTable) ~= "table" then
    Log("Invalid configTable passed to SetConfig")
    return
  end
  configRegistry[configName] = configTable
  Log("Config '" .. configName .. "' registered.")
end

function Spectra.GetConfig(configName)
  if type(configName) ~= "string" then
    Log("Invalid configName passed to GetConfig")
    return nil
  end
  return configRegistry[configName]
end

function Spectra.HasConfig(configName)
  return configRegistry[configName] ~= nil
end
