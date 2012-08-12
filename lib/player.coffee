class Player
  constructor: (@id) ->
    @x = ~~(Math.random()*320)
    @y = ~~(Math.random()*240)
    @avatar = "2:2:1:2004:21230:22480"
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
    [@x, @y, @id, @avatar]

  decode: ([x, y, id, avatar])->
    @x = x
    @y = y
    @id = id
    @avatar = avatar

module.exports = Player
