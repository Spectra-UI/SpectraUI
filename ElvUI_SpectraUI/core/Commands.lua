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
		self:RunInstaller()
		return
	end

	-- STATUS REPORT COMMANDS
	if msg == "status" or msg == "report" or msg == "statusreport" then
		-- Fetch lazily & silently (prevents load-order errors)
		local StatusReport = self:GetModule("StatusReport", true)

		if StatusReport and StatusReport.ToggleStatusReport then
			StatusReport:ToggleStatusReport()
		else
			print("|cff2AB6FFSpectraUI|r: Status Report module not loaded.")
		end

		return
	end

	-- DEFAULT → OPEN OPTIONS
	E:ToggleOptions("SpectraUI")
end
