_ = require \underscore

BattleEntity = require \./battle_entity

class Player extends BattleEntity
  (@world, @user_id) ->
    super()
    @x = 0  + ~~(Math.random()*320)
    @y = 60 + ~~(Math.random()*100)

    @_keys =
      up   : false
      down : false
      right: false
      left : false
      a: false
      b: false
    @initStatus()

    gender = ~~(Math.random!*2) + 1
    hair = ~~(Math.random!*9) + 1
    hair_color = ~~(Math.random!*6) 
    @avatar = "#{gender}:#{hair}:#{hair_color}:2019:2105:0"

    @on 'update', @on-update
    @on 'attacked', @on-attacked

  init-status: ->
    @x = 0  + ~~(Math.random!*320)
    @y = 60 + ~~(Math.random!*100)
    @hp = @HP

  on-update: ->
    super()
    @move()
    @update-avatar-action()

    if @isDead()
      @_dead_count ?= 60
      @_dead_count--
      if @_dead_count is 0
        delete @_dead_count
        # 復活処理
        @initStatus()

    # Aボタンを押していれば攻撃
    if @can-action() and @is-pushed \a
      {players} = @world.get-objects-by-player(@)
      # TODO ターゲット機構をつける
      target = first (filter (~> it isnt @ and it.isAlive!), players)
      if target? then @attack target

  check-status: ->
    if @hp < 0 then @hp = 0

  on-attacked: (enemy) ->
    @hp -= ~~(20 * Math.random!) + 10
    @checkStatus!
    @addStunValue ~~(@world.FPS / 2)

  attack: (enemy) ->
    console.log \attacking: , @user_id, '->' , enemy.user_id
    @add-action-cost @world.FPS * 1
    @action = \attack
    enemy.emit \attacked , @

  move: ->
    if @can-action!
      nx = @x
      ny = @y
      if @_keys.up    then ny = @y - @move_speed
      if @_keys.down  then ny = @y + @move_speed
      if @_keys.right then nx = @x + @move_speed
      if @_keys.left  then nx = @x - @move_speed

      if 0 < nx < 320
        @x = nx

      if 60 < ny < 160
        @y = ny

  update-key: (key, state) ->
    @_keys[key] = state

  is-pushed: (key_name) ->
    @_keys[key_name] is true

  # set avatar action
  update-avatar-action: ->
    # 死
    if @is-dead!
      @action = \dead
      return

    # スタン
    if @is-stunned!
      @action = \damage
      return

    # 他アニメーションは継続
    unless @can-action!
      @action = @action
      return

    # 立ち止まってる場合はstop
    dx = (@x - @_last.x)
    dy = (@y - @_last.y)
    if dx is 0 and dy is 0
      @action = \stop
    else
      # 位置が変わった場合はrun
      @action = \run
      # 右へ進んだか、左へ進んだか
      @dir = 
        if dx < 0
          +1
        else if dx > 0
          -1
        else
          @dir

module.exports = Player
