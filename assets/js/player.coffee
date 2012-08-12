{abs} = Math
class Nmmo.Player extends enchant.Avatar
  constructor: (avatar_id, @player_id) ->
    super avatar_id

    @scaleX = 0.5
    @scaleY = 0.5

    @action = 'run'

    @_last = 
      x: 0
      y: 0

    @on 'enterframe', =>
      diff_x = @x - @_last.x
      diff_y = @y - @_last.y
      if diff_x is 0 and diff_y is 0
        @action = 'stop'
      else
        @action = 'run'
        if diff_x < 0
          @scaleX = + abs(@scaleX)
        if diff_x > 0
          @scaleX = - abs(@scaleX)

      @_last.x = @x 
      @_last.y = @y

