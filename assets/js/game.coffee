class window.Game
  constructor: ->
    canvas = document.getElementById 'canvas'
    canvas.width  = 400
    canvas.height = 300
    @ctx = canvas.getContext('2d')

  _drawCircle: (x, y) ->
    @ctx.beginPath()
    @ctx.arc(x, y, 10, 0, Math.PI*2)  # x, y, size, start, end
    @ctx.fillStyle = 'rgb(255,0,0)'
    @ctx.fill()

  render: (data) ->
    @ctx.clearRect(0,0,400,300)
    @ctx.save()
    for id, player of data._players
      @_drawCircle(player.x, player.y)
    @ctx.restore()
