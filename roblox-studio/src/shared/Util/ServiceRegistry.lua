--!strict
--[[
	ServiceRegistry.lua — Roblox-idiomatic service location (refit v1.1)
	====================================================================

	Fixes from verifier audit (C-1):
	- Re-checks `services[name]` AFTER registering the waiter to close the
	  TOCTOU race between WaitFor and Register.
	- Uses pcall around coroutine.resume so a dead thread is silent.
	- Single coroutine.yield path; no double-spawn workaround.
]]

local ServiceRegistry = {}

export type ServiceMap = { [string]: any }

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

--[[
	WaitFor(name, timeoutSeconds?) — Blocks the current coroutine until
	`Register(name, ...)` has been called, or returns nil after the timeout.

	Race-free: registers itself as a waiter BEFORE the second check,
	so a Register that runs concurrently cannot be lost.
]]
function ServiceRegistry:WaitFor(name: string, timeoutSeconds: number?): any?
	local timeout = timeoutSeconds or 30

	-- Fast path: service already registered
	if services[name] then
		return services[name]
	end

	-- Register ourselves as a waiter
	local myThread = coroutine.running()
	waiters[name] = waiters[name] or {}
	table.insert(waiters[name], myThread)

	-- Re-check after registration: if Register ran between our fast-path
	-- check and our insert, we would otherwise be stuck.
	if services[name] then
		-- Remove our entry from the waiter list (best effort)
		local list = waiters[name]
		if list then
			for i, t in ipairs(list) do
				if t == myThread then
					table.remove(list, i)
					break
				end
			end
			if #list == 0 then
				waiters[name] = nil
			end
		end
		return services[name]
	end

	-- Watchdog: resume this thread on timeout
	task.spawn(function()
		local start = os.clock()
		while os.clock() - start < timeout do
			if services[name] then
				-- Service registered, Register will resume us
				return
			end
			task.wait(0.1)
		end
		-- Timeout: remove ourselves and resume with no value
		local list = waiters[name]
		if list then
			for i, t in ipairs(list) do
				if t == myThread then
					table.remove(list, i)
					break
				end
			end
			if #list == 0 then
				waiters[name] = nil
			end
		end
		-- pcall protects against dead thread / unyieldable
		pcall(function()
			if coroutine.status(myThread) ~= "dead" then
				task.spawn(myThread)
			end
		end)
	end)

	-- Block until resumed by Register or timeout watchdog
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

function ServiceRegistry:Clear()
	services = {}
	waiters = {}
end

return ServiceRegistry