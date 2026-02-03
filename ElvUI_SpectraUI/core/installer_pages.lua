-- Create references to ElvUI internals
local E = unpack(ElvUI)
local L = SpectraUI.Locales
local PI = E:GetModule("PluginInstaller")
-- dont touch this ^

-- =====================================================
-- INSTALLER MODE
-- =====================================================
-- false = Single layout (Spectra only)
-- true  = Dual layout (Spectra + Nova)
local DUAL_LAYOUT_MODE = false
local DEFAULT_LAYOUT = "spectra"

local chosen_profile = nil

-- Force default layout when single-layout mode is active
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
-- PROFILE HANDLING
-- =====================================================
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
	-- Run ElvUI setup since installer is skipped
	E:SetupCVars()
	E:SetupChat()

	local profileName = layout == "Nova" and "Nova" or "Spectra"

	-- Create and set private profile
	if ElvPrivateDB then
		if not ElvPrivateDB.profiles[profileName] then
			ElvPrivateDB.profileKeys[E.mynameRealm] = profileName
			ElvPrivateDB.profiles[profileName] = {}
			ElvPrivateDB.profiles[profileName] = E:CopyTable({}, E.privateVars.profile)
			E:CopyTable(E.private, ElvPrivateDB.profiles[profileName])
		end
	end

	-- Apply layout logic
	if layout == "healer" then
		SpectraUI:ElvUIProfileHorizontal()
	else
		SpectraUI:ElvUIProfileVertical()
	end
end

-- =====================================================
-- POPUP
-- =====================================================
E.PopupDialogs.SPECTRAUI_SELECT = {
	text = format(
		L["You already have the %s profile installed. Would you like to change to the %s profile?"],
		SpectraUI.Name,
		SpectraUI.Name
	),
	button1 = L["Change Profile"],
	button2 = L["Install New"],
	OnAccept = function(_, data)
		ChangeProfile(data)
	end,
	OnCancel = function(_, data)
		InstallProfile(data)
	end,
	timeout = 0,
	whileDead = 1,
	hideOnEscape = true,
	preferredIndex = 3,
}

-- =====================================================
-- INSTALLER METADATA
-- =====================================================
local path = SpectraUI.Media.mediaPath

SpectraUI.InstallerData.Title = SpectraUI.Name
SpectraUI.InstallerData.Name = SpectraUI.Name
SpectraUI.InstallerData.Logo = SpectraUI.Media.logo
SpectraUI.InstallerData.LogoSize = { 410, 205 }
SpectraUI.InstallerData.StepTitlesColor = { 0.9, 0.9, 0.9 }
SpectraUI.InstallerData.StepTitlesColorSelected = { 0, 0.98, 0.44 }

-- =====================================================
-- PAGE 1 — WELCOME
-- =====================================================
SpectraUI.InstallerData[1] = {
	SubTitle = format(L["Welcome to the installation for %s"], SpectraUI.Name),
	StepTitle = L["Welcome"],
	tutorialImage = true,
	descriptions = {
		[1] = format(
			L["The %s installation process is designed to be straightforward."],
			SpectraUI.Name
		),
		[2] = format(
			L["|CFFF63939Important|r: Major updates to %s will require reinstalling."],
			SpectraUI.Name
		),
		[3] = L["Press continue to start or skip to cancel."],
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
-- PAGE 2 — ESSENTIAL SETTINGS (SPECTRA ONLY)
-- =====================================================
SpectraUI.InstallerData[#SpectraUI.InstallerData + 1] = {
	SubTitle = L["Essential Settings"],
	StepTitle = "SpectraUI",
	tutorialImage = true,
	descriptions = {
		[1] = function()
			return format(
				L["This will install %s. Choose between DPS/Tank or Healer."],
				SpectraUI.Name
			)
		end,
	},
	options = {
		[1] = {
			text = L["DPS / Tank"],
			func = function()
				if SpectraUI.Profiles.spectra.private and SpectraUI.Profiles.spectra.profile then
					E:StaticPopup_Show("SPECTRAUI_SELECT", nil, nil, "Spectra")
				else
					InstallProfile("spectra")
				end
			end,
			preview = path .. "preview\\profile_vertical.tga",
		},
		[2] = {
			text = L["Healer"],
			func = function()
				if SpectraUI.Profiles.spectraV2.private and SpectraUI.Profiles.spectraV2.profile then
					E:StaticPopup_Show("SPECTRAUI_SELECT", nil, nil, "Spectra V2")
				else
					InstallProfile("healer")
				end
			end,
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
