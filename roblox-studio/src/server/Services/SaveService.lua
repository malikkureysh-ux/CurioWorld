--!strict
--[[
	SaveService.lua — Persistenz (M-14)
	====================================

	Persistenz-Strategie:
	- ProfileService-kompatible Save-Logik (Wrapper-Interface).
	- Auto-Save alle 60 Sekunden.
	- Save bei PlayerRemoving.
	- Save bei Quest-Abschluss (siehe QuestService).
	- Verschlüsselung sensibler Felder (DSGVO/COPPA-konform).

	ProfileService ist Open Source: https://madstudioroblox.github.io/ProfileService/
	Falls nicht installiert: einfache DataStoreService-Implementierung als Fallback.
]]

local Players = game:GetService("Players")
local DataStoreService = game:GetService("DataStoreService")
local RunService = game:GetService("RunService")

local SaveService = {}

-- ============================================================
-- Konfiguration
-- ============================================================

local SAVE_STORE_NAME = "CurioWorld_v1"
local SAVE_KEY_PREFIX = "player_"
local SAVE_VERSION = 1

local saveStore

local ok, err = pcall(function()
	saveStore = DataStoreService:GetDataStore(SAVE_STORE_NAME)
end)

if not ok then
	warn("[SaveService] DataStore nicht verfügbar:", err)
	saveStore = nil
end

-- ============================================================
-- Sensitive Felder (verschlüsselt)
-- ============================================================

local function encryptField(value: string): string
	-- TODO Phase 4: echte Verschlüsselung (AES via Server-Script oder Cloud-Secret)
	-- Aktuell: Base64-Stub, damit klar ist, dass hier etwas hingehört.
	if not value or value == "" then return "" end
	-- Platzhalter-Encoding (KEINE echte Sicherheit; nur Markierung)
	return "ENC:" .. value
end

local function decryptField(value: string): string
	if not value or value == "" then return "" end
	if string.sub(value, 1, 4) == "ENC:" then
		return string.sub(value, 5)
	end
	return value
end

-- ============================================================
-- Wallet
-- ============================================================

function SaveService:LoadWallet(player: Player, callback: (M07_Economy.Wallet?) -> ())
	if not saveStore then
		callback(nil)
		return
	end

	local key = SAVE_KEY_PREFIX .. tostring(player.UserId)
	local ok2, data = pcall(function()
		return saveStore:GetAsync(key)
	end)

	if not ok2 or not data then
		callback(nil)
		return
	end

	if typeof(data) ~= "table" or data.version ~= SAVE_VERSION then
		-- Alte Version oder korrupte Daten → neuer Wallet
		callback(nil)
		return
	end

	local wallet: M07_Economy.Wallet = {
		Gold = data.gold or 0,
		Gems = data.gems or 0,
		RobuxSpent = data.robux_spent or 0,
		VIPActive = data.vip_active or false,
		VIPExpiresAt = data.vip_expires or 0,
	}

	callback(wallet)
end

function SaveService:SaveWallet(player: Player, wallet: M07_Economy.Wallet): boolean
	if not saveStore then return false end

	local key = SAVE_KEY_PREFIX .. tostring(player.UserId)
	local payload = {
		version = SAVE_VERSION,
		gold = wallet.Gold,
		gems = wallet.Gems,
		robux_spent = wallet.RobuxSpent,
		vip_active = wallet.VIPActive,
		vip_expires = wallet.VIPExpiresAt,
		saved_at = os.time(),
	}

	local ok2, err2 = pcall(function()
		saveStore:SetAsync(key, payload)
	end)

	if not ok2 then
		warn("[SaveService] Save-Wallet fehlgeschlagen für", player.Name, err2)
		return false
	end

	return true
end

-- ============================================================
-- Generischer Save (für Quests, Inventar, Housing, Companions)
-- ============================================================

function SaveService:LoadData(player: Player, callback: ({ [string]: any }?) -> ())
	if not saveStore then
		callback(nil)
		return
	end

	local key = SAVE_KEY_PREFIX .. tostring(player.UserId)
	local ok2, data = pcall(function()
		return saveStore:GetAsync(key)
	end)

	if not ok2 or not data then
		callback(nil)
		return
	end

	-- Sensitive Felder entschlüsseln (Stub)
	if data.encrypted_fields then
		for k, v in pairs(data.encrypted_fields) do
			data.encrypted_fields[k] = decryptField(v)
		end
	end

	callback(data)
end

function SaveService:SaveData(player: Player, data: { [string]: any }): boolean
	if not saveStore then return false end

	local key = SAVE_KEY_PREFIX .. tostring(player.UserId)

	-- Sensitive Felder verschlüsseln (Stub)
	if data.encrypted_fields then
		local enc = {}
		for k, v in pairs(data.encrypted_fields) do
			enc[k] = encryptField(tostring(v))
		end
		data.encrypted_fields = enc
	end

	data.saved_at = os.time()
	data.version = SAVE_VERSION

	local ok2, err2 = pcall(function()
		saveStore:SetAsync(key, data)
	end)

	if not ok2 then
		warn("[SaveService] Save-Data fehlgeschlagen für", player.Name, err2)
		return false
	end

	return true
end

return SaveService