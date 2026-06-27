--!strict
--[[
    Beispiel-Test mit TestEZ.
    Wird später als Tests-Modul eingebunden.
]]

local HelloWorld = require(game:GetService("ReplicatedStorage").Shared.HelloWorld)

return function()
    describe("HelloWorld", function()
        it("should greet correctly", function()
            expect(HelloWorld.greet("World")).to.equal("Hello, World!")
        end)

        it("should add two numbers", function()
            expect(HelloWorld.add(2, 3)).to.equal(5)
        end)

        it("should handle zero", function()
            expect(HelloWorld.add(0, 0)).to.equal(0)
        end)
    end)
end