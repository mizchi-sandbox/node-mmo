window.onload = ->
  socket = io.connect '/entrance'
  window.game = new Nmmo.Game
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
