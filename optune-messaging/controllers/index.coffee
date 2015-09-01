#Message = require '../models/message'
Thread = require '../models/thread'

module.exports.getThreads = (userid, callback) ->
    Thread.find { $or:[{from:userid}, {to:userid}] }, (err, thrs) ->
        if err then null else callback thrs

module.exports.updateThread = (id, messages, callback) ->
    query = _id: id
    Thread.update query, { messages: messages }, (err) ->
        if err then callback false else callback true

module.exports.addThread = (from, to, message, callback) ->
    msg = {from: from, message: message}
    thr = new Thread(from: from, to: to)
    thr.messages.push msg
    thr.save (err) ->
        if err then null else callback thr

module.exports.getThread = (id, userid, callback) ->
    Thread.findOne {_id: id, $or:[{from:userid}, {to:userid}]}, (err, thr) ->
        if err then null else callback thr

module.exports.addMessage = (id, from, message, callback) ->
    Thread.findOne {_id: id}, (err, thr) ->
        if err
            null
        msg = {from: from, message: message}
        thr.messages.push msg
        thr.save (err) ->
            if err then null else callback true
