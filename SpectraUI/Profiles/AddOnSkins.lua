local E, L, V, P, G = unpack(ElvUI)
local IsAddOnLoaded = _G.C_AddOns and _G.C_AddOns.IsAddOnLoaded or _G.IsAddOnLoaded

-- AddOnSkins profile setup
function SpectraUI:AddOnSkins()
	if not IsAddOnLoaded("AddOnSkins") then return end

	AddOnSkinsDB.profiles["SpectraUI"] = {
		["Font"] = "SpectraUI Caption",
		["EmbedBackdrop"] = false,
		["EmbedBackdropTransparent"] = false,
		["EmbedSystem"] = true,
		["EmbedOoC"] = true,
		["Shadows"] = false,
		["DBMFont"] = "SpectraUI Caption",
		["Hekili"] = false,
		["EmbedLeftWidth"] = 205,
		["FontFlag"] = "SHADOW",
		["EmbedOoCDelay"] = 3,
		["HideChatFrame"] = "ChatFrame4",
	}

	AddOnSkinsDB.profileKeys[E.mynameRealm] = "SpectraUI"

	SpectraUI:Print("|CFFB707E2AddOnSkins|r" .. " profile |CFF03FA6Eset|r!")
end
