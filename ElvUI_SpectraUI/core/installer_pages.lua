-- Create references to ElvUI internals
local E = unpack(ElvUI)
local L = SpectraUI.Locales
-- dont touch this ^

local private, profile, privateIsSet, profileIsSet = SpectraUI:CheckProfile()

local function ChangeProfile()
	if not profileIsSet then
		if ElvDB and ElvDB.profiles and ElvDB.profiles.Spectra then
			ElvDB.profileKeys[E.mynameRealm] = "Spectra"
		end
	end

	if not privateIsSet then
		if not E.private.install_complete then
			E:SetupCVars()
			E:SetupChat()
		end

		if ElvPrivateDB and ElvPrivateDB.profiles and ElvPrivateDB.profiles.Spectra then
			ElvPrivateDB.profileKeys[E.mynameRealm] = "Spectra"
		end
	end

	SpectraUI:InstallComplete()
end

local function InstallProfile()
	-- we need to run elvui setup for cvars and chat first, because we are skipping the elvui installer
	E:SetupCVars()
	E:SetupChat()

	-- create and set a new private profile
	if ElvPrivateDB then
		ElvPrivateDB.profileKeys[E.mynameRealm] = "Spectra"

		if not ElvPrivateDB.profiles.Spectra then
			ElvPrivateDB.profiles.Spectra = E:CopyTable({}, E.privateVars.profile)
			E:CopyTable(E.private, ElvPrivateDB.profiles.Spectra)
		end
	end

	-- run the profile setup
	SpectraUI:ElvUIProfileVertical()
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
		ChangeProfile()
	end,
	OnCancel = function()
		InstallProfile()
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
--The Plugin Installer is reponsible for displaying the install guide for this layout.

-- general settings for the installer
SpectraUI.InstallerData.Title = SpectraUI.Name
SpectraUI.InstallerData.Name = SpectraUI.Name
SpectraUI.InstallerData.Logo = SpectraUI.Media.logo
SpectraUI.InstallerData.LogoSize = { 410, 205 }
SpectraUI.InstallerData.StepTitlesColor = { 0.9, 0.9, 0.9 }
SpectraUI.InstallerData.StepTitlesColorSelected = { 0, 0.98, 0.44 }

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
	SubTitle = L["Essential Settings"],
	StepTitle = "ElvUI",
	tutorialImage = true,
	descriptions = {
		[1] = format(
			L["This process will install %s and allow you to choose between a DPS/Tank or Healer layout. It will also activate the essential features of %s."],
			SpectraUI.Name,
			SpectraUI.Name
		),
		[2] = L["|CFFF63939Important|r: Skipping this step may lead to an incomplete and malfunctioning interface!"],
	},
	options = {
		[1] = {
			text = L["DPS/Tank"],
			func = function()
				if private and profile then
					E:StaticPopup_Show("SPECTRAUI_SELECT")
				else
					InstallProfile()
				end
			end,
			preview = path .. "preview\\profile_vertical.tga",
		},
		[2] = {
			text = L["Healer"],
			func = function() end,
			preview = path .. "preview\\profile_horizontal.tga",
		},
	},
}

SpectraUI.InstallerData[#SpectraUI.InstallerData + 1] = {
	SubTitle = L["Weakauras"],
	tutorialImage = true,
	descriptions = {
		[1] = L["These are the Weakauras that are available. Please click a button below to apply the new Weakauras."],
	},
	options = {
		[1] = {
			text = L["UI Elements"],
			func = function()
				E:StaticPopup_Show(
					"SPECTRAUI_EDITBOX",
					nil,
					nil,
					E.Retail and SpectraUI.Links.WA.retail or SpectraUI.Links.WA.classic
				)
			end,
			preview = path .. "preview\\UI_Elements.tga",
		},
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
			preview = path .. "preview\\Details.tga",
		},
		[2] = {
			text = "Syling Tracker",
			func = function()
				SpectraUI:SylingTracker()
				SpectraUI:Scorpio()
			end,
			preview = path .. "preview\\SylingTracker.tga",
		},
		[3] = {
			text = "CDTL2",
			func = function()
				SpectraUI:CDTL2()
			end,
			preview = path .. "preview\\CDTL2.tga",
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
			text = "BigWigs",
			func = function()
				SpectraUI:BigWigs()
			end,
			preview = path .. "preview\\BigWigs.tga",
		},
		[2] = {
			text = "Cooldown To Go",
			func = function()
				SpectraUI:CooldownToGo()
			end,
			preview = path .. "preview\\CooldownToGo.tga",
		},
		[3] = {
			text = "OmniCD",
			func = function()
				SpectraUI:OmniCD()
			end,
			preview = path .. "preview\\OmniCD.tga",
		},
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

-- Recommendations here is the new page
--SpectraUI.InstallerData[#SpectraUI.InstallerData + 1] = {
--	SubTitle = "Recommendations",
--	tutorialImage = true,
--	descriptions = {
--		[1] = L["For more information and support, visit my Discord server."],
--	},
--	options = {
--		[1] = {
--			text = "OPTIONAL BUTTON 1",
--			func = function()
--				--E:StaticPopup_Show("SPECTRAUI_EDITBOX", nil, nil, "https://discord.gg/gfGrNrER3K")
--			end,
--			preview = path .. "preview\\IMAGE.tga",
--		},
--		[2] = {
--			text = "OPTIONAL BUTTON 2",
--			func = function()
--				--E:StaticPopup_Show("SPECTRAUI_EDITBOX", nil, nil, "https://discord.gg/gfGrNrER3K")
--			end,
--			preview = path .. "preview\\IMAGE.tga",
--		},
--	},
--}

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
