--!strict
--[[
	M14_Parental.lua — Parental Consent & Privacy Dashboard (Phase 3 Runtime)
	===========================================================================

	User Story:
	  Als Eltern möchte ich:
	  1. Für mein <13-jähriges Kind eine Einwilligung erteilen (COPPA/DSGVO)
	  2. Sehen, welche Daten gespeichert sind
	  3. Chat-Berechtigungen für mein Kind einschränken
	  4. Spielzeit-Limits setzen
	  5. Alles widerrufbar (Daten-Export + Account-Löschung)

	Architektur:
	  - ConsentRegistry: child_pid → parent_consent_record
	  - ParentLink: parent_user_id → child_pid (via Roblox Friend-Service in Phase 4)
	  - PrivacyRequests: data_export / account_deletion mit 30-Tage-Grace
	  - PlayTimeLimits: max_minutes_per_day
]]

local Players = game:GetService("Players")
local DataStoreService = game:GetService("DataStoreService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local Log = require(ReplicatedStorage.Shared.Util.Log)

local M14_Parental = {}

-- ============================================================
-- Types
-- ============================================================

export type ConsentRecord = {
	child_pid: string,
	parent_user_id: number,
	consent_given_at: number,
	consent_version: number,
	ip_address: string?,        -- Anonymized-Hash
	expires_at: number?,
	revoked_at: number?,
}

export type PlayTimeLimit = {
	child_pid: string,
	max_minutes_per_day: number,
	enabled: boolean,
	warning_at_minutes: number?,
}

export type PrivacyRequest = {
	child_pid: string,
	request_type: "data_export" | "account_deletion",
	requested_at: number,
	execute_at: number,         -- 30-Tage-Grace-Period
	executed: boolean,
}

-- ============================================================
-- Constants
-- ============================================================

local CONSENT_STORE_NAME = "CurioWorld_v1_consent"
local CONSENT_VERSION = 1
local CONSENT_EXPIRY_DAYS = 365  -- Re-consent alle 12 Monate
local PRIVACY_GRACE_DAYS = 30

-- ============================================================
-- State (In-Memory)
-- ============================================================

local consentRecords: { [string]: ConsentRecord } = {}  -- pid → record
local playTimeLimits: { [string]: PlayTimeLimit } = {}
local privacyRequests: { [string]: PrivacyRequest } = {}

local consentStore
local ok = pcall(function()
	consentStore = DataStoreService:GetDataStore(CONSENT_STORE_NAME)
end)
if not ok then
	Log:Warn("[M14] Consent-DataStore unavailable:", consentStore)
end

-- ============================================================
-- Per-Player Session-Tracking (für PlayTime)
-- ============================================================

local sessionStart: { [string]: number } = {}  -- pid → os.time()
local playTimeToday: { [string]: { date: string, minutes: number } } = {}

local function todayKey(): string
	return os.date("%Y-%m-%d")
end

local function loadPlayTime(pid: string): number
	local entry = playTimeToday[pid]
	if entry and entry.date == todayKey() then
		return entry.minutes
	end
	return 0
end

local function savePlayTime(pid: string, minutes: number)
	playTimeToday[pid] = { date = todayKey(), minutes = minutes }
end

-- ============================================================
-- Public API
-- ============================================================

function M14_Parental:GrantConsent(childPid: string, parentUserId: number, ipHash: string?): ConsentRecord
	if not childPid or not parentUserId then return nil end

	local record: ConsentRecord = {
		child_pid = childPid,
		parent_user_id = parentUserId,
		consent_given_at = os.time(),
		consent_version = CONSENT_VERSION,
		ip_address = ipHash,
		expires_at = os.time() + (CONSENT_EXPIRY_DAYS * 86400),
		revoked_at = nil,
	}
	consentRecords[childPid] = record

	-- Persist to DataStore (server-authoritative)
	if consentStore then
		local ok2, err = pcall(function()
			consentStore:SetAsync("consent_" .. childPid, record)
		end)
		if not ok2 then
			Log:Warn("[M14] Failed to persist consent:", err)
		end
	end

	Log:Info(("[M14] Consent granted: child=%s parent=%d"):format(childPid, parentUserId))
	return record
end

function M14_Parental:RevokeConsent(childPid: string): boolean
	local record = consentRecords[childPid]
	if not record then return false end
	record.revoked_at = os.time()
	Log:Info(("[M14] Consent revoked: child=%s"):format(childPid))
	return true
end

function M14_Parental:HasConsent(childPid: string): boolean
	local record = consentRecords[childPid]
	if not record then return false end
	if record.revoked_at then return false end
	if record.expires_at and record.expires_at < os.time() then return false end
	return true
end

function M14_Parental:GetConsent(childPid: string): ConsentRecord?
	return consentRecords[childPid]
end

-- ============================================================
-- Play-Time Limits
-- ============================================================

function M14_Parental:SetPlayTimeLimit(childPid: string, maxMinutesPerDay: number,
                                       enabled: boolean?, warningAtMinutes: number?)
	if maxMinutesPerDay < 0 then return false end

	playTimeLimits[childPid] = {
		child_pid = childPid,
		max_minutes_per_day = maxMinutesPerDay,
		enabled = enabled ~= false,  -- default true
		warning_at_minutes = warningAtMinutes or math.floor(maxMinutesPerDay * 0.8),
	}
	Log:Info(("[M14] PlayTimeLimit set: %s → %d min/day"):format(childPid, maxMinutesPerDay))
	return true
end

function M14_Parental:GetPlayTimeLimit(childPid: string): PlayTimeLimit?
	return playTimeLimits[childPid]
end

function M14_Parental:CheckPlayTime(player: any): (boolean, number, number?)
	-- Returns (allowed, minutes_played, warning_at_minutes_or_nil)
	local M06 = require(ReplicatedStorage.Shared.Modules.M06_Inventory)
	local pid = M06:ToPid(player)
	if not pid then return true, 0, nil end

	local limit = playTimeLimits[pid]
	if not limit or not limit.enabled then
		return true, loadPlayTime(pid), nil  -- no limit
	end

	local played = loadPlayTime(pid)
	if played >= limit.max_minutes_per_day then
		return false, played, nil  -- limit reached
	end

	return true, played, limit.warning_at_minutes
end

-- ============================================================
-- Privacy Requests (GDPR Art. 17/20)
-- ============================================================

function M14_Parental:RequestDataExport(childPid: string): PrivacyRequest
	local req: PrivacyRequest = {
		child_pid = childPid,
		request_type = "data_export",
		requested_at = os.time(),
		execute_at = os.time() + (PRIVACY_GRACE_DAYS * 86400),
		executed = false,
	}
	privacyRequests[childPid] = req
	Log:Info(("[M14] Data export requested for %s"):format(childPid))
	return req
end

function M14_Parental:RequestAccountDeletion(childPid: string): PrivacyRequest
	local req: PrivacyRequest = {
		child_pid = childPid,
		request_type = "account_deletion",
		requested_at = os.time(),
		execute_at = os.time() + (PRIVACY_GRACE_DAYS * 86400),
		executed = false,
	}
	privacyRequests[childPid] = req
	Log:Info(("[M14] Account deletion requested for %s (executes in 30 days)"):format(childPid))
	return req
end

function M14_Parental:CancelPrivacyRequest(childPid: string): boolean
	local req = privacyRequests[childPid]
	if not req or req.executed then return false end
	privacyRequests[childPid] = nil
	Log:Info(("[M14] Privacy request cancelled for %s"):format(childPid))
	return true
end

function M14_Parental:GetPrivacyRequest(childPid: string): PrivacyRequest?
	return privacyRequests[childPid]
end

-- ============================================================
-- Session-Tracking (called by Bootstrap on Join/Leave)
-- ============================================================

function M14_Parental:OnPlayerJoin(player: Player)
	local M06 = require(ReplicatedStorage.Shared.Modules.M06_Inventory)
	local pid = M06:ToPid(player)
	if not pid then return end
	sessionStart[pid] = os.time()
end

function M14_Parental:OnPlayerLeave(player: Player)
	local M06 = require(ReplicatedStorage.Shared.Modules.M06_Inventory)
	local pid = M06:ToPid(player)
	if not pid then return end
	local start = sessionStart[pid]
	if start then
		local minutes = math.floor((os.time() - start) / 60)
		savePlayTime(pid, loadPlayTime(pid) + minutes)
		sessionStart[pid] = nil
	end
end

-- Lifecycle: track playtime + enforce limits
Players.PlayerAdded:Connect(function(player)
	M14_Parental:OnPlayerJoin(player)
end)
Players.PlayerRemoving:Connect(function(player)
	M14_Parental:OnPlayerLeave(player)
end)

return M14_Parental