enchant()
enchant.EventTarget::on = -> @addEventListener arguments...

class MyGame extends enchant.Game
  constructor: (socket) ->
    super 320, 240
    @fps = 30
    MyGame.game = @

    @scene = @rootScene
    @scene.backgroundColor = 'black' 

    @preload "chara1.png"
    @onload = ->
      @rootScene.addChild new Player(100, 100)
    @start()

    @on 'enterframe', =>
      if @input.up
        socket.emit 'key', key: 'up', state: true
      if @input.down
        socket.emit 'key', key: 'down', state: true
      if @input.left
        socket.emit 'key', key: 'left', state: true
      if @input.right
        socket.emit 'key', key: 'right', state: true



class Player extends enchant.Sprite
  constructor: (@x, @y, @_id) ->
    super 32, 32
    game = MyGame.game
    @image = game.assets['chara1.png']
    @addEventListener 'enterframe', =>

$ ->
  socket = io.connect '/entrance'
  window.game = new MyGame socket
  playerData = {}

  #listener
  socket.on 'getPlayerData', (data) ->
    console.log '=======', data
    playerData = data

  socket.on 'update', (worldState) ->
    player_object = game.rootScene.childNodes[0]
    for id, {x, y, id} of worldState._players
      if id is playerData.player_id
        player_object.x = x
        player_object.y = y
      # else
      #   console.log 'other', x, y

    player = game.rootScene.childNodes[0]
    # game.render(worldState)

  #send key logic
  KEYCODES =
    37: 'left'
    38: 'up'
    39: 'right'
    40: 'down'

  sendKey = (state) -> (e) ->
    return if KEYCODES[e.keyCode] is undefined
    socket.emit 'key',
      key: KEYCODES[e.keyCode], state: state

  $(window).keydown sendKey(true)
  $(window).keyup sendKey(false)
