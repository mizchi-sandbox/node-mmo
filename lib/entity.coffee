{EventEmitter} = require('events')
{abs} = Math

class Entity extends EventEmitter
  distance: (other) ->
    abs(@x - other.x) + abs(@y - other.y)

module.exports = Entity