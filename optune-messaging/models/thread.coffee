mongoose = require 'mongoose'

schema = new mongoose.Schema
    startDate:
        type: Date
        default: Date.now
    from:
        type: String
        required: true
    to:
        type: String
        required: true
    messages: [
        sendDate:
            type: Date
            default: Date.now
        readDate:
            type: Date
            default: null
        from:
            type: String
            required: true
        message:
            type: String
            required: true
    ]

module.exports = mongoose.model('Thread', schema)
