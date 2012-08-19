{abs} = Math

class PlayerLabel extends enchant.Label
  constructor: (@player) ->
    super()
    @color = @getColor()
    @on 'enterframe', @update
    
  getColor: ->
    if @player.user_id is enchant.Game.instance.player_id
      'green'
    else
      'white'

  update: ->
    @text = @createLabelText()

  createLabelText: ->
    "#{@player.x}:#{@player.y}"

class Nmmo.PlayerAvatar extends enchant.Avatar
  constructor: (avatar) ->
    super avatar
    @game = enchant.Game.instance
    @scaleX = 0.5
    @scaleY = 0.5

class Nmmo.Player extends enchant.Group
  constructor: (avatar, @user_id) ->
    @game = enchant.Game.instance
    super arguments...
    @avatar = new Nmmo.PlayerAvatar avatar, @user_id
    @addChild @avatar

    @label = new PlayerLabel @
    @addChild @label

    @on 'enterframe', =>
      @avatar.scaleX = @avatar.dir * abs(@avatar.scaleX)
      # if @user_id is @game.player_id
      #   @game.bg.scroll @x

  update: ({
    x, y, user_id,
    avatar, action, dir
  }) ->
    @user_id = user_id
    @moveTo x, y

    @avatar.avatar = avatar
    @avatar.action = action
    @avatar.dir = dir
