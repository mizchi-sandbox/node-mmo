var Player = require('./player');

var World = function(){
  this.players = {};
  this.FPS = 15;
};

World.prototype = {
  // cache and return player
  login: function(id){
    var player = new Player(id);
    this.players[id] = player;
    return player;
  },

  //delete cache
  logout: function(id){
    delete this.players[id];
  },

  //start mainloop
  start: function(callback){
    var self = this;
    var mainloop = function(){
      for(var id in self.players){
        var player = self.players[id];
        player.move();
      }
      callback(self);
      setTimeout(mainloop, 1000/self.FPS);
    };
    mainloop();
  },

  toJson: function(){
    var objects = [];
    for(var id in this.players){
      var player = this.players[id];
      objects.push([player.x, player.y]);
    }
    return {
      objects: objects
    };
  }
};

module.exports = World;
