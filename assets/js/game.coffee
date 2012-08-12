class Nmmo.Game extends enchant.Game
  constructor: ->
    window.game = @
    super 320, 240
    @fps = 15
    # @scene.backgroundColor = 'black'
    @rootScene.backgroundColor="#888888"

    @bg = new AvatarBG(0)
    @bg.y = 50
    @rootScene.addChild(@bg)

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
      unless _.include client_ids, id
        @rootScene.addChild new Nmmo.Player(avatar, id)

    # オブジェクトの削除
    for node in @rootScene.childNodes when node instanceof Nmmo.Player
      unless node.user_id in server_ids
        @rootScene.removeChild node

  update: (objects) ->
    for [x, y, id] in objects
      object = _.find @rootScene.childNodes, (obj) -> obj.user_id is id
      object.moveTo x, y
      @bg.scroll x

  bindSocket: (socket, onEnterFrame) ->
    @playerData = {}
    @onload = => socket.on 'getPlayerData', (@playerData) =>
      socket.on 'update', ({o}) =>
        @sync(o)
        @update(o)

    @on 'enterframe', =>
      onEnterFrame(@input)

