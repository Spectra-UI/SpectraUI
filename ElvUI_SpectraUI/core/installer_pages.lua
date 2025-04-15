-- Create references to ElvUI internals
local E = unpack(ElvUI)
local L = SpectraUI.Locales
local PI = E:GetModule("PluginInstaller")
-- dont touch this ^

local function ChangeProfile(layout)
	if E.charSettings then
		local profileName =layout == "Nova" and "Nova" or "Spectra"
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

	local profileName =layout == "Nova" and "Nova" or "Spectra"

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

-- here yu can setup your installer pages
-- example page below >

-- SpectraUI.InstallerData[PAGE_NUMBER] = {
-- 	SubTitle = "TITLE",
-- 	StepTitle = "STEP TITLE",
-- 	tutorialImage = true, -- show logo yes = true / no = false
-- 	descriptions = { -- you can add up to 4 descriptions
-- 		[1] = "DESCRIPTION 1",
-- 		[2] = "DESCRIPTION 2",
-- 		[3] = "DESCRIPTION 3",
-- 		[4] = "DESCRIPTION 4",
-- 	},
-- 	options = { -- you can add up to 4 options/buttons to perform actions
-- 		[1] = {
-- 			text = "BUTTON 1", -- Button text
-- 			preview = "BUTTON_1\\PREVIEW.TGA", -- preview file path or nil
-- 			func = function() -- function to run
-- 				print("BUTTON 1")
-- 			end,
-- 		},
-- 		[2] = {
-- 			text = "BUTTON 2", -- Button text
-- 			preview = "BUTTON_2\\PREVIEW.TGA", -- preview file path or nil
-- 			func = function() -- function to run
-- 				print("BUTTON 2")
-- 			end,
-- 		},
--         [3] = {
-- 			text = "BUTTON 3", -- Button text
-- 			preview = "BUTTON_3\\PREVIEW.TGA", -- preview file path or nil
-- 			func = function() -- function to run
-- 				print("BUTTON 3")
-- 			end,
-- 		},
--         [4] = {
-- 			text = "BUTTON 3", -- Button text
-- 			preview = "BUTTON_3\\PREVIEW.TGA", -- preview file path or nil
-- 			func = function() -- function to run
-- 				print("BUTTON 3")
-- 			end,
-- 		},
-- 	},
-- }

--This is the data we pass on to the ElvUI Plugin Installer.
--The Plugin Installer is responsible for displaying the install guide for this layout.

-- general settings for the installer
SpectraUI.InstallerData.Title = SpectraUI.Name
SpectraUI.InstallerData.Name = SpectraUI.Name
SpectraUI.InstallerData.Logo = SpectraUI.Media.logo
SpectraUI.InstallerData.LogoSize = { 410, 205 }
SpectraUI.InstallerData.StepTitlesColor = { 0.9, 0.9, 0.9 }
SpectraUI.InstallerData.StepTitlesColorSelected = { 0, 0.98, 0.44 }

local spectra_name = SpectraUI.Name
local nova_name = "|CFF03DDFANOVA|r" --#03DDFAFF
local chosen_profile = nil

function SpectraUI:ClearSelection()
	chosen_profile = nil
end

-- installer pages
SpectraUI.InstallerData[1] = {
	SubTitle = format(L["Welcome to the installation for %s"], SpectraUI.Name),
	StepTitle = L["Welcome"],
	tutorialImage = true,
	descriptions = {
		[1] = format(
			L["The %s installation process is designed to be straightforward. You'll be prompted through a series of steps to apply the interface to your system seamlessly. Once the installation is complete, you'll have access to the full suite of %s features"],
			SpectraUI.Name,
			SpectraUI.Name
		),
		[2] = format(
			L["|CFFF63939Important|r: Major updates to %s will require you to go through the installation process again, which may result in the loss of any changes you’ve made. Please make sure to back up your settings if needed!"],
			SpectraUI.Name
		),
		[3] = L["Please press the continue button if you wish to go through the installation process, otherwise click the 'Skip Process' button."],
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

SpectraUI.InstallerData[#SpectraUI.InstallerData + 1] = {
	SubTitle = L["Choose the layout you prefer"],
	StepTitle = "Layout selection",
	tutorialImage = true,
	descriptions = {
		[1] = format(
			L["On this page, you can choose which layout you want to install. You can select either %s or NOVA. Please select your preferred option to proceed with the installation."],
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

SpectraUI.InstallerData[#SpectraUI.InstallerData + 1] = {
	SubTitle = L["Essential Settings"],
	StepTitle = "SpectraUI",
	tutorialImage = true,
	descriptions = {
		[1] = function()
			local text_spectra = format(
				L["This process will install %s and allow you to choose between a DPS/Tank or Healer layout. It will also activate the essential features of %s."],
				SpectraUI.Name,
				SpectraUI.Name
			)
			local text_nova = format(
				L["This process will install %s's NOVA Project. It will also activate the essential features of %s."],
				SpectraUI.Name,
				SpectraUI.Name
			)
			local text_not_selected = format(
				L["You have |CFFF63939not selected a layout|r yet. Please select a layout to continue the process."]
			)

			return (chosen_profile == "nova") and text_nova
				or ((chosen_profile == "spectra") and text_spectra or text_not_selected)
		end,
		[2] = function()
			local text =
				L["|CFFF63939Important|r: Skipping this step may lead to an incomplete and malfunctioning interface!"]
			return chosen_profile and text or ""
		end,
	},
	options = {
		[1] = function()
			local spectra = {
				text = L["DPS/Tank"],
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
			return (chosen_profile == "nova") and nova or (chosen_profile == "spectra") and spectra
		end,
		[2] = function()
			local spectra = {
				text = L["Healer"],
				func = function()
					if SpectraUI.Profiles.spectraV2.private and SpectraUI.Profiles.spectraV2.profile then
						E:StaticPopup_Show("SPECTRAUI_SELECT", nil, nil, "Spectra V2")
					else
						InstallProfile("healer")
					end
				end,
				preview = path .. "preview\\profile_horizontal.tga",
			}
			return (chosen_profile == "spectra") and spectra
		end,
	},
}

SpectraUI.InstallerData[#SpectraUI.InstallerData + 1] = {
	SubTitle = L["Weakauras"],
	tutorialImage = true,
	descriptions = {
		[1] = L["These are the Weakauras that are available. Please click a button below to apply the new Weakauras."],
	},
	options = {
		[1] = function()
			local spectra = {
				text = L["UI Elements"],
				func = function()
					E:StaticPopup_Show(
						"SPECTRAUI_EDITBOX",
						nil,
						nil,
						E.Retail and SpectraUI.Links.WA.spectra.retail or SpectraUI.Links.WA.spectra.classic
					)
				end,
				preview = path .. "preview\\UI_Elements.tga",
			}
			local nova = {
				text = L["NOVA Elements"],
				func = function()
					E:StaticPopup_Show(
						"SPECTRAUI_EDITBOX",
						nil,
						nil,
						E.Retail and SpectraUI.Links.WA.nova.retail or SpectraUI.Links.WA.nova.classic
					)
				end,
				preview = path .. "preview\\NOVA_Weakauras.tga",
			}
			return (chosen_profile == "nova") and nova or (chosen_profile == "spectra") and spectra
		end,
	},
}

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
				SpectraUI:Details()
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
				SpectraUI:OmniCD()
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
					SpectraUI:Blizzard()
				end,
			},
		},
	}
end

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
