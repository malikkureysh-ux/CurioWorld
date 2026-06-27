--!strict
--[[
    Beispiel-ModuleScript: Demonstriert Type-Annotations und Module-Struktur.
    Wird von Rojo nach ReplicatedStorage.Shared.HelloWorld synchronisiert.
]]

local HelloWorld = {}

function HelloWorld.greet(name: string): string
    return `Hello, {name}!`
end

function HelloWorld.add(a: number, b: number): number
    return a + b
end

return HelloWorld