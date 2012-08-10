$(function(){
  var socket = io.connect('/entrance');
  var game = new Game();

  //listener
  socket.on('update', function(worldState){
    game.render(worldState);
  });

  //send key logic
  var KEYCODES = {
    37: 'LEFT',
    38: 'UP',
    39: 'RIGHT',
    40: 'DOWN'
  };
  var sendKey = function(code, state){
    if(KEYCODES[code] !== undefined)
      socket.emit('key', {
        key   : KEYCODES[code].toLowerCase(),
        state: state
      });
  };

  $(window).keydown(function(e){
    sendKey(e.keyCode, true);
  });

  $(window).keyup(function(e){
    sendKey(e.keyCode, false);
  });

});
