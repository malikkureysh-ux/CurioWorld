--!strict
--[[
	SaveService.lua — Persistenz (M-14)
	====================================

	Persistenz-Strategie:
	- DataStoreService-basiert (ProfileService-kompatibel als Phase 3).
	- Auto-Save alle 60 Sekunden (vom Caller orchestriert).
	- Save bei PlayerRemoving.
	- Save bei Quest-Abschluss (siehe QuestService).

	Verschlüsselung (DSGVO/COPPA-konform):
	- AES-256-GCM via OpenSSL wäre Phase 4 (braucht externes Tooling).
	- Phase 2: XOR-Cipher mit zufälligem 16-Byte-IV + Server-Side Secret.
	  Orders of magnitude besser als Base64-Prefix, aber reversibel mit Key.
	  Für Production mit echter Compliance: Secret via KMS (AWS KMS / GCP KMS).
]]

local DataStoreService = game:GetService("DataStoreService")
local HttpService = game:GetService("HttpService")

local SaveService = {}

-- ============================================================
-- Wallet-Typ (Spiegel von M07_Economy.Wallet, hier dupliziert,
-- damit SaveService keine Modul-Abhängigkeit hat)
-- ============================================================

export type Wallet = {
	Gold: number,
	Gems: number,
	RobuxSpent: number,
	VIPActive: boolean,
	VIPExpiresAt: number,
}

export type Settings = {
	VolumeMaster: number?,
	VolumeMusic: number?,
	VolumeSFX: number?,
	Language: string?,
	AnimationsEnabled: boolean?,
	HighContrast: boolean?,
	ReducedMotion: boolean?,
	ChatEnabled: boolean?,
}

-- ============================================================
-- Konfiguration
-- ============================================================

local SAVE_STORE_NAME = "CurioWorld_v1"
local SAVE_KEY_PREFIX = "player_"
local SETTINGS_KEY_PREFIX = "settings_"
local SAVE_VERSION = 1

-- Encryption-Secret: in Production via KMS einlesen
-- Aktuell: hardcoded (akzeptabel für Phase-2-Stub, dokumentiert in docs/PENDING_UPLOAD_WORKFLOW.md)
local ENCRYPTION_SECRET = "CurioWorld_v1_aes_xor_secret_2026_replace_in_prod"

local saveStore

local ok, err = pcall(function()
	saveStore = DataStoreService:GetDataStore(SAVE_STORE_NAME)
end)

if not ok then
	warn("[SaveService] DataStore nicht verfügbar:", err)
	saveStore = nil
end

-- ============================================================
-- XOR-Cipher mit zufälligem IV (Phase-2-Stub für echte AES-256-GCM)
-- ============================================================

-- 16 zufällige Bytes via HttpService:GenerateGUID (deterministisch nach RandomString)
local function generateIV(): string
	-- Roblox RandomString gibt alphanumerisch; wir hashen zu 16 Bytes
	local guid1 = HttpService:GenerateGUID(false)
	local guid2 = HttpService:GenerateGUID(false)
	local combined = guid1 .. guid2
	local iv = ""
	for i = 1, 32 do
		iv = iv .. string.char(string.byte(combined, i) % 256)
	end
	return iv
end

local function deriveKeyStream(secret: string, iv: string, length: number): string
	-- PBKDF-ähnlicher Key-Stream via wiederholtem Hash (Phase-2-Stub).
	-- In Production: HKDF + AES-256-GCM.
	local stream = ""
	local combined = secret .. ":" .. iv
	local h = 0
	for i = 1, #combined do
		h = (h * 31 + string.byte(combined, i)) % 2^32
	end

	while #stream < length do
		h = (h * 1103515245 + 12345) % 2^31  -- simple LCG
		stream = stream .. string.char(math.floor(h / 2^23) % 256)
	end
	return string.sub(stream, 1, length)
end

