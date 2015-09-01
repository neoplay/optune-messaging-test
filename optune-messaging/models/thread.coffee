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

module.exports = mongoose.model('Thread', schema)
