-- Create references to ElvUI internals
local E = unpack(ElvUI)
local S = E:GetModule("Skins")
-- dont touch this ^

local IsAddOnLoaded = _G.C_AddOns and _G.C_AddOns.IsAddOnLoaded or _G.IsAddOnLoaded

-- Popup for our links
E.PopupDialogs.SPECTRAUI_EDITBOX = {
	text = SpectraUI.Media.icon .. " " .. SpectraUI.Name,
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
		if self:GetText() ~= self.temptxt then
			self:SetText(self.temptxt)
		end

		self:HighlightText()
	end,
	whileDead = 1,
	preferredIndex = 3,
	hideOnEscape = 1,
}

-- Creat a own print prompt
function SpectraUI:Print(...)
	local printName = SpectraUI.Media.icon .. " " .. SpectraUI.Name .. ":"
	print(printName, ...)
end

-- check if addons are loaded
function SpectraUI:CheckAddons()
	SpectraUI.Addons.BigWigs = IsAddOnLoaded("BigWigs")
	SpectraUI.Addons.Details = IsAddOnLoaded("Details")
end

local function CheckForProfile(db, name)
	if db then
		for i = 1, #db do
			if db[i] == name then
				return true
			end
		end
	end
end

function SpectraUI:CheckProfile()
	local privateProfiles = E.charSettings and E.charSettings:GetProfiles()
	local profiles = E.data and E.data:GetProfiles()

	if privateProfiles and profiles then
		SpectraUI.Profiles = {
			private = CheckForProfile(privateProfiles, "SpectraUI"),
			privateIsSet = E.charSettings:GetCurrentProfile() == "SpectraUI",
			dps = {
				private = CheckForProfile(privateProfiles, "SpectraUI"),
				profile = CheckForProfile(profiles, "SUI DPS/Tank"),
				privateIsSet = E.charSettings:GetCurrentProfile() == "SpectraUI",
				profileIsSet = E.data:GetCurrentProfile() == "SUI DPS/Tank",
			},
			healer = {
				private = CheckForProfile(privateProfiles, "SpectraUI"),
				profile = CheckForProfile(profiles, "SUI Healer"),
				privateIsSet = E.charSettings:GetCurrentProfile() == "SpectraUI",
				profileIsSet = E.data:GetCurrentProfile() == "SUI Healer",
			}
		}
	end
end

-- Add button to Game Menu
local SpectraMenuButton = CreateFrame('Button', nil, GameMenuFrame, 'GameMenuButtonTemplate')
local isMenuExpanded = false
local SpectraGameMenu = CreateFrame("Frame")
SpectraGameMenu:RegisterEvent("PLAYER_ENTERING_WORLD")
SpectraGameMenu:SetScript("OnEvent", function()

	if E.Retail or E.TBC then
		-- Retail/TBC
		local Menubutton
		if not _G["SpectraGameMenu"] then
			Menubutton = CreateFrame('Button', 'SpectraGameMenu', GameMenuFrame, 'MainMenuFrameButtonTemplate')
			Menubutton:SetScript('OnClick', function()
				if InCombatLockdown() then return end
				E:ToggleOptions()
				E.Libs['AceConfigDialog']:SelectGroup('ElvUI', 'SpectraUI')
				HideUIPanel(_G.GameMenuFrame)
			end)


			Menubutton:SetText(SpectraUI.Name)

			S:HandleButton(Menubutton, nil, nil, nil, true)

			local offset = E.TBC and 19 or 36
			local xMenubutton = _G.GameMenuFrame:GetSize()
			if E.TBC then
				Menubutton:Size(xMenubutton - 118, offset)
			else
				Menubutton:Size(xMenubutton - 62, offset)
			end

			GameMenuFrame.SpectraUI = Menubutton
			GameMenuFrame.MenuButtons.SpectraUI = Menubutton

			hooksecurefunc(GameMenuFrame, 'Layout', function()
				GameMenuFrame.MenuButtons.SpectraUI:SetPoint("CENTER", _G.GameMenuFrame, "TOP", 0, -20)
				for _, button in pairs(GameMenuFrame.MenuButtons) do
					if button then
						local point, anchor, point2, x, y = button:GetPoint()
						button:SetPoint(point, anchor, point2, x, y - offset)
					end
				end

				if E.Retail then
					GameMenuFrame:Height(538 + offset)
				end


			end)
		end
	else
		-- Classic
		if not isMenuExpanded then

			SpectraMenuButton:SetText(SpectraUI.Name)
			S:HandleButton(SpectraMenuButton)

			    -- Size from logout button
			local logoutBtn = _G["GameMenuButtonLogout"]
			if logoutBtn then
				local x, y = logoutBtn:GetSize()
				SpectraMenuButton:SetSize(x, y)
			end

			SpectraMenuButton:SetScript("OnClick", function()
				if not InCombatLockdown() then
					E:ToggleOptions("SpectraUI")
					HideUIPanel(_G["GameMenuFrame"])
				end
			end)

			    -- Anchor update function
			local function UpdateSpectraMenuAnchor()
				if GameMenuFrame.ElvUI then
					SpectraMenuButton:Point("TOP", GameMenuFrame.ElvUI, "BOTTOM", 0, -1)
				elseif _G.GameMenuButtonAddons then
					SpectraMenuButton:Point("TOP", _G.GameMenuButtonAddons, "BOTTOM", 0, -1)
				end
			end

			    -- Hook
			if type(_G.GameMenuFrame_UpdateVisibleButtons) == "function" then
				hooksecurefunc('GameMenuFrame_UpdateVisibleButtons', function()
					UpdateSpectraMenuAnchor()
				end)
			else
				-- Fallback: do the same update whenever menu opens
				_G["GameMenuFrame"]:HookScript("OnShow", function()
					UpdateSpectraMenuAnchor()
				end)
			end

			_G["GameMenuFrame"]:HookScript("OnShow", function()
				local logoutBtn = _G["GameMenuButtonLogout"]
				if not logoutBtn then return end

				local _, y = logoutBtn:GetSize()

				logoutBtn:ClearAllPoints()
				logoutBtn:SetPoint("TOP", SpectraMenuButton, "BOTTOM", 0, -y)
				_G["GameMenuFrame"]:SetHeight(_G["GameMenuFrame"]:GetHeight() + logoutBtn:GetHeight() + 4)
			end)

			isMenuExpanded = true
		end
	end
end)