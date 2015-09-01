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
                req.flash 'danger', 'Die Empfängerliste konnte nicht geladen werden.'
            res.locals.users = obj
            res.render 'messaging/threadNew', {}

    app.post '/messaging/new', (req, res) ->
        Thread.addThread req.session.user.id, req.body.to, req.body.message, (result) ->
            if result
                res.redirect '/messaging/' + result._id
            else
                req.flash 'danger', 'Der Thread konnte nicht erstellt werden.'
                res.redirect '/messaging/new'

    # thread : show
    app.get '/messaging/:id', (req, res) ->
        Thread.getThread req.params.id, req.session.user.id, (result) ->
            if not result
                # TODO: fix error headers already sent
                req.flash 'danger', 'Der Thread wurde nicht gefunden.'
                return res.redirect '/messaging'
            # preprocess messages
            for msg, i in result.messages
                # update readDate
                if msg.readDate == null && !(msg.from._id.toString() is req.session.user.id.toString())
                    result.messages[i].readDate = new Date
            # save readDate
            result.save (err) ->
                if err
                    req.flash 'danger', 'Einige Nachrichten konnten nicht als gelesen markiert werden.'
                res.render 'messaging/threadShow', {thread: result}

    app.post '/messaging/:id', (req, res) ->
        Thread.addMessage req.params.id, req.session.user.id, req.body.message, (result) ->
            if !result
                req.flash 'danger', 'Die Nachricht konnte nicht gesendet werden.'
            res.redirect '/messaging/' + req.params.id
