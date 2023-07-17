--!strict

local package = script:FindFirstAncestor("Rx")
local T = require(package.T)
local Delta = require(package.Schedulers.Delta)

--[=[

Returns a Scheduler that is fired by *signal*. Arguments received from the
signal are passed as additional arguments to the worker.

@param signal -- The signal that drives the scheduler.

]=]
local function signal<T...>(signal: RBXScriptSignal<T...>): T.Scheduler<T...>
	return function(worker: T.Worker<T...>): T.Subscription
		local delta = Delta()
		local conn = signal:Connect(function(...)
			worker(delta(), ...)
		end)
		return function()
			conn:Disconnect()
		end
	end
end

return signal
