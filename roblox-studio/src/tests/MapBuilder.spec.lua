--!strict
--!nolint
return function()
	local MapBuilder = require(script.Parent.Parent.Modules.MapBuilder)

	local validMap = {
		Name = "TestMap",
		Layout = {
			{
				Name = "TestPart",
				ClassName = "Part",
				Properties = {
					Anchored = true,
					Position = Vector3.new(0, 5, 0),
					Size = Vector3.new(4, 1, 4),
				},
			},
		},
	}

	describe("MapBuilder.Validate", function()
		it("accepts a valid map", function()
			local ok, errs = MapBuilder:Validate(validMap)
			assert(ok, "expected ok, got errors: " .. table.concat(errs, ", "))
		end)

		it("flags missing Name", function()
			local bad = { Name = "", Layout = {} }
			local ok, errs = MapBuilder:Validate(bad)
			assert(not ok, "should fail")
			local found = false
			for _, e in ipairs(errs) do
				if e:find("name missing") then found = true end
			end
			assert(found, "expected name-missing error")
		end)

		it("flags missing Layout", function()
			local bad = { Name = "X", Layout = {} }
			local ok, errs = MapBuilder:Validate(bad)
			assert(not ok, "should fail empty layout")
		end)

		it("flags missing ClassName", function()
			local bad = { Name = "X", Layout = { { Name = "foo" } } }
			local ok, errs = MapBuilder:Validate(bad)
			assert(not ok, "should fail missing ClassName")
		end)

		it("flags non-Vector3 Position", function()
			local bad = {
				Name = "X",
				Layout = {
					{ Name = "p", ClassName = "Part",
					  Properties = { Position = { 0, 5, 0 }, Anchored = true, Size = Vector3.new(1,1,1) } },
				},
			}
			local ok, errs = MapBuilder:Validate(bad)
			assert(not ok, "should fail non-Vector3 position")
		end)

		it("flags Anchored=false for static Parts", function()
			local bad = {
				Name = "X",
				Layout = {
					{ Name = "p", ClassName = "Part",
					  Properties = { Anchored = false, Position = Vector3.new(0,0,0), Size = Vector3.new(1,1,1) } },
				},
			}
			local ok, errs = MapBuilder:Validate(bad)
			assert(not ok, "should flag Anchored=false")
		end)

		it("flags Material.Neon", function()
			local bad = {
				Name = "X",
				Layout = {
					{ Name = "p", ClassName = "Part",
					  Properties = { Material = Enum.Material.Neon, Anchored = true, Position = Vector3.new(0,0,0), Size = Vector3.new(1,1,1) } },
				},
			}
			local ok, errs = MapBuilder:Validate(bad)
			assert(not ok, "should flag Material.Neon")
		end)

		it("flags malformed MeshId", function()
			local bad = {
				Name = "X",
				Layout = {
					{ Name = "m", ClassName = "MeshPart",
					  Properties = { MeshId = "not-a-roblox-id", Anchored = true, Position = Vector3.new(0,0,0), Size = Vector3.new(1,1,1) } },
				},
			}
			local ok, errs = MapBuilder:Validate(bad)
			assert(not ok, "should flag malformed MeshId")
		end)

		it("flags NpcId not in whitelist", function()
			local bad = {
				Name = "X",
				Layout = {
					{ Name = "npc", ClassName = "Part",
					  Properties = { Anchored = true, Transparency = 1, Position = Vector3.new(0,0,0), Size = Vector3.new(1,1,1) },
					  Attributes = { NpcId = "Bob" } },
				},
			}
			local ok, errs = MapBuilder:Validate(bad)
			assert(not ok, "should flag unknown NpcId")
		end)

		it("flags QuestHook not in whitelist", function()
			local bad = {
				Name = "X",
				Layout = {
					{ Name = "q", ClassName = "MeshPart",
					  Properties = { MeshId = "rbxassetid://1", Anchored = true, Position = Vector3.new(0,0,0), Size = Vector3.new(1,1,1) },
					  Attributes = { QuestHook = "FAKE_QUEST" } },
				},
			}
			local ok, errs = MapBuilder:Validate(bad)
			assert(not ok, "should flag unknown QuestHook")
		end)

		it("flags Model without PrimaryPart", function()
			local bad = {
				Name = "X",
				Layout = {
					{ Name = "M", ClassName = "Model", Children = { { Name = "c", ClassName = "Part" } } },
				},
			}
			local ok, errs = MapBuilder:Validate(bad)
			assert(not ok, "should flag Model without PrimaryPart")
		end)

		it("accepts Model WITH PrimaryPart", function()
			local good = {
				Name = "X",
				Layout = {
					{ Name = "M", ClassName = "Model", PrimaryPart = "c",
					  Children = { { Name = "c", ClassName = "Part", Properties = { Anchored = true, Position = Vector3.new(0,0,0), Size = Vector3.new(1,1,1) } } } },
				},
			}
			local ok, errs = MapBuilder:Validate(good)
			assert(ok, "Model with PrimaryPart should pass: " .. table.concat(errs, ", "))
		end)

		it("flags duplicate Names in same parent", function()
			local bad = {
				Name = "X",
				Layout = {
					{ Name = "dup", ClassName = "Part" },
					{ Name = "dup", ClassName = "Part" },
				},
			}
			local ok, errs = MapBuilder:Validate(bad)
			assert(not ok, "should flag duplicate names")
		end)
	end)

	describe("MapBuilder.BuildInto", function()
		it("builds top-level children", function()
			local container = Instance.new("Folder")
			container.Name = "TestContainer"
			container.Parent = game:GetService("Workspace")
			MapBuilder:BuildInto(validMap, container)
			local found = container:FindFirstChild("TestPart")
			assert(found ~= nil, "TestPart should be built")
			container:Destroy()
		end)

		it("returns nil if container is nil", function()
			local result = MapBuilder:BuildInto(validMap, nil)
			assert(result == nil, "should return nil on nil container")
		end)
	end)
end
