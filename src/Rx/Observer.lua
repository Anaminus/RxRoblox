--!strict

local package = script:FindFirstAncestor("Rx")
local packages = script:FindFirstAncestor("Rx").Parent
local Maid = require(packages.Maid)
local T = require(package.T)

--[=[

@class export

Provides an implementation of an Observer. Used by Observable to handle
subscriptions.

]=]
local export = {}

local Active: "active" = "active"
local Errored: "errored" = "errored"
local Completed: "completed" = "completed"
local Canceled: "canceled" = "canceled"

--- Used by Observer type to enforce the Observable contract. OnNext can only be
--- invoked while active.
export.state = table.freeze{
	Active = Active,
	Errored = Errored,
	Completed = Completed,
	Canceled = Canceled,
}

local Observer = {__index={}}

--[=[

Creates a new Observer.

@param onNext     -- Called when the observable emits an item.
@param onError    -- Called when the observable emits an error.
@param onComplete -- Called when the observable completes.
@return           -- The created observer.

]=]
function export.new(onNext: T.OnNext?, onError: T.OnError?, onComplete: T.OnComplete?): T.Observer
	local self = setmetatable({
		state = Active,
		onNext = onNext,
		onError = onError,
		onComplete = onComplete,
		task = nil,
	}, Observer)
	return self::any
end

--[=[

Cleans up the task of a given observer.

@param observer -- The Observer to clean up.

]=]
function export.cleanup(observer: T._Observer)
	local task = observer.task
	if task ~= nil then
		observer.task = nil
		Maid.clean(task)
	end
end

--[=[

Produces notifications suitable to be passed to new that either use a given
notification, or invoke the equivalent notification of *observer*.

@param observer   -- Observer from which unspecified notifications are filled.
@param onNext     -- Optional OnNext notification to use.
@param onError    -- Optional OnError notification to use
@param onComplete -- Optional OnComplete notification to use.
@return           -- *onNext*, or a function that calls `observer:Next()`.
@return           -- *onError*, or a function that calls `observer:Error()`.
@return           -- *onComplete*, or a function that calls `observer:Complete()`.

]=]
function export.fill(
	observer: T.Observer,
	onNext: T.OnNext?,
	onError: T.OnError?,
	onComplete: T.OnComplete?
): (T.OnNext, T.OnError, T.OnComplete)
	local next = onNext or function(...)
		observer:Next(...)
	end
	local error = onError or function(...)
		observer:Error(...)
	end
	local complete = onComplete or function(...)
		observer:Complete(...)
	end
	return next, error, complete
end

--[=[

Invokes the observer's OnNext notification.

@param ... -- Arguments to be passed to the notification.

]=]
function Observer.__index:Next(...: any)
	if self.state == Active then
		if self.onNext then
			task.spawn(self.onNext, ...)
		end
	elseif self.state == Canceled then
		warn(debug.traceback("notification pushed to canceled observer", 2))
	end
end

--[=[

Invokes the observer's OnError notification.

@param ... -- Arguments to be passed to the notification.

]=]
function Observer.__index:Error(...: any)
	if self.state == Active then
		self.state = Errored
		if self.onError then
			task.spawn(self.onError, ...)
		end
		export.cleanup(self)
	end
end

--[=[

Invokes the observer's OnComplete notification.

]=]
function Observer.__index:Complete()
	if self.state == Active then
		self.state = Completed
		if self.onComplete then
			task.spawn(self.onComplete)
		end
		export.cleanup(self)
	end
end

return table.freeze(export)
