-- Create references to ElvUI internals
local E = unpack(ElvUI)
local L = SpectraUI.Locales
local PI = E:GetModule("PluginInstaller")
local chosen_profile = nil
-- dont touch this ^

-- =====================================================
-- INSTALLER MODE
-- =====================================================
-- false = Single layout (Spectra only)
-- true  = Dual layout (Spectra + Nova)
local DUAL_LAYOUT_MODE = false
local DEFAULT_LAYOUT = "spectra"

local function ChangeProfile(layout)
	if E.charSettings then
		local profileName = layout == "Nova" and "Nova" or "Spectra"
		E.charSettings:SetProfile(profileName)
	end

	if E.data then
		E.data:SetProfile(layout)
	end
end

local function InstallProfile(layout)
	-- we need to run elvui setup for cVars and chat first, because we are skipping the elvui installer
	E:SetupCVars()
	E:SetupChat()

	local profileName = layout == "Nova" and "Nova" or "Spectra"

	-- create and set a new private profile
	if ElvPrivateDB then
		if not ElvPrivateDB.profiles.Spectra then
			ElvPrivateDB.profileKeys[E.mynameRealm] = profileName
			ElvPrivateDB.profiles[profileName] = {}
			ElvPrivateDB.profiles[profileName] = E:CopyTable({}, E.privateVars.profile)
			E:CopyTable(E.private, ElvPrivateDB.profiles[profileName])
		end
	end

	if layout == "nova" then
		SpectraUI:ElvUIProfileNova()
	else
		-- run the profile setup
		if layout == "healer" or layout == "Spectra V2" then
			SpectraUI:ElvUIProfileHorizontal()
		else
			SpectraUI:ElvUIProfileVertical()
		end
	end
end

-- =====================================================
-- WEAKAURAS IMPORT HELPER
-- =====================================================
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

	local layoutKey = chosen_profile or "spectra"

	local importString =
		SpectraUI.WeakAuras
		and SpectraUI.WeakAuras[layoutKey]
		and SpectraUI.WeakAuras[layoutKey][groupKey]

	if not importString or importString == "" then
		E:Print("Missing WeakAura import: " .. layoutKey .. " / " .. groupKey)
		return
	end

	-- IMPORTANT: trim whitespace or WA will fail decompression
	importString = importString:match("^%s*(.-)%s*$")

	-- This opens the WeakAuras import window
	WeakAuras.Import(importString)

end

-- =====================================================
-- WEAKAURAS CONFIRMATION POPUP
-- =====================================================
E.PopupDialogs.SPECTRAUI_CONFIRM_WA_IMPORT = {

	text = L["This will import the required WeakAuras.\n\nDo you want to continue?"],
	button1 = L["Import"],
	button2 = CANCEL,
	OnAccept = function(_, data)
		-- data = { groupKey = "anchors"/"essentials" }
		SpectraUI_ImportWeakAura(data.groupKey)
	end,
	timeout = 0,
	whileDead = 1,
	hideOnEscape = true,
	preferredIndex = 3,
}


-- Popup for profile change
E.PopupDialogs.SPECTRAUI_SELECT = {
	text = format(
		L["You already have the %s profile installed. Would you like to change to the %s profile?"],
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

-- media path & files
local path = SpectraUI.Media.mediaPath

-- =====================================================
-- INSTALLER SETTINGS
-- =====================================================
SpectraUI.InstallerData.Title = SpectraUI.Name
SpectraUI.InstallerData.Name = SpectraUI.Name
SpectraUI.InstallerData.Logo = SpectraUI.Media.logo
SpectraUI.InstallerData.LogoSize = { 410, 205 }
SpectraUI.InstallerData.StepTitlesColor = { 0.9, 0.9, 0.9 }
SpectraUI.InstallerData.StepTitlesColorSelected = { 0.1647, 0.7137, 1, 1 }

local spectra_name = SpectraUI.Name
local nova_name = "|CFF03DDFANOVA|r" --#03DDFAFF

-- =====================================================
-- SELECTION STATE
-- =====================================================

-- Single layout mode -> force Spectra selection
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

-- =====================================================
-- PAGE 1: WELCOME
-- =====================================================
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
				SpectraUI:SetupSkip()
			end,
		},
	},
}

