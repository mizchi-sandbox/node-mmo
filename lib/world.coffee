Player = require('./player');

class World
  constructor: ->
    @_players = {}
    @FPS = 15

  # return player by id
  getPlayer: (player_id) ->
    @_players[player_id]

  # cache and return player
  login: (player_id) ->
    @_players[player_id] = new Player(player_id)

  # delete cache
  logout: (player_id) ->
    delete @_players[player_id]

  # update player key state by id
  updatePlayerKeyState: (player_id, key, state) ->
    player = @getPlayer(player_id)
    player.updateKey key, state

  # start mainloop
  start: (emitter) ->
    do mainloop = =>
      for id, player of @_players
        player.move()
      emitter(@)
      setTimeout(mainloop, 1000/@FPS);

  minify: ->
    # [[x, y, id]...]
    ([x, y, id] for id, {x, y} of @_players)

module.exports = World
