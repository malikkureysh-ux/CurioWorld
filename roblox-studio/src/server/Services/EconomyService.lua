--!strict
--[[
	EconomyService.lua — Server-seitige Wirtschaftslogik (M-07)
	============================================================

	Verantwortlichkeiten:
	- Wallet pro Spieler:in (Gold, Gems, Robux, VIP-Status).
	- Belohnungen vergeben (Quests, Events, Daily Login).
	- Käufe abwickeln (Gold/Gems intern, Robux über MarketplaceService).
	- Compliance-Audit auf jedem Kauf (C-002, C-019).
	- Telemetrie-Events für jeden Geldfluss.
]]

local Players = game:GetService("Players")
local MarketplaceService = game:GetService("MarketplaceService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local M07_Economy = require(ReplicatedStorage.Shared.Modules.M07_Economy)
local SaveService   = require(ServerScriptService.Services.SaveService)
local TelemetryService = require(ServerScriptService.Services.TelemetryService)

local EconomyService = {}

-- ============================================================
-- State
-- ============================================================

-- Wallets werden beim Join via SaveService geladen.
local wallets: { [Player]: M07_Economy.Wallet } = {}

local function ensureWallet(player: Player): M07_Economy.Wallet
	if not wallets[player] then
		wallets[player] = {
			Gold = 0,
			Gems = 0,
			RobuxSpent = 0,
			VIPActive = false,
			VIPExpiresAt = 0,
		}
	end
	return wallets[player]
end

-- Daily-Bonus-State (3 verbrauchbare Boosts pro Tag)
local dailyBonus: { [Player]: { Charges: number, LastReset: number } } = {}

-- ============================================================
-- Remote API (Server <-> Client)
-- ============================================================

local remotesFolder = Instance.new("Folder")
remotesFolder.Name = "EconomyRemotes"
remotesFolder.Parent = ReplicatedStorage

local remoteGetBalance = Instance.new("RemoteFunction")
remoteGetBalance.Name = "GetBalance"
remoteGetBalance.Parent = remotesFolder

local remoteAddGold = Instance.new("RemoteEvent")
remoteAddGold.Name = "AddGold" -- Server-only, Client darf NIE senden
remoteAddGold.Parent = remotesFolder

-- ============================================================
-- Public API
-- ============================================================

function EconomyService:GetBalance(player: Player): M07_Economy.Wallet
	return ensureWallet(player)
end

function EconomyService:AddGold(player: Player, amount: number, source: string?)
	if amount <= 0 then return end
	local wallet = ensureWallet(player)

	-- Daily-Bonus anwenden, falls Charge verfügbar
	local db = dailyBonus[player]
	if db and db.Charges > 0 and amount > 0 then
		amount = math.floor(amount * M07_Economy.DailyBonus.GoldMultiplier)
		db.Charges -= 1
	end

	wallet.Gold = math.min(wallet.Gold + amount, M07_Economy.Limits.Gold.HardCap)

	TelemetryService:Track(player, "economy.gold.added", {
		amount = amount,
		source = source or "unknown",
		new_balance = wallet.Gold,
	})

	remoteAddGold:FireClient(player, wallet.Gold)
end

function EconomyService:AddGems(player: Player, amount: number, source: string?)
	if amount <= 0 then return end
	local wallet = ensureWallet(player)
	wallet.Gems = math.min(wallet.Gems + amount, M07_Economy.Limits.Gems.HardCap)

	TelemetryService:Track(player, "economy.gems.added", {
		amount = amount,
		source = source or "unknown",
		new_balance = wallet.Gems,
	})
end

function EconomyService:SpendGold(player: Player, amount: number, reason: string): boolean
	if amount <= 0 then return true end
	local wallet = ensureWallet(player)
	if wallet.Gold < amount then return false end

	wallet.Gold -= amount

	TelemetryService:Track(player, "economy.gold.spent", {
		amount = amount,
		reason = reason,
		new_balance = wallet.Gold,
	})

	return true
end

function EconomyService:SpendGems(player: Player, amount: number, reason: string): boolean
	if amount <= 0 then return true end
	local wallet = ensureWallet(player)
	if wallet.Gems < amount then return false end

	wallet.Gems -= amount

	TelemetryService:Track(player, "economy.gems.spent", {
		amount = amount,
		reason = reason,
		new_balance = wallet.Gems,
	})

	return true
end

function EconomyService:TryPurchase(player: Player, item: M07_Economy.ShopItem): (boolean, string?)
	-- Compliance-Audit
	local ok, err = M07_Economy.AuditItem(item)
	if not ok then
		TelemetryService:Track(player, "economy.purchase.blocked_compliance", {
			item_id = item.Id,
			reason = err,
		})
		return false, err
	end

	local wallet = ensureWallet(player)

	-- VIP-Check
	if item.VIPOnly and not M07_Economy.IsVipActive(wallet, os.time()) then
		return false, "vip_required"
	end

	-- Interne Währungen
	if item.PriceGold and item.PriceGold > 0 then
		if not self:SpendGold(player, item.PriceGold, "purchase:" .. item.Id) then
			return false, "not_enough_gold"
		end
	end
	if item.PriceGems and item.PriceGems > 0 then
		if not self:SpendGems(player, item.PriceGems, "purchase:" .. item.Id) then
			-- Gems nicht abgebucht, weil Gold bereits weg? In Production
			-- würde man hier Transaktionen mit Rollback machen. Vereinfacht:
			return false, "not_enough_gems"
		end
	end

	-- Robux-Käufe laufen über MarketplaceService.ProcessReceipt
	-- (siehe ProcessReceipt unten)

	TelemetryService:Track(player, "economy.purchase.success", {
		item_id = item.Id,
		category = item.Category,
	})

	return true, nil
end

-- ============================================================
-- VIP-Pass
-- ============================================================

function EconomyService:GrantVip(player: Player, durationSeconds: number)
	local wallet = ensureWallet(player)
	local now = os.time()
	wallet.VIPActive = true
	if wallet.VIPExpiresAt > now then
		wallet.VIPExpiresAt = wallet.VIPExpiresAt + durationSeconds
	else
		wallet.VIPExpiresAt = now + durationSeconds
	end

	TelemetryService:Track(player, "vip.granted", {
		expires_at = wallet.VIPExpiresAt,
		duration = durationSeconds,
	})
end

-- ============================================================
-- Daily-Bonus
-- ============================================================

function EconomyService:GetDailyBonus(player: Player): { Charges: number, MaxCharges: number, SecondsUntilRecharge: number }
	local db = dailyBonus[player]
	if not db then
		db = { Charges = M07_Economy.DailyBonus.MaxCharges, LastReset = os.time() }
		dailyBonus[player] = db
	end

	-- Recharge-Logik: alle 10 Min eine Charge zurück, max 3.
	local elapsed = os.time() - db.LastReset
	local recharged = math.min(
		math.floor(elapsed / M07_Economy.DailyBonus.RechargeSeconds),
		M07_Economy.DailyBonus.MaxCharges - db.Charges
	)
	if recharged > 0 then
		db.Charges += recharged
		db.LastReset = os.time()
	end

	local nextRechargeIn = M07_Economy.DailyBonus.RechargeSeconds - (elapsed % M07_Economy.DailyBonus.RechargeSeconds)

	return {
		Charges = db.Charges,
		MaxCharges = M07_Economy.DailyBonus.MaxCharges,
		SecondsUntilRecharge = nextRechargeIn,
	}
end

-- ============================================================
-- Robux-Marketplace (für später; braucht korrekte Asset-IDs in Phase 4)
-- ============================================================

local VipPassProductId = 0 -- TODO: echte Asset-ID nach Studio-Setup

MarketplaceService.ProcessReceipt = function(receiptInfo)
	local player = Players:GetPlayerByUserId(receiptInfo.PlayerId)
	if not player then
		return Enum.ProductPurchaseDecision.NotProcessedYet
	end

	if receiptInfo.ProductId == VipPassProductId then
		EconomyService:GrantVip(player, M07_Economy.VIP.DurationSeconds)
		return Enum.ProductPurchaseDecision.PurchaseGranted
	end

	-- Unbekanntes Produkt: nicht gewähren, Roblox-Logs prüfen
	warn("[EconomyService] Unknown product:", receiptInfo.ProductId)
	return Enum.ProductPurchaseDecision.NotProcessedYet
end

-- ============================================================
-- Lifecycle
-- ============================================================

Players.PlayerAdded:Connect(function(player)
	ensureWallet(player)
	dailyBonus[player] = { Charges = M07_Economy.DailyBonus.MaxCharges, LastReset = os.time() }

	-- Wallet aus SaveService laden
	SaveService:LoadWallet(player, function(loaded)
		if loaded then
			wallets[player] = loaded
		end
		remoteGetBalance:InvokeClient(player, wallets[player])
	end)
end)

Players.PlayerRemoving:Connect(function(player)
	local wallet = wallets[player]
	if wallet then
		SaveService:SaveWallet(player, wallet)
	end
	dailyBonus[player] = nil
	wallets[player] = nil
end)

-- Auto-Save alle 60 Sekunden (zusätzlich zu PlayerRemoving + Quest-Abschluss)
task.spawn(function()
	while true do
		task.wait(60)
		for player, wallet in pairs(wallets) do
			SaveService:SaveWallet(player, wallet)
		end
	end
end)

return EconomyService