require 'coffee-script'
require 'livescript'
global <<< require 'prelude-ls'
global._ = require \underscore

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

# session
RedisStore = require('connect-redis')(express)
session_store = new RedisStore()
app.use express.bodyParser()
app.use express.cookieParser()
app.use express.session {
  secret: '<keyboard cat>'
  store: session_store
  cookie: maxAge: 60*60*1000
}

app.listen(5000)
console.log('server start:', 5000)

#Socket.IO
io = require('socket.io').listen(app)
cookie = require 'cookie'

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
  user_id = socket.id
  world.login user_id
  socket.emit 'getPlayerData', user_id

  # on client updating key
  socket.on 'key', ({key, state}) ->
    world.updatePlayerKeyState(user_id, key, state)

  # on client disconnection
  socket.on 'disconnect', ->
    world.logout user_id

# emit data by mainloop
world.start (world-state) ->
  entrance.emit 'update', worldState

# rooting
app.get '/', (req, res) ->
  req.session.login_date = String Date.now()
  res.render 'index'
