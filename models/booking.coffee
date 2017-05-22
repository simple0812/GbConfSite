#_id:编号
#name:会议名称
#starttime:会议开始时间
#endtime：会议结束时间
#remarks：备注
#external:外部参会人员 [{ name: '', email:'', phone:'' },...]
#status:会议状态 0:未开始， 1:进行中， 2:结束， 3:取消或者异常
#isAudit:是否被审核 0:未审核, 1:审核，2:退回
#reason:退回理由

#booker:预定会议的用户
#room:会议室
#users:内容参会人员

schema = new Schema
#  _id: {type:String}
  name: {type: String, default :''}
  startTime: {type:Date, default : new Date()}
  endTime: {type:Date, default : new Date()}
  remarks: {type:String, default :''}
  externalUsers: {type:Array, default :[]}
  status: {type:Number, default :0}
  isAudit: {type:Number, default :0}
  reason: {type:String, default :''}

  booker:{type:Schema.ObjectId, ref :'User'}
  room: {type:Schema.ObjectId, ref :'Room'}
  users : [{ type: Schema.ObjectId, ref: 'User' }]


module.exports = Booking = mongoose.model('Booking', schema, 'booking')