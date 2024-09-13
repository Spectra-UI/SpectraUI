local E, L, V, P, G = unpack(ElvUI)
local IsAddOnLoaded = _G.C_AddOns and _G.C_AddOns.IsAddOnLoaded or _G.IsAddOnLoaded

-- CDTL2 profile setup
function SpectraUI:CDTL2()
	print(SpectraUI.Name, "CDTL2")
	if not IsAddOnLoaded("CDTL2") then return end
end
