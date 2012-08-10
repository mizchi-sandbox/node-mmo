#Express
express = require('express')
app = express.createServer()
app.use(express.static(__dirname + '/public'))
app.listen(3000)
console.log('server start:', 3000)

#StateMachine
World = require('./lib/world')
world = new World()

#Socket.IO
io = require('socket.io').listen(app)
io.sockets.on 'connection', (socket) ->
  player = world.login(socket.id)
  socket.on 'key', ({key, state}) ->
    player.updateKey key, state

  socket.on 'disconnect', ->
    world.logout socket.id

# emit data by mainloop
world.start (worldState) ->
  io.sockets.emit 'update', worldState
