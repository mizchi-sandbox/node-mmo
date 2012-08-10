var Player = function(id){
  this.id = id;
  this.x = 0;
  this.y = 0;
  this.keys = {
     up   : false,
     down : false,
     right: false,
     left : false
  };
};

Player.prototype = {
  move: function(){
    if(this.keys.up)    this.y -= 1
    if(this.keys.down)  this.y += 1
    if(this.keys.right) this.x += 1
    if(this.keys.left)  this.x -= 1
  },
  updateKey: function(key, status){
    this.keys[key] = status;
  }
};

module.exports = Player;
