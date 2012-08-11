#StateMachine
World = require './lib/world'
world = new World

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

# session
RedisStore = require('connect-redis')(express)
session_store = new RedisStore()
app.use express.bodyParser()
app.use express.cookieParser()
app.use express.session
  secret: '<keyboard cat>'
  store: session_store
  cookie: maxAge: 60*60*1000

app.listen(5000)
console.log('server start:', 5000)

#Socket.IO
io = require('socket.io').listen(app)
cookie = require 'cookie'

console.log require('connect').utils

io.set 'log level', 1
io.set 'authorization', (handshake, callback) ->
  decoded_cookie = cookie.parse handshake.headers.cookie
  handshake.sid = decoded_cookie['connect.sid']
  console.log decoded_cookie
  session_store.get handshake.sid, (e, data) ->
    handshake.session = data
    callback null, true

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
