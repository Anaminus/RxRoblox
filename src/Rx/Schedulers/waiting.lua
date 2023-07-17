--!strict

local package = script:FindFirstAncestor("Rx")
local T = require(package.T)

--[=[

Returns a Scheduler that waits *time* seconds before firing.

@param time -- Number of seconds to wait between intervals.

]=]
local function waiting(time: number): T.Scheduler<>
	return function(worker: T.Worker<>): T.Subscription
		local thread = task.spawn(function()
			while true do
				local dt = task.wait(time)
				worker(dt)
			end
		end)
		return function()
			task.cancel(thread)
		end
	end
end

return waiting
