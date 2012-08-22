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
      @_on_going = ['n', 's', 'e', 'w'][~~(Math.random()*10)]
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
