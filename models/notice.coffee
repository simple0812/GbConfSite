#_id:编号
#booker:发送人编号
#receiver:接受人编号

#booking:预约

schema = new Schema
  status:{type:Number, default :0}
  booker: {type:Schema.ObjectId, ref :'User'}
  receiver: {type:Schema.ObjectId, ref :'User'}
  booking: {type:Schema.ObjectId, ref :'Booking'}
  isRead:{type:Number, default :0}


module.exports = Notice = mongoose.model('Notice', schema, 'notice')