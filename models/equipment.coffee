#_id:编号
#name:资产名称
#createtime : 创建时间
#status:状态
#model:型号

#多对多: (* equipment <=> room *) device <=> group booking <=> user(参加会议)
#一对多: room -> booking  booking -> message room -> device user -> booking（作为预定人预定的会议）

schema = new Schema
  model:{type:String, default :''}
  name: {type: String, default :''}
  status: {type: Number, default :0}
  createTime: {type:Date, default :new Date()}
  icon:{type:String, default :''}


module.exports = Equipment = mongoose.model('Equipment', schema, 'equipment')
