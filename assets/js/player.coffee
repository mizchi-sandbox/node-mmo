{abs} = Math

class PlayerLabel extends enchant.Label
  constructor: (@player) ->
    super()
    @color = 'white'
    @on 'enterframe', @update

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

    @action = 'run'

    @_last = 
      x: 0
      y: 0

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
