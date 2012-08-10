Player = require('./player');

class World
  constructor: ->
    @players = {}
    @FPS = 15

  # cache and return player
  login: (id) ->
    @players[id] = new Player(id)

  # delete cache
  logout: (id) ->
    delete @players[id]

  #start mainloop
  start: (callback) ->
    do mainloop = =>
      for id, player of @players
        player.move()
      callback(@)
      setTimeout(mainloop, 1000/@FPS);

  toJson: ->
    objects = []
    for id, player of @players
      objects.push [player.x, player.y]
    {
      objects: objects
    }

module.exports = World
