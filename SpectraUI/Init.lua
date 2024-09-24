local addon, ns = ...
GetAddOnMetadata = _G.C_AddOns and _G.C_AddOns.GetAddOnMetadata or _G.GetAddOnMetadata
local Version = GetAddOnMetadata(addon, "Version")

-- Cache Lua / WoW API
local format = string.format
local ReloadUI = ReloadUI
local tconcat = _G.table.concat
local IsAddOnLoaded = _G.C_AddOns and _G.C_AddOns.IsAddOnLoaded or _G.IsAddOnLoaded
local path = "Interface\\AddOns\\SpectraUI\\media\\"
local InstallerData = {}

-- Change this line and use a unique name for your plugin.
local MyPluginName = "SpectraUI"

-- Create references to ElvUI internals
local E, L, V, P, G = unpack(ElvUI)
local PI = E:GetModule("PluginInstaller")

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
	"|CFF03FA6EHoffa|r  - Author", --#16F5EE
	"|CFF00A3FFB|r|CFF00B4FFl|r|CFF00C6FFi|r|CFF00D8FFn|r|CFF00EAFFk|r|CFF00F6FFi|r|CFF00F6FFi|r - Programming",
	"|cffc500ffRepooc|r",
	"|cff0DB1D0J|r|cff18A2D2i|r|cff2494D4b|r|cff2F86D7e|r|cff3B78D9r|r|cff4669DBi|r|cff525BDEs|r|cff5D4DE0h|r",
	"|CFFC7D377Lillekatt|r  - Creator and provider of the Role Icons",
}

-- example of donators if you want to add some
local DONATORS = {
	-- "EXAMPLE",
}

local CREDITS_STRING = tconcat(CREDITS, "|n")
local DONATORS_STRING = tconcat(DONATORS, "|n")

-- popup for ypur links
E.PopupDialogs.SPECTRAUI_EDITBOX = {
	text = SpectraUI.Icon .. " " .. SpectraUI.Name,
	button1 = OKAY,
	hasEditBox = 1,
	OnShow = function(self, data)
		self.editBox:SetAutoFocus(false)
		self.editBox.width = self.editBox:GetWidth()
		self.editBox:Width(280)
		self.editBox:AddHistoryLine("text")
		self.editBox.temptxt = data
		self.editBox:SetText(data)
		self.editBox:SetJustifyH("CENTER")
	end,
	OnHide = function(self)
		self.editBox:Width(self.editBox.width or 50)
		self.editBox.width = nil
		self.temptxt = nil
	end,
	EditBoxOnEnterPressed = function(self)
		self:GetParent():Hide()
	end,
	EditBoxOnEscapePressed = function(self)
		self:GetParent():Hide()
	end,
	EditBoxOnTextChanged = function(self)
		if self:GetText() ~= self.temptxt then self:SetText(self.temptxt) end

		self:HighlightText()
	end,
	whileDead = 1,
	preferredIndex = 3,
	hideOnEscape = 1,
}

--This function is executed when you press "Skip Process" or "Finished" in the installer.
local function InstallComplete()
	-- Set a variable tracking the version of the addon when layout was installed
	E.db[MyPluginName].install_version = Version
	E.private.install_complete = E.version

	ReloadUI()
end

-- some cosmetics to the installer
local skinInstaller = nil

local function OnEnter(button)
	button:SetBackdropBorderColor(SpectraUI.UIColor.r, SpectraUI.UIColor.g, SpectraUI.UIColor.b, SpectraUI.UIColor.a)
	if button.Pic then
		PluginInstallFrame.tutorialImage:Size(512, 256)
		PluginInstallFrame.tutorialImage:SetTexture(button.Pic)
		E:UIFrameFadeIn(PluginInstallFrame.tutorialImage, 0.75, 0, 1)
	else
		PluginInstallFrame.tutorialImage:Size(410, 205)
	end
end

local function OnLeave(button)
	button:SetBackdropBorderColor(unpack(E.media.bordercolor))
	PluginInstallFrame.tutorialImage:Size(410, 205)
	PluginInstallFrame.tutorialImage:SetTexture(SpectraUI.Logo)
