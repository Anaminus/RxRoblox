--!strict

local T = require(script.T)
local Observable = require(script.Observable)

--[=[

@class export

]=]
local export = {}

-- Types

export type Task = T.Task
export type OnNext = T.OnNext
export type OnError = T.OnError
export type OnComplete = T.OnComplete
export type Transformer = T.Transformer
export type Observer = T.Observer
export type Subscription = T.Subscription
export type Subscribe = T.Subscribe
export type Observable = T.Observable

-- Observables

export.isObservable = Observable.is
export.create = Observable.new

return table.freeze(export)
