local E = unpack(ElvUI)

-- OmniCD profile setup
function SpectraUI:OmniCD()
	if not SpectraUI.Addons.OmniCD then
		return
	end

	OmniCDDB.profiles["SpectraUI"] = {
		["Party"] = {
			["party"] = {
				["extraBars"] = {
					["raidBar1"] = {
						["manualPos"] = {
							["raidBar1"] = {
								["y"] = 384.3555214597109,
								["x"] = 682.3111276328564,
							},
						},
					},
				},
				["spells"] = {
					["5209"] = true,
					["676"] = false,
					["18288"] = false,
					["19505"] = false,
					["408"] = false,
					["7744"] = false,
					["586"] = true,
					["18499"] = false,
					["12328"] = true,
					["20594"] = false,
					["5484"] = false,
					["13896"] = false,
					["20549"] = false,
					["20484"] = true,
					["2651"] = false,
					["26297"] = false,
					["2944"] = false,
					["29166"] = true,
					["20608"] = true,
					["1161"] = true,
					["14177"] = false,
					["14183"] = false,
					["12051"] = true,
				},
				["icons"] = {
					["showCounter"] = false,
					["desaturateActive"] = true,
				},
				["position"] = {
					["offsetX"] = 85,
					["anchor"] = "TOPRIGHT",
					["columns"] = 20,
					["paddingX"] = 2,
					["attach"] = "TOPLEFT",
					["uf"] = "ElvUI",
					["offsetY"] = -8,
					["preset"] = "TOPLEFT",
				},
				["general"] = {
					["showRange"] = true,
				},
			},
			["noneZoneSetting"] = "party",
			["visibility"] = {
				["arena"] = false,
				["none"] = true,
			},
		},
		["General"] = {
			["textures"] = {
				["statusBar"] = {
					["BG"] = "SpectraUI Main",
					["bar"] = "SpectraUI Main",
				},
			},
			["fonts"] = {
				["statusBar"] = {
					["font"] = "SpectraUI Title",
				},
				["icon"] = {
					["font"] = "SpectraUI Title",
					["ofsX"] = 1,
					["flag"] = "NONE",
					["size"] = 12,
				},
				["anchor"] = {
					["font"] = "SpectraUI Title",
					["size"] = 10,
				},
			},
		},
	}

	OmniCDDB.profileKeys[E.mynameRealm] = "SpectraUI"

	SpectraUI:Print("|CFFB707E2OmniCD|r" .. " profile |CFF03FA6Eset|r!")
end
