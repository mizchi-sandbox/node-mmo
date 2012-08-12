Player = require('./player');

class World
  constructor: ->
    @_players = {}
    @FPS = 15

  # return player by id
  getPlayer: (user_id) ->
    @_players[user_id]

  # cache and return player
  login: (user_id) ->
    @_players[user_id] = new Player(user_id)

  # delete cache
  logout: (user_id) ->
    delete @_players[user_id]

  # update player key state by id
  updatePlayerKeyState: (user_id, key, state) ->
    player = @getPlayer(user_id)
    player.updateKey key, state

  # start mainloop
  start: (emitter) ->
    do mainloop = =>
      for id, player of @_players
        player.move()
      emitter @compless()
      setTimeout(mainloop, 1000/@FPS);

  compless: ->
    o: ([x, y, user_id, avatar] for user_id, {x, y, avatar} of @_players)

module.exports = World
