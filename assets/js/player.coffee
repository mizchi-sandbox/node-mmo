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

class PlayerAvatar extends enchant.Avatar
  constructor: (avatar) ->
    super avatar
    @game = enchant.Game.instance
    @scaleX = 0.5
    @scaleY = 0.5

    @x = - ~~(@width / 2)
    @y = - ~~(@height / 2)

class PlayerCircle extends enchant.Surface
  constructor: ->
    super arguments...
    @context.beginPath()
    @context.arc(50, 50, 45, 0, Math.PI*2, false);
    @context.strokeStyle = 'green'
    @context.stroke()
    @context.lineWidth = 5;

class Nmmo.Player extends enchant.Group
  constructor: (avatar, @user_id) ->
    @game = enchant.Game.instance
    super arguments...

    # 各オブジェクト
    @avatar = new PlayerAvatar avatar
    @label  = new PlayerLabel @

    @circle = new enchant.Sprite @game.width, @game.height
    @circle.image = new PlayerCircle @game.width, @game.height
    @addChild @circle

    @addChild @avatar
    @addChild @label

    @on 'enterframe', =>
      @avatar.scaleX = @avatar.dir * abs(@avatar.scaleX)

  update: ({
    x, y, user_id,
    avatar, action, dir
  }) ->
    @user_id = user_id
    @moveTo x, y

    @avatar.avatar = avatar
    @avatar.action = action
    @avatar.dir = dir
