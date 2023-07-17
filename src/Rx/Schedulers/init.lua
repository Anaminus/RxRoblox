local export = {}

export.custom = require(script.custom)
export.signal = require(script.signal)

return table.freeze(export)
