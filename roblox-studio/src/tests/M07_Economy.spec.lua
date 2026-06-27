--!strict
--[[
	M07_Economy.spec.lua — TestEZ-Specs für Economy-Modul
	======================================================

	Tests für die Compliance-kritischen Funktionen:
	- Kein Pay-to-Win (Power-Items ablehnen)
	- VIP-Pass bietet KEINEN Gameplay-Boost
	- Wallet-Berechnungen korrekt
	- Tages-Bonus korrekt (KEIN Stamina, immer Gold grant)
]]

-- Module loader (TestEZ-konform: require am Anfang)
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local M07_Economy = require(ReplicatedStorage.Shared.Modules.M07_Economy)

return function()
	describe("M07_Economy.AuditItem", function()
		it("should accept Cosmetic items", function()
			local item = {
				Id = "skin_red",
				Category = "Cosmetic",
				PriceRobux = 100,
			}
			local ok = M07_Economy:AuditItem(item)
			assert(ok, "Cosmetic should pass audit")
		end)

		it("should accept Comfort items", function()
			local item = { Id = "extra_slot", Category = "Comfort", PriceRobux = 50 }
			local ok = M07_Economy:AuditItem(item)
			assert(ok, "Comfort should pass audit")
		end)

		it("should accept Event items", function()
			local item = { Id = "event_ticket", Category = "Event", PriceRobux = 25 }
			local ok = M07_Economy:AuditItem(item)
			assert(ok, "Event should pass audit")
		end)

		it("should accept VIP items", function()
			local item = { Id = "vip_badge", Category = "VIP", PriceRobux = 0, VIPOnly = true }
			local ok = M07_Economy:AuditItem(item)
			assert(ok, "VIP should pass audit")
		end)

		it("should REJECT Power items (Pay-to-Win prevention)", function()
			local item = {
				Id = "speed_boost",
				Category = "Power",  -- not in allowed list
				PriceRobux = 100,
			}
			local ok, err = M07_Economy:AuditItem(item)
			assert(not ok, "Power item must be rejected")
			assert(string.find(err, "category_not_allowed"), "Error must mention category_not_allowed")
		end)

		it("should REJECT empty category", function()
			local item = { Id = "x", Category = "", PriceRobux = 10 }
			local ok = M07_Economy:AuditItem(item)
			assert(not ok, "Empty category must be rejected")
		end)

		it("should REJECT nil category", function()
			local item = { Id = "x", PriceRobux = 10 }
			local ok = M07_Economy:AuditItem(item)
			assert(not ok, "Nil category must be rejected")
		end)

		it("should REJECT negative prices (Robux)", function()
			local item = { Id = "exploit", Category = "Cosmetic", PriceRobux = -100 }
			local ok, err = M07_Economy:AuditItem(item)
			assert(not ok, "Negative Robux price must be rejected")
			assert(string.find(err, "negative_price_robux"), "Error must mention negative_price_robux")
		end)

		it("should REJECT negative prices (Gold)", function()
			local item = { Id = "exploit", Category = "Cosmetic", PriceGold = -50 }
			local ok, err = M07_Economy:AuditItem(item)
			assert(not ok, "Negative Gold price must be rejected")
			assert(string.find(err, "negative_price_gold"), "Error must mention negative_price_gold")
		end)

		it("should REJECT negative prices (Gems)", function()
			local item = { Id = "exploit", Category = "Cosmetic", PriceGems = -10 }
			local ok, err = M07_Economy:AuditItem(item)
			assert(not ok, "Negative Gems price must be rejected")
			assert(string.find(err, "negative_price_gems"), "Error must mention negative_price_gems")
		end)
	end)

	describe("M07_Economy.VIP compliance (C-002, C-007)", function()
		it("VIP should NOT grant XP boost", function()
			assert(M07_Economy.VIP.Benefits.XPBoost == nil,
				"VIP must not grant XP boost (C-002)")
		end)

		it("VIP should NOT grant Gold boost", function()
			assert(M07_Economy.VIP.Benefits.GoldBoost == nil,
				"VIP must not grant Gold boost (C-002)")
		end)

		it("VIP should NOT grant Gems boost", function()
			assert(M07_Economy.VIP.Benefits.GemsBoost == nil,
				"VIP must not grant Gems boost (C-002)")
		end)

		it("VIP should NOT grant Gameplay boost", function()
			assert(M07_Economy.VIP.Benefits.GameplayBoost == nil,
				"VIP must not grant Gameplay boost (C-002)")
		end)

		it("VIP should NOT refill Stamina (Stamina must not exist)", function()
			assert(M07_Economy.VIP.Benefits.StaminaRefill == nil,
				"VIP must not refill Stamina (C-002, C-007)")
		end)

		it("VIP should NOT allow Story Skip", function()
			assert(M07_Economy.VIP.Benefits.StorySkip == nil,
				"VIP must not allow Story Skip (C-002)")
		end)

		it("VIP should NOT allow Learning Task Skip", function()
			assert(M07_Economy.VIP.Benefits.LearningTaskSkip == nil,
				"VIP must not allow Learning Task Skip (C-002)")
		end)

		it("VIP benefits list should be in forbidden list as documentation", function()
			for _, forbidden in ipairs(M07_Economy.VIP.ForbiddenBenefits) do
				assert(M07_Economy.VIP.Benefits[forbidden] == nil,
					"VIP.ForbiddenBenefits[" .. forbidden .. "] must not be granted")
			end
		end)
	end)

	describe("M07_Economy.CanAfford", function()
		it("should accept when Gold is sufficient", function()
			local item = { Id = "skin", Category = "Cosmetic", PriceGold = 100 }
			local wallet = {
				Gold = 200, Gems = 0, RobuxSpent = 0,
				VIPActive = false, VIPExpiresAt = 0,
			}
			local ok = M07_Economy:CanAfford(wallet, item)
			assert(ok, "Should be affordable with enough Gold")
		end)

		it("should accept when Gems are sufficient", function()
			local item = { Id = "premium_skin", Category = "Cosmetic", PriceGems = 50 }
			local wallet = {
				Gold = 0, Gems = 200, RobuxSpent = 0,
				VIPActive = false, VIPExpiresAt = 0,
			}
			local ok = M07_Economy:CanAfford(wallet, item)
			assert(ok, "Should be affordable with enough Gems")
		end)

		it("should reject when Gold is insufficient", function()
			local item = { Id = "skin", Category = "Cosmetic", PriceGold = 100 }
			local wallet = {
				Gold = 50, Gems = 0, RobuxSpent = 0,
				VIPActive = false, VIPExpiresAt = 0,
			}
			local ok, reason = M07_Economy:CanAfford(wallet, item)
			assert(not ok, "Should not be affordable with insufficient Gold")
			assert(reason == "not_enough_gold")
		end)

		it("should reject when Gems are insufficient", function()
			local item = { Id = "skin", Category = "Cosmetic", PriceGems = 100 }
			local wallet = {
				Gold = 0, Gems = 50, RobuxSpent = 0,
				VIPActive = false, VIPExpiresAt = 0,
			}
			local ok, reason = M07_Economy:CanAfford(wallet, item)
			assert(not ok)
			assert(reason == "not_enough_gems")
		end)

		it("should reject VIP-only items when not VIP", function()
			local item = { Id = "vip_skin", Category = "Cosmetic", PriceRobux = 0, VIPOnly = true }
			local wallet = {
				Gold = 9999, Gems = 9999, RobuxSpent = 0,
				VIPActive = false, VIPExpiresAt = 0,
			}
			local ok, reason = M07_Economy:CanAfford(wallet, item)
			assert(not ok)
			assert(reason == "vip_required")
		end)

		it("should accept VIP-only items when VIP active", function()
			local item = { Id = "vip_skin", Category = "Cosmetic", PriceRobux = 0, VIPOnly = true }
			local future = os.time() + 86400
			local wallet = {
				Gold = 100, Gems = 0, RobuxSpent = 0,
				VIPActive = true, VIPExpiresAt = future,
			}
			local ok = M07_Economy:CanAfford(wallet, item)
			assert(ok, "Should be affordable with active VIP")
		end)
	end)

	describe("M07_Economy.DailyBonus (Anti-Frust, C-007)", function()
		it("should NOT be a Stamina/Energy consumption resource", function()
			-- Real assertion: a Stamina system would define a Stamina field.
			-- Verify no Stamina/Energy field exists anywhere in the module.
			assert(M07_Economy.Stamina == nil, "Stamina field must not exist (C-007)")
			assert(M07_Economy.Energy == nil, "Energy field must not exist (C-007)")
			assert(M07_Economy.DailyBonus.MaxCharges == 3,
				"Daily bonus should have 3 max charges, not energy-like unlimited value")
			assert(M07_Economy.DailyBonus.GoldMultiplier > 1,
				"Daily bonus should multiply reward, not consume resource")
		end)

		it("Gold multiplier should match spec (20%, not 50%)", function()
			-- D-010 spec: 20% bonus; 50% was a draft error
			assert(M07_Economy.DailyBonus.GoldMultiplier == 1.2,
				"GoldMultiplier must be 1.2 (20%), matching D-010_currency.md")
		end)
	end)

	describe("M07_Economy.IsVipActive", function()
		it("should return true for active VIP", function()
			local future = os.time() + 86400
			local wallet = { VIPActive = true, VIPExpiresAt = future }
			assert(M07_Economy:IsVipActive(wallet, os.time()) == true)
		end)

		it("should return false for expired VIP", function()
			local past = os.time() - 86400
			local wallet = { VIPActive = true, VIPExpiresAt = past }
			assert(M07_Economy:IsVipActive(wallet, os.time()) == false)
		end)

		it("should return false for inactive VIP", function()
			local wallet = { VIPActive = false, VIPExpiresAt = 0 }
			assert(M07_Economy:IsVipActive(wallet, os.time()) == false)
		end)
	end)
end