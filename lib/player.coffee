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

  onUpdate: ->
    super()
    @move()
    @updateAvatarAction()

    # Aボタンを押していれば攻撃
    if @canAction() and @isPushed('a')
      {players} = @world.getObjectsByPlayer(@)
      # TODO ターゲット機構をつける
      target = _.first players.filter (p) => p isnt @ and p.isAlive()
      if target? then @attack target

  checkStatus: ->
    if @hp < 0 then @hp = 0

  onAttacked: (enemy) ->
    @hp -= 30
    @checkStatus()
    @addStunValue ~~(@world.FPS / 2)

  attack: (enemy) ->
    console.log 'attacking:', @user_id, '->' , enemy.user_id
    @addActionCost @world.FPS * 1
    @action = 'attack'
    enemy.emit 'attacked', @

  move: ->
    if @canAction()
      if @_keys.up    then @y -= @move_speed
      if @_keys.down  then @y += @move_speed
      if @_keys.right then @x += @move_speed
      if @_keys.left  then @x -= @move_speed
    # TODO 当たり判定

  updateKey: (key, state) ->
    @_keys[key] = state

  isPushed: (key_name) ->
    @_keys[key_name] is true

  encode: ->
    [@x, @y, @user_id, @avatar, @action, @dir]

  # set @action
  updateAvatarAction: ->
    # 死
    if @isDead()
      @action = 'dead'
      return

    # スタン
    if @isStunned()
      @action = 'damage'
      return

    # 他アニメーションは継続
    unless @canAction()
      @action = @action
      return

    # 立ち止まってる場合はstop
    dx = (@x - @_last.x)
    dy = (@y - @_last.y)
    if dx is 0 and dy is 0
      @action = 'stop'
    else
      # 位置が変わった場合はrun
      @action = 'run'
      # 右へ進んだか、左へ進んだか
      @dir = 
        if dx < 0
          +1
        else if dx > 0
          -1
        else
          @dir

module.exports = Player
