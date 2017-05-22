User = require "#{$WEBPATH}/models/user"
Organization = require "#{$WEBPATH}/models/organization"
Booking = require "#{$WEBPATH}/models/booking"
md5 = require('blueimp-md5').md5
#

app.post '/admin/init', (req, res) ->
  user = new User()
  User.find {userName:'admin', status:0}, (err, docs) ->
    return res.json {'status':'fail', 'result':JSON.stringify err} if err?
    return res.json {'status':'fail', 'result':"用户名称已存在"} if docs.length >0
    user.userName = 'admin'
    user.name = 'admin'
    user.password = md5 'admin'

    user.save (err, doc) ->
      return res.json {'status':'fail', 'result':JSON.stringify err} if err?
      Organization.findByIdAndUpdate doc.organization, {$addToSet:{users:doc._id}}, (err, orgDoc) ->
        return res.json {'status':'fail', 'result':JSON.stringify err} if err?
        res.json {'status':'success', 'result':doc}

app.post '/user', (req, res) ->
  user = new User()
  user[k] = v for k, v of req.body
  return res.json {'status':'fail', 'result':'登录名不能为空'} if (!user.userName || user.userName.length is 0)
  return res.json {'status':'fail', 'result':'密码不能为空'} if (!user.password || user.password.length is 0)
  return res.json {'status':'fail', 'result':'邮箱不能为空'} if (!user.email || user.email.length is 0)
  return res.json {'status':'fail', 'result':'角色不能为空'} if (!user.role || user.role.length is 0)
  User.find {userName:user.userName, status:0}, (err, docs) ->
    return res.json {'status':'fail', 'result':JSON.stringify err} if err?
    return res.json {'status':'fail', 'result':"用户名称已存在"} if docs.length >0
    user.save (err, doc) ->
      return res.json {'status':'fail', 'result':JSON.stringify err} if err?
      Organization.findByIdAndUpdate doc.organization, {$addToSet:{users:doc._id}}, (err, orgDoc) ->
        return res.json {'status':'fail', 'result':JSON.stringify err} if err?
        User.updateStamp()
        res.json {'status':'success', 'result':doc}

app.get '/user/all', (req, res) ->
  Organization.find {}, (err, org) ->
    return res.json {status:'failed', message:err.message} if err?
    User.find {}, (err, users) ->
      return res.json {status:'failed', message:err.message} if err?
      each._doc.id = each._id for each in org
      each._doc.id = each._id for each in users
      res.json {organizations:org, users:users}

app.get '/user/:userID', (req, res) ->
  range = ["userName", "name", "email", "mobilePhone", "telephone"]
  uid = req.params.userID
  User.findById uid, (err, user) ->
# TODO write to error LOG
    return res.send 400, err.message if err?
    result = {}
    result[key] = user.get(key) for key in range when user[key]
    res.json result

app.get '/users', (req, res) ->
  oid = req.query.organization || '';
  orderBy = req.query.orderby || 'createTime'
  orderMode = req.query.ordermode || 'desc'
  pageSize = req.query.pagesize || 15
  pageIndex = req.query.pageindex || 1
  keyword = req.query.keyword || ''
  firstNum = (pageIndex - 1) * pageSize
  endNum = firstNum + parseInt pageSize
  reg = new RegExp(keyword, 'ig')
  arr = [{status:0}]
  sample ={$and:arr}
  arr.push({$or:[{name:{$regex:reg}}, {userName:{$regex:reg}}]}) if keyword.length > 0
  if oid.length >0 then arr.push({organization:oid }) else arr.push({organization:{$ne:null}})
  arr.push({userName:{$ne:'admin'}})

  User.find(sample).populate('organization').exec (err, docs) ->
    return res.json {'status':'fail', 'result':JSON.stringify err} if err?
    ret = {status:'success', result:''}
    ret.recordCount = docs.length
    docs = _.sortBy docs, (node) -> node[orderBy]
    docs = docs.reverse() if orderMode is 'desc'
    ret.result = docs[firstNum...endNum]
    ret.count = ret.result.length
    res.json ret

app.delete '/user', (req, res) ->
  id = req.body.id || ''
  return res.json {'status':'fail', 'result':'用户编号不能为空'} if id.length is 0

  #逻辑删除
  User.findByIdAndUpdate id, {status:9}, (err, doc) ->
    return res.json {'status':'fail', 'result':JSON.stringify err} if err?
    Organization.findByIdAndUpdate doc.organization, {$pull:{users:doc._id}}, (err, doc) ->
      return res.json {'status':'fail', 'result':JSON.stringify err} if err?
      Booking.update {booker:id}, {status:9}, (err, doc) ->
        return res.json {'status':'fail', 'result':JSON.stringify err} if err?
        User.updateStamp()
        res.json {'status':'success', 'result':"删除成功"}

