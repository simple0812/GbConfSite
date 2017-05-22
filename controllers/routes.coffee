Notice =require "#{$WEBPATH}/models/notice"

app.get '/',authenticateCheck,(req, res) ->
  res.render 'booking', user:req.user?.userName

app.get '/index',authenticateCheck, (req, res) ->
  res.render 'booking'
app.get '/test', (req, res) ->
  res.render 'test'
app.get '/booking',authenticateCheck, (req, res) ->
#    console.log 'ss'
  res.render 'booking'

app.get '/invite',authenticateCheck, (req, res) ->
  userId = req.session.passport.user?._id
  if(userId)
    Notice.update {receiver:userId, isRead:0}, {isRead:1}, {multi:true}, (err, docs) ->
      res.render 'invite', title:'与会通知'
  else res.render 'invite', title:'与会通知'
#  app.get '/meeting', (req, res) ->
#    res.render 'room/index'

app.get '/user',authenticateCheck, (req, res) ->
  return res.redirect "/MB/index" if "normal" is req.user?.role
  return res.redirect "/audit" if "auditor" is req.user?.role
  return res.send 403, "您无权访问此页面" unless "admin" is req.user?.role
  res.render 'user', title: "用户管理"

app.get '/device',authenticateCheck, (req, res) ->
  return res.redirect "/MB/index" if "normal" is req.user?.role
  return res.redirect "/audit" if "auditor" is req.user?.role
  return res.send 403, "您无权访问此页面" unless "admin" is req.user?.role
  res.render 'device', title: "预约机管理"

app.get '/looking',authenticateCheck, (req, res) ->
  res.render 'looking', title:'预约'

app.get '/setting',authenticateCheck, (req, res) ->
  return res.redirect "/MB/index" if "normal" is req.user?.role
  return res.redirect "/audit" if "auditor" is req.user?.role
  return res.send 403, "您无权访问此页面" unless "admin" is req.user?.role
  res.render 'setting', title:"系统设置"

app.get '/equipment',authenticateCheck, (req, res) ->
  return res.redirect "/MB/index" if "normal" is req.user?.role
  return res.redirect "/audit" if "auditor" is req.user?.role
  return res.send 403, "您无权访问此页面" unless "admin" is req.user?.role
  res.render 'equipment', title: "设备管理"


app.get '/book2',authenticateCheck, (req, res) ->
  res.render 'book2'

app.get '/audit',authenticateCheck, (req, res) ->
  return res.redirect "/MB/index" if "normal" is req.user?.role
  return res.send 403, "您无权访问此页面" unless "admin" is req.user?.role or "auditor" is req.user?.role
  res.render 'audit', title:'审批'

app.get '/socket', authenticateCheck, (req, res) ->
  res.render 'socket'
