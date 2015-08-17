Message = require './models/message'
Thread = require './models/thread'

module.exports.addThread = (from, to, callback) ->
    thr = new Thread(from: from, to:to)
    thr.save (err) ->
        if err then null else callback thr

module.exports.addMessage = (thread, from, to, message) ->
    console.log "Hello #{threadId}! #{from} #{to} #{message}"
