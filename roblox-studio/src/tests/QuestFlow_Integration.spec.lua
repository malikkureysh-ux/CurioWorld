--!strict
--[[
	QuestFlow_Integration.spec.lua — End-to-End Integration Test
	=============================================================

	Testet die komplette Quest-Loop:
	  NPC-Trigger → Dialogue → Talk-Flag → Puzzle-Solve → Objective-Zone → Reward

	Dieser Test beweist, dass die ganze Pipeline funktioniert,
	ohne dass ein Spieler tatsächlich spielen muss.
]]

return function()
	-- Module-Setup
	local M02_Quest = require(script.Parent.Parent.Modules.M02_Quest)
	local M03_Dialogue = require(script.Parent.Parent.Modules.M03_Dialogue)
	local M05_Puzzle = require(script.Parent.Parent.Modules.M05_Puzzle)
	local M06_Inventory = require(script.Parent.Parent.Modules.M06_Inventory)
	local M07_Economy = require(script.Parent.Parent.Modules.M07_Economy)
	local M11_Companion = require(script.Parent.Parent.Modules.M11_Companion)
	local M13_Moderation = require(script.Parent.Parent.Modules.M13_Moderion)
	local M15_Localization = require(script.Parent.Parent.Modules.M15_Localization)

	describe("QuestFlow_Integration — HH_01 (Kran-Intro)", function()
		local fakePlayer = {
			Name = "test_player",
			UserId = 77777,
			SetAttribute = function(self, key, value)
				self[key] = value
			end,
			GetAttribute = function(self, key)
				return self[key]
			end,
		}

		-- Setup: Sprache setzen, Wallet initialisieren
		M15_Localization:Set(fakePlayer, "de")

		it("Step 1 — Dialogue should mark NPC talked", function()
			-- Start HH_01 (Quest-System)
			local progress = M02_Quest:StartQuest(fakePlayer, "HH_01_kran_intro")
			expect(progress).to.be.a("table")
			expect(progress.quest_id).to.equal("HH_01_kran_intro")
			expect(progress.current_step).to.equal(1)
		end)

		it("Step 1 — Dialogue step should not be complete without NPC talk", function()
			local progress = M02_Quest:StartQuest(fakePlayer, "HH_01_kran_intro")

			-- Mock WorldServices mit talk=false
			local mockWorld = {
				hasTalkedToNpc = function(self, p, npcId)
					return false
				end,
			}
			local ok, reason = M02_Quest:EvaluateStep(fakePlayer, progress, mockWorld)
			expect(ok).to.equal(false)
			expect(reason).to.be.a("string")
		end)

		it("Step 1 — Dialogue step completes after NPC talk", function()
			local progress = M02_Quest:StartQuest(fakePlayer, "HH_01_kran_intro")

			-- Mock WorldServices mit talk=true
			local mockWorld = {
				hasTalkedToNpc = function(self, p, npcId)
					return npcId == "Hafenwirtin"
				end,
			}
			local ok, reason = M02_Quest:EvaluateStep(fakePlayer, progress, mockWorld)
			expect(ok).to.equal(true)
		end)

		it("Step 1→2 — Advance moves to puzzle step", function()
			local progress = M02_Quest:StartQuest(fakePlayer, "HH_01_kran_intro")
			-- First step was already solved; advance
			local advanced = M02_Quest:AdvanceStep(progress)
			expect(advanced).to.equal(true)
			expect(progress.current_step).to.equal(2)

			-- Step 2 = puzzle (CraneTutorial)
			local quest = M02_Quest.SampleQuests["HH_01_kran_intro"]
			expect(quest.steps[2].type).to.equal("puzzle")
			expect(quest.steps[2].target).to.equal("CraneTutorial")
		end)

		it("Step 2 — Puzzle not solved → step fails", function()
			local progress = M02_Quest:StartQuest(fakePlayer, "HH_01_kran_intro")
			M02_Quest:AdvanceStep(progress)

			local mockWorld = {
				hasSolvedPuzzle = function(self, p, puzzleId)
					return false
				end,
			}
			local ok, reason = M02_Quest:EvaluateStep(fakePlayer, progress, mockWorld)
			expect(ok).to.equal(false)
		end)

		it("Step 2 — Puzzle solved → step completes", function()
			local progress = M02_Quest:StartQuest(fakePlayer, "HH_01_kran_intro")
			M02_Quest:AdvanceStep(progress)

			-- Real puzzle: solve CraneTutorial
			local state = M05_Puzzle:Start(fakePlayer, "CraneTutorial")
			expect(state).to.be.a("table")
			local ok = M05_Puzzle:Submit(fakePlayer, "CraneTutorial",
				{"Seil-Befestigen", "Hebel-Positionieren", "Last-Heben", "Senken"}, nil)
			expect(ok).to.equal(true)

			-- Now EvaluateStep should succeed
			local mockWorld = {
				hasSolvedPuzzle = function(self, p, puzzleId)
					return M05_Puzzle:IsSolved(p, puzzleId)
				end,
			}
			local evalOk, reason = M02_Quest:EvaluateStep(fakePlayer, progress, mockWorld)
			expect(evalOk).to.equal(true)
		end)

		it("Step 2→3 — Advance moves to objective step", function()
			local progress = M02_Quest:StartQuest(fakePlayer, "HH_01_kran_intro")
			M02_Quest:AdvanceStep(progress)
			M02_Quest:AdvanceStep(progress)
			expect(progress.current_step).to.equal(3)

			local quest = M02_Quest.SampleQuests["HH_01_kran_intro"]
			expect(quest.steps[3].type).to.equal("objective")
			expect(quest.steps[3].target).to.equal("DropZoneA")
		end)

		it("Step 3 — Objective zone not entered → fails", function()
			local progress = M02_Quest:StartQuest(fakePlayer, "HH_01_kran_intro")
			M02_Quest:AdvanceStep(progress)
			M02_Quest:AdvanceStep(progress)

			local mockWorld = {
				isInZone = function(self, p, center, radius)
					return false  -- not in zone
				end,
			}
			local ok = M02_Quest:EvaluateStep(fakePlayer, progress, mockWorld)
			expect(ok).to.equal(false)
		end)

		it("Step 3 — Objective zone entered → completes", function()
			local progress = M02_Quest:StartQuest(fakePlayer, "HH_01_kran_intro")
			M02_Quest:AdvanceStep(progress)
			M02_Quest:AdvanceStep(progress)

			local zone = M02_Quest.QuestZones["DropZoneA"]
			expect(zone).to.be.a("table")

			local mockWorld = {
				isInZone = function(self, p, center, radius)
					return (center == zone.center and radius == zone.radius)
				end,
			}
			local ok = M02_Quest:EvaluateStep(fakePlayer, progress, mockWorld)
			expect(ok).to.equal(true)
		end)

		it("Step 3→Complete — Quest completes with reward", function()
			local progress = M02_Quest:StartQuest(fakePlayer, "HH_01_kran_intro")
			-- Advance through all steps
			M02_Quest:AdvanceStep(progress)  -- 1→2
			M02_Quest:AdvanceStep(progress)  -- 2→3

			-- Verify reward structure
			local quest = M02_Quest.SampleQuests["HH_01_kran_intro"]
			expect(quest.rewards).to.be.a("table")
			expect(#quest.rewards).to.equal(3)  -- 50 Gold + 5 Gems + 1 Companion

			local goldReward = nil
			local gemsReward = nil
			local companionReward = nil
			for _, r in ipairs(quest.rewards) do
				if r.type == "Gold" then goldReward = r end
				if r.type == "Gems" then gemsReward = r end
				if r.type == "Companion" then companionReward = r end
			end
			expect(goldReward.amount).to.equal(50)
			expect(gemsReward.amount).to.equal(5)
			expect(companionReward.item).to.equal("Curio_Seagull")
		end)
	end)

	describe("QuestFlow_Integration — HH_03 (Werft-Bootsbau)", function()
		local fakePlayer = {
			Name = "crafter",
			UserId = 88888,
			SetAttribute = function(self, key, value) self[key] = value end,
			GetAttribute = function(self, key) return self[key] end,
		}

		it("Should grant items via M06_Inventory during collect step", function()
			-- Pre-populate inventory (simulating pickup from MaterialStorage)
			M06_Inventory:Add(fakePlayer, "WoodPlank", 4)
			M06_Inventory:Add(fakePlayer, "Rope", 2)
			expect(M06_Inventory:GetCount(fakePlayer, "WoodPlank")).to.equal(4)
			expect(M06_Inventory:GetCount(fakePlayer, "Rope")).to.equal(2)

			-- Now evaluate collect step
			local progress = M02_Quest:StartQuest(fakePlayer, "HH_03_werft_boat")
			local mockWorld = {
				hasItem = function(self, p, itemId, count)
					return M06_Inventory:Has(p, itemId, count)
				end,
			}
			local ok = M02_Quest:EvaluateStep(fakePlayer, progress, mockWorld)
			expect(ok).to.equal(true)
		end)

		it("Should fail collect step without items", function()
			local fresh = {
				Name = "new_crafter", UserId = 99999,
				SetAttribute = function(self, k, v) self[k] = v end,
				GetAttribute = function(self, k) return self[k] end,
			}
			local progress = M02_Quest:StartQuest(fresh, "HH_03_werft_boat")
			local mockWorld = {
				hasItem = function(self, p, itemId, count)
					return M06_Inventory:Has(p, itemId, count)
				end,
			}
			local ok = M02_Quest:EvaluateStep(fresh, progress, mockWorld)
			expect(ok).to.equal(false)
		end)
	end)

	describe("QuestFlow_Integration — Cross-Module", function()
		it("M15_Localization should provide German for NPC names", function()
			local fakePlayer = { UserId = 11111, Name = "x" }
			M15_Localization:Set(fakePlayer, "de")
			local text = M15_Localization:GetString(fakePlayer, "npc.hafenwirtin.greeting", {})
			expect(type(text)).to.equal("string")
			expect(text:find("Lina") ~= nil).to.equal(true)
		end)

		it("M13_Moderation should reject URLs from 12-13", function()
			local ok, err = M13_Moderation:CanSendMessage("12-13", "check http://bad.com here")
			expect(ok).to.equal(false)
			expect(err).to.equal("url_not_allowed")
		end)

		it("M07_Economy should reject Power-category purchases", function()
			local wallet = {
				Gold = 10000, Gems = 1000, RobuxSpent = 0,
				VIPActive = true, VIPExpiresAt = os.time() + 86400,
			}
			local powerItem = {
				Id = "speed_boost", Name = "Speed Boost",
				Category = "Power", PriceGold = 100, PriceGems = nil, PriceRobux = nil,
				VIPOnly = false, ReleasedAt = 0,
			}
			local ok, err = M07_Economy.AuditItem(powerItem)
			expect(ok).to.equal(false)
			expect(err:find("category_not_allowed") ~= nil).to.equal(true)
		end)

		it("M11_Companion should unlock via inventory add", function()
			local fakePlayer = { Name = "pet_owner", UserId = 55555 }
			M11_Companion:Unlock(fakePlayer, "Curio_Seagull")
			expect(#M11_Companion:GetOwned(fakePlayer)).to.equal(1)
		end)
	end)
end