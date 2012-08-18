Entity = require './entity'

class Player extends Entity
  constructor: (@user_id) ->
    @x = ~~(Math.random()*200)
    @y = ~~(Math.random()*200)
    @dir = 1 # 右
    @avatar = "1:10:0:2019:2105:2210"
    @move_speed = 3
    @_keys =
      up   : false
      down : false
      right: false
      left : false
      a: false
      b: false

    @on 'update', @update

  update: ->
    last_x = @x
    last_y = @y

    @move()
    @setAction (@x - last_x), (@y - last_y)

  move: ->
    # move actually
    if @_keys.up    then @y -= @move_speed
    if @_keys.down  then @y += @move_speed
    if @_keys.right then @x += @move_speed
    if @_keys.left  then @x -= @move_speed

  # set @action
  setAction: (diff_x, diff_y) ->
    # Aボタンを押してる時は attack
    if @_keys.a
      @action = 'attack'
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
    console.log key, state
    @_keys[key] = state

  encode: ->
    [@x, @y, @user_id, @avatar, @action, @dir]

module.exports = Player
