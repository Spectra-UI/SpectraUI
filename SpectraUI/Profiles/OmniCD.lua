local E, L, V, P, G = unpack(ElvUI)
local IsAddOnLoaded = _G.C_AddOns and _G.C_AddOns.IsAddOnLoaded or _G.IsAddOnLoaded

-- OmniCD profile setup
function SpectraUI:OmniCD()
	print(SpectraUI.Name, "OmniCD")
	if not IsAddOnLoaded("OmniCD") then return end
end
