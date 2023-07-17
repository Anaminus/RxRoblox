--!strict

local package = script:FindFirstAncestor("Rx")
local T = require(package.T)
local Observable = require(package.Observable)

--[=[

An Observable that emits nothing and completes normally.

]=]
local empty = Observable.new(function(obr: T.Observer): T.Task
	obr:Complete()
	return nil
end)

return empty
