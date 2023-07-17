--!strict

local RunService = game:GetService("RunService")

local package = script:FindFirstAncestor("Rx")
local T = require(package.T)

--[=[

Returns a Scheduler that is fired by RunService.PreRender.

]=]
local function preRender(): T.Scheduler<>
	return function(worker: T.Worker<>): T.Subscription
		local conn = RunService.PreRender:Connect(worker)
		return function()
			conn:Disconnect()
		end
	end
end

return preRender
