window.onload = ->
  socket = io.connect '/entrance'
  window.game = new Nmmo.Game
  game.bindIO socket

  last_input = game.input
  game.on 'enterframe', ->
    for key, state of game.input
      if state isnt last_input[key]
        socket.emit 'key', key: key, state: state
    last_input = _.clone game.input

  game.start()
