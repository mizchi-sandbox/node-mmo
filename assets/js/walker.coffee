
enchant()
class SampleGame extends enchant.Game
  constructor : ->
    super 320, 320
    @fps = 30
    SampleGame.game = @
    @preload "miku.gif"
    @onload = ->
      @rootScene.addChild new Player(100, 100)
    @start()

class Player extends Sprite
  constructor: (x, y) ->
    super 44, 32
    @x = x
    @y = y
    game = SampleGame.game
    @image = game.assets['miku.gif']
    @addEventListener 'enterframe', ->
      if game.input.up
        @y -= 5
      else if game.input.down
        @y += 5
      if game.input.left
        @x -= 5
      else if game.input.right
        @x += 5

$ ->
  socket = io.connect '/entrance'
  game = new MMOGame
  window.playerData = null

  #listener
  socket.on 'getPlayerData', (data) ->
    playerData = data

  socket.on 'update', (worldState) ->
    game.render(worldState)

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
  # new SampleGame()
