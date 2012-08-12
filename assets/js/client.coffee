window.onload = ->
  socket = io.connect '/entrance'
  window.game = new Nmmo.Game

  last_input = game.input
  game.bindSocket socket, (input) ->
    for key, state of input
      if state isnt last_input[key]
        socket.emit 'key', key: key, state: state
    last_input = _.clone input

  game.start()
