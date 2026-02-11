-- ElvUI references
local E = unpack(ElvUI)
local L = SpectraUI.Locales

-- Lua
local tinsert = tinsert
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
				return SpectraUI.Media.logo, 307, 154
			end,
		},

		-- GENERAL TAB (LANDING PAGE)
		general = {
			order = 2,
			type = "group",
			name = L["General"],
			args = {
				-- DESCRIPTION
				descriptionGroup = {
					order = 1,
					type = "group",
					inline = true,
					name = L["Description"],
					args = {
						desc = {
							order = 1,
							type = "description",
							fontSize = "medium",
							name = SpectraUI.Name .. " is a layout for ElvUI.",
						},
						spacer = {
							order = 2,
							type = "description",
							name = "\n",
						},
						status = {
							order = 3,
							type = "execute",
							name = L["Status Report"],
							func = function()
								E:ToggleOptions()
	                            SpectraUI:GetModule("StatusReport"):ToggleStatusReport()
							end,
						},
					},
				},

				-- INSTALLATION GUIDE
				installGroup = {
					order = 2,
					type = "group",
					inline = true,
					name = L["Installation Guide"],
					args = {
						desc = {
							order = 1,
							type = "description",
							fontSize = "medium",
							name = L["The installation guide will walk you through the recommended setup for SpectraUI. You can re-run it at any time."],
						},
						spacer = {
							order = 2,
							type = "description",
							name = "\n",
						},
						install = {
							order = 3,
							type = "execute",
							name = L["Open Installer"],
							func = function()
								SpectraUI:RunInstaller()
								E:ToggleOptions()
							end,
						},
					},
				},

				-- CREDITS
				creditsGroup = {
					order = 3,
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

				-- SUPPORTERS
				supportersGroup = {
					order = 4,
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
