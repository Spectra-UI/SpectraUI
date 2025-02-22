local E = unpack(ElvUI)
local L = SpectraUI.Locales

function SpectraUI:AddPortraitsTextures()
	if not SpectraUI.Addons.mMediaTag then
		SpectraUI:Print(L["|CFFF63939Error!|r mMediaTag is missing! Pleas install or enable mMediaTag."]) --#F63939
		return
	elseif not (mMT and mMT.Media.CustomPortraits) then
		SpectraUI:Print(
			L["|CFFF63939Error!|r You are using an outdated version of mMediaTag. Please update mMediaTag!"]
		) --#F63939
		return
	end

	if not mMT.Media.CustomPortraits["spectraui"] then
		mMT.Media.CustomPortraits["spectraui"] = {
			name = SpectraUI.Name, -- name to show

			-- portrait texture part
			texture = "Interface\\AddOns\\SpectraUI\\media\\portrait\\texture.tga",
			border = "Interface\\AddOns\\SpectraUI\\media\\portrait\\border.tga",
			shadow = "Interface\\AddOns\\SpectraUI\\media\\portrait\\shadow.tga",
			inner = "Interface\\AddOns\\SpectraUI\\media\\portrait\\inner_shadow.tga",

			-- else use this
			extraMask = false,
			mask = "Interface\\AddOns\\SpectraUI\\media\\portrait\\mask.tga",

			-- extra textures for rare, elite and boss
			rare = "Interface\\AddOns\\SpectraUI\\media\\portrait\\rare_texture.tga",
			rareborder = "Interface\\AddOns\\SpectraUI\\media\\portrait\\rare_border.tga",
			rareshadow = "Interface\\AddOns\\SpectraUI\\media\\portrait\\rare_shadow.tga",

			elite = "Interface\\AddOns\\SpectraUI\\media\\portrait\\rare_texture.tga",
			eliteborder = "Interface\\AddOns\\SpectraUI\\media\\portrait\\rare_border.tga",
			eliteshadow = "Interface\\AddOns\\SpectraUI\\media\\portrait\\rare_shadow.tga",

			boss = "Interface\\AddOns\\SpectraUI\\media\\portrait\\boss_texture.tga",
			bossborder = "Interface\\AddOns\\SpectraUI\\media\\portrait\\boss_border.tga",
			bossshadow = "Interface\\AddOns\\SpectraUI\\media\\portrait\\boss_shadow.tga",
		}
	end
	mMT.Media.CustomPortraits.spectraui.offset = E.db.SpectraUI.portraitsOffset

	if not mMT.Media.CustomPortraits["spectraui_diamond"] then
		mMT.Media.CustomPortraits["spectraui_diamond"] = {
			name = SpectraUI.Name .. " Diamond", -- name to show

			-- portrait texture part
			texture = "Interface\\AddOns\\SpectraUI\\media\\portrait\\diamond_texture.tga",
			border = "Interface\\AddOns\\SpectraUI\\media\\portrait\\diamond_border.tga",
			shadow = "Interface\\AddOns\\SpectraUI\\media\\portrait\\diamond_shadow.tga",
			inner = "Interface\\AddOns\\SpectraUI\\media\\portrait\\diamond_inner.tga",

			-- else use this
			extraMask = false,
			mask = "Interface\\AddOns\\SpectraUI\\media\\portrait\\diamond_mask.tga",

			-- extra textures for rare, elite and boss
			rare = "Interface\\AddOns\\SpectraUI\\media\\portrait\\diamond_rare_texture.tga",
			rareborder = "Interface\\AddOns\\SpectraUI\\media\\portrait\\diamond_rare_border.tga",
			rareshadow = "Interface\\AddOns\\SpectraUI\\media\\portrait\\diamond_rare_shadow.tga",

			elite = "Interface\\AddOns\\SpectraUI\\media\\portrait\\diamond_rare_texture.tga",
			eliteborder = "Interface\\AddOns\\SpectraUI\\media\\portrait\\diamond_rare_border.tga",
			eliteshadow = "Interface\\AddOns\\SpectraUI\\media\\portrait\\diamond_rare_shadow.tga",

			boss = "Interface\\AddOns\\SpectraUI\\media\\portrait\\diamond_boss_texture.tga",
			bossborder = "Interface\\AddOns\\SpectraUI\\media\\portrait\\diamond_boss_border.tga",
			bossshadow = "Interface\\AddOns\\SpectraUI\\media\\portrait\\diamond_boss__shadow.tga",
		}
	end
	mMT.Media.CustomPortraits.spectraui_diamond.offset = E.db.SpectraUI.portraitsOffset
end

function SpectraUI:PlayerPortrait()
	if mMT and mMT.Modules.Portraits and _G.mMT_Portrait_Player then
		RegisterStateDriver(_G.mMT_Portrait_Player,"visibility","[exists]hide;show")
	end
end
