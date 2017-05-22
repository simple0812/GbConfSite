Equipment = require "#{$WEBPATH}/models/equipment"
util = require('util');
fs =require('fs')
formidable = require('formidable')
path = require 'path'
Guid = require 'guid'


app.post '/equipment', (req, res) ->
  equip = new Equipment()
  equip[k] = v for k, v of req.body
  return res.json {'status':'fail', 'result':'设备名不能为空'} if (!equip.name || equip.name.length is 0)
  Equipment.find {name:equip.name, model:equip.model, status: 0}, (err, docs) ->
    return res.json {'status':'fail', 'result':JSON.stringify err} if err?
    return res.json {'status':'fail', 'result':"设备已存在"} if docs?.length > 0
    if equip.icon.length is undefined || equip.icon.length is 0
      equip.icon=''
#    docs.forEach (n)->
#      return res.json {'status':'fail', 'result':'设备已存在'} if n.model==req.body.model
    equip.save (err, doc) ->
      return res.json {'status':'fail', 'result':JSON.stringify err} if err?
      res.json {'status':'success', 'result':doc}
app.post '/upload/icon', (req, res) ->
  form = new formidable.IncomingForm()
  form.uploadDir ="public/upload/"
  form.keepExtensions = true
  form.parse req, (err, fields, files) ->
    file = files.file
    extName = path.extname file.name or ''
    name = Guid.raw() + extName
    uploadPath = path.join 'public/upload', name
    fs.rename file.path, uploadPath , (err, doc) ->
      obj= JSON.stringify {'status':'fail', 'result':JSON.stringify err} if err?
      res.end ("<script>window.parent.upFinish(#{obj})</script>") if obj?
      obj=""
      obj = JSON.stringify {'status':'success', 'result':name}
      res.end ("<script>window.parent.upFinish(#{obj})</script>")


app.get '/equipments', (req, res) ->
  orderBy = req.body[0] || '0'
  Equipment.find {status:0}, (err, docs) ->
    return res.send(400, err.message) if err?
    docs = _.sortBy docs, (node) -> node['createTime']
    docs = docs.reverse() if orderBy is '0'
    res.json docs

app.delete '/equipment', (req, res) ->
  id = req.body.id || ''
  return res.json {'status':'fail', 'result':'设备编号不能为空'} if id.length is 0
  Equipment.findById id, (err, doc) ->
    unless "" is doc.icon
      p = path.join "public", doc.icon
      fs.exists p, (exists) ->
        if exists
          fs.unlink p, (err) -> console.log err if err?
  #逻辑删除
  Equipment.findByIdAndUpdate id, {status:9,icon:""}, (err, doc) ->
    return res.json {'status':'fail', 'result':JSON.stringify err} if err?
    res.json {'status':'success', 'result':"删除成功"}

app.delete '/equipments', (req, res) ->
  ids = req.body.ids || []
  return res.json {'status':'fail', 'result':'设备编号不能为空'} if ids.length is 0
  for each in ids
    Equipment.findById each, (err, doc) ->
      console.log err if err?
      unless "" is doc.icon
        p = path.join "public", doc.icon
        fs.exists p, (exists) ->
          if exists
            fs.unlink p, (err) -> console.log err if err?
  Equipment.update {_id:{$in:ids}},{status:9,icon:""}, {multi:true}, (err, docs) ->
    return res.json {'status':'fail', 'result':JSON.stringify err} if err?
    res.json {'status':'success', 'result':"删除成功"}

app.put '/equipment', (req, res) ->
  name = req.body.name
  return res.json {'status':'fail', 'result':'设备名称不能为空'} unless name?
  iconPath="";
  Equipment.findById req.body.id, (err, doc)->
    return res.json {'status':'fail', 'result':JSON.stringify err} if err?
    return res.json {'status':'fail', 'result':'设备不存在'} unless doc?
    return res.json {'status':'success', 'result':doc} if doc.name is name and doc.model is req.body.model and doc.icon is req.body.icon
    iconPath = doc.icon unless doc.icon is req.body.icon
    Equipment.find {name:name,model:req.body.model,icon:req.body.icon, status: 0}, (err, fdocs) ->
      return res.json {'status':'fail', 'result':JSON.stringify err} if err?
      return res.json {'status':'fail', 'result':"设备已存在"} if fdocs?.length > 0
      Equipment.findByIdAndUpdate req.body.id, {$set:{name: name,model: req.body.model,icon:req.body.icon}}, (err, doc) ->
        return res.json {'status':'fail', 'result':JSON.stringify err} if err?
        if iconPath
          pathtemp= path.join 'public', iconPath
          fs.exists pathtemp,(exists)->
           if exists
             fs.unlink pathtemp,(err) -> console.log err if err?
        res.json {'status':'success', 'result':doc}


app.delete '/deleteIconFile', (req, res) ->
  id = req.body.id
  icon=req.body.icon
  if id is 0
    iconpath= path.join 'public',icon
    fs.exists iconpath,(exists)->
      console.log "exists:",exists
      if exists
        console.log '-------'
        fs.unlink iconpath,(err) ->
          console.log err
  else
    Equipment.find { _id:id}, (err, docs) ->

      if icon is docs[0].icon
        return
      else
        iconpath= path.join 'public', icon
        fs.exists iconpath,(exists)->
          console.log iconpath
          console.log "exists:",exists
          if exists and iconpath isnt 'public/img/equip.png'
            console.log '+++++++'
            fs.unlink iconpath,(err) ->
              console.log err

# 获取初始化设备查询条件
app.get "/equipments/initialize", (req, res) ->
  p = []
  res.json p