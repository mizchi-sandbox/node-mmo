class Nmmo.Game extends enchant.Game
  constructor: ->
    super 320, 240
    @fps = 15
    @scene = @rootScene
    @scene.backgroundColor = 'black'
    @preload [
      "avatarBg1.png"
      "avatarBg2.png"
      "avatarBg3.png"
    ]

  sync: (objects) ->
    client_ids = (obj.user_id for obj in game.rootScene.childNodes)
    server_ids = (id for [__, __, id] in objects)

    # オブジェクトの追加
    for [x, y, id, avatar] in objects
      if not _.include client_ids, id
        @rootScene.addChild new Nmmo.Player(avatar, id)

    # オブジェクトの削除
    for node in @rootScene.childNodes
      unless node.user_id in server_ids
        @rootScene.removeChild node

  update: (objects) ->
    for [x, y, id] in objects
      object = _.find @rootScene.childNodes, (obj) -> obj.user_id is id
      object.moveTo x, y

  bindSocket: (socket, onEnterFrame) ->
    @playerData = {}
    @onload = => socket.on 'getPlayerData', (@playerData) =>
      socket.on 'update', ({o}) =>
        @sync(o)
        @update(o)

    @on 'enterframe', =>
      onEnterFrame(@input)

