Box =require "#{$WEBPATH}/models/box"
Group =require "#{$WEBPATH}/models/group"
Room =require "#{$WEBPATH}/models/room"
moment = require "moment"
#async = require "async"
#_ = require 'underscore'

app.get '/devices', (req,res) ->
#  Box.find().exec (err, boxes) ->
  Box.find().populate('room').exec (err, boxes) ->
  # TODO write to error LOG
    return res.send(400, err.message) if err?
    console.log boxes
    for each in boxes
      if !each.lastLinkTime
        each._doc.online = false
      else if moment(each.lastLinkTime).diff(moment(),'m') < 3
        each._doc.online = true
      else
        each._doc.online = false
    res.json boxes

app.post '/device', (req,res) ->
  #TODO create box
  console.log 'create box'
  Box.findOne {name:req.body.name}, (err,doc) ->
    return res.json {'status':'fail', 'result':JSON.stringify err} if err?
    return res.send(400, '终端名已存在') if doc?
#    return res.send {400, 'message':'终端名已存在'} if doc?
#    res.json {'status':'success', 'result':'ddd'}
    box = new Box()
    data = req.body
#    delete data.room
    box[k] = v for k, v of data
    box.lastLinkTime = new Date()
    box.save (err, doc) ->
      return res.json {'status':'fail', 'result':JSON.stringify err} if err?
      boxes = []
      boxes.push(doc._id)
      Room.findByIdAndUpdate(doc.room,{boxes:doc._id}).exec (err,doroom) ->
        return res.json {'status':'fail', 'result':JSON.stringify err} if err?
        Box.findById(doc._id).populate('room').exec (err,resultBox) ->
          return res.json {'status':'fail', 'result':JSON.stringify err} if err?
          console.log resultBox
          res.json resultBox


app.put '/device/:id', (req,res) ->
  #TODO update box
  console.log 'update box'
  id = req.params.id
  data = req.body
  delete data.room
  delete data._id
  console.log data
  Box.findByIdAndUpdate(id,data).populate('room').exec (err,box) ->
    return res.send(400, err.message) if err?
    console.log err if err?
    console.log box
    res.json box

app.put '/devices', (req,res) ->
  ids = req.body.ids || []
  data = req.body.data || {}
  Box.update {_id: {$in: ids}}, data, {multi: true}, (err, docs) ->
    console.log err if err?
    return res.send(400, err.message) if err?
    res.json 'status':'success'
#  Box.where("_id").in(ids).update(data).exec (err, doc) ->
#    console.log doc
#    console.log err if err?
#    res.json 'status':'success'

app.delete '/device/:id', (req,res) ->

  #TODO delete box
  console.log 'delete box'
  id = req.params.id
  Box.findByIdAndRemove id, (err,box) ->
    console.log err if err?
    return res.send(400, err.message) if err?
    Group.update {},{$pull:{boxes:id}}, {multi: true}, (err, counts)->
      console.log err if err?
      return res.send(400, err.message) if err?

      res.json {'status':'success', 'message':'删除成功'}


#
#  id = req.params.roomID
#  Room.findByIdAndUpdate id, {status: 9}, (err, room) ->
## TODO write to error LOG
#    return res.send(400, err.message) if err?
#    Booking.update {room: room._id, status: 0}, {status:9}, {multi: true}, (err, docs) ->
#      console.log err if err?
#      Room.updateRoomStamp()
#      res.json room

app.delete '/devices', (req,res) ->
  #TODO delete boxes
  console.log 'delete boxes'
  ids = req.body || []
  Box.where("_id").in(ids).remove().exec (err, doc) ->
    console.log err if err?
    return res.send(400, err.message) if err?
    Group.update {},{$pullAll:{boxes:ids}}, {multi: true}, (err, counts)->
      console.log err if err?
      return res.send(400, err.message) if err?
      res.json 'status':'success'

app.put '/command', (req,res) ->
  console.log '33'
  console.log req.body
  command = {}
  command.command = req.body.command
  console.log command
  devices = req.body.boxes
  Box.update {_id: {$in: devices}}, {$addToSet:{commands:command}}, {multi: true}, (err, docs) ->
    console.log err if err?
    return res.send(400, err.message) if err?
#    res.json 'status':'success'
    socketio.sockets.emit 'changed', devices
    res.json 'status':true
#  TODO socketio

app.get '/snapshot/:id', (req,res) ->
  id = req.params.id
  res.json {status:'fail'} unless Snapshot[id]?
  res.json {status:'success', snapshot:Snapshot[id]} if Snapshot[id]?


#  console.log 'socketio'
#  p = req.body || []
#  x = {boxes: []}
#  ids = p.boxes
##  for each in p.boxes
#  Box.find(_id: {$in: ids}).exec (err, boxes) ->
#    console.log boxes.length
#    res.json 'length':boxes.length
##      # TODO write to error LOG
#    return res.send(400, err.message) if err?
#    res.json boxes
#    if box?
#      box.appendCommands p.command
#      x.boxes.push box.name
#    else
#      @html "#{each}", 404
#  socketio.sockets.emit 'changed', x

#app.post 'group', (req,res) ->
#  #TODO create group
#  console.log 'create group'
#
#app.put 'group', (req,res) ->
#  #TODO update group
#  console.log 'update group'