#  _id:编号
#name:部门名称
#createtime:创建时间

#users:员工列表

schema = new Schema
  name: {type: String, match: /\w{4,18}/i, default :''}
  createTime: {type:Date, default : new Date()}



#员工列表
  users: [{ type: Schema.ObjectId, ref: 'User' }]


module.exports = Department = mongoose.model('Department', schema, 'department')