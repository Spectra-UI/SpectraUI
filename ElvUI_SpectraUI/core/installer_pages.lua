-- Create references to ElvUI internals
local E = unpack(ElvUI)
local L = SpectraUI.Locales
local PI = E:GetModule("PluginInstaller")

-- Installer state
local chosen_profile = nil -- "QHD" or "FHD"
local chosen_role = nil    -- "dps" or "healer"

-- INSTALLER SETTINGS
SpectraUI.InstallerData.Title = SpectraUI.Name
SpectraUI.InstallerData.Name = SpectraUI.Name
SpectraUI.InstallerData.Logo = SpectraUI.Media.logo
SpectraUI.InstallerData.LogoSize = { 410, 205 }
SpectraUI.InstallerData.StepTitlesColor = { 0.9, 0.9, 0.9 }
SpectraUI.InstallerData.StepTitlesColorSelected = { 0.1647, 0.7137, 1, 1 }

local path = SpectraUI.Media.mediaPath
local spectra_name = SpectraUI.Name

function SpectraUI:Print(msg)
	print(format("|cff2ab6ff%s|r: %s", spectra_name, msg))
end

-- INSTALLER MODE
-- false = Single layout (QHD)
-- true  = Dual layout (QHD or FHD)
local DUAL_LAYOUT_MODE = false
local DEFAULT_LAYOUT = "QHD"

-- PROFILE HANDLING
local function ChangeProfile(layout)
	if E.charSettings then
		E.charSettings:SetProfile(layout)
	end

	if E.data then
		E.data:SetProfile(layout)
	end
end

local function InstallProfile(layout)
	-- we need to run elvui setup for cVars and chat first, because we are skipping the elvui installer
	E:SetupCVars()
	E:SetupChat()

	local profileName = layout == "QHD" and "FHD" or "DPS"

	-- create and set a new private profile
	if ElvPrivateDB then
		if not ElvPrivateDB.profiles.Spectra then
			ElvPrivateDB.profileKeys[E.mynameRealm] = profileName
			ElvPrivateDB.profiles[profileName] = {}
			ElvPrivateDB.profiles[profileName] = E:CopyTable({}, E.privateVars.profile)
			E:CopyTable(E.private, ElvPrivateDB.profiles[profileName])
		end
	end

	-- QHD PROFILES
	if layout == "QHD" then
		if chosen_role == "dps" then
			SpectraUI:ElvUIProfileDPSQHD()
		elseif chosen_role == "healer" then
			if SpectraUI.ElvUIProfileHealerQHD then
				SpectraUI:ElvUIProfileHealerQHD()
			else
				SpectraUI:Print("|cff57ff75Healer|r layout is currently under development.")
			end
		end
	else
		-- FHD future support
		if chosen_role == "dps" and SpectraUI.ElvUIProfileDPSFHD then
			SpectraUI:ElvUIProfileDPSFHD()
		elseif chosen_role == "healer" and SpectraUI.ElvUIProfileHealerFHD then
			SpectraUI:ElvUIProfileHealerFHD()
		else
			SpectraUI:Print("|cff8b8b8bFHD layout not available yet.|r")
		end
	end
end

-- WEAKAURAS IMPORT HELPER
local function SpectraUI_ImportWeakAura(groupKey)
	if not WeakAuras then
		if C_AddOns and C_AddOns.LoadAddOn then
			C_AddOns.LoadAddOn("WeakAuras")
		end
	end

	if not WeakAuras or not WeakAuras.Import then
		E:Print("WeakAuras is not installed.")
		return
	end

	local layoutKey = "spectra"

	local importString =
		SpectraUI.WeakAuras
		and SpectraUI.WeakAuras[layoutKey]
		and SpectraUI.WeakAuras[layoutKey][groupKey]

	if not importString or importString == "" then
		E:Print("Missing WeakAura import: " .. layoutKey .. " / " .. groupKey)
		return
	end

	importString = importString:match("^%s*(.-)%s*$")
	WeakAuras.Import(importString)

end

