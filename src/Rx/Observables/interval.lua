--!strict

local package = script:FindFirstAncestor("Rx")
local T = require(package.T)
local Observable = require(package.Observable)

--[=[

Creates an observable that emits a sequence of integers spaced over time
according to a given scheduler.

Examples:

Observable that emits every half-second:

```lua
Rx.interval(Rx.scheduler.wait(0.5))
:Subscribe(function(i: number)
	print("sequence", i)
end)
```

Observable that emits every render frame:

```lua
Rx.interval(Rx.scheduler.renderStepped())
:Subscribe(function(i: number)
	print("frame", i)
end)
```

The operator also passes the arguments received from the scheduler as additional
arguments:

```lua
Rx.interval(Rx.scheduler.renderStepped())
:Subscribe(function(i: number, deltaTime: number)
	print("frame", i, deltaTime)
end)
```

@param scheduler -- The scheduler that drives the interval.

]=]
local function interval<T...>(scheduler: T.Scheduler<T...>): T.Observable
	return Observable.new(function(obr: T.Observer): T.Task
		local i = 0
		return scheduler(function(dt: number)
			obr:Next(i, dt)
			i += 1
		end)
	end)
end

return interval
