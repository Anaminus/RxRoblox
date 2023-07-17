--!strict

local RunService = game:GetService("RunService")

local package = script:FindFirstAncestor("Rx")
local T = require(package.T)

--[=[

Returns a Scheduler that is fired by RunService.Stepped.

]=]
local function stepped(): T.Scheduler<>
	return function(worker: T.Worker<>): T.Subscription
		local conn = RunService.Stepped:Connect(worker)
		return function()
			conn:Disconnect()
		end
	end
end

return stepped
