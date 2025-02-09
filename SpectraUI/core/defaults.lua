-- Create references to ElvUI internals
local _, _, _, P, _ = unpack(ElvUI)
-- dont touch this ^

-- Create a unique table for our plugin
-- Default settings DB for the addon
P.SpectraUI = {
	portraitsOffset = 3.5, -- Portrait zoom offset, default setting
	playerPortraitHide = false, -- hide player portrait when target exist
	detailsEmbedded = { -- settings for the embedded system
		chatEmbedded = "RightChat",
	},
	elvui_skipped = false,
}
