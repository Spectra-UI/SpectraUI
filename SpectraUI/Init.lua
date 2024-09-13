local addon, ns = ...
GetAddOnMetadata = _G.C_AddOns and _G.C_AddOns.GetAddOnMetadata or _G.GetAddOnMetadata
local Version = GetAddOnMetadata(addon, "Version")

-- Cache Lua / WoW API
local format = string.format
local GetCVarBool = GetCVarBool
local ReloadUI = ReloadUI
local StopMusic = StopMusic
local tconcat = _G.table.concat
local IsAddOnLoaded = _G.C_AddOns and _G.C_AddOns.IsAddOnLoaded or _G.IsAddOnLoaded
local path = "Interface\\AddOns\\SpectraUI\\media\\"

-- Change this line and use a unique name for your plugin.
local MyPluginName = "SpectraUI"

-- Create references to ElvUI internals
local E, L, V, P, G = unpack(ElvUI)

-- Create reference to LibElvUIPlugin
local EP = LibStub("LibElvUIPlugin-1.0")

-- Create a new ElvUI module so ElvUI can handle initialization when ready
SpectraUI = E:NewModule(MyPluginName, "AceHook-3.0", "AceEvent-3.0", "AceTimer-3.0")

-- Name, Logo and Icon for your plugin.
SpectraUI.Name = "|CFFFFFFFFSpectra|r |CFF03FA6EUI|r" --#03FA6E #FFFFFF
SpectraUI.UIColor = { r = 0, g = 0.98, b = 0.44, a = 1, hex = "|CFF03FA6E" }
SpectraUI.Icon = "|TInterface\\AddOns\\SpectraUI\\media\\icon.tga:14:14|t"
SpectraUI.Logo = "Interface\\AddOns\\SpectraUI\\media\\logo.tga"
SpectraUI.LogoText = "Interface\\AddOns\\SpectraUI\\media\\logo_text.tga"

-- example of credits if you want to add some
local CREDITS = {
	"|CFF16F5EEHoffa|r  - Author", --#16F5EE
	"|CFF00A3FFB|r|CFF00B4FFl|r|CFF00C6FFi|r|CFF00D8FFn|r|CFF00EAFFk|r|CFF00F6FFi|r|CFF00F6FFi|r - Programming",
}

local CREDITS_STRING = tconcat(CREDITS, "|n")

--This function is executed when you press "Skip Process" or "Finished" in the installer.
local function InstallComplete()
	-- Set a variable tracking the version of the addon when layout was installed
	E.db[MyPluginName].install_version = Version
	E.private.install_complete = E.version

	ReloadUI()
end

-- some cosmetics to the installer
local function Resize()
	PluginInstallFrame:SetSize(800, 512)
	PluginInstallFrame:SetScale(1.25)

	PluginInstallFrame.Desc1:ClearAllPoints()
	PluginInstallFrame.Desc1:SetPoint("TOP", PluginInstallFrame.SubTitle, "BOTTOM", 0, -30)
	PluginInstallFrame.tutorialImage:ClearAllPoints()
	PluginInstallFrame.tutorialImage:SetPoint("BOTTOM", 0, 100)
end

local function OnEnter(button)
	button:SetBackdropBorderColor(SpectraUI.UIColor.r, SpectraUI.UIColor.g, SpectraUI.UIColor.b, SpectraUI.UIColor.a)
	if button.Pic then
		PluginInstallFrame.tutorialImage:SetTexture(button.Pic)
		E:UIFrameFadeIn(PluginInstallFrame.tutorialImage, 0.75, 0, 1)
	end
end

local function OnLeave(button)
	button:SetBackdropBorderColor(unpack(E.media.bordercolor))
	PluginInstallFrame.tutorialImage:SetTexture(SpectraUI.Logo)
end