app.delete '/users', (req, res) ->
  ids = req.body.ids || []
  return res.json {'status':'fail', 'result':'用户编号不能为空'} if ids.length is 0
  #逻辑删除
  User.update {_id:{$in:ids}}, {status:9}, {multi:true}, (err, count) ->
    return res.json {'status':'fail', 'result':JSON.stringify err} if err?
    Organization.update {}, {$pullAll:{users:ids}}, {multi:true}, (err, doc) ->
      return res.json {'status':'fail', 'result':JSON.stringify err} if err?
      Booking.update {booker:{$in:ids}}, {status:9}, {multi:true}, (err, doc) ->
        return res.json {'status':'fail', 'result':JSON.stringify err} if err?
        User.updateStamp()
        res.json {'status':'success', 'result':"删除成功"}

app.put '/user', (req, res) ->
  id = req.body.id || ''
  return res.json {'status':'fail', 'result':'用户编号不能为空'} if id.length is 0
  User.findById id, (err, doc) ->
    return res.json {'status':'fail', 'result':JSON.stringify err} if err?
    return res.json {'status':'fail', 'result':"用户不存在"} unless doc?
    User.find {userName: req.body.userName, status:0}, (err, docs) ->
      return res.json {'status':'fail', 'result':JSON.stringify err} if err?
      return res.json {'status':'fail', 'result':"登录名已存在"} if docs.length >0
      doc[k]= v for k, v of req.body
      delete  doc.id
      doc.save (err, doc) ->
        return res.json {'status':'fail', 'result':JSON.stringify err} if err?
        User.updateStamp()
        res.json {'status':'success', 'result':doc}

app.put '/user/name', (req, res) ->
  id = req.body.id || ''
  return res.json {'status':'fail', 'result':'用户编号不能为空'} if id.length is 0
  User.findById id, (err, doc) ->
    return res.json {'status':'fail', 'result':JSON.stringify err} if err?
    return res.json {'status':'fail', 'result':"用户不存在"} unless doc?
    doc.name = req.body.name
    doc.save (err, doc) ->
      return res.json {'status':'fail', 'result':JSON.stringify err} if err?
      User.updateStamp()
      res.json {'status':'success', 'result':doc}

app.put '/user/password', (req, res) ->
  id = req.body.id || ''
  return res.json {'status':'fail', 'result':'用户编号不能为空'} if id.length is 0
  User.findById id, (err, doc) ->
    return res.json {'status':'fail', 'result':JSON.stringify err} if err?
    return res.json {'status':'fail', 'result':"用户不存在"} unless doc?
    return res.json {'status':'fail', 'result':"原始密码不正确"} unless doc.password is req.body.oldpassword
    doc.password = req.body.newpassword
    doc.save (err, doc) ->
      return res.json {'status':'fail', 'result':JSON.stringify err} if err?
      User.updateStamp()
      res.json {'status':'success', 'result':doc}

#app.get '/login', (req, res) ->
#  userName = req.query.userName
#  password = req.query.password
#  return res.json {'status':'fail', 'result':'登录名不能为空'} if (!userName || userName.length is 0)
#  return res.json {'status':'fail', 'result':'密码不能为空'} if (!password || password.length is 0)
#  User.find {userName:userName, password:password, status:0}, (err, docs) ->
#    return res.json {'status':'fail', 'result':JSON.stringify err} if err?
#    return res.json {'status':'fail', 'result':"用户名或者密码错误"} if docs.length is 0
#    res.cookie 'username', docs[0].userName
#    res.cookie 'userid', docs[0]._id.toString()
#    res.json {status:'success', result:docs[0]}


app.put '/UpdateAdminPassword', (req, res) ->
  User.find {userName:'admin', status:0}, (err, docs) ->
    return res.json {'status':'fail', 'result':JSON.stringify err} if err?
    return res.json {'status':'fail', 'result':"用户名或者密码错误"} if docs.length is 0
    old=req.body.oldpassword
    password=req.body.newpassword
    if docs[0].password != old
      return res.json {status:'fail', result:'原密码输入错误'}
    User.findOneAndUpdate {userName:'admin', status:0}, { $set: { password: password }}, (err)->
      return res.json {'status':'fail', 'result':JSON.stringify err} if err?
      User.updateStamp()
      res.json {status:'success', result:'修改成功'}
