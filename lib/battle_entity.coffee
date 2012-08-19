_ = require 'underscore'

Entity = require './entity'
{abs} = Math

class BattleEntity extends Entity
  constructor: ->
    super()
    @x = 0
    @y = 0
    @_nextActionFrameCount  = 0 # 0なら行動可。毎フレーム減少
    @_stunnedFrameCount = 0 # 0なら行動可。毎フレーム減少
    @dir = 1 # 右
    @move_speed = 3

    @HP = 100
    @hp = 100

  onUpdate: ->
    @_saveLastState()
    if @_stunnedFrameCount > 0
      @_stunnedFrameCount--
    else if @_nextActionFrameCount > 0
      @_nextActionFrameCount--

  distance: (other) ->
    abs(@x - other.x) + abs(@y - other.y)

  addStunValue: (val) ->
    @_stunnedFrameCount += val

  addActionCost: (val) ->
    @_nextActionFrameCount += val

  canAction: ->
    @_nextActionFrameCount <= 0 and not @isStunned() and @isAlive()
  isStunned: -> @_stunnedFrameCount > 0

  isAlive: -> @hp > 0
  isDead: -> not @isAlive()

  _saveLastState:-> @_last = _.clone @

module.exports = BattleEntity