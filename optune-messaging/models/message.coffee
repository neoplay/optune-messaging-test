mongoose = require 'mongoose'

schema = new mongoose.Schema
    sendDate:
        type: Date
        default: Date.now
    readDate:
        type: Date
        default: null
    sender:
        type: String
        required: true
    recipient:
        type: String
        required: true

module.exports = mongoose.model('Message', schema)
