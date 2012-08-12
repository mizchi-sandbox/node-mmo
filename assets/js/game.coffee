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

  syncObject: (objects) ->
    client_ids = (obj.player_id for obj in game.rootScene.childNodes)
    server_ids = (id for [x, y, id] in objects)

    # オブジェクトの削除
    for node in @rootScene.childNodes
      unless node.player_id in server_ids
        @rootScene.removeChild node

    # オブジェクトの追加
    for [x, y, id] in objects
      if not _.include client_ids, id
        @rootScene.addChild new Nmmo.Player("2:2:1:2004:21230:22480", id)

  bindSocket: (socket, onEnterFrame) ->
    @playerData = {}
    @onload = => socket.on 'getPlayerData', (@playerData) =>
      @rootScene.addChild new Nmmo.Player("2:2:1:2004:21230:22480", @playerData.player_id)

      socket.on 'update', ({o}) =>
        @syncObject(o)
        # 全オブジェクトの状態を更新
        for [x, y, id] in o
          object = _.find @rootScene.childNodes, (obj) -> obj.player_id is id
          object.moveTo x, y

    @on 'enterframe', =>
      onEnterFrame(@input)

