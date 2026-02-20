local E = unpack(ElvUI)
local L = SpectraUI.Locales

-- Lua
local tconcat = _G.table.concat

-- Credits / Supporters strings
local CREDITS_STRING = tconcat(SpectraUI.CREDITS or {}, "|n")
local DONATORS_STRING = tconcat(SpectraUI.DONATORS or {}, "|n")

-- Options Table
SpectraUI.options = {
    type = "group",
    name = SpectraUI.Media.icon .. " " .. SpectraUI.Name,
    args = {

        -- Header LOGO
        logo = {
            order = 1,
            type = "description",
            name = "",
            image = function() return SpectraUI.Media.logo, 250, 125 end
        },

        -- DASHBOARD TAB
        dashboard = {
            order = 2,
            type = "group",
            name = L["Dashboard"],
            args = {

                -- Status Banner
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
                                local ok, mod =
                                    pcall(SpectraUI.GetModule, SpectraUI,
                                          "Status")
                                if ok and mod and mod.GetSummary then
                                    return mod:GetSummary()
                                end
                                return (SpectraUI.Name or "SpectraUI") ..
                                           " | UI Scale Match: ? | Resolution: ?"
                            end
                        }
                    }
                },

                statusSpacer = {order = 2, type = "description", name = "\n"},

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
                            name = "Spectra|cff2ab6ffUI|r is an |cff1784d1ElvUI|r plugin that delivers a complete UI overhaul built around clarity, consistency, and performance. It features two dedicated layouts |cffD96C3ADPS/Tank|r & |cff57ff75Healer|r. Includes an enhanced custom installer for a streamlined setup experience. Spectra|cff2ab6ffUI|r is currently designed and supported for (QHD) 1440p displays."
                        },
                        spacer = {order = 2, type = "description", name = "\n"},
                        openStatus = {
                            order = 3,
                            type = "execute",
                            name = SpectraUI.Color.ui.hex .. L["Status Report"] ..
                                "|r",
                            func = function()
                                E:ToggleOptions()
                                SpectraUI:GetModule("StatusReport")
                                    :ToggleStatusReport()
                            end
                        }
                    }
                },

                overviewSpacer = {order = 4, type = "description", name = "\n"},

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
                            name = L["The installation guide will walk you through the recommended setup for Spectra|cff2ab6ffUI|r. You can re-run it at any time."]
                        },
                        spacer = {order = 2, type = "description", name = "\n"},
                        install = {
                            order = 3,
                            type = "execute",
                            name = SpectraUI.Color.ui.hex .. L["Install"],
                            func = function()
                                SpectraUI:RunInstaller()
                                E:ToggleOptions()
                            end
                        }
                    }
                },

                installSpacer = {order = 6, type = "description", name = "\n"},

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
                            name = "Need help, want to report an issue, or stay up to date with Spectra|cff2ab6ffUI|r development? Join the community on |cff7289daDiscord|r."
                        },
                        spacer = {order = 2, type = "description", name = "\n"},
                        openDiscord = {
                            order = 3,
                            type = "execute",
                            name = L["|cff7289daDiscord|r"],
                            func = function()
                                E:StaticPopup_Show("SPECTRAUI_EDITBOX", nil,
                                                   nil, SpectraUI.Links.Discord)
                            end
                        }
                    }
                },

                supportSpacer = {order = 8, type = "description", name = "\n"},

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
                            name = CREDITS_STRING ~= "" and CREDITS_STRING or
                                "—"
                        }
                    }
                },

                creditsSpacer = {order = 10, type = "description", name = "\n"},

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
                            name = DONATORS_STRING ~= "" and DONATORS_STRING or
                                "—"
                        }
                    }
                }
            }
        },

        armory = {
            order = 3,
            type = "group",
            name = L["Armory"],
            childGroups = "tab",
            args = {

                geartracker = {
                    order = 1,
                    type = "group",
                    name = "GearTracker",
                    childGroups = "tab",
                    args = {

                        -- TRACKING TAB
                        tracking = {
                            order = 1,
                            type = "group",
                            name = L["Tracking"],
                            args = {

                                -- Description Box
                                descBox = {
                                    order = 1,
                                    type = "group",
                                    inline = true,
                                    name = L["Tracking"],
                                    args = {
                                        desc = {
                                            order = 1,
                                            type = "description",
                                            fontSize = "medium",
                                            name = "Choose which specialization to track and optionally override individual gear slots."
                                        }
                                    }
                                },

                                spacer1 = {
                                    order = 2,
                                    type = "description",
                                    name = "\n",
                                    width = "full"
                                },

                                -- Spec Select
                                specSelect = {
                                    order = 5,
                                    type = "select",
                                    name = "Tracked Specialization",
                                    width = "full",
                                    values = {}
                                },

                                specStatus = {
                                    order = 6,
                                    type = "description",
                                    width = "full",
                                    name = ""
                                },

                                spacer3 = {
                                    order = 7,
                                    type = "description",
                                    name = "\n",
                                    width = "full"
                                },

                                -- Gear Slots
                                slots = {
                                    order = 8,
                                    type = "group",
                                    inline = true,
                                    name = "Gear Slots",
                                    args = {
                                        head = {
                                            order = 1,
                                            type = "input",
                                            name = "Head",
                                            width = "full"
                                        },
                                        neck = {
                                            order = 2,
                                            type = "input",
                                            name = "Neck",
                                            width = "full"
                                        },
                                        shoulder = {
                                            order = 3,
                                            type = "input",
                                            name = "Shoulder",
                                            width = "full"
                                        },
                                        back = {
                                            order = 4,
                                            type = "input",
                                            name = "Back",
                                            width = "full"
                                        },
                                        chest = {
                                            order = 5,
                                            type = "input",
                                            name = "Chest",
                                            width = "full"
                                        },
                                        wrist = {
                                            order = 6,
                                            type = "input",
                                            name = "Wrist",
                                            width = "full"
                                        },
                                        hands = {
                                            order = 7,
                                            type = "input",
                                            name = "Hands",
                                            width = "full"
                                        },
                                        waist = {
                                            order = 8,
                                            type = "input",
                                            name = "Waist",
                                            width = "full"
                                        },
                                        legs = {
                                            order = 9,
                                            type = "input",
                                            name = "Legs",
                                            width = "full"
                                        },
                                        boots = {
                                            order = 10,
                                            type = "input",
                                            name = "Boots",
                                            width = "full"
                                        },
                                        finger1 = {
                                            order = 11,
                                            type = "input",
                                            name = "Finger 1",
                                            width = "full"
                                        },
                                        finger2 = {
                                            order = 12,
                                            type = "input",
                                            name = "Finger 2",
                                            width = "full"
                                        },
                                        trinket1 = {
                                            order = 13,
                                            type = "input",
                                            name = "Trinket 1",
                                            width = "full"
                                        },
                                        trinket2 = {
                                            order = 14,
                                            type = "input",
                                            name = "Trinket 2",
                                            width = "full"
                                        },
                                        mainhand = {
                                            order = 15,
                                            type = "input",
                                            name = "Main Hand",
                                            width = "full"
                                        },
                                        offhand = {
                                            order = 16,
                                            type = "input",
                                            name = "Off Hand",
                                            width = "full"
                                        },
                                        ranged = {
                                            order = 17,
                                            type = "input",
                                            name = "Ranged",
                                            width = "full"
                                        }
                                    }
                                },

                                spacer4 = {
                                    order = 9,
                                    type = "description",
                                    name = "\n",
                                    width = "full"
                                },

                                reset = {
                                    order = 10,
                                    type = "execute",
                                    name = "Reset to Preset",
                                    width = "full",
                                    func = function() end
                                }
                            }
                        },

                        -- IMPORT TAB
                        import = {
                            order = 2,
                            type = "group",
                            name = L["Import"],
                            args = {

                                descBox = {
                                    order = 1,
                                    type = "group",
                                    inline = true,
                                    name = L["Import"],
                                    args = {
                                        desc = {
                                            order = 1,
                                            type = "description",
                                            fontSize = "medium",
                                            name = "Import a gear profile from WoWSims. This will populate your tracked gear slots automatically.\n\n|cffffcc00Important:|r The import string must be a valid |cff2ab6ffWoWSims JSON export|r."
                                        }
                                    }
                                },

                                spacer = {
                                    order = 2,
                                    type = "description",
                                    name = "\n",
                                    width = "full"
                                },

                                importBox = {
                                    order = 3,
                                    type = "input",
                                    multiline = 18,
                                    width = "full",
                                    dialogControl = "MultiLineEditBox",
                                    name = "Paste WoWSims Export String",
                                    get = function()
                                        local GT =
                                            SpectraUI:GetModule("GearTracker")
                                        local db = GT:GetDB()
                                        return db.importBuffer or ""
                                    end,
                                    set = function(_, v)
                                        local GT =
                                            SpectraUI:GetModule("GearTracker")
                                        local db = GT:GetDB()
                                        db.importBuffer = v or ""
                                    end
                                },

                                importButton = {
                                    order = 4,
                                    type = "execute",
                                    name = "Import",
                                    func = function()
                                        local GT =
                                            SpectraUI:GetModule("GearTracker")
                                        local db = GT:GetDB()

                                        if not GT or not GT.DoImport then
                                            SpectraUI:Print(
                                                "|cffff3333GearTracker: Import function missing.|r")
                                            return
                                        end

                                        GT:DoImport(db.importBuffer)
                                    end
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

-- Inject GearTracker module options (DO NOT TOUCH DASHBOARD)
if SpectraUI.InjectGearTrackerOptions then SpectraUI:InjectGearTrackerOptions() end
