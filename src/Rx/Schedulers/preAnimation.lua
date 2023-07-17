--!strict

local RunService = game:GetService("RunService")

local package = script:FindFirstAncestor("Rx")
local T = require(package.T)

--[=[

Returns a Scheduler that is fired by RunService.PreAnimation.

]=]
local function preAnimation(): T.Scheduler<>
	return function(worker: T.Worker<>): T.Subscription
		local conn = RunService.PreAnimation:Connect(worker)
		return function()
			conn:Disconnect()
		end
	end
end

return preAnimation
