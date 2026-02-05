local E = unpack(ElvUI)
local SpectraUI = E:GetModule("SpectraUI")

-- LOAD COMMANDS
function SpectraUI:LoadCommands()

	self:RegisterChatCommand("sui", "HandleSlashCommand")
	self:RegisterChatCommand("spectra", "HandleSlashCommand")
	self:RegisterChatCommand("spectraui", "HandleSlashCommand")

end

-- COMMAND HANDLER
function SpectraUI:HandleSlashCommand(msg)

	-- Trim + lowercase input safely
	msg = msg and msg:lower():match("^%s*(.-)%s*$") or ""

	-- INSTALLER COMMANDS
	if msg == "install" or msg == "installer" then
		SpectraUI:RunInstaller()
		return
	end

	-- DEFAULT → OPEN OPTIONS
	E:ToggleOptions("SpectraUI")

end