local function SetEvents()
	PluginInstallFrame.Option1:SetScript("OnEnter", nil)
	PluginInstallFrame.Option1:SetScript("OnLeave", nil)
	PluginInstallFrame.Option2:SetScript("OnEnter", nil)
	PluginInstallFrame.Option2:SetScript("OnLeave", nil)
	PluginInstallFrame.Option3:SetScript("OnEnter", nil)
	PluginInstallFrame.Option3:SetScript("OnLeave", nil)
	PluginInstallFrame.Option4:SetScript("OnEnter", nil)
	PluginInstallFrame.Option4:SetScript("OnLeave", nil)

	PluginInstallFrame.Next:SetScript("OnEnter", nil)
	PluginInstallFrame.Next:SetScript("OnLeave", nil)
	PluginInstallFrame.Prev:SetScript("OnEnter", nil)
	PluginInstallFrame.Prev:SetScript("OnLeave", nil)

	PluginInstallFrame.Option1:SetScript("OnEnter", OnEnter)
	PluginInstallFrame.Option1:SetScript("OnLeave", OnLeave)
	PluginInstallFrame.Option2:SetScript("OnEnter", OnEnter)
	PluginInstallFrame.Option2:SetScript("OnLeave", OnLeave)
	PluginInstallFrame.Option3:SetScript("OnEnter", OnEnter)
	PluginInstallFrame.Option3:SetScript("OnLeave", OnLeave)
	PluginInstallFrame.Option4:SetScript("OnEnter", OnEnter)
	PluginInstallFrame.Option4:SetScript("OnLeave", OnLeave)

	PluginInstallFrame.Next:SetScript("OnEnter", OnEnter)
	PluginInstallFrame.Next:SetScript("OnLeave", OnLeave)
	PluginInstallFrame.Prev:SetScript("OnEnter", OnEnter)
	PluginInstallFrame.Prev:SetScript("OnLeave", OnLeave)
end

local function ResetPic()
	PluginInstallFrame.Option1.Pic = nil
	PluginInstallFrame.Option2.Pic = nil
	PluginInstallFrame.Option3.Pic = nil
	PluginInstallFrame.Option4.Pic = nil
end

