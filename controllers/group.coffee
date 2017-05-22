Group =require "#{$WEBPATH}/models/group"
#moment = require "moment"
#async = require "async"
#_ = require 'underscore'

app.get '/groups', (req,res) ->
  #TODO get groups
  Group.find().exec (err, groups) ->
    # TODO write to error LOG
    return res.send(400, err.message) if err?
    res.json groups

app.post '/group', (req,res) ->
  #TODO create group
  console.log 'create group'
  console.log req.body
  Group.findOne {name:req.body.name}, (err,doc) ->
    return res.json {'status':'fail', 'result':JSON.stringify err} if err?
    return res.send(400, '分组名已存在') if doc?
    #    return res.send {400, 'message':'终端名已存在'} if doc?
    #    res.json {'status':'success', 'result':'ddd'}
    group = new Group()
    group[k] = v for k, v of req.body
    group.save (err, doc) ->
      console.log doc
      return res.json {'status':'fail', 'result':JSON.stringify err} if err?
      res.json doc

app.put '/group/:id', (req,res) ->
  #TODO update group
  console.log 'update group'
  id = req.params.id
  data = req.body
  Group.findOne {name:req.body.name}, (err,doc) ->
    return res.json {'status':'fail', 'result':JSON.stringify err} if err?
    if doc?
      return res.send(400, '分组名已存在') unless  (doc?._id.toString() is id)
    Group.findByIdAndUpdate id,data,(err,box) ->
      console.log err if err?
      return res.send(400, err.message) if err?
      console.log box
      res.json box

app.delete '/group/:id', (req,res) ->

  #TODO delete box
  console.log 'delete box'
  id = req.params.id
  Group.findByIdAndRemove id, (err,box) ->
    console.log err if err?
    return res.send(400, err.message) if err?
    res.json {'status':'success', 'message':'删除成功'}


app.delete '/groups', (req,res) ->
  #TODO delete boxes
  console.log 'delete boxes'
  ids = req.body || []
  Group.where("_id").in(ids).remove().exec (err, doc) ->
    console.log err if err?
    return res.send(400, err.message) if err?
    res.json 'status':'success'