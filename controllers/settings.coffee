Equipment = require "../models/equipment"
_ = require "underscore"
Setting = require "#{$WEBPATH}/models/setting"
util = require('util');
fs =require('fs')
formidable = require('formidable')
path = require 'path'
Guid = require 'guid'
android_regex = /MRoomReserve-\d+\.apk/
deamon4android_regex = /WAMonitor-sign-\d+\.apk/
# 预约查询页面之 初始化 设备查询条件
app.get "/equipments/initialize", (req, res) ->
# TODO add more equipments' name
  names = ["投影仪"]
  Equipment.find (err, equipments) ->
# TODO add to LOG error
    return res.send(400, err.message) if err?
    results = _.filter equipments, (equipment) -> equipment.name in names
    res.json results

updateAndroid = (arg1,arg2) ->
  android={}
  if arg1.name
    fs.unlink arg1.url, (err) ->
      console.log err if err?
      android.name=arg1.name
      android.code=arg2.code
      android.url=arg2.url
      android.force=arg1.force
  else
    android.name=arg2.name
    android.code=arg2.code
    android.url=arg2.url
    android.force=arg2.force
  android

updateD4A =(arg1,arg2) ->
  deamon4android={}
  if arg1.name
    fs.unlink arg1.url, (err) ->
      console.log err if err?
      deamon4android.name=arg1.name
      deamon4android.code=arg2.code
      deamon4android.url=arg2.url
      deamon4android.force=arg1.force
  else
    deamon4android.name=arg2.name
    deamon4android.code=arg2.code
    deamon4android.url=arg2.url
    deamon4android.force=arg2.force
  deamon4android

updateSetting = (type, code, file, uploadPath, setting, req, res) ->
  if type is 'android'
    if code is setting.android.code
      fs.unlink file.path, (err) ->
        console.log err if err?
        return res.json {'status':'fail', 'result':'没有新版本'}
    else
      android=updateAndroid(setting.android,file)
      Setting.update {}, {'android':android},(err)->
        return res.json {'status':'fail', 'result':'升级失败'} if err?
        fs.rename file.path, uploadPath , (err, doc) ->
          return res.json {'status':'fail', 'result':JSON.stringify err} if err?
          res.json {'status':'success', 'result':code}
  else
    if code is setting.deamon4android.code
      fs.unlink file.path, (err) ->
        console.log err if err?
        return res.json {'status':'fail', 'result':'没有新版本'}
    else
      deamon4android =updateD4A(setting.deamon4android,file)
      Setting.update {}, {'deamon4android':deamon4android},(err)->
        return res.json {'status':'fail', 'result':'升级失败'} if err?
        fs.rename file.path, uploadPath , (err, doc) ->
          return res.json {'status':'fail', 'result':JSON.stringify err} if err?
          res.json {'status':'success', 'result':code}

getCode = (file) ->
  if file.type is 'android'
    unless android_regex.test file.name
      fs.unlink file.path, (err) ->
        console.log err if err?
      return
  else if file.type is 'deamon4android'
    unless deamon4android_regex.test file.name
      fs.unlink file.path, (err) ->
        console.log err if err?
      return
  else
    return

  p = path.basename file.name, path.extname file.name
  code = p.split('-').pop()

app.post '/settings', (req, res) ->
  setting = new Setting()
  setting[k] = v for k, v of req.body
  return res.json {'status':'fail', 'result':'用户名不能为空'} if (!setting.email.username || setting.email.username.length is 0||!setting.email.password||setting.email.password.length is 0)
  return res.json {'status':'fail', 'result':'密码不能为空'} if (!setting.email.password||setting.email.password.length is 0)
  Setting.find (err, docs) ->
    return res.json {'status':'fail', 'result':JSON.stringify err} if err?
    if docs.length is undefined||docs.length is 0
      setting.save (err, doc) ->
        return res.json {'status':'fail', 'result':JSON.stringify err} if err?
        res.json {'status':'success', 'result':""}
    else
      setting.email.protocol=docs[0].email.protocol  unless setting.email.protocol
      setting.email.host=docs[0].email.host  unless setting.email.host
      setting.email.port=docs[0].email.port  unless setting.email.port
      setting.email.username=docs[0].email.username  unless setting.email.username
      setting.email.password=docs[0].email.password  unless setting.email.password
      Setting.update $set:{ email: setting.email },(err)->
      res.json {'status':'success', 'result':""}

app.post '/upload/package', (req,res)->
    type = req.query.type
    form = new formidable.IncomingForm()
    form.encoding = 'utf-8'
    form.uploadDir ="public/package/"
    form.keepExtensions = true
    code = ''
    setting={}
    form.parse req, (err, fields, files) ->
       return res.json {'status':'fail', 'result':'上传失败'} if err?
       file = files.file
       return res.json {'status':'fail', 'result':'上传失败'} unless file?
       file.type = type
       file.url = path.join 'public/package', file.name
       uploadPath = path.join 'public/package', file.name
       code=getCode file
       file.code=code
       return res.json {'status':'fail', 'result':'升级包不正确，请确认后再上传'} unless code
       Setting.find {}, (err, docs) ->
         return res.json {'status':'fail', 'result':'升级失败'} if err?
         if docs?.length <= 0
           setting = new Setting()
           setting.save (err, doc) ->
             return res.json {'status':'fail', 'result':'升级失败'} if err?
             setting=doc
             updateSetting  type,  code, file, uploadPath, setting, req, res
         else
           setting=docs[0]
           updateSetting type,  code, file, uploadPath, setting, req, res

app.get '/getCode', (req, res) ->
  Setting.find (err, docs) ->
    return res.json {'status':'fail', 'result':JSON.stringify err} if err?
    if docs?.length <= 0
      return res.json  {'status':'fail', 'result':'目前没有系统'}
    else
      code={}
      code.android=docs[0].android.code
      code.deamon4android=docs[0].deamon4android.code
      res.json {'status':'success', 'result':code}
app.get '/getEmail',(req,res) ->
  Setting.find (err, docs) ->
    return res.json {'status':'fail', 'result':JSON.stringify err} if err?
    if docs?.length <= 0
      return res.json  {'status':'fail', 'result':'目前没有Email'}
    else
      email={}
      email.host=docs[0].email.host
      email.port=docs[0].email.port
      email.username=docs[0].email.username
      email.password= docs[0].email.password
      console.log email
      res.json {'status':'success', 'result':email}