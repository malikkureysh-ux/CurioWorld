--!strict
--!nolint
return function()
	local MapBuilder = require(script.Parent.Parent.Modules.MapBuilder)
	local HamburgHarborMap = require(script.Parent.Parent.Data.hamburg_harbor_map)

	describe("hamburg_harbor_map integration", function()
		it("parses successfully", function()
			assert(HamburgHarborMap ~= nil, "should not be nil")
			assert(HamburgHarborMap.Name == "HamburgHarbor", "wrong map name")
		end)

		it("has 8 top-level layout areas", function()
			local count = #HamburgHarborMap.Layout
			-- PlazaEntry, HarborBasin, CraneArea, Speicherhaus, Werft,
			-- LighthouseIsland, QuestBoards, Lanterns = 8
			assert(count == 8, "expected 8 top-level areas, got " .. count)
		end)

		it("Validate passes for the real Hamburg Harbor map", function()
			local ok, errs = MapBuilder:Validate(HamburgHarborMap)
			if not ok then
				error("Validate failed: " .. table.concat(errs, "\n"))
			end
		end)

		it("contains all 4 NPC spawn points (Hafenwirtin, Yuki, Maja, Nils)", function()
			local names = {}
			for _, area in ipairs(HamburgHarborMap.Layout) do
				for _, desc in ipairs(area.Children or {}) do
					if desc.Attributes and desc.Attributes.NpcId then
						names[desc.Attributes.NpcId] = true
					end
				end
			end
			assert(names.Hafenwirtin, "missing Hafenwirtin spawn")
			assert(names.Yuki, "missing Yuki spawn")
			assert(names.Maja, "missing Maja spawn")
			assert(names.Nils, "missing Nils spawn")
		end)

		it("contains 3 quest hooks (HH_01/HH_02/HH_03)", function()
			local hooks = {}
			for _, area in ipairs(HamburgHarborMap.Layout) do
				local function walk(node)
					if node.Attributes and node.Attributes.QuestHook then
						hooks[node.Attributes.QuestHook] = true
					end
					for _, child in ipairs(node.Children or {}) do
						walk(child)
					end
				end
				walk(area)
			end
			assert(hooks.HH_01_kran_intro, "missing HH_01 hook")
			assert(hooks.HH_02_crane_firstlift, "missing HH_02 hook")
			assert(hooks.HH_03_werft_boat, "missing HH_03 hook")
		end)

		it("CraneArea has 3 cranes (CraneA, CraneB, CraneC)", function()
			local craneArea = nil
			for _, area in ipairs(HamburgHarborMap.Layout) do
				if area.Name == "CraneArea" then craneArea = area end
			end
			assert(craneArea, "CraneArea not found")
			local craneNames = {}
			for _, child in ipairs(craneArea.Children) do
				if child.Name:match("^Crane") then craneNames[child.Name] = true end
			end
			assert(craneNames.CraneA, "missing CraneA")
			assert(craneNames.CraneB, "missing CraneB")
			assert(craneNames.CraneC, "missing CraneC")
		end)
	end)
end
