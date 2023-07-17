local export = {}

export.custom = require(script.custom)
export.signal = require(script.signal)
export.waiting = require(script.waiting)
export.render = require(script.render)

return table.freeze(export)
