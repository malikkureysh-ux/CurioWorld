--!strict
--[[
	MapInteractionService.spec.lua — Tests für Map ProximityPrompt-Handling
]]

return function()
	local MIS = require(script.Parent.Parent.parent.server.Services.MapInteractionService)

	describe("MapInteractionService — Init", function()
		it("should have Init method", function()
			expect(type(MIS.Init)).to.equal("function")
		end)

		it("should expose required RemoteEvents after init", function()
			MIS:Init()
			local rs = game:GetService("ReplicatedStorage")
			local folder = rs:FindFirstChild("MapInteractionRemotes")
			expect(folder ~= nil).to.equal(true)
			if folder then
				expect(folder:FindFirstChild("ShowDailyQuests")).to.be.a("userdata")
				expect(folder:FindFirstChild("QuestStarted")).to.be.a("userdata")
			end
		end)
	end)

	describe("MapInteractionService — ProximityPrompt Routing", function()
		-- Setup: erstelle ein Test-Map-Objekt mit ProximityPrompt
		it("should hook prompts with InteractType attribute", function()
			local testPart = Instance.new("Part")
			testPart.Name = "TestWorkbench"
			testPart.Anchored = true
			testPart:SetAttribute("InteractType", "QuestStart")
			testPart:SetAttribute("QuestHook", "HH_03_werft_boat")
			testPart.Parent = workspace

			local prompt = Instance.new("ProximityPrompt")
			prompt.ActionText = "Test"
			prompt.HoldDuration = 0
			prompt.Parent = testPart

			MIS:Init()

			-- Prompt sollte jetzt connected sein
			local connected = false
			for _, conn in ipairs(getconnections(prompt.Triggered)) do
				if conn.Connected then
					connected = true
					break
				end
			end
			expect(connected).to.equal(true)

			testPart:Destroy()
		end)

		it("should skip prompts without InteractType", function()
			local testPart = Instance.new("Part")
			testPart.Name = "TestDeco"
			testPart.Anchored = true
			testPart.Parent = workspace

			local prompt = Instance.new("ProximityPrompt")
			prompt.ActionText = "Just decorative"
			prompt.Parent = testPart

			MIS:Init()

			-- Sollte NICHT connected sein
			local connected = false
			for _, conn in ipairs(getconnections(prompt.Triggered)) do
				if conn.Connected then
					connected = true
					break
				end
			end
			expect(connected).to.equal(false)

			testPart:Destroy()
		end)
	end)
end