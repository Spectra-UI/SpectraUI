-- Create references to ElvUI internals
local E = unpack(ElvUI)
local L = SpectraUI.Locales
-- dont touch this ^

-- Variables & Cache Lua / WoW API
local tinsert = tinsert
local tconcat = _G.table.concat

-- Build the Credits & Donator String
local CREDITS_STRING = tconcat(SpectraUI.CREDITS, "|n")
local DONATORS_STRING = tconcat(SpectraUI.DONATORS, "|n")

-- Plugin Settings table
local function OptionsTable()
	E.Options.args.SpectraUI = {
		order = 100,
		type = "group",
		name = SpectraUI.Media.icon .. " " .. SpectraUI.Name,
		args = {
			logo = {
				type = "description",
				name = "",
				order = 1,
				image = function()
					return SpectraUI.Media.logo, 307, 154
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
						name = format(L["%s is a layout for ElvUI."], SpectraUI.Name),
					},
					spacer1 = {
						order = 2,
						type = "description",
						name = "\n",
					},
					discord = {
						order = 3,
						type = "execute",
						name = SpectraUI.Media.discordLogo .. " " .. "Discord",
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
						name = L["The installation guide should pop up automatically after you have completed the ElvUI installation. If you wish to re-run the installation process for this layout then please click the button below."],
					},
					spacer2 = {
						order = 2,
						type = "description",
						name = "",
					},
					install = {
						order = 3,
						type = "execute",
						name = L["Install"],
						desc = L["Run the installation process."],
						func = function()
							SpectraUI:RunInstaller()
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
						name = L["UI Elements"],
						func = function()
							E:StaticPopup_Show(
							"SPECTRAUI_EDITBOX",
								nil,
								nil,
								E.Retail and SpectraUI.Links.WA.retail or SpectraUI.Links.WA.classic
							)
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
					playerPortrait = {
						order = 1,
						type = "toggle",
						name = L["Player Portrait Hide"],
						desc = L["Hides the player portrait if a target exists."],
						get = function(info)
							return E.db.SpectraUI.playerPortraitHide
						end,
						set = function(info, value)
							E.db.SpectraUI.playerPortraitHide = value
							SpectraUI:PlayerPortrait()
						end,
					},
				},
			},
			embedded = {
				order = 6,
				type = "group",
				inline = true,
				name = L["Details Embedded"],
				args = {
					style = {
						order = 1,
						type = "select",
						name = L["Embedded Style"],
						get = function(info)
							return E.db.SpectraUI.detailsEmbedded.style
						end,
						set = function(info, value)
							E.db.SpectraUI.detailsEmbedded.style = value
							E:StaticPopup_Show("CONFIG_RL")
						end,
						values = {
							DISABLE = L["DISABLE"],
							one = L["One"],
							two_side = L["Two side by side"],
							two_top = L["Two on top of each other"],
						},
					},
					chat = {
						order = 2,
						type = "select",
						name = L["Embedded to Chat"],
						disabled = function() return E.db.SpectraUI.detailsEmbedded.style == "DISABLE" end,
						get = function(info)
							return E.db.SpectraUI.detailsEmbedded.chatEmbedded
						end,
						set = function(info, value)
							E.db.SpectraUI.detailsEmbedded.chatEmbedded = value
							E:StaticPopup_Show("CONFIG_RL")
						end,
						values = {
							LeftChat = L["Left Chat"],
							RightChat = L["Right Chat"],
						},
					},
				},
			},
			thankyou = {
				order = 7,
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

-- add the settings to our main table
tinsert(SpectraUI.Options, OptionsTable)
