--!strict
--!nolint
-- TestEZ globals provided by Roblox TestEZ. TestRunner catches missing TestEZ.

return function()
	local M02 = require(script.Parent.Parent.Modules.M02_Quest)

	-- Mock WorldServices for tests
	local function makeWorld(opts)
		opts = opts or {}
		return {
			hasTalkedToNpc = opts.hasTalkedToNpc or function() return false end,
			hasItem = opts.hasItem or function() return false end,
			hasRecentEvent = opts.hasRecentEvent or function() return false end,
			isInZone = opts.isInZone or function() return false end,
			hasSolvedPuzzle = opts.hasSolvedPuzzle or function() return false end,
			hasBuilt = opts.hasBuilt or function() return false end,
			allTeamDone = opts.allTeamDone or function() return false end,
		}
	end

	local fakePlayer = { UserId = 12345 }

	describe("M02 Quest", function()
		describe("StartQuest", function()
			it("returns nil for unknown quest", function()
				local result = M02:StartQuest(fakePlayer, "NONEXISTENT_QUEST")
				assert(result == nil, "should return nil for unknown quest")
			end)

			it("returns QuestProgress for known quest", function()
				local progress = M02:StartQuest(fakePlayer, "HH_01_kran_intro")
				assert(progress ~= nil, "should return progress")
				assert(progress.quest_id == "HH_01_kran_intro", "wrong quest_id")
				assert(progress.current_step == 1, "should start at step 1")
				assert(progress.pid == "12345", "pid should be UserId as string")
			end)

			it("respects initial state parameter", function()
				local progress = M02:StartQuest(fakePlayer, "HH_01_kran_intro", { foo = "bar" })
				assert(progress.state.foo == "bar", "state not preserved")
			end)
		end)

		describe("EvaluateStep", function()
			it("returns false when world services missing", function()
				local progress = M02:StartQuest(fakePlayer, "HH_01_kran_intro")
				local ok, reason = M02:EvaluateStep(fakePlayer, progress, nil)
				assert(ok == false, "should fail without world")
				assert(type(reason) == "string", "should give reason string")
			end)

			it("dialogue step requires hasTalkedToNpc", function()
				local progress = M02:StartQuest(fakePlayer, "HH_01_kran_intro")
				local world1 = makeWorld({ hasTalkedToNpc = function(_, id) return id == "Hafenwirtin" end })
				local ok1 = M02:EvaluateStep(fakePlayer, progress, world1)
				assert(ok1 == true, "should complete step_1 (Hafenwirtin talked)")

				-- Now advance and check step_2 (CraneTutorial puzzle)
				M02:AdvanceStep(progress)
				local world2 = makeWorld({ hasSolvedPuzzle = function(_, id) return id == "CraneTutorial" end })
				local ok2 = M02:EvaluateStep(fakePlayer, progress, world2)
				assert(ok2 == true, "should complete step_2 (CraneTutorial solved)")
			end)

			it("objective step checks isInZone with QuestZones lookup", function()
				local progress = M02:StartQuest(fakePlayer, "HH_02_crane_firstlift")
				-- Step 2: ContainerPickupA
				M02:AdvanceStep(progress)
				local zone = M02:GetZone("ContainerPickupA")
				assert(zone ~= nil, "QuestZones should have ContainerPickupA")
				local world = makeWorld({
					isInZone = function(_, center, radius)
						return (center - Vector3.new(-25, 6, 15)).Magnitude < radius
					end,
				})
				local ok = M02:EvaluateStep(fakePlayer, progress, world)
				assert(ok == true, "should complete objective in zone")
			end)

			it("collect step requires count", function()
				local progress = M02:StartQuest(fakePlayer, "HH_03_werft_boat")
				local world = makeWorld({ hasItem = function(_, id, count) return count >= 4 end })
				local ok, reason = M02:EvaluateStep(fakePlayer, progress, world)
				assert(ok == true, "should complete collect: " .. tostring(reason))
			end)
		end)

		describe("AdvanceStep / Complete", function()
			it("increment current_step", function()
				local progress = M02:StartQuest(fakePlayer, "HH_01_kran_intro")
				assert(progress.current_step == 1)
				M02:AdvanceStep(progress)
				assert(progress.current_step == 2)
				M02:AdvanceStep(progress)
				assert(progress.current_step == 3)
			end)

			it("Complete sets completed_at timestamp", function()
				local progress = M02:StartQuest(fakePlayer, "HH_01_kran_intro")
				assert(progress.completed_at == nil, "should not be completed yet")
				M02:Complete(progress)
				assert(progress.completed_at ~= nil, "completed_at should be set")
				assert(type(progress.completed_at) == "number", "completed_at should be number")
			end)
		end)
	end)
end
