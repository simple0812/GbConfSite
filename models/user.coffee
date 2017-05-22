md5 = require('blueimp-md5').md5
Setting = require "#{$WEBPATH}/models/setting"
#  _id:编号
#username:登录用户名
#realname:真实用户名
#password:密码
#email:邮箱
#phone:手机号码
#tel:电话号码
#housephone:内线
#type:用户类型(admin,auditor, norma)
#createtime:创建时间
#status:状态 0:存在 9：逻辑删除
#gender: 性别

#organization:部门
#joinBookings:参加会议
#ownerBookings:作为预定人预定的会议

schema = new Schema
  userName: {type: String,  default :''}
  name: {type: String,  default :''}
  email: {type:String, default :''}
  mobilePhone: {type:String, default :''}
  telephone: {type:String, default :''}
  housePhone: {type:String, default :''}
  password: {type:String, default :''}
  role: {type:String, default :''}
  hasNewNotice:{type:Number, default :0}
  createTime: {type:Date, default : new Date()}
  status:{type:Number, default :0}
  gender:{type:Number, default :1}

  organization: {type:Schema.ObjectId, ref :'Organization'}

module.exports = User = mongoose.model('User', schema, 'user')

User.updateStamp = () ->
  console.log('xxx')
  Setting.update {}, {$set:{'stamps.user':Guid.raw()}}, (err, count) ->
    console.log(count)

mongoose.connection.once 'open', (err) ->
  User.find {userName:'admin', status:0}, (err, docs) ->
    if err?
      console.log('create admin error')
    else if docs.length is 0
      user =
        userName:'admin'
        name:'admin'
        password: md5 'admin'
        role:'admin'
        organization : null
      User.create user, (err, docs) ->
        console.log('create admin user')
