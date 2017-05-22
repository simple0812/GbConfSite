Setting =require "#{$WEBPATH}/models/setting"
#_id: 编号
#name: 会议室名称
#createtime : 创建时间
#capacity:容纳人数
#isOpen:是否开放 #0:不开放, 1:开放
#isAudit:是否需要审核 #0:不需要，1:需要
#status:会议室状态
#remarks:备注

#equipments:会议室设备
#boxes:会议室预约机

schema = new Schema
  name: {type: String, default: ""}
  createTime: {type: Date, default : Date.now}
  capacity: {type: Number, default :0}
  isOpen: {type: Number, default :0}
  isAudit: {type: Number, default :0}
  isBoxBooking: {type: Number, default :0}
  status: {type: Number, default :0}
  remarks: {type: String, default :''}
  imgURL: {type: String, default: null}

  equipments : [{type: Schema.ObjectId, ref: "Equipment"}]
  boxes : [{type: Schema.ObjectId, ref: "Box"}]

module.exports = Room = mongoose.model('Room', schema, 'room')

Room.updateRoomStamp = () ->
  Setting.update {}, {$set:{'stamps.room':Guid.raw()}}, (err, count) ->
    console.log(count)