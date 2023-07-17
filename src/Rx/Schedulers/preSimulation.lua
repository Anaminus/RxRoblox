--!strict

local RunService = game:GetService("RunService")

local package = script:FindFirstAncestor("Rx")
local T = require(package.T)

--[=[

Returns a Scheduler that is fired by RunService.PreSimulation.

]=]
local function preSimulation(): T.Scheduler<>
	return function(worker: T.Worker<>): T.Subscription
		local conn = RunService.PreSimulation:Connect(worker)
		return function()
			conn:Disconnect()
		end
	end
end

return preSimulation
