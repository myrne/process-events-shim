{EventEmitter} = require "events"

processLacksEventFunctions = ->
  return false for name, value of EventEmitter.prototype when process[name]?
  return true

return unless window? and window.document and window.navigator # likely in the browser
return unless process? and global? # node-like
return unless window is global # likely in a shimmed environmemnt, like browserify
return unless window.onerror is null # it's initially null in at least Chrome, Safari, Firefox
return unless processLacksEventFunctions() # don't run if event functions are set by something else

process[name] = value for name, value of EventEmitter.prototype

window.onerror = (err, url, line) ->
  process.emit "uncaughtException", new Error "#{err} (#{url}:#{line})"

window.addEventListener "unload", (event) ->
  process.emit "exit"