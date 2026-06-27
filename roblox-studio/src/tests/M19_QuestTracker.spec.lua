--!strict
--!nolint
--[[
	M19_QuestTracker.spec.lua — TestEZ-Specs für Quest-Tracker Panel
	================================================================

	Tests:
	- Theme-Tokens
	- MaxVisibleQuests = 3
	- OnQuestClicked/OnMoreClicked Callback-Slots
]]

return function()
	local M19 = require(script.Parent.Parent.Modules.M19_QuestTracker)

	describe("M19_QuestTracker.Theme", function()
		it("defines BackgroundColor + BorderColor", function()
			assert(typeof(M19.Theme.BackgroundColor) == "Color3")
			assert(typeof(M19.Theme.BorderColor) == "Color3")
		end)

		it("defines Quest state colors (Idle/Active/Complete)", function()
			assert(typeof(M19.Theme.QuestIdle) == "Color3", "QuestIdle missing")
			assert(typeof(M19.Theme.QuestActive) == "Color3", "QuestActive missing")
			assert(typeof(M19.Theme.QuestComplete) == "Color3", "QuestComplete missing")
		end)

		it("defines UI geometry (CornerRadius/BorderThickness)", function()
			assert(typeof(M19.Theme.CornerRadius) == "UDim")
			assert(type(M19.Theme.BorderThickness) == "number")
		end)
	end)

	describe("M19_QuestTracker Limits", function()
		it("sets MaxVisibleQuests to 3", function()
			assert(M19.Theme.MaxVisibleQuests == 3,
				"MaxVisibleQuests must be 3, got " .. tostring(M19.Theme.MaxVisibleQuests))
		end)

		it("uses short TweenDuration (≤ 0.5s) for snappy feel", function()
			assert(type(M19.Theme.TweenDuration) == "number")
			assert(M19.Theme.TweenDuration > 0
				and M19.Theme.TweenDuration <= 0.5,
				"TweenDuration should be snappy")
		end)
	end)

	describe("M19_QuestTracker Callback Slots", function()
		it("exposes OnQuestClicked slot (nil by default)", function()
			-- Slot exists as field; may be nil before wiring
			assert(M19.OnQuestClicked == nil or type(M19.OnQuestClicked) == "function",
				"OnQuestClicked must be nil or function")
		end)

		it("exposes OnMoreClicked slot (nil by default)", function()
			assert(M19.OnMoreClicked == nil or type(M19.OnMoreClicked) == "function",
				"OnMoreClicked must be nil or function")
		end)

		it("allows assigning callbacks at runtime", function()
			local called = false
			local orig = M19.OnQuestClicked
			M19.OnQuestClicked = function() called = true end
			assert(type(M19.OnQuestClicked) == "function")
			M19.OnQuestClicked()
			assert(called, "Assigned callback should be invokable")
			M19.OnQuestClicked = orig -- restore
		end)
	end)

	describe("M19_QuestTracker Public API", function()
		it("exposes CreateForPlayer + Update as functions", function()
			assert(type(M19.CreateForPlayer) == "function")
			assert(type(M19.Update) == "function")
		end)
	end)
end