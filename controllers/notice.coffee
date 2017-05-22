Notice = require "#{$WEBPATH}/models/notice"

app.get '/notices', (req, res) ->
  userId = req.session.passport.user._id
#  userId = null
  query = {status:{$ne:9}}
  query.receiver = userId if userId?
  Notice.find(query).populate('booker').populate({path:'booking', options:{populate:'room'}}).exec (err, docs) ->
    return res.json {'status':'fail', 'result':JSON.stringify err} if err?
    res.json docs

app.get '/notices/:id/count', (req, res) ->
  userId = req.params.id
  query = {isRead:0, receiver:userId}
  Notice.count query, (err, count) ->
    return res.json {'status':'fail', 'result':JSON.stringify err} if err?
    res.json {'status':'success', 'result':count}

app.delete '/notice', (req, res) ->
  id = req.body.id || ''
  return res.json {'status':'fail', 'result':'编号不能为空'} if id.length is 0
  Notice.findByIdAndUpdate id, {status:9}, (err, doc) ->
    return res.json {'status':'fail', 'result':JSON.stringify err} if err?
    res.json {'status':'success', 'result':"删除成功"}

app.delete '/notices', (req, res) ->
  ids = req.body.ids || []
  return res.json {'status':'fail', 'result':'用户编号不能为空'} if ids.length is 0
  Notice.update {_id:{$in:ids}}, {status:9}, {multi:true}, (err, count) ->
    return res.json {'status':'fail', 'result':JSON.stringify err} if err?
    res.json {'status':'success', 'result':"删除成功"}