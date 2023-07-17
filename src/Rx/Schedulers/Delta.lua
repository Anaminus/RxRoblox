--[=[

Returns a function that returns the amount of time since the function was last
called.

]=]
local function Delta(): () -> number
	local last = os.clock()
	return function(): number
		local next = os.clock()
		local delta = next - last
		last = next
		return delta
	end
end

return Delta
