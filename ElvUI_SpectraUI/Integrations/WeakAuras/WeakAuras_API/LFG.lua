local SpectraUI = LibStub("AceAddon-3.0"):GetAddon("ElvUI_SpectraUI")

local db

function SpectraUI:LFGEnable()
  db = self.db.profile

  self:RegisterEvent("LFG_PROPOSAL_SHOW", "HandleProposalShow")
  self:RegisterEvent("LFG_PROPOSAL_SUCCEEDED", "HandleProposalSucceeded")
  self:RegisterEvent("LFG_PROPOSAL_FAILED", "HandleProposalFailed")
  self:RegisterEvent("LFG_PROPOSAL_DONE", "HandleProposalDone")
end

local function HandleLFGProposal(show)
  if show then
    db.lfgStartTimer = time()
    db.lfgExpTimer = db.lfgStartTimer + 40
---@diagnostic disable-next-line: undefined-global
    WeakAuras.ScanEvents("WA_Spectra_PROPOSAL", "SHOW")
  else
    db.lfgStartTimer = 0
    db.lfgExpTimer = 0
---@diagnostic disable-next-line: undefined-global
    WeakAuras.ScanEvents("WA_Spectra_PROPOSAL", "HIDE")
  end
end

function SpectraUI:HandleProposalShow()
  HandleLFGProposal(true)
end

function SpectraUI:HandleProposalSucceeded()
  HandleLFGProposal(false)
end

function SpectraUI:HandleProposalFailed()
  HandleLFGProposal(false)
end

function SpectraUI:HandleProposalDone()
  HandleLFGProposal(false)
end

function Spectra.GetLFGTimer()
  local curTime = time()
  if (db.lfgExpTimer or 0) > curTime then
    return db.lfgExpTimer - curTime, db.lfgExpTimer - db.lfgStartTimer
  end
end
