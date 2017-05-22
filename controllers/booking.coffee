User = require "#{$WEBPATH}/models/user"
Booking =require "#{$WEBPATH}/models/booking"
Notice =require "#{$WEBPATH}/models/notice"
Email =require "#{$WEBPATH}/models/email"
Room =require "#{$WEBPATH}/models/room"
moment = require "moment"
async = require "async"

app.post '/booking', (req, res) ->
  now = new Date()
  userId = req.user._id
  booking = new Booking()
  booking[k] = v for k, v of req.body
  booking.booker = userId
  return res.send(400, '会议时间不能小于30分钟') if moment(booking.startTime).add('m', 30) > booking.endTime
  return res.send(400, '开始时间必须大于当前时间') if moment(booking.startTime) < now

  receivers = ''
  for each in booking.externalUsers when each.email? and each.email.length >0
    receivers += each.email + ','
  query = []
  query.push({startTime:{$gte:moment(booking.startTime), $lte:moment(booking.endTime)}})
  query.push({endTime:{$gte:moment(booking.startTime), $lte:moment(booking.endTime)}})
  sample = {$or:query, _id:{$ne:booking._id}, room:booking.room, isAudit: {$ne: 2}}
  Booking.find(sample).exec (err, docs) ->
    return res.send(400, err.message) if err?
    return res.send(400, '当前预约时间与其他会议时间冲突') if docs.length > 0
    Room.findById(booking.room).exec (err, p) ->
      return res.send(400, err.message) if err?
      booking.isAudit = if p.isAudit is 0 then 1 else 0
      booking.save (err, doc) ->
        return res.send(400, err.message) if err?
        return res.json {result:doc, message:'预约成功，等待审核'} if doc.isAudit is 0
        Booking.findById(doc._id).populate('users').populate('booker').populate('room').exec (err, doc) ->
          return res.send(400, err.message) if err?
          notices = []
          bookUser = {booker:userId, receiver:userId, booking:doc._id}
          notices.push(bookUser)
          for each in booking.users
            notices.push( {booker:userId, receiver:each, booking:doc._id}) unless _.contains(notices,bookUser)

          Notice.create notices, (err) ->
#            return res.send(400, err.message) if err?

            bookerMail =
              to:doc?.booker?.email
              subject: "与会通知 ",
              text: "与会通知",
              html: "您预约的#{moment(doc.startTime).format('YYYY-MM-DD HH:mm')}在#{doc.room.name}的会议已经通过审核，请准时参加。"

            new Email(bookerMail).send (err, t) ->
              console.log(err);

            for each in doc.users when each.email? and each.email.length? >0
              receivers += each.email + ','
            return res.json doc if receivers.length is 0

            mail =
              to: receivers,
              subject: "与会通知 ",
              text: "与会通知",
              html: "请您于#{moment(doc.startTime).format('YYYY-MM-DD HH:mm')}在#{doc.room.name}参加会议"

            new Email(mail).send (err, t) ->
              console.log(err);
#              return res.send(400, '预约成功，但邮件发送失败') if err?

            res.json doc

app.put '/booking/:id', (req, res) ->
  now = new Date()
  userId = req.user._id;
  booking = {}
  booking[k] = v for k, v of req.body
  console.log booking
  return res.send(400, '会议时间不能小于30分钟') if moment(booking.startTime).add('m', 30) > moment(booking.endTime)
  return res.send(400, '开始时间必须大于当前时间') if moment(booking.startTime) < now

  receivers = ''
  for each in booking.externalUsers when each.email? and each.email.length >0
    receivers += each.email + ','

  query = []
  query.push({startTime:{$gte:moment(booking.startTime), $lte:moment(booking.endTime)}})
  query.push({endTime:{$gte:moment(booking.startTime), $lte:moment(booking.endTime)}})
  sample = {$or:query, _id:{$ne:booking._id}, room:booking.room, isAudit: {$ne: 2}}

  Booking.find sample, (err, docs) ->
    return res.send(400, err.message) if err?
    console.log docs
    return res.send(400, '当前预约时间与其他会议时间冲突') if docs.length > 0
    Booking.findById(req.body._id).populate('room').exec (err, booking) ->
      return res.send(400, err.message) if err?
      return res.send(400, '会议已开始不能修改') if booking.startTime < now
      tmAudit = booking.room.isAudit
      booking[k]= v for k, v of req.body
      booking.isAudit = if tmAudit is 0 then 1 else 0
      booking.save (err, doc) ->
        return res.send(400, err.message) if err?
        return res.json {result:doc, message:'修改预约成功，等待审核'} if  booking.isAudit is 0
        Booking.findById(doc._id).populate('users').populate('booker').populate('room').exec (err, doc) ->
          return res.send(400, err.message) if err?
          notices = []
          bookUser = {booker:userId, receiver:userId, booking:doc._id}
          notices.push(bookUser)
          for each in booking.users
            notices.push( {booker:userId, receiver:each, booking:doc._id}) unless _.contains(notices,bookUser)

          Notice.create notices, (err) ->
#            return res.send(400, err.message) if err?
            bookerMail =
              to:doc?.booker?.email
              subject: "与会通知 ",
              text: "与会通知",
              html: "您预约的#{moment(doc.startTime).format('YYYY-MM-DD HH:mm')}在#{doc.room.name}的会议已经通过审核，请准时参加。"
            new Email(bookerMail).send (err, t) ->
              console.log(err);
            for each in doc.users when each.email? and each.email.length? >0
              receivers += each.email + ','
            return res.json doc if receivers.length is 0
            mail =
              to: receivers,
              subject: "与会通知 ",
              text: "与会通知",
              html: "请您于#{moment(doc.startTime).format('YYYY-MM-DD HH:mm')}在#{doc.room.name}参加会议"

            new Email(mail).send (err, t) ->
              console.log(err);
#              return res.send(400, '预约成功，但邮件发送失败') if err?
            res.json doc



########## 浏览器预约查询 ##########                                          i
# req.query = {roomIds: ["xxx", ...], date: "2014-07-03"}
app.get "/bookings", (req, res) ->
  ids = req.query.roomIds or []
  date = req.query.date or ''
  Booking.where("room").in(ids).and([{status: 0},{isAudit: {$ne: 2}}]).populate({path:'users', select:'name role'}).exec (err, bookings) ->
# TODO write to error LOG
    return res.send(400, err.message) if err?
    results = _.filter bookings, (booking) ->
      if date is moment(booking.startTime).format("YYYY-MM-DD") then true else false
    res.json results

app.get "/booking/:bookingID", (req, res) ->
  id = req.params.bookingID
  Booking.findById(id).populate({path:"users", select:"name role"}).exec (err, booking) ->
# TODO write to error LOG
    return res.send 400, err.message if err?
    res.json booking



