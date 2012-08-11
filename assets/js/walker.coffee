$ ->
  socket = io.connect '/entrance'
  game = new Game
  window.playerData = null

  #listener
  socket.on 'getPlayerData', (data) ->
    playerData = data

  socket.on 'update', (worldState) ->
    game.render(worldState)

  #send key logic
  KEYCODES =
    37: 'LEFT',
    38: 'UP',
    39: 'RIGHT',
    40: 'DOWN'

  sendKey = (code, state) ->
    if KEYCODES[code] isnt undefined
      socket.emit 'key',
        key   : KEYCODES[code].toLowerCase(),
        state : state

  $(window).keydown (e) ->
    sendKey e.keyCode, true

  $(window).keyup (e) ->
    sendKey e.keyCode, false
