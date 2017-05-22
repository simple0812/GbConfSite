Room = require "../models/room"
Booking = require "../models/booking"
_ = require "underscore"
formidable = require "formidable"
path = require "path"
TMP_DIR = "public/tmp"
ROOM_DIR = "public/img/room"
fs = require "fs"
Setting =require "#{$WEBPATH}/models/setting"
#async = require "async"
#updateRoomStamp = () ->
#  Setting.update {}, {$set:{'stamps.room':Guid.raw()}}, (err, count) ->
#    console.log(count)

mvImage = (imgurl, callback) ->
  dirname = path.dirname imgurl
  filename = path.basename imgurl
  if dirname is "/tmp"
    oldpath = path.join TMP_DIR, filename
    newpath = path.join ROOM_DIR, filename
    fs.rename oldpath, newpath, (err) ->
#TODO write to error LOG
      rmTMPImage()
      callback(path.join("/img/room", filename))

rmTMPImage = ->
  fs.readdir TMP_DIR, (err, files) ->
# TODO write to error LOG
    for each in files
      fs.unlink (path.join TMP_DIR, each), (err) -> console.log err if err?

rmOldImage = (imgURL)->
  p = path.join ROOM_DIR, (path.basename imgURL)
  fs.unlink p, (err) -> console.log err if err?
#TODO write to error LOG


app.get '/room/index', authenticateCheck, (req, res) ->
  return res.redirect "/MB/index" if "normal" is req.user?.role
  return res.redirect "/audit" if "auditor" is req.user?.role
  return res.send 403, "您无权访问此页面" unless "admin" is req.user?.role
  res.render 'room/index', title: '会议室'

app.get '/room/list', (req, res) ->
  Room.find({status: 0}).populate("equipments").populate("boxes").exec (err, rooms) ->
#    populate({path:'equipments', select:'name role'})
    return res.json({status:'failed', message:err.message}) if err?
    range = ["_id", "name", "createTime", "capacity", "isOpen", "isAudit", "isBoxBooking", "remarks", "imgURL","boxes"]
    results = _.map rooms, (room)->
      p = {}
      p[key] = room.get(key) for key in range
      p.id = room._doc._id
      p.boxes = []
      p.boxes.push(each.name) for each in room.boxes
      p.equipments = []
      p.equipments.push {id: each._id, name: each.get("name"), icon:each.get("icon")} for each in room.equipments when each.get("status") is 0
      return p
    res.json {rooms:results}

app.get '/roomall', (req, res) ->
  Room.find({status: 0}).populate("equipments").exec (err, rooms) ->
# TODO write to error LOG
    return res.send(400, err.message) if err?
    range = ["_id", "name", "createTime", "capacity", "isOpen", "isAudit", "isBoxBooking", "remarks", "imgURL"]
    results = _.map rooms, (room)->
      p = {}
      p[key] = room.get(key) for key in range
      p.equipments = []
      p.equipments.push {id: each._id, name: each.get("name")} for each in room.equipments when each.get("status") is 0
      return p
    res.json results

app.get '/room/create', (req, res) ->
  res.render 'room/edit', title: "新建会议室"

app.post '/room', (req, res) ->
# TODO check the value of req.body
  room = new Room()
  range = ['name', 'capacity', 'isOpen', 'isAudit', 'isBoxBooking', 'remarks', 'equipments', 'boxes']
  room[k] = req.body[k] for k in range when req.body[k]?
  exec = (imgurl) ->
    room.imgURL = imgurl or null
    Room.find {name: room.name, status: 0}, (err, rooms) ->
# TODO write to error LOG
      return res.send(400, err.message) if err?
      return res.send 409 if rooms.length > 0
      room.save (e, result) ->
# TODO write to error LOG
        return res.send(400, e.message) if e?
        console.log('jinru post le ')
        Room.updateRoomStamp()
