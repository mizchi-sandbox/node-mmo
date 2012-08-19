exports = {} unless exports?

log_cnt = 0
exports.p = => console.log arguments...
exports.pm = =>
  unless (log_cnt++)%30
    console.log arguments...

exports.encodeObject = ->
exports.decodeObject = ([x, y, user_id, avatar, action, dir]) ->
  x: x
  y: y
  dir: dir
  user_id: user_id
  avatar: avatar
  action: action

Nmmo.Utils = exports if window?