--!strict

local package = script:FindFirstAncestor("Rx")
local T = require(package.T)
local Observer = require(package.Observer)

--[=[

@class export

Provides an implementation of an Observable.

]=]
local export = {}

--[=[

@class Observable

An implementation of the Observable interface based off of a custom function.

]=]
local Observable = {__index={}}

--[=[

Returns whether a given value is an Observable.

@param v -- The value to check.
@return  -- Whether *v* is an observable.

]=]
function export.is(v: any): boolean
	return getmetatable(v) == Observable
end

--[=[

Creates a new Observable.

@param onSubscribe -- Used to implement the Observable.
@return            -- The resulting observable.

]=]
function export.new(onSubscribe: T.Subscribe): T.Observable
	assert(type(onSubscribe) == "function", "onSubscribe must be function")
	local self = setmetatable({
		onSubscribe = onSubscribe,
	}, Observable)
	return self::any
end

--[=[

Pipes the observable through each given transformer in turn, returning the final
result.

@param ... -- The transformers to apply.
@return    -- The resulting observable.

]=]
function Observable.__index:Pipe(...: T.Transformer): T.Observable
	local observer = self
	for i = 1, select("#", ...) do
		local transformer = select(i, ...)
		observer = transformer(observer)
	end
	return observer
end

--[=[

Subscribes to the observable with the given notifications.

@param onNext     -- Called when the observable emits an item.
@param onError    -- Called when the observable emits an error.
@param onComplete -- Called when the observable completes.
@return           -- Cancels the subscription when called.

]=]
function Observable.__index:Subscribe(
	onNext: T.OnNext?,
	onError: T.OnError?,
	onComplete: T.OnComplete
): T.Subscription
	local observer = (Observer.new(onNext, onError, onComplete)::any)::T._Observer
	local task = self.onSubscribe(observer)

	local function subscription()
		if observer.state == Observer.state.Active then
			observer.state = Observer.state.Canceled
		end
		Observer.cleanup(observer)
	end

	if task == nil then
		return subscription
	end
	if observer.state ~= Observer.state.Active then
		subscription()
		return subscription
	end
	observer.task = task
	return subscription
end

return table.freeze(export)
