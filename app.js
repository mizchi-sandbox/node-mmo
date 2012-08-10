//Express
var express = require('express');
var app = express.createServer();
app.use(express.static(__dirname + '/public'));
app.listen(3000);
console.log('server start:', 3000);

// StateMachine
var World = require('./lib/world');
var world = new World();

//Socket.IO
var io = require('socket.io').listen(app);
io.sockets.on('connection', function (socket) {
  var player = world.login(socket.id);

  socket.on('key', function(data){
    player.updateKey(data.key, data.state);
  });

  socket.on('disconnect', function(){
    world.logout(socket.id);
  });
});

//emit data by mainloop
world.start(function(worldState){
  io.sockets.emit('update', worldState);
});