-- WEAKAURAS CONFIRMATION POPUP
E.PopupDialogs.SPECTRAUI_CONFIRM_WA_IMPORT = {

	text = L["This will import the required WeakAuras.\n\nDo you want to continue?"],
	button1 = L["Import"],
	button2 = CANCEL,
	OnAccept = function(_, data)
		-- data = { groupKey = "anchors" / "essentials" }
		SpectraUI_ImportWeakAura(data.groupKey)

		if data.groupKey == "anchors" then
			SpectraUI:Print(format(
				L["|cff2ab6ffAnchors|r WeakAuras installed |cff5ddb60successfully|r."],
				spectra_name
			))
		elseif data.groupKey == "essentials" then
			SpectraUI:Print(format(
				L["|cffF5C56AEssentials|r WeakAuras installed |cff5ddb60successfully|r."],
				spectra_name
			))
		end
	end,
	timeout = 0,
	whileDead = 1,
	hideOnEscape = true,
	preferredIndex = 3,
}


-- Popup for profile change
E.PopupDialogs.SPECTRAUI_SELECT = {
	text = format(
		L["You already have the %s profile |cff5ddb60installed|r. Would you like to change to the %s profile?"],
		SpectraUI.Name,
		SpectraUI.Name
	),
	button1 = L["Change Profile"],
	button2 = L["Install New"],
	OnAccept = function(frame, data)
		ChangeProfile(data)
	end,
	OnCancel = function(frame, data)
		InstallProfile(data)
	end,
	timeout = 0,
	whileDead = 1,
	hideOnEscape = true,
	preferredIndex = 3,
}

-- SELECTION STATE
if not DUAL_LAYOUT_MODE then
	chosen_profile = DEFAULT_LAYOUT
end

function SpectraUI:ClearSelection()
	if DUAL_LAYOUT_MODE then
		chosen_profile = nil
	else
		chosen_profile = DEFAULT_LAYOUT
	end
end

-- PAGE 1: WELCOME
SpectraUI.InstallerData[1] = {
	SubTitle = format(L["Welcome to the installation for %s"], SpectraUI.Name),
	StepTitle = L["Welcome"],
	tutorialImage = true,
	descriptions = {
		[1] = format(
			L["The %s installer will guide you through a short setup to get your interface ready."],
			SpectraUI.Name,
			SpectraUI.Name
		),
		[2] = format(
			L["|CFFF63939Important|r: Major updates to %s will require you to go through the installation process again, which may result in the loss of any changes you’ve made. Please make sure to back up your settings if needed!"],
			SpectraUI.Name
		),
		[3] = L["Click Continue to begin your setup, or Skip Process to exit."],
	},
	options = {
		[1] = {
			text = L["Skip Process"],
			func = function()
				SpectraUI:Print(L["Installation skipped, No settings were applied."])
				SpectraUI:SetupSkip()
			end,
		},
	},
}

-- PAGE 2: RESOLUTION SELECTION (ONLY IN DUAL MODE)
if DUAL_LAYOUT_MODE then
	SpectraUI.InstallerData[#SpectraUI.InstallerData + 1] = {
		SubTitle = L["Choose your resolution"],
		StepTitle = "Resolution",
		tutorialImage = true,
		descriptions = {
			[1] = L["Select the resolution you want to install."],
		},
		options = {
			{
				text = "QHD",
				func = function()
					chosen_profile = "QHD"
					PI:NextPage()
				end,
			},
			{
				text = "FHD",
				func = function()
					chosen_profile = "FHD"
					PI:NextPage()
				end,
			},
		},
	}
end

-- PAGE 3: ROLE SELECTION (DPS/TANK OR HEALER)
SpectraUI.InstallerData[#SpectraUI.InstallerData + 1] = {
	SubTitle = L["Select a layout |cff2ab6ffoptimized|r for your role"],
	StepTitle = "SpectraUI",
	tutorialImage = true,
	descriptions = {
		[1] = function()
			local text_spectra = format(
				L["|cffD96C3ADPS / Tank|r focuses on awareness and damage tracking \n\n|cff57ff75Healer|r focuses on clarity and raid visibility.\n|cff8b8b8bLayout is currently under development.|r"],
				SpectraUI.Name,
				SpectraUI.Name
			)
			return text_spectra
		end,
		
	},
	options = {
		{
			text = L["|cffD96C3ADPS / Tank|r"],
			func = function()
				chosen_role = "dps"
				InstallProfile(chosen_profile)
				PI:NextPage()
			end,
			preview = path .. "preview\\DPS_QHD.tga",
		},
		{
	         text = L["|cff8b8b8bHealer|r"],
	         func = function()
		     SpectraUI:Print("|cff57ff75Healer|r layout is currently under development.")
	         end,
	         preview = path .. "preview\\Healer_QHD.tga",
	         disabled = true,
        },
	},
}