#        Setting.update {}, {$set:{stamps:{room:'asdfsadfsadfsdf'}}}, (err, count) ->
        res.json result
  if req.body.imgURL? then mvImage req.body.imgURL, exec else exec()

app.delete '/rooms', (req, res) ->
  ids = req.body or []
  Room.where("_id").in(ids).update({status: 9}).exec (err, doc) ->
# TODO write to error LOG
    return res.send(400, err.message) if err?
    Booking.update {room: {$in: ids}}, {status:9}, {multi: true}, (err, docs) ->
      console.log err if err?
      Room.updateRoomStamp()
      res.json ids
## delete use async
#  async.map ids, (id, callback) ->
#    Room.findByIdAndUpdate id, {status: 9}, (err, room) ->
## TODO write to error LOG
#      callback err, id
#  , (err, results) ->
## TODO write to error LOG
#      return res.send(400, err.message) if err?
#      res.json results

app.get '/room/edit/:roomID', (req, res) ->
  id = req.params.roomID
  res.render 'room/edit', title: "编辑会议室", id:id

app.get '/room/:roomID', (req, res) ->
  id = req.params.roomID
  Room.findById(id).populate("equipments").exec (err, room) ->
# TODO write to error LOG
    return res.send(400, err.message) if err?
    range = ["_id", "name", "createTime", "capacity", "isOpen", "isAudit", "isBoxBooking", "remarks", "imgURL"]
    results = {}
    results[key] = room.get(key) for key in range
    results.equipments = []
    results.equipments.push {id: each._id, name: each.get("name")} for each in room.equipments when each.get("status") is 0
    res.json results

app.put '/room/:roomID', (req, res) ->
  id = req.params.roomID
  range = ['name', 'capacity', 'isOpen', 'isAudit', 'isBoxBooking', 'remarks', 'equipments', 'boxes']
  Room.findById id, (err, room) ->
# TODO write to error LOG
    return res.send(404, err.message) if err?
    room.set k, req.body[k] for k in range when req.body[k]?
    if req.body.imgURL? and path.basename(room.get("imgURL")) isnt path.basename(req.body.imgURL)
      mvImage req.body.imgURL, (imgurl) ->
        p = room.get "imgURL"
        rmOldImage p
        room.imgURL = imgurl or null
        room.save (err, doc) ->
# TODO write to error LOG
          return res.send(400, err.message) if err?
          Room.updateRoomStamp()
          res.json doc
    else
      room.save (err, doc)->
# TODO write to error LOG
        return res.send(400, err.message) if err?
        Room.updateRoomStamp()
        res.json doc

app.delete '/room/:roomID', (req, res) ->
  id = req.params.roomID
  Room.findByIdAndUpdate id, {status: 9}, (err, room) ->
# TODO write to error LOG
    return res.send(400, err.message) if err?
    Booking.update {room: room._id, status: 0}, {status:9}, {multi: true}, (err, docs) ->
      console.log err if err?
      Room.updateRoomStamp()
      res.json room

app.post '/upload/room/image', (req, res) ->
  form = new formidable.IncomingForm()
  form.encoding = 'utf-8'
  form.uploadDir = TMP_DIR
  form.keepExtensions = true
  form.parse req, (err, field, file) ->
# TODO write to error LOG
    return req.send(400, err.message) if err?
    file = file["files[]"]
    return req.send(400, "上传失败") unless file?
    filename = path.basename file.path
    res.json "/tmp/" + filename

# 预约查询（条件查询）
app.get "/rooms", (req, res) ->
  console.log 'ddd'
  equipments = req.query.equipments or []
  capacity = parseInt req.query.capacity or 0
  Room.where().and([{status: 0}, {isOpen: 1}]).where("capacity").gte(capacity).exec (err, rooms) ->
# TODO write to error LOG
    return req.send(400, err.message) if err?
    results = _.filter rooms, (room) ->
      for each in equipments
        p = []
        p.push id.toString() for id in room.equipments
        return false unless _.contains p, each
      true
    res.json results