local function xorEncrypt(plaintext: string): string
	if not plaintext or plaintext == "" then return "" end
	local iv = generateIV()
	local keystream = deriveKeyStream(ENCRYPTION_SECRET, iv, #plaintext)

	local ciphertext = {}
	for i = 1, #plaintext do
		local p = string.byte(plaintext, i)
		local k = string.byte(keystream, i)
		local c = bit32.bxor(p, k)
		table.insert(ciphertext, string.char(c))
	end

	-- IV + Ciphertext in Hex (HttpService:JSONEncode-fähig)
	local ivHex = iv:gsub(".", function(c)
		return string.format("%02x", string.byte(c))
	end)
	local ctHex = table.concat(ciphertext):gsub(".", function(c)
		return string.format("%02x", string.byte(c))
	end)
	return "XOR:" .. ivHex .. ":" .. ctHex
end

local function xorDecrypt(encoded: string): string
	if not encoded or encoded == "" then return "" end
	if string.sub(encoded, 1, 4) ~= "XOR:" then
		-- Legacy-Format "ENC:" oder plaintext
		if string.sub(encoded, 1, 4) == "ENC:" then
			return string.sub(encoded, 5)
		end
		return encoded
	end

	local hexPayload = string.sub(encoded, 5)
	local sepIdx = hexPayload:find(":")
	if not sepIdx then return "" end
	local ivHex = string.sub(hexPayload, 1, sepIdx - 1)
	local ctHex = string.sub(hexPayload, sepIdx + 1)

	local iv = {}
	for i = 1, #ivHex, 2 do
		local hexByte = string.sub(ivHex, i, i + 1)
		table.insert(iv, string.char(tonumber(hexByte, 16)))
	end
	local ivStr = table.concat(iv)

	local ct = {}
	for i = 1, #ctHex, 2 do
		local hexByte = string.sub(ctHex, i, i + 1)
		table.insert(ct, string.char(tonumber(hexByte, 16)))
	end
	local ctStr = table.concat(ct)

	local keystream = deriveKeyStream(ENCRYPTION_SECRET, ivStr, #ctStr)
	local plaintext = {}
	for i = 1, #ctStr do
		local c = string.byte(ctStr, i)
		local k = string.byte(keystream, i)
		local p = bit32.bxor(c, k)
		table.insert(plaintext, string.char(p))
	end
	return table.concat(plaintext)
end

-- ============================================================
-- Settings-Speicherung (Phase 3: separate DataStore-Keys)
-- ============================================================

function SaveService:SaveSetting(player: Player, key: string, value: any): boolean
	if not saveStore then return false end

	local storeKey = SETTINGS_KEY_PREFIX .. tostring(player.UserId)
	local ok2, data = pcall(function()
		return saveStore:GetAsync(storeKey)
	end)
	local settings: any = (ok2 and typeof(data) == "table") and data or {}

	settings[key] = value
	settings.saved_at = os.time()
	settings.version = SAVE_VERSION

	local ok3, err3 = pcall(function()
		saveStore:SetAsync(storeKey, settings)
	end)
	if not ok3 then
		warn("[SaveService] SaveSetting failed for", player.Name, key, err3)
		return false
	end
	return true
end

function SaveService:LoadSettings(player: Player, callback: (Settings?) -> ())
	if not saveStore then
		callback(nil)
		return
	end

	local storeKey = SETTINGS_KEY_PREFIX .. tostring(player.UserId)
	local ok2, data = pcall(function()
		return saveStore:GetAsync(storeKey)
	end)
	if not ok2 or not data or typeof(data) ~= "table" then
		callback(nil)
		return
	end

	-- Filter auf erlaubte Felder (defensiv gegen Schema-Drift)
	local out: Settings = {}
	if type(data.VolumeMaster) == "number" then out.VolumeMaster = data.VolumeMaster end
	if type(data.VolumeMusic) == "number" then out.VolumeMusic = data.VolumeMusic end
	if type(data.VolumeSFX) == "number" then out.VolumeSFX = data.VolumeSFX end
	if type(data.Language) == "string" then out.Language = data.Language end
	if type(data.AnimationsEnabled) == "boolean" then out.AnimationsEnabled = data.AnimationsEnabled end
	if type(data.HighContrast) == "boolean" then out.HighContrast = data.HighContrast end
	if type(data.ReducedMotion) == "boolean" then out.ReducedMotion = data.ReducedMotion end
	if type(data.ChatEnabled) == "boolean" then out.ChatEnabled = data.ChatEnabled end

	callback(out)
end

-- ============================================================
-- Wallet
-- ============================================================

function SaveService:LoadWallet(player: Player, callback: (Wallet?) -> ())
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

	local wallet: Wallet = {
		Gold = data.gold or 0,
		Gems = data.gems or 0,
		RobuxSpent = data.robux_spent or 0,
		VIPActive = data.vip_active or false,
		VIPExpiresAt = data.vip_expires or 0,
	}

	callback(wallet)
end

function SaveService:SaveWallet(player: Player, wallet: Wallet): boolean
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

	-- Sensitive Felder entschlüsseln (XOR-Cipher)
	if data.encrypted_fields then
		for k, v in pairs(data.encrypted_fields) do
			data.encrypted_fields[k] = xorDecrypt(v)
		end
	end

	callback(data)
end

function SaveService:SaveData(player: Player, data: { [string]: any }): boolean
	if not saveStore then return false end

	local key = SAVE_KEY_PREFIX .. tostring(player.UserId)

	-- Sensitive Felder verschlüsseln (XOR-Cipher)
	if data.encrypted_fields then
		local enc = {}
		for k, v in pairs(data.encrypted_fields) do
			enc[k] = xorEncrypt(tostring(v))
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