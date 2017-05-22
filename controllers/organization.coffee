Organization = require "#{$WEBPATH}/models/organization"
User = require "#{$WEBPATH}/models/user"
#

app.post '/organization', (req, res) ->
  organization = new Organization()

  organization.name = req.body.name
  organization.parent = req.body.parent || null

  Organization.find {parent: organization.parent, name:organization.name}, (err, docs)->
    return res.json {'status':'fail', 'result':JSON.stringify err} if err?
    return res.json {'status':'fail', 'result':'组织名称已存在，请换个名称'} if docs.length > 0
    organization.save (err, doc) ->
      return res.json {'status':'fail', 'result':JSON.stringify err} if err?
      User.updateStamp()
      res.json {'status':'success', 'result':doc}

app.get '/organizations', (req, res) ->
  Organization.find().exec (err, docs)->
    return res.json {'status':'fail', 'result':JSON.stringify err} if err?
    res.json {'status':'success', 'result':docs}

app.put '/organization', (req, res) ->
  name = req.body.name
  return res.json {'status':'fail', 'result':'组织名称不能为空'} unless name?

  Organization.find {_id: req.body.id}, (err, docs)->
    return res.json {'status':'fail', 'result':JSON.stringify err} if err?
    return res.json {'status':'fail', 'result':'组织不存在'} if docs.length is 0
    Organization.find {parent:docs[0].parent, name:name}, (err, fdocs) ->
      return res.json {'status':'fail', 'result':JSON.stringify err} if err?
      return res.json {'status':'fail', 'result':'组织名称存在，请换个名称'} if fdocs.length > 0
      Organization.findByIdAndUpdate req.body.id, {$set:{name: name}}, (err, doc) ->
        return res.json {'status':'fail', 'result':JSON.stringify err} if err?
        User.updateStamp()
        res.json {'status':'success', 'result':doc}

app.delete '/organization', (req, res) ->
  id = req.body.id
  return res.json {'status':'fail', 'result':'组织编号不能为空'} unless id?
  #查询该组织是否有子组织
  Organization.find {parent:id}, (err, docs) ->
    return res.json {'status':'fail', 'result':JSON.stringify err} if err?
    return res.json {'status':'fail', 'result':'删除失败，请先删除该组织下的组织'} if docs.length > 0
    Organization.findById id, (err, doc) ->
      return res.json {'status':'fail', 'result':JSON.stringify err} if err?
      return res.json {'status':'fail', 'result':'删除失败，请先删除该组织下的用户'} if doc.users.length > 0
      Organization.findByIdAndRemove id, (err, doc) ->
        return res.json {'status':'fail', 'result':JSON.stringify err} if err?
        User.updateStamp()
        res.json {status:'success', result:'删除成功'}
