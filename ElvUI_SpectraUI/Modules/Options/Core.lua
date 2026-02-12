-- ElvUI references
local E = unpack(ElvUI)
local L = SpectraUI.Locales

-- Lua
local tconcat = _G.table.concat

-- Credits / Supporters strings
local CREDITS_STRING = tconcat(SpectraUI.CREDITS or {}, "|n")
local DONATORS_STRING = tconcat(SpectraUI.DONATORS or {}, "|n")

-- OPTIONS TABLE
SpectraUI.options = {
	type = "group",
	name = SpectraUI.Media.icon .. " " .. SpectraUI.Name,
	args = {

		-- HEADER LOGO
		logo = {
			order = 1,
			type = "description",
			name = "",
			image = function()
				return SpectraUI.Media.logo, 250, 125
			end,
		},

		-- DASHBOARD TAB
		dashboard = {
			order = 2,
			type = "group",
			name = L["Dashboard"],
			args = {

				-- STATUS BANNER
				statusStrip = {
					order = 1,
					type = "group",
					inline = true,
					name = "",
					args = {
						statusLine = {
							order = 1,
							type = "header",
							name = function()
								local ok, mod = pcall(SpectraUI.GetModule, SpectraUI, "Status")
								if ok and mod and mod.GetSummary then
									return mod:GetSummary()
								end
								-- Safe fallback if module isn't loaded yet
								return (SpectraUI.Name or "SpectraUI") .. " | UI Scale Match: ? | Resolution: ?"
							end,
						},
					},
				},

				-- VISUAL RESET BETWEEN BANNER AND CONTENT
				statusSpacer = {
					order = 2,
					type = "description",
					name = "\n",
				},

				-- OVERVIEW
				overviewGroup = {
					order = 3,
					type = "group",
					inline = true,
					name = L["Overview"],
					args = {

						desc = {
							order = 1,
							type = "description",
							fontSize = "medium",
							name = "Spectra|cff2ab6ffUI|r is an |cff1784d1ElvUI|r plugin that delivers a complete UI overhaul built around clarity, consistency, and performance. It features two dedicated layouts |cffD96C3ADPS/Tank|r & |cff57ff75Healer|r. Includes an enhanced custom installer for a streamlined setup experience. Spectra|cff2ab6ffUI|r is currently designed and supported for (QHD) 1440p displays.",
						},

						spacer = {
							order = 2,
							type = "description",
							name = "\n",
						},

						openStatus = {
							order = 3,
							type = "execute",
							name = SpectraUI.Color.ui.hex .. L["Status Report"] .. "|r",
							func = function()
								E:ToggleOptions()
								SpectraUI:GetModule("StatusReport"):ToggleStatusReport()
							end,
						},
					},
				},

				-- SPACE AFTER OVERVIEW
				overviewSpacer = {
					order = 4,
					type = "description",
					name = "\n",
				},

				-- INSTALLATION GUIDE
				installGroup = {
					order = 5,
					type = "group",
					inline = true,
					name = L["Installation Guide"],
					args = {
						desc = {
							order = 1,
							type = "description",
							fontSize = "medium",
							name = L["The installation guide will walk you through the recommended setup for Spectra|cff2ab6ffUI|r. You can re-run it at any time."],
						},
						spacer = {
							order = 2,
							type = "description",
							name = "\n",
						},
						install = {
							order = 3,
							type = "execute",
							name = SpectraUI.Color.ui.hex .. L["Install"],
							func = function()
								SpectraUI:RunInstaller()
								E:ToggleOptions()
							end,
						},
					},
				},

				-- SPACE AFTER INSTALLER
				installSpacer = {
					order = 6,
					type = "description",
					name = "\n",
				},

				-- SUPPORT
				supportGroup = {
					order = 7,
					type = "group",
					inline = true,
					name = L["Support"],
					args = {

						desc = {
							order = 1,
							type = "description",
							fontSize = "medium",
							name = "Need help, want to report an issue, or stay up to date with Spectra|cff2ab6ffUI|r development? Join the community on |cff7289daDiscord|r.",
						},

						spacer = {
							order = 2,
							type = "description",
							name = "\n",
						},

						openDiscord = {
							order = 3,
							type = "execute",
							name = L["|cff7289daDiscord|r"],
							func = function()
								E:StaticPopup_Show("SPECTRAUI_EDITBOX", nil, nil, SpectraUI.Links.Discord)
							end,
						},
					},
				},

				-- SPACE AFTER SUPPORT
				supportSpacer = {
					order = 8,
					type = "description",
					name = "\n",
				},

				-- CREDITS
				creditsGroup = {
					order = 9,
					type = "group",
					inline = true,
					name = L["Credits"],
					args = {
						desc = {
							order = 1,
							type = "description",
							fontSize = "medium",
							name = CREDITS_STRING ~= "" and CREDITS_STRING or "—",
						},
					},
				},

				-- SPACE AFTER CREDITS
				creditsSpacer = {
					order = 10,
					type = "description",
					name = "\n",
				},

				-- SUPPORTERS
				supportersGroup = {
					order = 11,
					type = "group",
					inline = true,
					name = L["Supporters"],
					args = {
						desc = {
							order = 1,
							type = "description",
							fontSize = "medium",
							name = DONATORS_STRING ~= "" and DONATORS_STRING or "—",
						},
					},
				},
			},
		},
	},
}
