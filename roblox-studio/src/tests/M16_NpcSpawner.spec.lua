--!strict
--!nolint
return function()
	local M16 = require(script.Parent.Parent.Modules.M16_NpcSpawner)

	describe("M16 NpcSpawner", function()
		describe("Config", function()
			it("has all 4 NPCs defined", function()
				assert(M16.NpcConfig.Hafenwirtin, "Hafenwirtin missing")
				assert(M16.NpcConfig.Yuki, "Yuki missing")
				assert(M16.NpcConfig.Maja, "Maja missing")
				assert(M16.NpcConfig.Nils, "Nils missing")
			end)

			it("each NPC has DisplayName + DialogueKey + Role", function()
				for id, config in pairs(M16.NpcConfig) do
					assert(type(config.DisplayName) == "string", id .. " missing DisplayName")
					assert(type(config.DialogueKey) == "string", id .. " missing DialogueKey")
					assert(type(config.Role) == "string", id .. " missing Role")
				end
			end)
		end)

		describe("SpawnAll", function()
			it("returns empty table when no districts folder", function()
				local result = M16:SpawnAll(nil)
				assert(type(result) == "table", "should return table")
				local count = 0
				for _ in pairs(result) do count += 1 end
				assert(count == 0, "should be empty, got " .. count)
			end)

			it("returns empty table when no HamburgHarbor child", function()
				local districts = Instance.new("Folder")
				districts.Name = "Districts"
				districts.Parent = game:GetService("Workspace")
				local result = M16:SpawnAll(districts)
				local count = 0
				for _ in pairs(result) do count += 1 end
				assert(count == 0, "should be empty without HamburgHarbor")
				districts:Destroy()
			end)
		end)
	end)
end
