_ = require 'underscore'

Entity = require \./entity
Player = require \./player
Monster = require \./monster

{ 
  encodeObject
  decodeObject
} = require '../shared/utils'

class World extends Entity
  ->
    @_players = {}
    @monsters = []
    @FPS = 15

  # return player by id
  getPlayer: (user_id) ->
    @_players[user_id]

  # return all objects in its sights
  getObjectsByPlayer: (player) ->
    # TODO 攻撃レンジは武器に依存
    players: (filter (~> player.distance(it) < 50), @monsters)
  # cache and return player
  login: (user_id) ->
    @_players[user_id] = new Player @, user_id

  # delete cache
  logout: (user_id) ->
    delete @_players[user_id]

  # update player key state by id
  updatePlayerKeyState: (user_id, key, state) ->
    player = @getPlayer(user_id)
    player.updateKey key, state

  # start mainloop
  start: (emitter) ->
    do mainloop = ~>
      @update!
      emitter @compless!
      setTimeout mainloop, 1000/@FPS

  # game main logic
  update: ->
    for id, player of @_players
      player.emit 'update'

    for monster in @monsters
      monster.emit 'update'

    if @monsters.length < 8
      @monsters.push (new Monster @, ~~(Math.random()* 1000))

  compless: ->
    o: map encodeObject, (values @_players).concat @monsters

module.exports = World
