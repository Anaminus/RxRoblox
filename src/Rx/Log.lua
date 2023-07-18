--!strict

--[=[

@class export

Provides utility functions for logging.

]=]
local export = {}

--[=[

Emits a message formatted according to string.format.

@param format -- Format string.
@param ...    -- Format arguments.

]=]
function export.Printf(format: string, ...: any)
	print(string.format(format, ...))
end

--[=[

Emits a message formatted according to string.format with a stack trace.

@param format -- Format string.
@param ...    -- Format arguments.

]=]
function export.Printft(format: string, ...: any)
	print(debug.traceback(string.format(format, ...), 2))
end

--[=[

Emits a warning formatted according to string.format.

@param format -- Format string.
@param ...    -- Format arguments.

]=]
function export.Warnf(format: string, ...: any)
	warn(string.format(format, ...))
end

--[=[

Emits a warning formatted according to string.format with a stack trace at a
given level.

@param level  -- The stack level.
@param format -- Format string.
@param ...    -- Format arguments.

]=]
function export.Warnft(level: number, format: string, ...: any)
	warn(debug.traceback(string.format(format, ...), level+1))
end

--[=[

Emits an error formatted according to string.format.

@param format -- Format string.
@param ...    -- Format arguments.

]=]
function export.Errorf(format: string, ...: any)
	error(string.format(format, ...), 2)
end

--[=[

Emits an error formatted according to string.format at a given stack level.

@param level  -- The stack level.
@param format -- Format string.
@param ...    -- Format arguments.

]=]
function export.Errorfl(level: number, format: string, ...: any)
	error(string.format(format, ...), level+1)
end

--[=[

Asserts a value with the error formatted according to string.format.

A successful assertion returns the condition.

@param cond   -- The condition to assert.
@param format -- Format string.
@param ...    -- Format arguments.

]=]
function export.Assertf<T>(cond: T, format: string, ...: any): T
	if not cond then
		error(string.format(format, ...), 2)
	end
	return cond
end

--[=[

Asserts a value with an error formatted according to string.format at a given
stack level.

A successful assertion returns the condition.

@param cond   -- The condition to assert.
@param level  -- The stack level.
@param format -- Format string.
@param ...    -- Format arguments.

]=]
function export.Assertfl<T>(cond: T, level: number, format: string, ...: any): T
	if not cond then
		error(string.format(format, ...), level+1)
	end
	return cond
end

--[=[

Expects the type of a given argument.

@param i        -- Indicates which argument is expected.
@param expected -- The expected type, according to typeof.
@param value    -- The value to check.

]=]
function export.ExpectArg(i: number, expected: string, value: any)
	if typeof(value) ~= expected then
		error(string.format("bad argument #%d: expected %s, got %s", i, expected, typeof(value)), 3)
	end
end

--[=[

Expects an argument according to a predicate.

@param i         -- Indicates which argument is expected.
@param predicate -- Function used to determine whether the value's type matches.
@param expected  -- The expected type.
@param value     -- The value to check.

]=]
function export.ExpectArgf(i: number, predicate: (any)->boolean, expected: string, value: any)
	if predicate(value) then
		error(string.format("bad argument #%d: expected %s, got %s", i, expected, typeof(value)), 3)
	end
end

--[=[

Expects the type of an optional argument.

@param i        -- Indicates which argument is expected.
@param expected -- The expected type, according to typeof.
@param value    -- The value to check.

]=]
function export.ExpectOptArg(i: number, expected: string, value: any)
	if value == nil then
		return
	end
	if typeof(value) ~= expected then
		error(string.format("bad argument #%d: expected %s, got %s", i, expected, typeof(value)), 3)
	end
end

--[=[

Expects an optional argument according to a predicate.

@param i         -- Indicates which argument is expected.
@param predicate -- Function used to determine whether the value's type matches.
@param expected  -- The expected type.
@param value     -- The value to check.

]=]
function export.ExpectOptArgf(i: number, predicate: (any)->boolean, expected: string, value: any)
	if value == nil then
		return
	end
	if predicate(value) then
		error(string.format("bad argument #%d: expected %s, got %s", i, expected, typeof(value)), 3)
	end
end

return table.freeze(export)
