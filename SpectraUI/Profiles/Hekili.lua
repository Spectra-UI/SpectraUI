local E, L, V, P, G = unpack(ElvUI)
local IsAddOnLoaded = _G.C_AddOns and _G.C_AddOns.IsAddOnLoaded or _G.IsAddOnLoaded

-- Hekili profile setup
function SpectraUI:Hekili()
	print(SpectraUI.Name, "Hekili")
	if not IsAddOnLoaded("Hekili") then return end
end
