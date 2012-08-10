window.Game = function(){
  var canvas = document.getElementById('canvas');
  canvas.width = 400;
  canvas.height = 300;
  this.ctx = canvas.getContext('2d');
};

Game.prototype = {
  _drawCircle: function(x, y){
    this.ctx.beginPath();
    this.ctx.arc(x, y, 10, 0, Math.PI*2); // x, y, size, start, end
    this.ctx.fillStyle = 'rgb(255,0,0)'
    this.ctx.fill();
  },
  render: function(data){
    //reset canvas before each rendering
    this.ctx.clearRect(0,0,400,300);
    this.ctx.save();

    //draw all objects
    for(var i in data.players){
      var obj = data.players[i];
      this._drawCircle(obj.x, obj.y);
    }
    this.ctx.restore();
  }
};
