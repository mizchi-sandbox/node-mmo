{abs, PI} = Math

class PlayerLabel extends enchant.Label
  constructor: (@player) ->
    super()
    @color = @getColor()
    @font  = "10px 'Georgia'"
    @on 'enterframe', @update
    
  getColor: ->
    if @player.user_id is enchant.Game.instance.player_id
      'green'
    else
      'white'

  update: ->
    @text = @createLabelText()
    @x = - 10
    @y = - ~~ 24

  createLabelText: ->
    percent = ~~(@player.hp/@player.HP * 100)
    "#{percent}%"

class PlayerAvatar extends enchant.Avatar
  constructor: (avatar) ->
    super avatar
    @game = enchant.Game.instance
    @scaleX = 0.5
    @scaleY = 0.5

    @x = - ~~(@width / 2)
    @y = - ~~(@height / 2)

class PlayerCircle extends enchant.Sprite
  constructor: (@player) ->
    super game.width, game.height
    @surface = new enchant.Surface game.width, game.height
    @lineWidth = 2
    @radius = 24
    @x = - @radius - @lineWidth/2
    @y = - @radius - @lineWidth/2

    @last_hp_rate = @getHPrate()
    @renderHPBar @getHPrate()

    @on 'enterframe', =>
      current_hp_rate = @getHPrate()
      if @last_hp_rate isnt current_hp_rate
        @last_hp_rate = current_hp_rate
        @renderHPBar(current_hp_rate)

  getHPrate: -> @player.hp/@player.HP

  renderHPBar: (hp_rate) ->
    @surface.context.lineWidth = @lineWidth

    @surface.context.clearRect 0, 0, game.width, game.height

    real_rad = 1/4 - (2/4) * hp_rate
    @drawArc @surface.context, real_rad,  1/4, 'red' , @lineWidth, false
    @drawArc @surface.context, 3/4     , -3/4, 'blue', @lineWidth, false

    @image = @surface
    @opacity = 0.6

  drawArc: (ctx, start, end, color, size = 4, vec = true)->
    ctx.lineWidth = size
    ctx.beginPath()
    ctx.strokeStyle = color

    ctx.arc @radius+size, @radius+size, # x, y
      @radius, PI*start , PI*end , vec

    ctx.stroke()


class Nmmo.Player extends enchant.Group
  constructor: (avatar, @user_id) ->
    @game = enchant.Game.instance
    super arguments...

    @hp = 1
    @HP = 1

    # アバター
    @avatar = new PlayerAvatar avatar
    @addChild @avatar

    # ラベル
    @label  = new PlayerLabel @
    @addChild @label

    if @isControlled()
      # サークル
      @circle = new PlayerCircle @
      @addChild @circle


    @on 'enterframe', =>
      @avatar.scaleX = @avatar.dir * abs(@avatar.scaleX)

  isControlled: -> @user_id is @game.player_id

  update: ({
    x, y, user_id,
    avatar, action, dir
    hp, HP
  }) ->
    @user_id = user_id
    @moveTo x, y

    @avatar.avatar = avatar
    @avatar.action = action
    @avatar.dir = dir

    @hp = hp
    @HP = HP
