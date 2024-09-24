local E, L, V, P, G = unpack(ElvUI)

-- CooldownToGo profile setup
function SpectraUI:CooldownToGo()
	if not SpectraUI.Addons.CooldownToGo then return end

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

	SpectraUI:Print("|CFFB707E2CooldownToGo|r" .. " profile |CFF03FA6Eset|r!")
end
