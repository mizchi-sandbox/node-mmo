_ = require 'underscore'

Entity = require './entity'

class BattleEntity extends Entity
  constructor: ->
    @x = 0
    @y = 0
    @nextActionFrameCount  = 0 # 0なら行動可。毎フレーム減少
    @stunnedFrameCount = 0 # 0なら行動可。毎フレーム減少
    @dir = 1 # 右
    @move_speed = 3

    @HP = 100


  onUpdate: ->
    @_saveLastState()
    if @stunnedFrameCount > 0
      @stunnedFrameCount--
    else if @nextActionFrameCount > 0
      @nextActionFrameCount--

  _saveLastState:->
    @_last = _.clone @

  isMoved  : ->

  canAction: ->
    @nextActionFrameCount <= 0 and not @isStunned()
  isStunned: -> @stunnedFrameCount > 0

  isAlive: ->
  isDead: ->

class Player extends BattleEntity
  constructor: (@world, @user_id) ->
    super()
    @x = ~~(Math.random()*200)
    @y = ~~(Math.random()*200)
    @avatar = "1:10:0:2019:2105:2210"
    @_keys =
      up   : false
      down : false
      right: false
      left : false
      a: false
      b: false

    @on 'update', @onUpdate
    @on 'attacked', @onAttacked

  onUpdate: ->
    super()
    @move()
    @setAvatarAction()

    # Aボタンを押していれば攻撃
    if @canAction() and @_keys.a is true
      {players} = @world.getObjectsByPlayer(@)
      for player in players when player isnt @
        @attack player

  onAttacked: (enemy) ->
    @stunnedFrameCount = ~~(@world.FPS / 2)

  attack: (enemy) ->
    console.log 'attacking:', @user_id, '->' , enemy.user_id
    @nextActionFrameCount = @world.FPS * 1
    @action = 'attack'
    enemy.emit 'attacked', @

  move: ->
    # 攻撃中、もしくはスタン中は動けない
    if @canAction()
      # move actually
      if @_keys.up    then @y -= @move_speed
      if @_keys.down  then @y += @move_speed
      if @_keys.right then @x += @move_speed
      if @_keys.left  then @x -= @move_speed

  # set @action
  setAvatarAction: ->
    diff_x = (@x - @_last.x)
    diff_y = (@y - @_last.y)

    # ダメージを受けているときは硬直
    if @stunnedFrameCount > 0
      @action = 'damage'
      return

    # アニメーション中は同じアクションを継続
    if @nextActionFrameCount > 0
      @action = @action
      return

    # 立ち止まってる場合はstop
    else if diff_x is 0 and diff_y is 0
      @action = 'stop'

    # 位置が変わった場合はrun
    else
      @action = 'run'
      @dir = 
        if diff_x < 0
          +1
        else if diff_x > 0
          -1
        else
          @dir

  updateKey: (key, state) ->
    @_keys[key] = state

  encode: ->
    [@x, @y, @user_id, @avatar, @action, @dir]

module.exports = Player