--This is the data we pass on to the ElvUI Plugin Installer.
--The Plugin Installer is reponsible for displaying the install guide for this layout.
local InstallerData = {
	Title = SpectraUI.Name,
	Name = SpectraUI.Name,
	tutorialImage = SpectraUI.Logo, --If you have a logo you want to use, otherwise it uses the one from ElvUI
	tutorialImageSize = { 512, 256 },
	Pages = {
		[1] = function()
			Resize()
			ResetPic()
			PluginInstallFrame.SubTitle:SetText("Welcome to the installation for " .. SpectraUI.Name)
			PluginInstallFrame.Desc1:SetText("This installation process will guide you through a few steps and create a new ElvUI profile.")
			PluginInstallFrame.Desc2:SetText("Please press the continue button if you wish to go through the installation process, otherwise click the 'Skip Process' button.")
			PluginInstallFrame.Option1:Show()
			PluginInstallFrame.Option1:SetScript("OnClick", InstallComplete)
			PluginInstallFrame.Option1:SetText("Skip Process")

			PluginInstallFrame.Option2:Hide()
			PluginInstallFrame.Option3:Hide()
			PluginInstallFrame.Option4:Hide()
		end,
		[2] = function()
			Resize()
			ResetPic()
			PluginInstallFrame.SubTitle:SetText("ElvUI")
			PluginInstallFrame.Desc1:SetText("These are the layouts that are available. Please click a button below to apply the layout of your choosing.")
			PluginInstallFrame.Desc2:SetText("Importance: |CFFF63939High|r")
			PluginInstallFrame.Option1:Show()
			PluginInstallFrame.Option1:SetScript("OnClick", function()
				SpectraUI:ElvUIProfile()
			end)
			PluginInstallFrame.Option1:SetText("SpectraUI")
		end,
		[3] = function()
			Resize()
			ResetPic()
			PluginInstallFrame.SubTitle:SetText("Weakaura")
			PluginInstallFrame.Desc1:SetText("These are the profiles that are available. Please click a button below to apply the profile for the AddOn.")
			PluginInstallFrame.Desc2:SetText("Importance: |CFFF63939High|r")

			PluginInstallFrame.Option1:Show()
			PluginInstallFrame.Option1:SetScript("OnClick", function()
				E:StaticPopup_Show("ELVUI_EDITBOX", nil, nil, "https://wago.io/NOLINK")
			end)
			PluginInstallFrame.Option1:SetText("Class WA")
			PluginInstallFrame.Option1.Pic = path .. "preview\\ClassWA.tga"

			PluginInstallFrame.Option2:Show()
			PluginInstallFrame.Option2:SetScript("OnClick", function()
				E:StaticPopup_Show("ELVUI_EDITBOX", nil, nil, "https://wago.io/NOLINK")
			end)
			PluginInstallFrame.Option2:SetText("Dynamic Portraits")
			PluginInstallFrame.Option2.Pic = path .. "preview\\DynamicPortraits.tga"
		end,
		[4] = function()
			Resize()
			ResetPic()
			PluginInstallFrame.SubTitle:SetText("AddOns 1")
			PluginInstallFrame.Desc1:SetText("These are the profiles that are available. Please click a button below to apply the profile for the AddOn.")
			PluginInstallFrame.Desc2:SetText("Importance: |CFFFF9130Medium|r")

			PluginInstallFrame.Option1:Show()
			PluginInstallFrame.Option1:SetScript("OnClick", function()
				SpectraUI:Details()
			end)
			PluginInstallFrame.Option1:SetText("Details")
			PluginInstallFrame.Option1.Pic = path .. "preview\\Details.tga"

			PluginInstallFrame.Option2:Show()
			PluginInstallFrame.Option2:SetScript("OnClick", function()
				SpectraUI:SylingTracker()
			end)
			PluginInstallFrame.Option2:SetText("Syling Tracker")
			PluginInstallFrame.Option2.Pic = path .. "preview\\SylingTracker.tga"

			PluginInstallFrame.Option3:Show()
			PluginInstallFrame.Option3:SetScript("OnClick", function()
				SpectraUI:CDTL2()
			end)
			PluginInstallFrame.Option3:SetText("Cooldown Timeline 2")
			PluginInstallFrame.Option3.Pic = path .. "preview\\CDTL2.tga"
		end,
		[5] = function()
			Resize()
			ResetPic()
			PluginInstallFrame.SubTitle:SetText("AddOns 2")
			PluginInstallFrame.Desc1:SetText("These are the profiles that are available. Please click a button below to apply the profile for the AddOn.")
			PluginInstallFrame.Desc2:SetText("Importance: |CFF9BFF30Low|r")

			PluginInstallFrame.Option1:Show()
			PluginInstallFrame.Option1:SetScript("OnClick", function()
				SpectraUI:BigWigs()
			end)
			PluginInstallFrame.Option1:SetText("BigWigs")
			PluginInstallFrame.Option1.Pic = path .. "preview\\BigWigs.tga"

			PluginInstallFrame.Option2:Show()
			PluginInstallFrame.Option2:SetScript("OnClick", function()
				SpectraUI:Hekili()
			end)
			PluginInstallFrame.Option2:SetText("Hekili")
			PluginInstallFrame.Option2.Pic = path .. "preview\\Hekili.tga"

			PluginInstallFrame.Option3:Show()
			PluginInstallFrame.Option3:SetScript("OnClick", function()
				SpectraUI:CooldownToGo()
			end)
			PluginInstallFrame.Option3:SetText("Cooldown To Go")
			PluginInstallFrame.Option3.Pic = path .. "preview\\CooldownToGo.tga"

			PluginInstallFrame.Option4:Show()
			PluginInstallFrame.Option4:SetScript("OnClick", function()
				SpectraUI:OmniCD()
			end)
			PluginInstallFrame.Option4:SetText("OmniCD")
			PluginInstallFrame.Option4.Pic = path .. "preview\\OmniCD.tga"
		end,
		[6] = function()
			Resize()
			ResetPic()
			PluginInstallFrame.SubTitle:SetText("Blizzard")
			PluginInstallFrame.Desc1:SetText("On Retail, you can now copy and import the Blizzard interface profile.")
			PluginInstallFrame.Desc2:SetText("Importance: |CFFF63939High|r")

			PluginInstallFrame.Option1:Show()
			PluginInstallFrame.Option1:SetScript("OnClick", function()
				E:StaticPopup_Show("ELVUI_EDITBOX", nil, nil, "1 39 0 0 1 7 7 UIParent 0.0 45.0 -1 ##$$%/&('%)#+#,$ 0 1 1 7 7 UIParent 0.0 45.0 -1 ##$$%/&('%(#,$ 0 2 1 7 7 UIParent 0.0 45.0 -1 ##$$%/&('%(#,$ 0 3 1 5 5 UIParent -5.0 -77.0 -1 #$$$%/&('%(#,$ 0 4 1 5 5 UIParent -5.0 -77.0 -1 #$$$%/&('%(#,$ 0 5 1 1 4 UIParent 0.0 0.0 -1 ##$$%/&('%(#,$ 0 6 1 1 4 UIParent 0.0 -50.0 -1 ##$$%/&('%(#,$ 0 7 1 1 4 UIParent 0.0 -100.0 -1 ##$$%/&('%(#,$ 0 10 1 7 7 UIParent 0.0 45.0 -1 ##$$&('% 0 11 1 7 7 UIParent 0.0 45.0 -1 ##$$&('%,# 0 12 1 7 7 UIParent 0.0 45.0 -1 ##$$&('% 1 -1 1 4 4 UIParent 0.0 0.0 -1 ##$#%# 2 -1 1 2 2 UIParent 0.0 0.0 -1 ##$#%( 3 0 1 8 7 UIParent -300.0 250.0 -1 $#3# 3 1 1 6 7 UIParent 300.0 250.0 -1 %#3# 3 2 1 6 7 UIParent 520.0 265.0 -1 %#&#3# 3 3 1 0 2 CompactRaidFrameManager 0.0 -7.0 -1 '#(#)#-#.#/#1$3# 3 4 1 0 2 CompactRaidFrameManager 0.0 -5.0 -1 ,#-#.#/#0#1#2( 3 5 1 5 5 UIParent 0.0 0.0 -1 &#*$3# 3 6 1 5 5 UIParent 0.0 0.0 -1 -#.#/#4$ 3 7 1 4 4 UIParent 0.0 0.0 -1 3# 4 -1 1 7 7 UIParent 0.0 45.0 -1 # 5 -1 1 7 7 UIParent 0.0 45.0 -1 # 6 0 1 2 2 UIParent -255.0 -10.0 -1 ##$#%#&.(()( 6 1 1 2 2 UIParent -270.0 -155.0 -1 ##$#%#'+(()( 7 -1 1 7 7 UIParent 0.0 45.0 -1 # 8 -1 0 6 6 UIParent 35.0 50.0 -1 #'$A%$&7 9 -1 1 7 7 UIParent 0.0 45.0 -1 # 10 -1 1 0 0 UIParent 16.0 -116.0 -1 # 11 -1 1 8 8 UIParent -9.0 85.0 -1 # 12 -1 1 2 2 UIParent -110.0 -275.0 -1 #K$#%# 13 -1 1 8 8 MicroButtonAndBagsBar 0.0 0.0 -1 ##$#%)&- 14 -1 1 2 2 MicroButtonAndBagsBar 0.0 10.0 -1 ##$#%( 15 0 1 7 7 StatusTrackingBarManager 0.0 0.0 -1 # 15 1 1 7 7 StatusTrackingBarManager 0.0 17.0 -1 # 16 -1 1 5 5 UIParent 0.0 0.0 -1 #( 17 -1 1 1 1 UIParent 0.0 -100.0 -1 ## 18 -1 1 5 5 UIParent 0.0 0.0 -1 #- 19 -1 1 7 7 UIParent 0.0 0.0 -1 ##")
			end)
			PluginInstallFrame.Option1:SetText("Blizzard")

			PluginInstallFrame.Option2:Hide()

			PluginInstallFrame.Option3:Hide()

			PluginInstallFrame.Option4:Hide()
		end,
		[7] = function()
			Resize()
			ResetPic()
			PluginInstallFrame.SubTitle:SetText("Installation Complete")
			PluginInstallFrame.Desc1:SetText("You have completed the installation process.")
			PluginInstallFrame.Desc2:SetText("Please click the button below in order to finalize the process and automatically reload your UI.")

			PluginInstallFrame.Option1:Show()
			PluginInstallFrame.Option1:SetScript("OnClick", InstallComplete)
			PluginInstallFrame.Option1:SetText("Finished")

			PluginInstallFrame.Option2:Hide()

			PluginInstallFrame.Option3:Hide()

			PluginInstallFrame.Option4:Hide()
		end,
	},
	StepTitles = {
		[1] = "Welcome",
		[2] = "ElvUI",
		[3] = "Weakaura",
		[4] = "AddOns 1",
		[5] = "AddOns 2",
		[6] = "Blizzard",
		[7] = "Installation Complete",
	},
	StepTitlesColor = { 0.9, 0.9, 0.9 },
	StepTitlesColorSelected = { 0, 0.98, 0.44 },
	StepTitleWidth = 200,
	StepTitleButtonWidth = 180,
	StepTitleTextJustification = "CENTER",
}

