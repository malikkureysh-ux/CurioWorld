--!strict
--[[
    Beispiel-Server-Script.
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HelloWorld = require(ReplicatedStorage.Shared.HelloWorld)

print(HelloWorld.greet("Roblox Dev"))
print("2 + 3 =", HelloWorld.add(2, 3))