-- =====================================================
-- PAGE 2: LAYOUT SELECTION (ONLY IN DUAL MODE)
-- =====================================================
if DUAL_LAYOUT_MODE then
	SpectraUI.InstallerData[#SpectraUI.InstallerData + 1] = {
		SubTitle = L["Choose the layout you prefer"],
		StepTitle = "Layout selection",
		tutorialImage = true,
		descriptions = {
			[1] = format(
				L["On this page, you can choose which layout you want to install. Please select your preferred option to proceed with the installation."],
				spectra_name,
				SpectraUI.Name
			),
			[2] = format(
				L["|CFFF63939Important|r: Major updates to %s will require you to go through the installation process again, which may result in the loss of any changes you’ve made. Please make sure to back up your settings if needed!"],
				SpectraUI.Name
			),
			[3] = L["Please select a layout to continue the process."],
		},
		options = {
			[1] = {
				text = spectra_name,
				preview = path .. "preview\\profile_horizontal.tga",
				func = function()
					SpectraUI:CheckProfile()
					chosen_profile = "spectra"
					PI:NextPage()
				end,
			},
			[2] = {
				text = nova_name,
				preview = path .. "preview\\NOVA.tga",
				func = function()
					SpectraUI:CheckProfile()
					chosen_profile = "nova"
					PI:NextPage()
				end,
			},
		},
	}
end

-- =====================================================
-- NEXT PAGE: ROLE SELECTION (DPS/TANK OR HEALER)
-- =====================================================
SpectraUI.InstallerData[#SpectraUI.InstallerData + 1] = {
	SubTitle = L["Select a layout |cff2ab6ffoptimized|r for your role"],
	StepTitle = "SpectraUI",
	tutorialImage = true,
	descriptions = {
		[1] = function()
			local text_spectra = format(
				L["|cffD96C3ADPS / Tank|r focuses on awareness and damage tracking \n\n|cff57ff75Healer|r focuses on clarity and raid visibility.\n|CFFedbf46Profile is currently under development.|r"],
				SpectraUI.Name,
				SpectraUI.Name
			)
			return text_spectra
		end,
		
	},
	options = {
		[1] = function()
			local spectra = {
				text = L["|cffD96C3ADPS / Tank|r"],
				func = function()
					if SpectraUI.Profiles.spectra.private and SpectraUI.Profiles.spectra.profile then
						E:StaticPopup_Show("SPECTRAUI_SELECT", nil, nil, "Spectra")
					else
						InstallProfile("spectra")
					end
				end,
				preview = path .. "preview\\profile_vertical.tga",
			}

			local nova = {
				text = L["Nova"],
				func = function()
					if SpectraUI.Profiles.nova.private and SpectraUI.Profiles.nova.profile then
						E:StaticPopup_Show("SPECTRAUI_SELECT", nil, nil, "Nova")
					else
						InstallProfile("nova")
					end
				end,
				preview = path .. "preview\\NOVA.tga",
			}

			-- In single layout mode chosen_profile is always "spectra"
			return (chosen_profile == "nova") and nova or spectra
		end,

		[2] = function()
			local spectra = {
				text = L["|cff8b8b8bHealer|r"],
				disabled = true, -- disables the button
				func = function()
					-- intentionally empty
				end,
				preview = path .. "preview\\profile_horizontal.tga",
			}
			return (chosen_profile == "spectra") and spectra
		end,
	},
}

-- =====================================================
-- WEAKAURAS
-- =====================================================
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
					L["This will import the required WeakAuras: Anchors.\n\nContinue?"]

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
					L["This will import the required WeakAuras: Essentials.\n\nContinue?"]

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

