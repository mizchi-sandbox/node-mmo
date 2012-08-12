enchant()
enchant.EventTarget::on = -> @addEventListener arguments...

class MyGame extends enchant.Game
  constructor: ->
    super 320, 240
    @fps = 15
    MyGame.game = @

    @scene = @rootScene
    @scene.backgroundColor = 'black'
    @preload [
      "avatarBg1.png"
      "avatarBg2.png"
      "avatarBg3.png"
    ]

  syncObject: (objects) ->
    client_ids = (obj.player_id for obj in game.rootScene.childNodes)
    server_ids = (id for [x, y, id] in objects)

    # オブジェクトの削除
    for node in @rootScene.childNodes
      unless node.player_id in server_ids
        @rootScene.removeChild node

    # オブジェクトの追加
    for [x, y, id] in objects
      if not _.include client_ids, id
        @rootScene.addChild new Player("2:2:1:2004:21230:22480", id)

  bindSocket: (socket, onEnterFrame) ->
    @playerData = {}
    @onload = => socket.on 'getPlayerData', (@playerData) =>
      @rootScene.addChild new Player("2:2:1:2004:21230:22480", @playerData.player_id)

      socket.on 'update', ({o}) =>
        @syncObject(o)
        # 全オブジェクトの状態を更新
        for [x, y, id] in o
          object = _.find @rootScene.childNodes, (obj) -> obj.player_id is id
          object.moveTo x, y

    @on 'enterframe', =>
      onEnterFrame(@input)

{abs} = Math
class Player extends enchant.Avatar
  constructor: (avatar_id, @player_id) ->
    super avatar_id
    game = MyGame.game

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

window.onload = ->
  socket = io.connect '/entrance'
  window.game = new MyGame
  window.game.bindSocket socket, (input) ->
    if input.up
      socket.emit 'key', key: 'up', state: true
    if input.down
      socket.emit 'key', key: 'down', state: true
    if input.left
      socket.emit 'key', key: 'left', state: true
    if input.right
      socket.emit 'key', key: 'right', state: true

  window.game.start()

  KEYCODES =
    37: 'left'
    38: 'up'
    39: 'right'
    40: 'down'

  sendKey = (state) -> (e) ->
    return if KEYCODES[e.keyCode] is undefined
    socket.emit 'key',
      key: KEYCODES[e.keyCode], state: state

  $(window).keyup sendKey(false)
