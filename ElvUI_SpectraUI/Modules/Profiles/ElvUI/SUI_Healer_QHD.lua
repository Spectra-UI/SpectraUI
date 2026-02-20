local E = unpack(ElvUI)
local D = E:GetModule("Distributor")
local SUI = E:GetModule("SpectraUI")

-- ! classic Healer QHD profile
function SUI:ElvUIProfileHealerQHD()
    -- donte remove the " at the begining and and of the string here
    -- Profile! replace !E1!DUMMY ELVUI PROFILE STRING with your ElvUI Profile String.
    local profile = ""

    -- Private Profile! replace !E1!DUMMY ELVUI PROFILE STRING with your ElvUI Private Profile String.
    local private = ""

    -- Global Profile! replace !E1!DUMMY ELVUI PROFILE STRING with your ElvUI Global Profile String.
    local global = ""

    -- Nameplate Stylefilter String! replace !E1!DUMMY ELVUI PROFILE STRING with your ElvUI Nameplate Stylefilter String.
    --	local nameplatestylefilters =
    --		""

    -- Aurafilter String! replace !E1!DUMMY ELVUI PROFILE STRING with your ElvUI Aurafilter String.
    local aurafilters = ""

    -- Profile
    D:ImportProfile(private)
    --	D:ImportProfile(nameplatestylefilters)
    D:ImportProfile(aurafilters)
    D:ImportProfile(profile)
    D:ImportProfile(global)

	-- Setups
    SUI:SetupCVars()
    if not SUI.Addons.Chattynator then
		E:SetupChat()
	end

    -- Set UI Scale
    E.global.general.UIScale = 0.53333333333333

    SUI:Print("|cff57ff75Healer|r layout |CFF5ddb60set|r!!")
end
