class Player
  constructor: (@id) ->
    @x = 0
    @y = 0
    @_keys =
      up   : false
      down : false
      right: false
      left : false

  move: ->
    if(@_keys.up)    then @y -= 1
    if(@_keys.down)  then @y += 1
    if(@_keys.right) then @x += 1
    if(@_keys.left)  then @x -= 1

  updateKey: (key, state) ->
    @_keys[key] = state

module.exports = Player
