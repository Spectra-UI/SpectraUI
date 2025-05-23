local E = unpack(ElvUI)

-- CooldownToGo profile setup
function SpectraUI:Scorpio()
	if not SpectraUI.Addons.Scorpio then
		return
	end

	if E.Retail then
		Scorpio_DB = {
			["ToyItems"] = {
				166779,
				118221,
				128223,
				80822,
				88580,
				118716,
				82467,
				130147,
				173727,
				104323,
				118427,
				156871,
				118222,
				113096,
				206268,
				140192,
				54437,
				127864,
				122298,
				119093,
				122674,
				170199,
				130209,
				88579,
				119083,
				88531,
				54343,
				64383,
				104324,
				88385,
				116115,
				119134,
				88589,
				108735,
				118244,
				134021,
				147838,
				153039,
				130169,
				104294,
				119212,
				143727,
				68806,
				130171,
				172179,
				113375,
				118191,
				116122,
				102467,
				37710,
				64361,
				131900,
				46709,
				138873,
				118224,
				123851,
				88370,
				129093,
				37460,
				138876,
				88387,
				88381,
				111476,
				54438,
				88377,
				17712,
				165791,
				138878,
				118938,
				110560,
				108743,
				127670,
				129165,
				115503,
				116113,
				114227,
				118935,
				64358,
				95567,
				153126,
				113670,
				95568,
				116120,
				127766,
				88584,
			},
		}
	end

	Scorpio_DB = {
		["ToyItems"] = {},
	}
	Scorpio_Setting = {
		["loglevel"] = 3,
		["taskfactor"] = 0.4,
		["smoothloading"] = false,
		["taskthreshold"] = 15,
	}

	CooldownToGoDB.profileKeys[E.mynameRealm] = "SpectraUI"

	SpectraUI:Print("|CFFB707E2Scorpio|r" .. " profile |CFF03FA6Eset|r!")
end
