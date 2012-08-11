#Express
express = require 'express' 
assets  = require 'connect-assets'

app = express.createServer()

# middleware
app.use express.static(__dirname + '/public')
app.use assets()
app.set 'view engine', 'ejs'
app.set 'view options', layout: false
app.get '/', (req, res) ->
  res.render 'index'

app.listen(3000)
console.log('server start:', 3000)


#StateMachine
World = require './lib/world' 
world = new World

#Socket.IO
io = require('socket.io').listen(app)
entrance = io.of '/entrance'
entrance.on 'connection', (socket) ->
  # init
  player_id = socket.id
  world.login player_id
  socket.emit 'getPlayerData', player_id: player_id

  # on client updating key
  socket.on 'key', ({key, state}) ->
    world.updatePlayerKeyState(player_id, key, state)

  # on client disconnection
  socket.on 'disconnect', ->
    world.logout player_id

# emit data by mainloop
world.start (worldState) ->
  entrance.emit 'update', worldState
