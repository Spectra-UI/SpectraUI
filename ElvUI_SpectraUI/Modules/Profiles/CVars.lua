local E = unpack(ElvUI)
local SUI = E:GetModule("SpectraUI")

local function ApplySpectraCVars()

    -- Nameplates baseline
    SetCVar("nameplateGlobalScale", 1)
    SetCVar("nameplateMinScale", 1)
    SetCVar("nameplateMaxScale", 1)
    SetCVar("nameplateSelectedScale", 1.2)
    SetCVar("nameplateMaxDistance", 41)

    -- Camera (core gameplay feel)
    SetCVar("cameraDistanceMaxZoomFactor", 4)
    SetCVar("cameraWaterCollision", 1)

    -- Interaction / QoL
    SetCVar("instantQuestText", 1)

    -- Chat / Information
    SetCVar("removeChatDelay", 1)

end

function SUI:SetupCVars()
    E.db.SpectraUI = E.db.SpectraUI or {}

    if not E.db.SpectraUI.cvars_installed then
        ApplySpectraCVars()
        E.db.SpectraUI.cvars_installed = true
        SUI:Print("Recommended |cff2AB6FFCVars|r applied.")
    end
end