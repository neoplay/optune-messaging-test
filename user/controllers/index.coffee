User = require '../models/user'
mongoose = require 'mongoose'
messaging = require('../../optune-messaging/index')

module.exports = (app) ->

    # index
    app.get '/', (req, res) ->
        #thread = messaging.addThread 'from', 'to', (result) ->
        #    console.log result
        res.render 'index', {session: req.session}

    app.post '/add', (req, res) ->
        User.findOne {name: req.body.name}, (err, obj) ->
            if err
                throw err
            else if obj
                req.session.user = {}
                req.session.user.id = obj._id
                req.session.user.name = obj.name
                console.log req.session
                res.redirect '/'
            else
                us = new User(name: req.body.name)
                us.save (err, obj) ->
                    if err
                        throw err
                    else
                        req.session.user = {}
                        req.session.user.id = obj._id
                        req.session.user.name = obj.name
                        res.redirect '/'

    app.get '/logout', (req, res) ->
        req.session.destroy()
        res.redirect '/'
