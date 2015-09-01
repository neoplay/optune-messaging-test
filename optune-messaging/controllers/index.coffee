Thread = require '../models/thread'

module.exports.getThreads = (userid, callback) ->
    Thread.find({ $or:[{from:userid}, {to:userid}] }).populate('from to messages.from').exec()
    .then (thrs) ->
        callback thrs
    .then null, (err) ->
        console.log err
        callback null

module.exports.addThread = (from, to, message, callback) ->
    msg = {from: from, message: message}
    thr = new Thread(from: from, to: to)
    thr.messages.push msg
    thr.save (err) ->
        if err then null else callback thr

module.exports.getThread = (id, userid, callback) ->
    Thread.findOne({_id: id, $or:[{from:userid}, {to:userid}]}).populate('from to messages.from').exec()
    .then (thr) ->
        callback thr
    .then null, (err) ->
        console.log err
        callback null

module.exports.addMessage = (id, from, message, callback) ->
    Thread.findOne {_id: id}, (err, thr) ->
        if err
            null
        msg = {from: from, message: message}
        thr.messages.push msg
        thr.save (err) ->
            if err then null else callback true

module.exports.updateThread = (id, messages, callback) ->
    query = _id: id
    Thread.update query, { messages: messages }, (err) ->
        if err then callback false else callback true
