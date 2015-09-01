mongoose = require 'mongoose'

schema = new mongoose.Schema
    startDate:
        type: Date
        default: Date.now
    from:
        type: mongoose.Schema.Types.ObjectId
        ref: 'User'
        required: true
    to:
        type: mongoose.Schema.Types.ObjectId
        ref: 'User'
        required: true
    messages: [
        sendDate:
            type: Date
            default: Date.now
        readDate:
            type: Date
            default: null
        from:
            type: mongoose.Schema.Types.ObjectId
            ref: 'User'
            required: true
        message:
            type: String
            required: true
    ]

schema.statics.getThreads = (userid, callback) ->
    this.find({ $or:[{from:userid}, {to:userid}] }).populate('from to messages.from').exec()
    .then (thrs) ->
        callback thrs
    .then null, (err) ->
        console.log err
        callback null

schema.statics.addThread = (from, to, message, callback) ->
    msg = {from: from, message: message}
    thr = new @(from: from, to: to)
    thr.messages.push msg
    thr.save (err) ->
        if err then null else callback thr

schema.statics.getThread = (id, userid, callback) ->
    this.findOne({_id: id, $or:[{from:userid}, {to:userid}]}).populate('from to messages.from').exec()
    .then (thr) ->
        callback thr
    .then null, (err) ->
        console.log err
        callback null

schema.statics.addMessage = (id, from, message, callback) ->
    this.findOne {_id: id}, (err, thr) ->
        if err
            null
        msg = {from: from, message: message}
        thr.messages.push msg
        thr.save (err) ->
            if err then null else callback true

schema.statics.updateThread = (id, messages, callback) ->
    query = _id: id
    this.update query, { messages: messages }, (err) ->
        if err then callback false else callback true


module.exports = mongoose.model('Thread', schema)
