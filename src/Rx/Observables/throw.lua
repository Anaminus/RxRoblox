--!strict

local package = script:FindFirstAncestor("Rx")
local T = require(package.T)
local Observable = require(package.Observable)

--[=[

Creates an Observable that emits nothing and throws an error.

If the factory function emits an error, then that error will be thrown to the
observer. Otherwise, all returned values will be thrown to the observer.

@param factory -- Used to produce the error.

]=]
local function throw(factory: () -> (...any)): T.Observable
	return Observable.new(function(obr: T.Observer): T.Task
		local results = table.pack(pcall(factory))
		if not results[1] then
			obr:Error(results[2])
			return nil
		end
		obr:Error(table.unpack(results, 2, results.n))
		return nil
	end)
end

return throw
