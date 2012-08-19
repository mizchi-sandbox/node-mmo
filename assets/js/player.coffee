{abs, PI} = Math

# プレーヤーの状態を表示するためのラベルを生成するクラス
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

# プレーヤーのアバターを管理するクラス
class PlayerAvatar extends enchant.Avatar
  constructor: (avatar) ->
    super avatar
    @game = enchant.Game.instance
    @scaleX = 0.5
    @scaleY = 0.5

    @x = - ~~(@width / 2)
    @y = - ~~(@height / 2)

# プレーヤーの残りHPを表示するクラス。操作プレーヤーのみ表示。
class PlayerHPGauge extends enchant.Sprite
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
      # もし前回と今回の残HP率が異なるなら再描画
      if @last_hp_rate isnt current_hp_rate
        @last_hp_rate = current_hp_rate
        @renderHPBar(current_hp_rate)

  # 残HP率を取得
  getHPrate: -> @player.hp/@player.HP

  # HPバーを表示
  renderHPBar: (hp_rate) ->
    @surface.context.lineWidth = @lineWidth

    @surface.context.clearRect 0, 0, game.width, game.height

    real_rad = 1/4 - (2/4) * hp_rate
    @drawArc @surface.context, real_rad,  1/4, 'red' , @lineWidth, false
    @drawArc @surface.context, 3/4     , -3/4, 'blue', @lineWidth, false

    @image = @surface
    @opacity = 0.6

  # canvasのarcをラップして円を書くメソッド
  drawArc: (ctx, start, end, color, size = 4, vec = true)->
    ctx.lineWidth = size
    ctx.beginPath()
    ctx.strokeStyle = color

    ctx.arc @radius+size, @radius+size, # x, y
      @radius, PI*start , PI*end , vec

    ctx.stroke()


# 複数のプレーヤーパーツを束ねて表示するPlayerクラス
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
      @gauge = new PlayerHPGauge @
      @addChild @gauge


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
