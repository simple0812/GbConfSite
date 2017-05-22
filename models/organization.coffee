#  _id:编号
#name:部门名称
#createtime:创建时间
#parent：父级
#users:员工列表

schema = new Schema
  name: String
  createTime: {type:Date, default : new Date()}
  parent:{ type: Schema.ObjectId, ref: 'Organization'}
  users: [{ type: Schema.ObjectId, ref: 'User' }]


module.exports = Organization = mongoose.model('Organization', schema, 'organization')
