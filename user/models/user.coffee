mongoose = require 'mongoose'

userSchema = new mongoose.Schema
    name: String

module.exports = mongoose.model('User', userSchema)
