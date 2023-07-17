--!strict

local package = script:FindFirstAncestor("Rx")
local T = require(package.T)
local Delta = require(package.Schedulers.Delta)

--[=[

Returns a Scheduler that is fired by a custom function. *scheduler* is called
repeatedly in an infinite loop. It receives a function that, when called, fires
the worker. Arguments passed to this function are passed as additional arguments
to the worker. Delta time is handled automatically.

@param scheduler -- Implements the custom scheduler.

]=]
local function custom<T...>(scheduler: ((T...)->())->()): T.Scheduler<T...>
	return function(worker: T.Worker<T...>): T.Subscription
		local thread = task.spawn(function()
			local delta = Delta()
			while true do
				scheduler(function(...)
					worker(delta(), ...)
				end)
			end
		end)
		return function()
			task.cancel(thread)
		end
	end
end

return custom
