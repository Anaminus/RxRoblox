--!strict

local packages = script:FindFirstAncestor("Rx").Parent
local Maid = require(packages.Maid)

-- Any value encapsulating the finalization of a procedure or state.
export type Task = Maid.Task

-- Represents an "unsubscribe" method. Calling it indicates that the associated
-- observer is no longer interested in the Observables it is subscribed to.
export type Subscription = () -> ()

-- A callback for emitting an OnNext notification.
export type OnNext = (...any) -> ()
-- A callback for emitting an OnError notification.
export type OnError = (...any) -> ()
-- A callback for emitting an OnComplete notification.
export type OnComplete = () -> ()

-- Transformer transforms one Observable into another.
export type Transformer = (Observable) -> Observable

-- Used to enforce the Observable contract. OnNext can only be invoked while
-- active.
export type ObserverState = "active" | "errored" | "completed" | "canceled"

-- The interface implemented by observers.
export type Observer = {
	Next: (self: Observer, ...any) -> (),
	Error: (self: Observer, ...any) -> (),
	Complete: (self: Observer) -> (),
}

-- Implementation of Observer, used by Observable.Subscribe.
export type _Observer = {
	state: ObserverState,    -- Current state of the observer.
	onNext: OnNext?,         -- Invoked by Next.
	onError: OnError?,       -- Invoked by Error.
	onComplete: OnComplete?, -- Invoked by Complete.
	task: Task,              -- Set by Subscribe for finalization.
}

-- The interface implemented by any observable value.
export type Observable = {
	-- Pipes the observable through each given transformer in turn, returning
	-- the final result.
	Pipe: (self: Observable, ...Transformer) -> Observable,
	-- Subscribes to the observable with the given notifications. Returns a
	-- function that cancels the subscription.
	Subscribe: (self: Observable,
		onNext: OnNext?,
		onError: OnError?,
		onCompleted: OnComplete?
	) -> Subscription,
}

-- Implementation of Observable based off of a custom function.
export type _Observable = {
	onSubscribe: Subscribe,
}

-- Used by an Observable to handle a new subscriber.
export type Subscribe = (Observer) -> Task

-- Schedules *worker* to be called at a particular interval. The returned
-- Subscription cancels the schedule.
export type Scheduler<T...> = (worker: Worker<T...>) -> Subscription

-- Called by a Scheduler. Receives the time since the worker was last called.
-- Additional arguments passed depend on the scheduler.
export type Worker<T...> = (delta: number, T...) -> ()

return true
