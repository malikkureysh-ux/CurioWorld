--!strict
--[[
	ServiceRegistry.lua — Proper service-location pattern (replaces _G usage)
	========================================================================

	Roblox-idiomatic way to share service instances between server and client
	without using `_G` (which Selene flags as anti-pattern).

	Usage (server):
		local Registry = require(ServerScriptService.ServiceRegistry)
		Registry:Register("Economy", EconomyService)
		Registry:Get("Economy"):AddGold(player, 100)

	Usage (client):
		local Registry = require(ReplicatedStorage.ServiceRegistry)
		Registry:WaitFor("Economy", 30) -- 30s timeout
		local svc = Registry:Get("Economy")
]]

local ServiceRegistry = {}

export type ServiceMap = { [string]: any }

-- Internal state
local services: ServiceMap = {}
local waiters: { [string]: { thread } } = {}

-- ============================================================
-- Public API
-- ============================================================

function ServiceRegistry:Register(name: string, service: any)
	assert(type(name) == "string", "Service name must be a string")
	assert(service ~= nil, "Service cannot be nil")
	services[name] = service

	-- Wake up all threads waiting for this service
	local list = waiters[name]
	if list then
		for _, thread in ipairs(list) do
			task.spawn(thread)
		end
		waiters[name] = nil
	end
end

function ServiceRegistry:Get(name: string): any?
	return services[name]
end

function ServiceRegistry:WaitFor(name: string, timeoutSeconds: number?): any
	local timeout = timeoutSeconds or 30
	if services[name] then
		return services[name]
	end

	-- Add to waiters
	waiters[name] = waiters[name] or {}
	local myThread = coroutine.running()
	table.insert(waiters[name], myThread)

	-- Spawn a watchdog that resumes the waiter after the service is registered
	-- OR after the timeout expires (whichever comes first).
	task.spawn(function()
		local start = os.clock()
		while os.clock() - start < timeout do
			if services[name] then
				return
			end
			task.wait(0.1)
		end
		-- Timeout
		warn(string.format("[ServiceRegistry] Timeout waiting for service: %s", name))
		if coroutine.status(myThread) ~= "dead" then
			task.spawn(function()
				-- Resume with no value (caller should check)
				if coroutine.status(myThread) ~= "dead" then
					coroutine.resume(myThread)
				end
			end)
		end
	end)

	-- Yield this thread; will be resumed when service is registered or timeout fires
	coroutine.yield()

	return services[name]
end

function ServiceRegistry:Has(name: string): boolean
	return services[name] ~= nil
end

function ServiceRegistry:List(): { string }
	local out = {}
	for name, _ in pairs(services) do
		table.insert(out, name)
	end
	table.sort(out)
	return out
end

-- ============================================================
-- Debug
-- ============================================================

function ServiceRegistry:Clear()
	services = {}
	waiters = {}
end

return ServiceRegistry