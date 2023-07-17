--!strict

local package = script:FindFirstAncestor("Rx")
local T = require(package.T)
local Observable = require(package.Observable)

--[=[

An Observable that never completes.

]=]
local never = Observable.new(function(obr: T.Observer): T.Task
	return nil
end)

return never
