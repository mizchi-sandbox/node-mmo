{abs} = Math

class PlayerLabel extends enchant.Label
  constructor: (@player) ->
    super()
    @color = @getColor()
    @on 'enterframe', @update
    
  getColor: ->
    if @player.user_id is enchant.Game.instance.playerData
      'green'
    else
      'white'

  update: ->
    @text = @createLabelText()
    @x = @player.x
    @y = @player.y

  createLabelText: ->
    "#{@player.x}:#{@player.y}"

class Nmmo.Player extends enchant.Avatar
  constructor: (avatar, @user_id) ->
    super avatar
    @game = enchant.Game.instance

    @scaleX = 0.5
    @scaleY = 0.5

    @on 'enterframe', =>
      @scaleX = @dir * abs(@scaleX)

    @label = new PlayerLabel @
    @game.rootScene.addChild @label

    @on 'removed', =>
      @scene.removeChild @label

  update: ({
    x, y, user_id,
    avatar, action, dir
  }) ->
    @x = x
    @y = y
    @user_id = user_id
    @avatar = avatar
    @action = action
    @dir = dir
