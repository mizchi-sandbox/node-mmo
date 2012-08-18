_ = require 'underscore'

BattleEntity = require './battle_entity'

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

  isPushed: (key_name) -> @_keys[key_name] is true

  onUpdate: ->
    super()
    @move()
    @setAvatarAction()

    # Aボタンを押していれば攻撃
    if @canAction() and @isPushed 'a'
      {players} = @world.getObjectsByPlayer(@)
      for player in players when player isnt @
        @attack player

  onAttacked: (enemy) ->
    @hp -= 30
    if @hp < 0 then @hp = 0
    @addStunValue ~~(@world.FPS / 2)
    # @stunndFrameCount = @world.FPS * 1

  attack: (enemy) ->
    console.log 'attacking:', @user_id, '->' , enemy.user_id
    @addActionCost @world.FPS * 1
    # @nextActionFrameCount = @world.FPS * 1

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
    if @isDead()
      @action = 'dead'
      return

    # ダメージを受けているときは硬直
    if @stunnedFrameCount > 0
      @action = 'damage'
      return

    # アニメーション中は同じアクションを継続
    if @nextActionFrameCount > 0
      @action = @action
      return

    # 立ち止まってる場合はstop
    diff_x = (@x - @_last.x)
    diff_y = (@y - @_last.y)
    if diff_x is 0 and diff_y is 0
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
