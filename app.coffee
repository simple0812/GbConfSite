# Module dependencies
global.express = require 'express'
global.app = express()
global.mongoose = require 'mongoose'
global.Schema = mongoose.Schema
partials = require('express-partials')
mongoose.connect 'mongodb://localhost/meeting'
global.$WEBPATH = __dirname
global.Guid = require 'guid'
global.async = require 'async'
global._ = require 'underscore'
global.flash = require 'connect-flash'
global.passport = require 'passport'
global.LocalStrategy = require('passport-local').Strategy
global.Snapshot = {}
# all environments
app.set 'views', "#{__dirname}/views"
app.set 'view engine', 'coffee'
app.engine 'coffee',require('coffeecup').__express

app.use require('morgan')({ format: 'dev' })
app.use require('body-parser')()
app.use require('method-override')()
app.use require('cookie-parser')()
app.use require('cookie-session') {secret:'shgbit'}
app.use passport.initialize()
app.use passport.session()
app.use flash()
app.use partials()

partials.register('coffee','coffeecup')
partials.register('coffee',require('coffeecup'))
partials.register('coffee',require('coffeecup').render)

app.use express.static "#{__dirname}/public"

db = mongoose.connection
db.on 'error', (err)-> console.log err
db.once 'open', -> console.log 'db is opened'

logger = require './models/logger'
logger.level 'info'

# 权限验证
#app.use (req, res, next)->
#  console.log JSON.stringify req.cookies
#  return next() if req.url.indexOf '/login' >= 0
#  unless req.cookies.userid?
#    res.render 'test'
#  else next()
app.use (req, res, next) ->
  logger.info req.url, {'action':  req.method, 'source': ""}
  next()
require "./controllers/login"
require "./controllers/routes"
require "./controllers/organization"
require "./controllers/room"
require "./controllers/user"
require "./controllers/audit"
require "./controllers/booking"
require "./controllers/equipment"
require "./controllers/BM"
require "./controllers/MB"
require "./controllers/settings"
require "./controllers/notice"
require "./controllers/interface"
require "./controllers/box"
require "./controllers/group"




#app.listen 3001, ->
#  console.log 'listening on port 3001'

server = require('http').Server(app)
socketio = require('socket.io').listen server
socketio.sockets.on 'connection', (socket) ->
  console.log "SOCKET CONNECTION " + socket.id
  socket.on 'disconnect', (err)->
    logger.error err.message, {'action': "run", 'source': "socket"} if err
    logger.info "SOCKET DISCONNECTION", {'action': "run", 'source': "socket"}
    console.log "SOCKET DISCONNECTION " + socket.id
global.socketio = socketio
server.listen 3001, ->
  logger.info "service start", {'action': "run", 'source': "app"}
  console.log 'listening on port 3001'
