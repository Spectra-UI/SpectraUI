local E, L, V, P, G = unpack(ElvUI)
local IsAddOnLoaded = _G.C_AddOns and _G.C_AddOns.IsAddOnLoaded or _G.IsAddOnLoaded

-- SylingTracker profile setup
function SpectraUI:SylingTracker()
	if not IsAddOnLoaded("SylingTracker") then
		return
	end

	SylingTrackerDB = {
		["uiSettings"] = {
			["activities.header.label.textColor"] = {
				["a"] = 1,
				["b"] = 0.1411764770746231,
				["g"] = 0.4313725829124451,
				["r"] = 1,
			},
			["task.name.mediaFont"] = {
				["height"] = 12,
				["font"] = "SpectraUI Title",
				["outline"] = "NONE",
			},
			["activities.header.label.mediaFont"] = {
				["height"] = 15,
				["font"] = "SpectraUI Title",
				["outline"] = "NONE",
			},
			["tasks.header.showBorder"] = false,
			["professionRecipe.name.mediaFont"] = {
				["height"] = 12,
				["font"] = "SpectraUI Title",
				["outline"] = "NONE",
			},
			["collections.header.borderColor"] = {
				["a"] = 1,
				["r"] = 0.6941176652908325,
				["g"] = 0.3098039329051971,
				["b"] = 1,
			},
			["activities.header.showBackground"] = false,
			["achievement.name.mediaFont"] = {
				["height"] = 15,
				["font"] = "SpectraUI Title",
				["outline"] = "NONE",
			},
			["scenario.name.textColor"] = {
				["a"] = 1,
				["r"] = 1,
				["g"] = 1,
				["b"] = 1,
			},
			["questCategory.name.font"] = {
				["height"] = 15,
				["font"] = "SpectraUI Title",
				["outline"] = "NONE",
			},
			["scenario.stageCounter.mediaFont"] = {
				["height"] = 12,
				["font"] = "KMT-GothamXN_Ultra",
				["outline"] = "NONE",
			},
			["quests.header.label.textColor"] = {
				["a"] = 1,
				["r"] = 1,
				["g"] = 0.8196079134941101,
				["b"] = 0,
			},
			["quest.name.mediaFont"] = {
				["outline"] = "NONE",
				["font"] = "SpectraUI Title",
				["height"] = 12,
			},
			["quest.enablePOI"] = false,
			["achievement.backgroundColor"] = {
				["a"] = 0.5,
				["b"] = 0.1607843190431595,
				["g"] = 0.1607843190431595,
				["r"] = 0.1607843190431595,
			},
			["quests.header.showBorder"] = false,
			["dungeonQuest.backgroundColor"] = {
				["a"] = 0.73,
				["r"] = 0,
				["g"] = 0.2823529411764706,
				["b"] = 0.4862745098039216,
			},
			["dungeon.name.textColor"] = {
				["a"] = 1,
				["r"] = 1,
				["g"] = 1,
				["b"] = 1,
			},
			["scenario.header.showBackground"] = false,
			["tasks.header.backgroundColor"] = {
				["a"] = 0.5,
				["b"] = 0.1607843190431595,
				["g"] = 0.1607843190431595,
				["r"] = 0.1607843190431595,
			},
			["quest.showBorder"] = false,
			["task.showBackground"] = false,
			["task.showBorder"] = false,
			["collections.showHeader"] = true,
			["dungeon.header.showBackground"] = false,
			["scenario.stageName.textTransform"] = "NONE",
			["profession.header.label.mediaFont"] = {
				["outline"] = "NONE",
				["font"] = "SpectraUI Title",
				["height"] = 15,
			},
			["scenario.name.mediaFont"] = {
				["height"] = 15,
				["font"] = "SpectraUI Title",
				["outline"] = "NONE",
			},
			["objective.failed.text.textColor"] = {
				["a"] = 1,
				["r"] = 0.7803922295570374,
				["g"] = 0.250980406999588,
				["b"] = 0.250980406999588,
			},
			["questCategory.name.textTransform"] = "NONE",
			["scenario.header.label.mediaFont"] = {
				["height"] = 12,
				["font"] = "SpectraUI Title",
				["outline"] = "NONE",
			},
			["achievements.header.label.textColor"] = {
				["a"] = 1,
				["b"] = 0.1411764770746231,
				["g"] = 0.4313725829124451,
				["r"] = 1,
			},
			["achievement.borderColor"] = {
				["a"] = 0.4062507152557373,
				["b"] = 0,
				["g"] = 0,
				["r"] = 0,
			},
			["collectable.name.mediaFont"] = {
				["height"] = 12,
				["font"] = "SpectraUI Title",
				["outline"] = "NONE",
			},
			["achievements.header.backgroundColor"] = {
				["a"] = 0.5,
				["b"] = 0.1607843190431595,
				["g"] = 0.1607843190431595,
				["r"] = 0.1607843190431595,
			},
			["quests.header.backgroundColor"] = {
				["a"] = 0,
				["b"] = 0.1607843190431595,
				["g"] = 0.1607843190431595,
				["r"] = 0.1607843190431595,
			},
			["dungeon.header.backgroundColor"] = {
				["a"] = 0.5,
				["r"] = 0.1607843190431595,
				["g"] = 0.1607843190431595,
				["b"] = 0.1607843190431595,
			},
			["quest.showBackground"] = false,
			["quests.showCategories"] = false,
			["dungeon.header.showBorder"] = false,
			["activity.showBackground"] = false,
			["achievements.header.label.mediaFont"] = {
				["outline"] = "NONE",
				["font"] = "SpectraUI Title",
				["height"] = 12,
			},
			["objective.completed.text.textColor"] = {
				["a"] = 1,
				["r"] = 0.2901960909366608,
				["g"] = 0.6901960968971252,
				["b"] = 0.3019607961177826,
			},
			["collections.header.showBorder"] = false,
			["activities.showHeader"] = true,
			["tasks.showHeader"] = true,
			["profession.showHeader"] = true,
			["tasks.header.showBackground"] = false,
			["profession.header.label.textColor"] = {
				["a"] = 1,
				["b"] = 0.1411764770746231,
				["g"] = 0.4313725829124451,
				["r"] = 1,
			},
			["tasks.header.label.mediaFont"] = {
				["height"] = 15,
				["font"] = "GothamXNarrow Black",
				["outline"] = "NONE",
			},
			["collections.header.showBackground"] = false,
			["quests.header.label.mediaFont"] = {
				["height"] = 15,
				["font"] = "SpectraUI Title",
				["outline"] = "NONE",
			},
			["activities.header.showBorder"] = false,
			["collectable.showBorder"] = false,
			["quests.header.showBackground"] = true,
			["collectable.showBackground"] = false,
			["collections.header.label.textColor"] = {
				["a"] = 1,
				["b"] = 1,
				["g"] = 0.7098039388656616,
				["r"] = 0.1803921610116959,
			},
			["dungeon.showHeader"] = false,
			["scenario.showHeader"] = false,
			["scenario.stageName.mediaFont"] = {
				["height"] = 12,
				["font"] = "SpectraUI Title",
				["outline"] = "NONE",
			},
			["objective.progress.text.textColor"] = {
				["a"] = 1,
				["r"] = 1,
				["g"] = 1,
				["b"] = 1,
			},
			["scenario.header.showBorder"] = false,
			["quests.showHeader"] = true,
			["activity.showBorder"] = false,
			["objective.text.mediaFont"] = {
				["outline"] = "NONE",
				["font"] = "SpectraUI Caption",
				["height"] = 12,
			},
			["dungeon.header.label.mediaFont"] = {
				["outline"] = "NONE",
				["font"] = "SpectraUI Title",
				["height"] = 15,
			},
			["quest.level.mediaFont"] = {
				["outline"] = "NONE",
				["font"] = "SpectraUI Title",
				["height"] = 12,
			},
			["activity.name.mediaFont"] = {
				["height"] = 12,
				["font"] = "SpectraUI Title",
				["outline"] = "NONE",
			},
			["collections.header.label.mediaFont"] = {
				["height"] = 15,
				["font"] = "SpectraUI Title",
				["outline"] = "NONE",
			},
			["tasks.header.label.textColor"] = {
				["a"] = 1,
				["b"] = 0.1411764770746231,
				["g"] = 0.4313725829124451,
				["r"] = 1,
			},
			["dungeon.name.mediaFont"] = {
				["height"] = 15,
				["font"] = "SpectraUI Title",
				["outline"] = "NONE",
			},
			["achievements.showHeader"] = true,
			["legendaryQuest.backgroundColor"] = {
				["a"] = 0.6015626192092896,
				["r"] = 0.1607843190431595,
				["g"] = 0.1607843190431595,
				["b"] = 0.1607843190431595,
			},
			["quest.backgroundColor"] = {
				["a"] = 0.5,
				["r"] = 0.1607843190431595,
				["g"] = 0.1607843190431595,
				["b"] = 0.1607843190431595,
			},
			["scenario.header.label.textColor"] = {
				["a"] = 1,
				["b"] = 1,
				["g"] = 0.71,
				["r"] = 0.18,
			},
		},
		["trackers"] = {
			["main"] = {
				["scrollBarPositionOffsetX"] = 9,
				["size"] = {
					["height"] = 197,
					["width"] = 280,
				},
				["scrollBarThumbColor"] = {
					["a"] = 1,
					["r"] = 0.1803921610116959,
					["g"] = 0.7098039388656616,
					["b"] = 1,
				},
				["backgroundColor"] = {
					["a"] = 0.5,
					["b"] = 0.1607843190431595,
					["g"] = 0.1607843190431595,
					["r"] = 0.1607843190431595,
				},
				["scrollBarPosition"] = "LEFT",
				["showBorder"] = true,
				["visibilityRules"] = {
					["hideWhenEmpty"] = false,
				},
				["showBackground"] = true,
				["position"] = {
					["y"] = -25,
					["x"] = 23,
				},
				["locked"] = true,
				["relativePositionAnchor"] = "TOPLEFT",
				["showScrollBar"] = false,
				["showMinimizeButton"] = false,
			},
		},
		["settings"] = {
			["showMinimapIcon"] = false,
			["showBlizzardObjectiveTracker"] = false,
		},
		["itemBar"] = {
			["marginBottom"] = 0,
			["elementWidth"] = 18,
			["marginLeft"] = 0,
			["enabled"] = false,
			["position"] = {
				["y"] = 1072.000122070313,
				["x"] = 315.0008544921875,
			},
			["marginRight"] = 0,
			["columnCount"] = 5,
			["marginTop"] = 0,
			["elementHeight"] = 18,
		},
		["dbVersion"] = 2,
		["minimap"] = {
			["minimapPos"] = 161.1796170893932,
			["hide"] = true,
		},
	}

	SpectraUI:Print("|CFFB707E2SylingTracker|r" .. " profile |CFF03FA6Eset|r!")
end
