{abs} = Math

class Nmmo.Player extends enchant.Avatar
  constructor: (avatar, @user_id) ->
    super avatar

    @scaleX = 0.5
    @scaleY = 0.5

    @action = 'run'

    @_last = 
      x: 0
      y: 0

    @on 'enterframe', =>
      @scaleX = @dir * abs(@scaleX)

  decode: ([x, y, id, avatar, action, dir])->
    @x = x
    @y = y
    @user_id = id
    @avatar = avatar
    @action = action
    @dir = dir
