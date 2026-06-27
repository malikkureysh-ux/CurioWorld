--!strict
--[[
	M07_Economy.spec.lua — TestEZ-Specs für Economy-Modul
	======================================================

	Tests für die Compliance-kritischen Funktionen:
	- Kein Pay-to-Win (Power-Items ablehnen)
	- VIP-Pass bietet KEINEN Gameplay-Boost
	- Wallet-Berechnungen korrekt
	- Tages-Bonus korrekt (KEIN Stamina)
]]

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

		it("should REJECT negative prices", function()
			local item = {
				Id = "exploit",
				Category = "Cosmetic",
				PriceRobux = -100,
			}
			local ok, err = M07_Economy:AuditItem(item)
			assert(not ok, "Negative price must be rejected")
		end)
	end)

	describe("M07_Economy.VIP compliance", function()
		it("VIP should NOT grant XP boost", function()
			assert(M07_Economy.VIP.Benefits.XPBoost == nil,
				"VIP must not grant XP boost (C-002)")
		end)

		it("VIP should NOT grant Gold boost", function()
			assert(M07_Economy.VIP.Benefits.GoldBoost == nil,
				"VIP must not grant Gold boost (C-002)")
		end)

		it("VIP should NOT grant Gameplay boost", function()
			assert(M07_Economy.VIP.Benefits.GameplayBoost == nil,
				"VIP must not grant Gameplay boost (C-002)")
		end)

		it("VIP should NOT refill Stamina (Stamina must not exist)", function()
			assert(M07_Economy.VIP.Benefits.StaminaRefill == nil,
				"VIP must not refill Stamina (C-002, C-007)")
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
	end)

	describe("M07_Economy.DailyBonus (Anti-Frust)", function()
		it("should NOT be a Stamina/Energy consumption resource", function()
			-- DailyBonus is a REWARD boost, not a consumption resource.
			-- Verify it's not misused as energy.
			assert(M07_Economy.DailyBonus.MaxCharges == 3,
				"Daily bonus should have 3 max charges, not energy-like unlimited value")
			assert(M07_Economy.DailyBonus.GoldMultiplier > 1,
				"Daily bonus should multiply reward, not consume resource")
		end)
	end)
end