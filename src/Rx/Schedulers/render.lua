--!strict

local RunService = game:GetService("RunService")

local package = script:FindFirstAncestor("Rx")
local T = require(package.T)

--[=[

Returns a Scheduler that is fired according to RunService.BindToRenderStep.

Note that, because *name* is global, the scheduler's binding can be externally
overridden or unbound.

@param name     -- A label for binding to the render step.
@param priority -- Determines the order during the render step when the binding is invoked.

]=]
local function render(name: string, priority: number): T.Scheduler<>
	return function(worker: T.Worker<>): T.Subscription
		RunService:BindToRenderStep(name, priority, worker)
		return function()
			RunService:UnbindFromRenderStep(name)
		end
	end
end

return render
