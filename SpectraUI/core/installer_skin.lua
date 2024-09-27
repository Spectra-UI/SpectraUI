-- Create references to ElvUI internals
local E, _, V, P, G = unpack(ElvUI)
-- dont touch this ^

-- Cache Lua / WoW API
local ReloadUI = ReloadUI


local elvuiInstallCompleted = nil -- backup ElvUI installations Version

-- ElvUI Installer Table
local installerData = {
	Title = SpectraUI.InstallerData.Title,
	Name = SpectraUI.InstallerData.Name,
	tutorialImage = SpectraUI.InstallerData.Logo,
	tutorialImageSize = SpectraUI.InstallerData.LogoSize,
	StepTitlesColor = SpectraUI.InstallerData.StepTitlesColor,
	StepTitlesColorSelected = SpectraUI.InstallerData.StepTitlesColorSelected,
	StepTitleWidth = 200,
	StepTitleButtonWidth = 180,
	StepTitleTextJustification = "CENTER",
	Pages = {},
	StepTitles = {},
}

-- Cache/ Load ElvUI PluginInstaller API
local PI = E:GetModule("PluginInstaller")

-- Reset our Installer Skin, to prevent overriding other installers
local function ResetInstallerSkin()
	for i = 1, 4 do
		local option = _G.PluginInstallFrame["Option" .. i]
		if option.preview then option.preview = nil end
	end
end

-- Button OnEnter (Installer Skin)
local function OnEnter(button)
	if button.preview then
		PluginInstallFrame.tutorialImage:Size(512, 256)
		PluginInstallFrame.tutorialImage:SetTexture(button.preview)
		E:UIFrameFadeIn(PluginInstallFrame.tutorialImage, 0.75, 0, 1)
	else
		PluginInstallFrame.tutorialImage:Size(410, 205)
	end

	if button.backdrop then button = button.backdrop end
	if button.SetBackdropBorderColor then button:SetBackdropBorderColor(unpack(SpectraUI.Color.ui.rgb)) end
end

-- Button OnLeave (Installer Skin)
local function OnLeave(button)
	PluginInstallFrame.tutorialImage:Size(410, 205)
	PluginInstallFrame.tutorialImage:SetTexture(SpectraUI.Media.logo)

	if button.backdrop then button = button.backdrop end
	if button.SetBackdropBorderColor then button:SetBackdropBorderColor(unpack(E.media.bordercolor)) end
end

-- Button Events (Installer Skin)
local function SetEvents()
	local options = {
		_G.PluginInstallFrame.Option1,
		_G.PluginInstallFrame.Option2,
		_G.PluginInstallFrame.Option3,
		_G.PluginInstallFrame.Option4,
		_G.PluginInstallFrame.Next,
		_G.PluginInstallFrame.Prev,
	}

	for _, option in ipairs(options) do
		option:SetScript("OnEnter", nil)
		option:SetScript("OnLeave", nil)
	end

	for _, option in ipairs(options) do
		option:SetScript("OnEnter", OnEnter)
		option:SetScript("OnLeave", OnLeave)
	end
end

-- Change the Size of the Installer Frame (Installer Skin)
local function Resize()
	local currentInstalle = PI.Installs[1]
	if currentInstalle and currentInstalle.Title == installerData.Title then
		SetEvents()

		_G.PluginInstallFrame:SetSize(800, 512)
		--_G.PluginInstallFrame:SetScale(1.25)

		-- set a new psoition to tha logo and descriptions
		_G.PluginInstallFrame.Desc1:ClearAllPoints()
		_G.PluginInstallFrame.Desc1:SetPoint("TOP", _G.PluginInstallFrame.SubTitle, "BOTTOM", 0, -30)
		_G.PluginInstallFrame.tutorialImage:ClearAllPoints()
		_G.PluginInstallFrame.tutorialImage:SetPoint("BOTTOM", 0, 100)
	end
end

--This function is executed when you press "Skip Process" or "Finished" in the installer.
function SpectraUI:InstallComplete()
	-- Set a variable tracking the version of the addon when layout was installed
	E.db.SpectraUI.install_version = SpectraUI.Version
	E.private.install_complete = E.version

	ResetInstallerSkin()
	ReloadUI()
end
function SpectraUI:SetupSkip()
	E.private.install_complete = elvuiInstallCompleted or nil
	SpectraUI:InstallComplete()
end

-- Our Simple Steps/ Page function
local function SetUpPage(page)
	local currentInstalle = PI.Installs[1]
	if currentInstalle and currentInstalle.Title == installerData.Title then
		SetEvents()
		Resize()

		if SpectraUI.InstallerData[page].tutorialImage then
			_G.PluginInstallFrame.tutorialImage:Show()
		else
			_G.PluginInstallFrame.tutorialImage:Hide()
		end

		_G.PluginInstallFrame.SubTitle:SetText(SpectraUI.InstallerData[page].SubTitle or "")

		local desc = SpectraUI.InstallerData[page].descriptions
		if desc then
			for i = 1, #desc do
				_G.PluginInstallFrame["Desc" .. i]:SetText(desc[i])
			end
		end

		local options = SpectraUI.InstallerData[page].options
		if options then
			for i = 1, #options do
				_G.PluginInstallFrame["Option" .. i]:Show()
				_G.PluginInstallFrame["Option" .. i]:SetText(options[i].text)
				_G.PluginInstallFrame["Option" .. i]:SetScript("OnClick", options[i].func)
				_G.PluginInstallFrame["Option" .. i].preview = options[i].preview or nil
			end
		end
	end
end

function SpectraUI:RunInstaller()
	-- check elvui installation
	if E.private.install_complete then elvuiInstallCompleted = E.private.install_complete end

	-- build the installer table
	if not SpectraUI.InstallerData.build then
		for i = 1, #SpectraUI.InstallerData do
			installerData.StepTitles[i] = SpectraUI.InstallerData[i].StepTitle or SpectraUI.InstallerData[i].SubTitle
			installerData.Pages[i] = function()
				SetUpPage(i)
			end
		end
		SpectraUI.InstallerData.build = true
	end

	-- queue our installer
	PI:Queue(installerData)
end