-- =====================================================
-- ADDONS 1
-- =====================================================
SpectraUI.InstallerData[#SpectraUI.InstallerData + 1] = {
	SubTitle = "AddOns 1",
	tutorialImage = true,
	descriptions = {
		[1] = L["These are the profiles that are available. Please click a button below to apply the profile for the AddOn."],
	},
	options = {
		[1] = {
			text = "Details",
			func = function()
				if chosen_profile == "nova" then
					SpectraUI:DetailsNova()
				else
					SpectraUI:Details()
				end
			end,
			preview = function()
				local spectra = path .. "preview\\Details.tga"
				local nova = path .. "preview\\NOVA_Details.tga"
				return (chosen_profile == "nova") and nova or spectra
			end,
		},
		[2] = {
			text = "BigWigs",
			func = function()
				SpectraUI:BigWigs()
			end,
			preview = function()
				local spectra = path .. "preview\\BigWigs.tga"
				local nova = path .. "preview\\NOVA_BigWigs.tga"
				return (chosen_profile == "nova") and nova or spectra
			end,
		},
		[3] = {
			text = "Cooldown To Go",
			func = function()
				SpectraUI:CooldownToGo()
			end,
			preview = function()
				local spectra = path .. "preview\\CooldownToGo.tga"
				local nova = path .. "preview\\NOVA_CooldownToGo.tga"
				return (chosen_profile == "nova") and nova or spectra
			end,
		},
	},
}

-- =====================================================
-- ADDONS 2
-- =====================================================
SpectraUI.InstallerData[#SpectraUI.InstallerData + 1] = {
	SubTitle = "AddOns 2",
	tutorialImage = true,
	descriptions = {
		[1] = L["These are the profiles that are available. Please click a button below to apply the profile for the AddOn."],
	},
	options = {
		[1] = {
			text = "OmniCD",
			func = function()
				if chosen_profile == "nova" then
					SpectraUI:OmniCDNova()
				else
					SpectraUI:OmniCD()
				end
			end,
			preview = function()
				local spectra = path .. "preview\\OmniCD.tga"
				local nova = path .. "preview\\NOVA_OmniCD.tga"
				return (chosen_profile == "nova") and nova or spectra
			end,
		},
		[2] = function()
			local spectra = {
				text = "Syling Tracker",
				func = function()
					SpectraUI:SylingTracker()
					SpectraUI:Scorpio()
				end,
				preview = path .. "preview\\SylingTracker.tga",
			}
			return (chosen_profile == "spectra") and spectra
		end,
		[3] = function()
			local spectra = {
				text = "CDTL2",
				func = function()
					SpectraUI:CDTL2()
				end,
				preview = path .. "preview\\CDTL2.tga",
			}
			return (chosen_profile == "spectra") and spectra
		end,
	},
}

-- =====================================================
-- BLIZZARD (RETAIL ONLY)
-- =====================================================
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

-- =====================================================
-- FINISH
-- =====================================================
SpectraUI.InstallerData[#SpectraUI.InstallerData + 1] = {
	SubTitle = L["Installation Complete"],
	tutorialImage = true,
	descriptions = {
		[1] = L["|CFF03FA6EThe installation process is now complete!|r"],
		[2] = L["Click the button below to finalize everything and automatically reload your interface. If you run into any questions or issues, feel free to join our |TInterface\\AddOns\\ElvUI_SpectraUI\\media\\discord_logo.tga:14:14|t  |CFF03FA6EDiscord|r for assistance!"],
	},
	options = {
		[1] = {
			text = L["Finished"],
			func = function()
				SpectraUI:InstallComplete()
			end,
		},
		[2] = {
			text = SpectraUI.Media.discordLogo .. " " .. "Discord",
			func = function()
				E:StaticPopup_Show("SPECTRAUI_EDITBOX", nil, nil, "https://discord.gg/gfGrNrER3K")
			end,
		},
	},
}
