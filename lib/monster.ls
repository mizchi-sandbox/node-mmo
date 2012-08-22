Player = require \./player

class Monster extends Player
  object_id: 'monster'
  ->
    super ...
    console.log 'monster bone', @user_id

  on-death: ->
    @world.monsters = reject (~> it is @), @world.monsters

  on-update: ->
    unless @_on_going
      @_on_going = ['n', 's', 'e', 'w', 'none'][~~(Math.random()*5)]
      @_on_going_cnt = 6
    else
      switch @_on_going
        when 'n' then @y--
        when 's' then @y++
        when 'w' then @x--
        when 'e' then @x++
      if @_on_going_cnt-- is 0
        @_on_going = undefined
    super!

module.exports = Monster

# _ = require \underscore

# BattleEntity = require \./battle_entity

# class Monster extends BattleEntity
#   object_id: 'monster'
#   (@world, @user_id) ->
#     super()
#     @x = 0  + ~~(Math.random()*320)
#     @y = 60 + ~~(Math.random()*100)

#     @revive()

#     @on 'update', @on-update
#     @on 'attacked', @on-attacked

#   revive: ->
#     @x = 0  + ~~(Math.random!*320)
#     @y = 60 + ~~(Math.random!*100)
#     @hp = @HP

#   on-death: ->
#     console.log 'death!!!!!!!'
#     @world.monsters = reject (~> it is @), @world.monsters

#   on-update: ->
#     super()
#     @move()
#     @update-avatar-action()

#     if @isDead!
#       @on-death!
#       return

#   check-status: ->
#     if @hp < 0 then @hp = 0

#   on-attacked: (enemy) ->
#     @hp -= ~~(20 * Math.random!) + 10
#     @checkStatus!
#     @addStunValue ~~(@world.FPS / 2)

#   attack: (enemy) ->
#     console.log \attacking: , @user_id, '->' , enemy.user_id
#     @add-action-cost @world.FPS * 1
#     @action = \attack
#     enemy.emit \attacked , @

#   move: ->
#     if @can-action!
#       nx = @x
#       ny = @y
#       if @_keys.up    then ny = @y - @move_speed
#       if @_keys.down  then ny = @y + @move_speed
#       if @_keys.right then nx = @x + @move_speed
#       if @_keys.left  then nx = @x - @move_speed

#       if 0 < nx < 320
#         @x = nx

#       if 60 < ny < 160
#         @y = ny

#   update-key: (key, state) ->
#     @_keys[key] = state

#   is-pushed: (key_name) ->
#     @_keys[key_name] is true

#   # set avatar action
#   update-avatar-action: ->
#     # 死
#     if @is-dead!
#       @action = \dead
#       return

#     # スタン
#     if @is-stunned!
#       @action = \damage
#       return

#     # 他アニメーションは継続
#     unless @can-action!
#       @action = @action
#       return

#     # 立ち止まってる場合はstop
#     dx = (@x - @_last.x)
#     dy = (@y - @_last.y)
#     if dx is 0 and dy is 0
#       @action = \stop
#     else
#       # 位置が変わった場合はrun
#       @action = \run
#       # 右へ進んだか、左へ進んだか
#       @dir = 
#         if dx < 0
#           +1
#         else if dx > 0
#           -1
#         else
#           @dir

# module.exports = Monster
