local export = {}

export.custom = require(script.custom)
export.signal = require(script.signal)
export.waiting = require(script.waiting)

return table.freeze(export)
