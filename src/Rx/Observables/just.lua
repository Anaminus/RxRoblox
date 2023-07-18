--!strict

local package = script:FindFirstAncestor("Rx")
local T = require(package.T)
local Observable = require(package.Observable)

--[=[

Creates an observable that emits given values once before completing.

Note that all arguments are emitted at once, rather than individually.

```lua
Rx.just(1, 2, 3)
:Subscribe(function(a, b, c)
	print("values", a, b, c) --> values 1 2 3
end)
```

@param ... -- The values to emit.

]=]
local function just(...: any): T.Observable
	local values = table.pack(...)
	return Observable.new(function(obr: T.Observer): T.Task
		obr:Next(table.unpack(values, 1, values.n))
		obr:Complete()
		return nil
	end)
end

return just
