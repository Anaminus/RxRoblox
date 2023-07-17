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
export.defer = require(script.Observables.defer)
export.empty = require(script.Observables.empty)
export.never = require(script.Observables.never)
export.throw = require(script.Observables.throw)

-- Operators

export.pipe = require(script.Operators.pipe)

-- Schedulers

export.scheduler = require(script.Schedulers)

return table.freeze(export)