-- Create a unique table for our plugin
P[MyPluginName] = {}

-- Plugin Settings
local function InsertOptions()
	E.Options.args.MyPluginName = {
		order = 100,
		type = "group",
		name = SpectraUI.Icon .. " " .. SpectraUI.Name,
		args = {
			logo = {
				type = "description",
				name = "",
				order = 1,
				image = function()
					return SpectraUI.Logo, 307, 154
				end,
			},
			about = {
				order = 2,
				type = "group",
				inline = true,
				name = L["About"],
				args = {
					description1 = {
						order = 1,
						type = "description",
						name = format("%s is a layout for ElvUI.", SpectraUI.Name),
					},
				},
			},
			thankyou = {
				order = 3,
				type = "group",
				inline = true,
				name = L["Credits"],
				args = {
					desc = {
						order = 1,
						type = "description",
						fontSize = "medium",
						name = CREDITS_STRING,
					},
				},
			},
			install = {
				order = 4,
				type = "group",
				inline = true,
				name = L["Installation"],
				args = {
					description2 = {
						order = 1,
						type = "description",
						name = "The installation guide should pop up automatically after you have completed the ElvUI installation. If you wish to re-run the installation process for this layout then please click the button below.",
					},
					spacer2 = {
						order = 2,
						type = "description",
						name = "",
					},
					install = {
						order = 3,
						type = "execute",
						name = "Install",
						desc = "Run the installation process.",
						func = function()
							SetEvents()
							E:GetModule("PluginInstaller"):Queue(InstallerData)
							E:ToggleOptions()
						end,
					},
				},
			},
		},
	}
