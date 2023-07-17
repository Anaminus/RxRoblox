--!strict

local RunService = game:GetService("RunService")

local package = script:FindFirstAncestor("Rx")
local T = require(package.T)

--[=[

Returns a Scheduler that is fired by RunService.PostSimulation.

]=]
local function postSimulation(): T.Scheduler<>
	return function(worker: T.Worker<>): T.Subscription
		local conn = RunService.PostSimulation:Connect(worker)
		return function()
			conn:Disconnect()
		end
	end
end

return postSimulation