end

local function ResetPic()
	PluginInstallFrame.Option1.Pic = nil
	PluginInstallFrame.Option2.Pic = nil
	PluginInstallFrame.Option3.Pic = nil
	PluginInstallFrame.Option4.Pic = nil
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

local function Resize()
	local currentInstalle = PI.Installs[1]
	if currentInstalle and currentInstalle.Title == InstallerData.Title then
		SetEvents()

		PluginInstallFrame:SetSize(800, 512)
		PluginInstallFrame:SetScale(1.25)

		PluginInstallFrame.Desc1:ClearAllPoints()
		PluginInstallFrame.Desc1:SetPoint("TOP", PluginInstallFrame.SubTitle, "BOTTOM", 0, -30)
		PluginInstallFrame.tutorialImage:ClearAllPoints()
		PluginInstallFrame.tutorialImage:SetPoint("BOTTOM", 0, 100)
	end
end

local dicordLogo = "|TInterface\\AddOns\\SpectraUI\\media\\discord_logo.tga:14:14|t"

--This is the data we pass on to the ElvUI Plugin Installer.
--The Plugin Installer is reponsible for displaying the install guide for this layout.
InstallerData = {
	Title = SpectraUI.Name,
	Name = SpectraUI.Name,
	tutorialImage = SpectraUI.Logo, --If you have a logo you want to use, otherwise it uses the one from ElvUI
	tutorialImageSize = { 410, 205 },
	Pages = {
		[1] = function()
			Resize()
			ResetPic()
			PluginInstallFrame.SubTitle:SetText("Welcome to the installation for " .. SpectraUI.Name)
			PluginInstallFrame.Desc1:SetText(
				format(
					"The %s installation process is designed to be straightforward. You'll be prompted through a series of steps to apply the interface to your system seamlessly. Once the installation is complete, you'll have access to the full suite of %s features",
					SpectraUI.Name,
					SpectraUI.Name
				)
			)
			PluginInstallFrame.Desc2:SetText(
				format(
					"|CFFF63939Important|r: Major updates to %s will require you to go through the installation process again, which may result in the loss of any changes you’ve made. Please make sure to back up your settings if needed!",
					SpectraUI.Name
				)
			)
			PluginInstallFrame.Desc3:SetText("Please press the continue button if you wish to go through the installation process, otherwise click the 'Skip Process' button.")
			PluginInstallFrame.Option1:Show()
			PluginInstallFrame.Option1:SetScript("OnClick", InstallComplete)
			PluginInstallFrame.Option1:SetText("Skip Process")

			-- button 2 DC start
			PluginInstallFrame.Option2:Show()
			PluginInstallFrame.Option2:SetScript("OnClick", function()
				E:StaticPopup_Show("SPECTRAUI_EDITBOX", nil, nil, "https://discord.gg/gfGrNrER3K")
			end)
			PluginInstallFrame.Option2:SetText(dicordLogo .. " " .. "Discord")
			--PluginInstallFrame.Option2.Pic = path .. "preview\\Profile.tga"
			-- button 2 end

			PluginInstallFrame.Option3:Hide()
			PluginInstallFrame.Option4:Hide()
		end,
		[2] = function()
			Resize()
			ResetPic()
			PluginInstallFrame.SubTitle:SetText("Essential Settings")
			PluginInstallFrame.Desc1:SetText(
				format("This process will install %s and allow you to choose between a Vertical or Horizontal layout. It will also activate the essential features of %s.", SpectraUI.Name, SpectraUI.Name)
			)
			PluginInstallFrame.Desc2:SetText("|CFFF63939Important|r: Skipping this step may lead to an incomplete and malfunctioning interface!")
			--PluginInstallFrame.Desc3:SetText("Importance: |CFFF63939High|r")

			-- button 1 start
			PluginInstallFrame.Option1:Show()
			PluginInstallFrame.Option1:SetScript("OnClick", function()
				SpectraUI:ElvUIProfileVertical()
			end)
			PluginInstallFrame.Option1:SetText("Vertical")
			PluginInstallFrame.Option1.Pic = path .. "preview\\profile_vertical.tga"
			-- button 1 end

			-- button 2 start
			PluginInstallFrame.Option2:Show()
			PluginInstallFrame.Option2:SetScript("OnClick", function()
				-- SpectraUI:ElvUIProfileHorizontal()
			end)
			PluginInstallFrame.Option2:SetText("Horizontal")
			PluginInstallFrame.Option2.Pic = path .. "preview\\profile_horizontal.tga"
			-- button 2 end
		end,
		[3] = function()
			Resize()
			ResetPic()
			PluginInstallFrame.SubTitle:SetText("Weakauras")
			PluginInstallFrame.Desc1:SetText("These are the Weakauras that are available. Please click a button below to apply the new Weakauras.")
			--PluginInstallFrame.Desc2:SetText("Importance: |CFFF63939High|r")

			PluginInstallFrame.Option1:Show()
			PluginInstallFrame.Option1:SetScript("OnClick", function()
				E:StaticPopup_Show("SPECTRAUI_EDITBOX", nil, nil, "https://wago.io/Kqz6loIke")
			end)
			PluginInstallFrame.Option1:SetText("Frames")
			PluginInstallFrame.Option1.Pic = path .. "preview\\Frames.tga"

			PluginInstallFrame.Option2:Show()
			PluginInstallFrame.Option2:SetScript("OnClick", function()
				E:StaticPopup_Show("SPECTRAUI_EDITBOX", nil, nil, "https://wago.io/MBm1s8QQa")
			end)
			PluginInstallFrame.Option2:SetText("Theme Elements")
			PluginInstallFrame.Option2.Pic = path .. "preview\\UI_Elements.tga"
		end,
		[4] = function()
			Resize()
			ResetPic()
			PluginInstallFrame.SubTitle:SetText("AddOns 1")
			PluginInstallFrame.Desc1:SetText("These are the profiles that are available. Please click a button below to apply the profile for the AddOn.")
			--PluginInstallFrame.Desc2:SetText("Importance: |CFFFF9130Medium|r")

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
			PluginInstallFrame.Option3:SetText("CDTL2")
			PluginInstallFrame.Option3.Pic = path .. "preview\\CDTL2.tga"
			PluginInstallFrame.Option4:Show()
			PluginInstallFrame.Option4:SetScript("OnClick", function()
				SpectraUI:AddOnSkins()
			end)
			PluginInstallFrame.Option4:SetText("AddOnSkins")
			PluginInstallFrame.Option4.Pic = path .. "preview\\AddOnSkins.tga"
		end,
		[5] = function()
			Resize()
			ResetPic()
			PluginInstallFrame.SubTitle:SetText("AddOns 2")
			PluginInstallFrame.Desc1:SetText("These are the profiles that are available. Please click a button below to apply the profile for the AddOn.")
			--PluginInstallFrame.Desc2:SetText("Importance: |CFF9BFF30Low|r")

			PluginInstallFrame.Option1:Show()
			PluginInstallFrame.Option1:SetScript("OnClick", function()
				SpectraUI:BigWigs()
			end)
			PluginInstallFrame.Option1:SetText("BigWigs")
			PluginInstallFrame.Option1.Pic = path .. "preview\\BigWigs.tga"


			PluginInstallFrame.Option2:Show()
			PluginInstallFrame.Option2:SetScript("OnClick", function()
				SpectraUI:CooldownToGo()
			end)
			PluginInstallFrame.Option2:SetText("Cooldown To Go")
			PluginInstallFrame.Option2.Pic = path .. "preview\\CooldownToGo.tga"

			PluginInstallFrame.Option3:Show()
			PluginInstallFrame.Option3:SetScript("OnClick", function()
				SpectraUI:OmniCD()
			end)
			PluginInstallFrame.Option3:SetText("OmniCD")
			PluginInstallFrame.Option3.Pic = path .. "preview\\OmniCD.tga"
		end,
		[6] = function()
			Resize()
			ResetPic()
			PluginInstallFrame.SubTitle:SetText("Blizzard")
			PluginInstallFrame.Desc1:SetText("On Retail, you can now copy and import the Blizzard interface profile.")
			--PluginInstallFrame.Desc2:SetText("Importance: |CFFF63939High|r")

			PluginInstallFrame.Option1:Show()
			PluginInstallFrame.Option1:SetScript("OnClick", function()
				E:StaticPopup_Show(
					"SPECTRAUI_EDITBOX",
					nil,
					nil,
					"1 39 0 0 1 7 7 UIParent 0.0 45.0 -1 ##$$%/&('%)#+#,$ 0 1 1 7 7 UIParent 0.0 45.0 -1 ##$$%/&('%(#,$ 0 2 1 7 7 UIParent 0.0 45.0 -1 ##$$%/&('%(#,$ 0 3 1 5 5 UIParent -5.0 -77.0 -1 #$$$%/&('%(#,$ 0 4 1 5 5 UIParent -5.0 -77.0 -1 #$$$%/&('%(#,$ 0 5 1 1 4 UIParent 0.0 0.0 -1 ##$$%/&('%(#,$ 0 6 1 1 4 UIParent 0.0 -50.0 -1 ##$$%/&('%(#,$ 0 7 1 1 4 UIParent 0.0 -100.0 -1 ##$$%/&('%(#,$ 0 10 1 7 7 UIParent 0.0 45.0 -1 ##$$&('% 0 11 1 7 7 UIParent 0.0 45.0 -1 ##$$&('%,# 0 12 1 7 7 UIParent 0.0 45.0 -1 ##$$&('% 1 -1 1 4 4 UIParent 0.0 0.0 -1 ##$#%# 2 -1 1 2 2 UIParent 0.0 0.0 -1 ##$#%( 3 0 1 8 7 UIParent -300.0 250.0 -1 $#3# 3 1 1 6 7 UIParent 300.0 250.0 -1 %#3# 3 2 1 6 7 UIParent 520.0 265.0 -1 %#&#3# 3 3 1 0 2 CompactRaidFrameManager 0.0 -7.0 -1 '#(#)#-#.#/#1$3# 3 4 1 0 2 CompactRaidFrameManager 0.0 -5.0 -1 ,#-#.#/#0#1#2( 3 5 1 5 5 UIParent 0.0 0.0 -1 &#*$3# 3 6 1 5 5 UIParent 0.0 0.0 -1 -#.#/#4$ 3 7 1 4 4 UIParent 0.0 0.0 -1 3# 4 -1 1 7 7 UIParent 0.0 45.0 -1 # 5 -1 1 7 7 UIParent 0.0 45.0 -1 # 6 0 1 2 2 UIParent -255.0 -10.0 -1 ##$#%#&.(()( 6 1 1 2 2 UIParent -270.0 -155.0 -1 ##$#%#'+(()( 7 -1 1 7 7 UIParent 0.0 45.0 -1 # 8 -1 0 6 6 UIParent 35.0 50.0 -1 #'$A%$&7 9 -1 1 7 7 UIParent 0.0 45.0 -1 # 10 -1 1 0 0 UIParent 16.0 -116.0 -1 # 11 -1 1 8 8 UIParent -9.0 85.0 -1 # 12 -1 1 2 2 UIParent -110.0 -275.0 -1 #K$#%# 13 -1 1 8 8 MicroButtonAndBagsBar 0.0 0.0 -1 ##$#%)&- 14 -1 1 2 2 MicroButtonAndBagsBar 0.0 10.0 -1 ##$#%( 15 0 1 7 7 StatusTrackingBarManager 0.0 0.0 -1 # 15 1 1 7 7 StatusTrackingBarManager 0.0 17.0 -1 # 16 -1 1 5 5 UIParent 0.0 0.0 -1 #( 17 -1 1 1 1 UIParent 0.0 -100.0 -1 ## 18 -1 1 5 5 UIParent 0.0 0.0 -1 #- 19 -1 1 7 7 UIParent 0.0 0.0 -1 ##"
				)
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
			PluginInstallFrame.Desc1:SetText("|CFF03FA6EThe installation process is now complete!|r")
			PluginInstallFrame.Desc2:SetText(
				"Click the button below to finalize everything and automatically reload your interface. If you run into any questions or issues, feel free to join our |TInterface\\AddOns\\SpectraUI\\media\\discord_logo.tga:14:14|t  |CFF03FA6EDiscord|r for assistance!"
			)

			PluginInstallFrame.Option1:Show()
			PluginInstallFrame.Option1:SetScript("OnClick", InstallComplete)
			PluginInstallFrame.Option1:SetText("Finished")

			-- button 2 DC start
			PluginInstallFrame.Option2:Show()
			PluginInstallFrame.Option2:SetScript("OnClick", function()
				E:StaticPopup_Show("SPECTRAUI_EDITBOX", nil, nil, "https://discord.gg/gfGrNrER3K")
			end)
			PluginInstallFrame.Option2:SetText(dicordLogo .. " " .. "Discord")
			--PluginInstallFrame.Option2.Pic = path .. "preview\\Profile.tga"
			-- button 2 end

			PluginInstallFrame.Option3:Hide()
			PluginInstallFrame.Option4:Hide()
		end,
	},
	StepTitles = {
		[1] = "Welcome",
		[2] = "ElvUI",
		[3] = "Weakauras",
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
-- default settings db for the addon
P[MyPluginName] = {
	portraitsOffset = 5, -- Portrait zoom offest, default setting
}

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
					spacer1 = {
						order = 2,
						type = "description",
						name = "\n",
					},
					discord = {
						order = 3,
						type = "execute",
						name = L["Discord"],
						func = function()
							E:StaticPopup_Show("SPECTRAUI_EDITBOX", nil, nil, "https://discord.gg/gfGrNrER3K")
						end,
					},
				},
			},
			install = {
				order = 3,
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
			wa = {
				order = 4,
				type = "group",
				inline = true,
				name = L["Weakauras"],
				args = {
					frames = {
						order = 1,
						type = "execute",
						name = L["Frames"],
						func = function()
							E:StaticPopup_Show("SPECTRAUI_EDITBOX", nil, nil, "https://wago.io/Kqz6loIke")
						end,
					},
					elements = {
						order = 2,
						type = "execute",
						name = L["Theme Elements"],
						func = function()
							E:StaticPopup_Show("SPECTRAUI_EDITBOX", nil, nil, "https://wago.io/MBm1s8QQa")
						end,
					},
				},
			},
			settings = {
				order = 5,
				type = "group",
				inline = true,
				name = L["Settings"],
				args = {
					range_sq = {
						order = 1,
						name = L["Portraits offset"],
						type = "range",
						min = 0,
						max = 10,
						step = 0.1,
						disabled = function()
							return not IsAddOnLoaded("ElvUI_mMediaTag")
						end,
						get = function(info)
							return E.db[MyPluginName].portraitsOffset
						end,
						set = function(info, value)
							E.db[MyPluginName].portraitsOffset = value
							SpectraUI:AddPortraitsTextures()
							mMT.Modules.Portraits:Initialize()
						end,
					},
				},
			},
			thankyou = {
				order = 6,
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
			donators = {
				order = 7,
				type = "group",
				inline = true,
				name = L["Donators"],
				args = {
					desc = {
						order = 1,
						type = "description",
						fontSize = "medium",
						name = DONATORS_STRING,
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

	SpectraUI:AddPortraitsTextures()

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
	if E.private.install_complete and E.db[MyPluginName].install_version == nil then PI:Queue(InstallerData) end

	-- add textures to mMT
	SpectraUI:Setup_mMediaTag()
	SpectraUI:SetupDetails()

	-- Insert our options table when ElvUI config is loaded
	EP:RegisterPlugin(addon, InsertOptions)
end

-- Register module with callback so it gets initialized when ready
E:RegisterModule(SpectraUI:GetName())
