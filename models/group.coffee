#_id:编号
#name:分组名称
#createtime:创建时间

#devices:预约机

schema = new Schema
#  _id: {type:String}
  name: {type: String, default:''}
  createTime: {type:Date, default : new Date()}

  boxes:[{type:Schema.ObjectId, ref:'Box'}]


module.exports = Group = mongoose.model('Group', schema, 'Group')