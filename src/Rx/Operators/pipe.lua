--!strict

local package = script:FindFirstAncestor("Rx")
local T = require(package.T)
local Observable = require(package.Observable)
local Log = require(package.Log)

--[=[

Returns a Transformer that passes its input through each given argument in turn.

@param ... -- The transformers to apply.
@return    -- The resulting transformer.

]=]
local function pipe(...: T.Transformer): T.Transformer
	for i = 1, select("#", ...) do
		Log.ExpectArg(i, "function", (select(i, ...)))
	end
	local transformers = {...}
	return function(source: T.Observable): T.Observable
		Log.ExpectArgf(1, Observable.is, "Observable", source)
		for i, transformer in transformers do
			source = transformer(source)
			if not Observable.is(source) then
				Log.Errorfl(2, "bad transformer #%d: Observable expected, got %s", i, typeof(source))
			end
		end
		return source
	end
end

return pipe
