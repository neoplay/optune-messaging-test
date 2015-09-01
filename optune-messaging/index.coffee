mongoose = require 'mongoose'
Thread = require './models/thread'

module.exports = (app, userModel = 'User') ->

    User = mongoose.model userModel

    app.use (req, res, next) ->
        if !res.locals.user
            res.locals.user = req.session.user
        next()

    # threads
    app.get '/messaging', (req, res) ->
        Thread.getThreads req.session.user.id, (result) ->
            res.render 'messaging/threads', { threads: result }

    # thread : new
    app.get '/messaging/new', (req, res) ->
        res.locals.users = User.find { _id: { $ne: req.session.user.id } }, (err, obj) ->
            if err
                #todo error message
                console.log 'could not load users' #temp
            res.locals.users = obj
            res.render 'messaging/threadNew', {}

    app.post '/messaging/new', (req, res) ->
        Thread.addThread req.session.user.id, req.body.to, req.body.message, (result) ->
            if result
                res.redirect '/messaging/' + result._id
            else
                #todo error message
                res.render 'messaging/threadNew', {}

    # thread : show
    app.get '/messaging/:id', (req, res) ->
        Thread.getThread req.params.id, req.session.user.id, (result) ->
            if !result
                #todo error message
                res.redirect '/messaging'
            # preprocess messages
            for msg, i in result.messages
                # update readDate
                if msg.readDate == null && !(msg.from._id.toString() is req.session.user.id.toString())
                    result.messages[i].readDate = new Date
            # save readDate
            result.save (err) ->
                if err
                    #todo error message
                    console.log 'error updateing read date' #temp
                res.render 'messaging/threadShow', {thread: result}

    app.post '/messaging/:id', (req, res) ->
        Thread.addMessage req.params.id, req.session.user.id, req.body.message, (result) ->
            if !result
                #todo error message
                console.log 'error' #temp
            res.redirect '/messaging/' + req.params.id
