#_id:编号
#email:邮箱设置 {protocol: '', host:'', port:'', username:'', password:''}


schema = new Schema
  email: {type: Object, default :{protocol:'smtp', host: '', port:'', username:'', password:''}}
  android: {type: Object, default :{name:'',code:'',url:'',force:'false'}}
  deamon4android: {type: Object, default :{name:'',code:'',url:'',force:false}}
  stamps: {type: Object, default :{user:'',room:''}}

module.exports = Setting = mongoose.model('Setting', schema, 'setting')
mongoose.connection.once 'open', (err) ->
  Setting.find {}, (err, docs) ->
    if(err)
      console.log 'create setting err'
    else if  docs.length is 0
      Setting.create {}, (err, docs) ->
        console.log('create setting')