local _G = _G
local IsAddOnLoaded = _G.C_AddOns and _G.C_AddOns.IsAddOnLoaded or _G.IsAddOnLoaded

local path =  "Interface\\Addons\\SpectraUI\\media\\class\\"

local styles = {
	border = {
		name = SpectraUI.Name .. "- Modern",
		texture = path .. "SpectraUI_Modern.tga",
	},
	classborder = {
		name = SpectraUI.Name .. "- Classic",
		texture = path .. "SpectraUI_Classic.tga",
	},
}

local dropdownIcon = "Interface\\AddOns\\SpectraUI\\media\\icon.tga"
function SpectraUI:SetupDetails()
    if not IsAddOnLoaded("Details") then return end
	for _, data in next, styles do
		_G.Details:AddCustomIconSet(data.texture, data.name, false, dropdownIcon, {0, 1, 0, 1})
	end
end
