--!strict

local package = script:FindFirstAncestor("Rx")
local T = require(package.T)
local Observable = require(package.Observable)
local Observer = require(package.Observer)

--[=[

For each observer, waits until the observer subscribes, then produces a new
Observable for the observer.

If the factory function emits an error or returns a non-observable, then the
error will be thrown to the observer.

@param factory -- Used to produce Observables for each observer.

]=]
local function defer(factory: () -> T.Observable): T.Observable
	return Observable.new(function(obr: T.Observer): T.Task
		local ok, observable = pcall(factory)
		if not ok then
			obr:Error(observable)
			return nil
		end
		if not Observable.is(observable) then
			obr:Error("Observable expected")
			return nil
		end
		return observable:Subscribe(Observer.fill(obr))
	end)
end

return defer
