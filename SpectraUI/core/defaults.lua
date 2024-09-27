-- Create references to ElvUI internals
local E, _, V, P, G = unpack(ElvUI)
-- dont touch this ^

-- Create a unique table for our plugin
-- Default settings DB for the addon
P.SpectraUI = {
	portraitsOffset = 3.5, -- Portrait zoom offest, default setting
	detailsEmbedded = { -- settings for the embedded system
		chatEmbedded = "RightChat",
	},
}
