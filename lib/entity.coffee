{EventEmitter} = require('events')
{abs} = Math

class Entity extends EventEmitter
  constructor: ->
    @cnt = 0

  onUpdate: ->
    @cnt++

module.exports = Entity