end

function SpectraUI:Print(...)
	local printName = SpectraUI.Icon .. " " .. SpectraUI.Name .. ":"
	print(printName, ...)
end

function SpectraUI:Setup_mMediaTag()
	if not IsAddOnLoaded("ElvUI_mMediaTag") then return end

	local textureCoords = {
		WARRIOR = { 0, 0, 0, 0.125, 0.125, 0, 0.125, 0.125 },
		MAGE = { 0.125, 0, 0.125, 0.125, 0.25, 0, 0.25, 0.125 },
		ROGUE = { 0.25, 0, 0.25, 0.125, 0.375, 0, 0.375, 0.125 },
		DRUID = { 0.375, 0, 0.375, 0.125, 0.5, 0, 0.5, 0.125 },
		EVOKER = { 0.5, 0, 0.5, 0.125, 0.625, 0, 0.625, 0.125 },
		HUNTER = { 0, 0.125, 0, 0.25, 0.125, 0.125, 0.125, 0.25 },
		SHAMAN = { 0.125, 0.125, 0.125, 0.25, 0.25, 0.125, 0.25, 0.25 },
		PRIEST = { 0.25, 0.125, 0.25, 0.25, 0.375, 0.125, 0.375, 0.25 },
		WARLOCK = { 0.375, 0.125, 0.375, 0.25, 0.5, 0.125, 0.5, 0.25 },
		PALADIN = { 0, 0.25, 0, 0.375, 0.125, 0.25, 0.125, 0.375 },
		DEATHKNIGHT = { 0.125, 0.25, 0.125, 0.375, 0.25, 0.25, 0.25, 0.375 },
		MONK = { 0.25, 0.25, 0.25, 0.375, 0.375, 0.25, 0.375, 0.375 },
		DEMONHUNTER = { 0.375, 0.25, 0.375, 0.375, 0.5, 0.25, 0.5, 0.375 },
	}

	mMT:AddClassIcons("SpectraUI_Classic", path .. "class\\SpectraUI_Classic.tga", textureCoords, "SpectraUI Classic")
	mMT:AddClassIcons("SpectraUI_Modern", path .. "class\\SpectraUI_Modern.tga", textureCoords, "SpectraUI Modern")
end

-- This function will handle initialization of the addon
function SpectraUI:Initialize()
	-- Initiate installation process if ElvUI install is complete and our plugin install has not yet been run
	if E.private.install_complete and E.db[MyPluginName].install_version == nil then
		SetEvents()
		E:GetModule("PluginInstaller"):Queue(InstallerData)
	end

	-- add textures to mMT
	SpectraUI:Setup_mMediaTag()

	-- Insert our options table when ElvUI config is loaded
	EP:RegisterPlugin(addon, InsertOptions)
end

-- Register module with callback so it gets initialized when ready
E:RegisterModule(SpectraUI:GetName())
