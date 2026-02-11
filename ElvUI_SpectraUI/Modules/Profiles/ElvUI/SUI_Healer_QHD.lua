local E = unpack(ElvUI)
local D = E:GetModule("Distributor")

-- ! classic Healer QHD profile
function SpectraUI:ElvUIProfileHealerQHD()
	-- donte remove the " at the begining and and of the string here
	-- Profile! replace !E1!DUMMY ELVUI PROFILE STRING with your ElvUI Profile String.
	local profile =
	    ""

	-- Private Profile! replace !E1!DUMMY ELVUI PROFILE STRING with your ElvUI Private Profile String.
	local private =
		""

	-- Global Profile! replace !E1!DUMMY ELVUI PROFILE STRING with your ElvUI Global Profile String.
	local global =
		""

	-- Nameplate Stylefilter String! replace !E1!DUMMY ELVUI PROFILE STRING with your ElvUI Nameplate Stylefilter String.
--	local nameplatestylefilters =
--		""

	-- Aurafilter String! replace !E1!DUMMY ELVUI PROFILE STRING with your ElvUI Aurafilter String.
	local aurafilters = 
	    ""

	--profile
	D:ImportProfile(private)
--	D:ImportProfile(nameplatestylefilters)
	D:ImportProfile(aurafilters)
	D:ImportProfile(profile)
	D:ImportProfile(global)

	E:SetupCVars()
	E:SetupChat()

	-- Set UI Scale
	E.global.general.UIScale = 0.53333333333333

	SpectraUI:Print("|cff57ff75Healer|r layout |CFF5ddb60set|r!!")
end
