local E, L, V, P, G = unpack(ElvUI)
local IsAddOnLoaded = _G.C_AddOns and _G.C_AddOns.IsAddOnLoaded or _G.IsAddOnLoaded

-- CooldownToGo profile setup
function SpectraUI:CooldownToGo()
	print(SpectraUI.Name, "CooldownToGo")
	if not IsAddOnLoaded("CooldownToGo") then
		return
	end

	CooldownToGoDB = {
		["namespaces"] = {
			["LibDualSpec-1.0"] = {},
		},
		["profileKeys"] = {
			["Delecti - Twisting Nether"] = "Default",
			["Hagman - Twisting Nether"] = "Default",
			["Hoffajakt - Twisting Nether"] = "Default",
			["Lepra - Twisting Nether"] = "Default",
			["Sabaton - Outland"] = "Default",
			["Leprae - Outland"] = "Default",
			["Blaanos - Twisting Nether"] = "Default",
			["Zucre - Twisting Nether"] = "Default",
			["Karatequin - Twisting Nether"] = "Default",
			["Zulthara - Twisting Nether"] = "Default",
			["Felillo - Twisting Nether"] = "Default",
			["Exerz - Frostmane"] = "Default",
			["Trixan - Twisting Nether"] = "Spectra",
			["Leprae - Twisting Nether"] = "Default",
			["Hoffa - Twisting Nether"] = "Default",
			["Nattdjur - Outland"] = "Default",
		},
		["profiles"] = {
			["Spectra"] = {
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
			},
		},
	}

	local profileDB = CooldownToGoDB["profileKeys"] or {}
	profileDB[E.mynameRealm] = "Spectra"
end
