mongoose = require 'mongoose'

schema = new mongoose.Schema
    startDate:
        type: Date
        default: Date.now
    messages: [type: mongoose.Schema.Types.ObjectId, ref: 'Message']

module.exports = mongoose.model('Thread', schema)