-- PAGE 4: WEAKAURAS
SpectraUI.InstallerData[#SpectraUI.InstallerData + 1] = {
	SubTitle = L["Weakauras"],
	tutorialImage = true,
	descriptions = {
		[1] = function()
			local text_spectra = format(
				L["These WeakAuras are required for %s to function correctly.\n\nThey provide |cff2ab6ffAnchors|r and |cffF5C56AEssentials|r to the Core |cff2ab6ffUI|r elements used throughout the Interface."],
				SpectraUI.Name,
				SpectraUI.Name
			)
			return text_spectra
		end,

	},
	options = {
		[1] = {
			text = L["|cff2ab6ffAnchors|r"],
			func = function()
				E.PopupDialogs.SPECTRAUI_CONFIRM_WA_IMPORT.text =
					L["This will import the required WeakAuras:\n|cff2ab6ffAnchors|r"]

				E:StaticPopup_Show(
					"SPECTRAUI_CONFIRM_WA_IMPORT",
					nil,
					nil,
					{ groupKey = "anchors" }
				)
			end,
			preview = path .. "preview\\WA_Anchors.tga",
		},
		[2] = {
			text = L["|cffF5C56AEssentials|r"],
			func = function()
				E.PopupDialogs.SPECTRAUI_CONFIRM_WA_IMPORT.text =
					L["This will import the required WeakAuras:\n|cffF5C56AEssentials|r"]

				E:StaticPopup_Show(
					"SPECTRAUI_CONFIRM_WA_IMPORT",
					nil,
					nil,
					{ groupKey = "essentials" }
				)
			end,
			preview = path .. "preview\\WA_Essentials.tga",
		},
	},
}

-- PAGE 5: ADDONS
SpectraUI.InstallerData[#SpectraUI.InstallerData + 1] = {
	SubTitle = "AddOns",
	tutorialImage = true,
	descriptions = {
		[1] = function()
			local text_spectra = format(
				L["These are the |cff5ddb60Available|r AddOn profiles for %s.\n\nClick a button below to apply the profile for the selected AddOn."],
				SpectraUI.Name,
				SpectraUI.Name
			)
			return text_spectra
		end,
	},
	options = {
		{
			text = "Details",
			func = function()
				SpectraUI:Details()
			end,
			preview = path .. "preview\\Details.tga",
		},
		{
			text = "BigWigs",
			func = function()
				SpectraUI:BigWigs()
			end,
			preview = path .. "preview\\BigWigs.tga",
		},
	},
}

-- PAGE 6: BLIZZARD (RETAIL ONLY)
if E.Retail then
	SpectraUI.InstallerData[#SpectraUI.InstallerData + 1] = {
		SubTitle = "Blizzard",
		tutorialImage = true,
		descriptions = {
			[1] = L["On Retail, you can now copy and import the Blizzard interface profile."],
		},
		options = {
			[1] = {
				text = "Blizzard",
				func = function()
					if chosen_profile == "nova" then
						SpectraUI:BlizzardNova()
					else
						SpectraUI:Blizzard()
					end
				end,
			},
		},
	}
end

-- PAGE 7: FINISH
SpectraUI.InstallerData[#SpectraUI.InstallerData + 1] = {
	SubTitle = L["Installation Complete"],
	tutorialImage = true,
	descriptions = {
		[1] = L["|cff5ddb60The installation process is now complete!|r"],
		[2] = L["Click the button below to finalize everything and automatically reload your interface. If you run into any questions or issues, feel free to join our |TInterface\\AddOns\\ElvUI_SpectraUI\\media\\discord_logo.tga:14:14|t  |CFF2ab6ffDiscord|r for assistance!"],
	},
	options = {
		[1] = {
			text = SpectraUI.Media.discordLogo .. " " .. "Discord",
			func = function()
				E:StaticPopup_Show("SPECTRAUI_EDITBOX", nil, nil, "https://discord.gg/UxHZRpSwQz")
			end,
		},
		[2] = {
			text = L["Finished"],
			func = function()
				SpectraUI:InstallComplete()
			end,
		},
	},
}
