express  = require 'express'
mongoose = require 'mongoose'
MongoSessionStore = require('session-mongoose')(require('connect'))
sessionStore = new MongoSessionStore(url: 'mongodb://127.0.0.1/optune-messaging-test')

PORT        = process.env.PORT || 3000

app = express()
app.set 'port', PORT

app.use(express.static(__dirname + '/dist'));
app.set 'view engine', 'jade'
app.set 'views', __dirname + '/frontend/templates'

# mongoose
mongoose.connect 'mongodb://127.0.0.1/optune-messaging-test'

# body parser
app.use require('body-parser')()
# cookie parser
app.use require('cookie-parser')('testSecret')
# express session
app.use require('express-session')(store: sessionStore)

app.use '/img', express.static(__dirname + '/frontend/images')
app.use '/theme', express.static(__dirname + '/frontend/theme')
app.use '/fonts', express.static(__dirname + '/frontend/fonts')

# moment
app.locals.moment = require 'moment'

# user module
require('./user') app
# messaging module
require('./optune-messaging') app, 'User'

# error 404
app.use (req, res, next) ->
    res.status 404
    res.render '404'

# error 500
app.use (err, req, res, next) ->
    console.error(err.stack);
    res.status 500
    res.render '500'

if not module.parent
    app.listen app.get('port')
    console.log '\n' + 'Server started and listening on port:' + app.get('port')

module.exports = app
