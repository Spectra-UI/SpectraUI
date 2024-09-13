local E, L, V, P, G = unpack(ElvUI)
local IsAddOnLoaded = _G.C_AddOns and _G.C_AddOns.IsAddOnLoaded or _G.IsAddOnLoaded

-- CooldownToGo profile setup
function SpectraUI:CooldownToGo()
	print(SpectraUI.Name, "CooldownToGo")
	if not IsAddOnLoaded("CooldownToGo") then return end

	CooldownToGoDB.profiles["SpectraUI"] = {
		["fontSize"] = 15,
		["warnSound"] = false,
		["fadeTime"] = 1,
		["y"] = -70.00029754638672,
		["x"] = -89.99955749511719,
		["strata"] = "LOW",
		["locked"] = true,
		["iconSize"] = 32,
		["textPosition"] = "LEFT",
		["suppressReadyNotif"] = true,
		["font"] = "SpectraUI Caption",
	}

	CooldownToGoDB.profileKeys[E.mynameRealm] = "SpectraUI"
end
