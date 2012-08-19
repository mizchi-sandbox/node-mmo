exports = {} unless exports?

log_cnt = 0
exports.p = => console.log arguments...
exports.pm = =>
  unless (log_cnt++)%30
    console.log arguments...

class Encrypter
  constructor: (params_str) ->
    @protocol_mapped_array = 
      params_str
      .replace(/\s/g, '')
      .split(',')

  encode: (object) ->
    for key, index in @protocol_mapped_array
      object[key]

  decode: (object_array) ->
    retval = {}
    for val, index in object_array
      key = @protocol_mapped_array[index]
      retval[key] = val
    retval

object_encrypter = new Encrypter 'user_id,x,y,avatar,action,dir,HP,hp'

exports.encodeObject = -> object_encrypter.encode arguments...
exports.decodeObject = -> object_encrypter.decode arguments...

if window?
  Nmmo.Utils = exports 
else
  module.exports = exports
