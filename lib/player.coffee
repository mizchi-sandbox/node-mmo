class Player
  constructor: (@user_id) ->
    @x = ~~(Math.random()*320)
    @y = ~~(Math.random()*240)
    @avatar = "1:10:0:2019:2105:2210"
    @move_speed = 3
    @_keys =
      up   : false
      down : false
      right: false
      left : false

  move: ->
    if(@_keys.up)    then @y -= @move_speed
    if(@_keys.down)  then @y += @move_speed
    if(@_keys.right) then @x += @move_speed
    if(@_keys.left)  then @x -= @move_speed

  updateKey: (key, state) ->
    @_keys[key] = state

  compless: ->
    [@x, @y, @user_id, @avatar]

  decode: ([x, y, user_id, avatar])->
    @x = x
    @y = y
    @user_id = user_id
    @avatar = avatar

module.exports = Player
