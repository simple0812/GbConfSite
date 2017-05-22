Room = require "#{$WEBPATH}/models/room"
Booking =require "#{$WEBPATH}/models/booking"
User =require "#{$WEBPATH}/models/user"
Setting =require "#{$WEBPATH}/models/setting"
Organization =require "#{$WEBPATH}/models/organization"
Box =require "#{$WEBPATH}/models/box"
Notice =require "#{$WEBPATH}/models/notice"
Email =require "#{$WEBPATH}/models/email"

moment = require "moment"



app.get '/interface/:style/:roomId', (req, res) ->
  Room.findById req.params.roomId, (err, doc) ->
    return res.json {'status':'fail', 'result':JSON.stringify err} if err?
    return res.json {'status':'fail', 'result':'会议室不存在'} unless  doc
    t = req.params.style
    p = 'interface/index'
    if t is 'page'
      p = 'interface/testpage'
    else if t is 'retrieve'
      p = 'interface/testretrieve'
    res.render p, title: '会议室', room:doc,  layout:false

app.get "/interface/bookings", (req, res) ->
  ids = req.query.roomIds or []
  date = req.query.date or ''
  Booking.find({status: 0, room:{$in:ids} }).$where("this.startTime.setHours(0,0,0,0) == " + new Date(date).setHours(0,0,0,0)).populate('booker').sort('startTime').exec (err, bookings) ->
    return res.json {code:'fail', result:err.message} if err?
    res.json bookings


app.post "/bookings/:roomID", (req,res) ->
  roomId = req.params.roomID
  date = req.body.dates || []
  console.log typeof(req.body.dates)
  console.log (req.body.dates)
  startDate = moment(date[0]).format('YYYY-MM-DD')
  endDate = moment(date[1]).add(1,'day').format('YYYY-MM-DD')
  query = {}
  query.startTime = {$gte:moment(startDate), $lt:moment(endDate)}
  query.status = 0
  query.room = roomId
  Booking.find(query).exec (err, bookings) ->
    return res.json {code:'failed', result:err.message} if err?
    for each in bookings
      each._doc.id = each._id
      each._doc.startTime = moment(each.startTime).format('YYYY/MM/DD HH:mm:ss')
      each._doc.endTime = moment(each.endTime).format('YYYY/MM/DD HH:mm:ss')
    res.json {bookings:bookings}



app.post '/booking/start/:bookingID', (req, res) ->
  id = req.params.bookingID
  Booking.findById req.params.bookingID, (err, doc) ->
    return res.json {'status':'failed', message:err.message} if err?
    return res.json {'status':'failed', message:'预约不存在'} unless doc
    now = new Date()
    return res.json {'status':'failed', message:'会议已结束，无法提前开始'} if doc.endTime < now
    return res.json {'status':'failed', message:'会议正在进行中，无需提前开始'} if (doc.endTime > now and doc.startTime < now)
    return res.json {'status':'failed', message:'最多只能提前半个小时开始会议'} if moment(doc.startTime).add('m', -30) > now
    doc.startTime = now
    query = []
    query.push({startTime:{$gte:moment(doc.startTime), $lte:moment(doc.endTime)}})
    query.push({endTime:{$gte:moment(doc.startTime), $lte:moment(doc.endTime)}})
    sample = {$or:query, _id:{$ne:id}, room:doc.room}

    Booking.find sample, (err, docs) ->
      return res.json {'status':'failed', message:err.message} if err?
      return res.json {'status':'failed', message:'当前时间与其他会议时间冲突'} if docs.length > 0
      doc.save (err, doc) ->
        return res.json {'status':'failed', message:err.message} if err?
        doc._doc.id = doc._id
        doc._doc.startTime = moment(doc.startTime).format('YYYY/MM/DD HH:mm:ss')
        doc._doc.endTime = moment(doc.endTime).format('YYYY/MM/DD HH:mm:ss')
        res.json  {booking: doc}

app.post '/booking/end/:bookingID', (req, res) ->
  id = req.params.bookingID
  Booking.findById req.params.bookingID, (err, doc) ->
    return res.json {'status':'failed', message:err.message} if err?
    return res.json {'status':'failed', message:'预约不存在'} unless doc
    now = new Date()
    return res.json {'status':'failed', message:'会议已结束，请延长会议'} if doc.endTime < now
    return res.json {'status':'failed', message:'会议未开始，无法结束'} if doc.startTime > now
    doc.endTime = now
    query = []
    query.push({startTime:{$gte:moment(doc.startTime), $lte:moment(doc.endTime)}})
    query.push({endTime:{$gte:moment(doc.startTime), $lte:moment(doc.endTime)}})
    sample = {$or:query, _id:{$ne:id}, room:doc.room}
    Booking.find sample, (err, docs) ->
      return res.json {'status':'failed', message:err.message} if err?
      return res.json {'status':'failed', message:'当前时间与其他会议时间冲突'} if docs.length > 0
      doc.save (err, doc) ->
        return res.json {'status':'failed', message:err.message} if err?
        doc._doc.id = doc._id
        doc._doc.startTime = moment(doc.startTime).format('YYYY/MM/DD HH:mm:ss')
        doc._doc.endTime = moment(doc.endTime).format('YYYY/MM/DD HH:mm:ss')
        res.json  {booking: doc}

app.post '/booking/extend/:bookingID', (req, res) ->
  id = req.params.bookingID
  time = req.body.time
  now = new Date()
  Booking.findById req.params.bookingID, (err, doc) ->
    return res.json {'status':'failed', message:err.message} if err?
    return res.json {'status':'failed', message:'预约不存在'} unless doc
    return res.json {'status':'failed', message:'会议已结束，无法延长'} if doc.endTime < now
    return res.json {'status':'failed', message:'会议未开始，无法延长'} if doc.startTime > now
    tempTime = doc.endTime
    doc.endTime = moment(tempTime).add('seconds', time)
    query = []
    query.push({startTime:{$gte:moment(doc.startTime), $lte:moment(doc.endTime)}})
    query.push({endTime:{$gte:moment(doc.startTime), $lte:moment(doc.endTime)}})
    sample = {$or:query, _id:{$ne:id}, room:doc.room}

    Booking.find sample, (err, docs) ->
      return res.json {'status':'failed', message:err.message} if err?
      return res.json {'status':'failed', message:'当前时间与其他会议时间冲突'} if docs.length > 0
      doc.save (err, doc) ->
        return res.json {'status':'failed', message:err.message} if err?
        doc._doc.id = doc._id
        res.json {booking : doc}

app.post '/booking/:boxName', (req, res) ->
  now = new Date()
  boxName = req.params.boxName
  booking = new Booking()
  userId = req.body.booker
  bookType = req.body.type
  booking[k] = v for k, v of req.body
  booking.startTime = now if bookType is 'fast'
#  if bookType is 'normal'
  booking.externalUsers = [] unless (booking.externalUsers instanceof  Array)
  return res.json {status:'failed', message:'会议时间不能小于30分钟'} if moment(booking.startTime).add('m', 30) > booking.endTime
  return res.json {status:'failed', message:'开始时间必须大于当前时间'} if moment(booking.startTime) < now

  Box.find({name:boxName}).populate('room').exec (err, docs) ->
    return res.json {status:'failed', message:err.message} if err?
    return res.json {status:'failed', message:'终端名称不存在'} if docs?.length is 0

    box = docs[0]
    return res.json {status:'failed', message:'终端没有与会议室绑定'} unless box.room?._id

    booking.room = box.room._id

    receivers = ''
    for each in booking.externalUsers when each.email?
      receivers += each.email + ','
    query = []
    query.push({startTime:{$gte:moment(booking.startTime), $lte:moment(booking.endTime)}})
    query.push({endTime:{$gte:moment(booking.startTime), $lte:moment(booking.endTime)}})
    sample = {$or:query, _id:{$ne:booking._id}, room:booking.room, isAudit: {$ne: 2}}
    Booking.find(sample).exec (err, docs) ->
      return res.json {status:'failed', message:err.message} if err?
      return res.json {status:'failed', message:'当前预约时间与其他会议时间冲突'} if docs.length > 0

      booking.isAudit = if box.room.isAudit is 0 then 1 else 0
      booking.save (err, doc) ->
        return res.json {status:'failed', message:err.message} if err?
        return res.json {status:'auditing', message:'待审核'} if doc.isAudit is 0
        Booking.findById(doc._id).populate('users').populate('booker').populate('room').exec (err, doc) ->
          return res.json {status:'failed', message:err.message} if err?
          notices = []
          bookUser = {booker:userId, receiver:userId, booking:doc._id}
          notices.push(bookUser)
          for each in booking.users
            notices.push( {booker:userId, receiver:each, booking:doc._id}) unless _.contains(notices,bookUser)

          Notice.create notices, (err) ->
            return res.json {status:'failed', message:err.message} if err?

            bookerMail =
              to:doc?.booker?.email
              subject: "与会通知 ",
              text: "与会通知",
              html: "您预约的#{moment(doc.startTime).format('YYYY-MM-DD HH:mm')}在#{doc.room.name}的会议已经通过审核，请准时参加。"

            new Email(bookerMail).send (err, t) ->
              console.log(err);

            for each in doc.users when each.email?
              receivers += each.email + ','

            return res.json {status:'success', message:'成功'} if receivers.length is 0

            mail =
              to: receivers,
              subject: "与会通知 ",
              text: "与会通知",
              html: "请您于#{moment(doc.startTime).format('YYYY-MM-DD HH:mm')}在#{doc.room.name}参加会议"

            new Email(mail).send (err, t) ->
              console.log(err);

            res.json {status:'success', message:'成功'}

app.get '/box/:boxName', (req, res) ->
  console.log('xxx')
  boxName = req.params.boxName
  Box.find({name:boxName}).populate('room').exec (err, docs) ->
    return res.json {status:'failed', message:err.message} if err?
    return res.json {status:'failed', message:'终端名称不存在'} if docs?.length is 0
    box = {}
    box[k] = v for k,v of docs[0]
    box.room._doc.id = box.room._id
    box._doc.dateTime = moment().format('YYYY/MM/DD HH:mm:ss.SS')
    box._doc.userStamp = ''
    box._doc.roomStamp = ''
    box._doc.id = box._id
    Setting.find {}, (err, settings) ->
      if(settings?.length > 0)
        box._doc.userStamp = settings[0].stamps.user
        box._doc.roomStamp = settings[0].stamps.room
      unless (box.room?._id)
        box._doc.bookings = []
        res.json box
      else
        todayMoment = moment(new Date().setHours(0,0,0,0))
        today = todayMoment.format('YYYY-MM-DD')
        tomorrow = todayMoment.add(1,'day').format('YYYY-MM-DD')

        query = {}
        query.startTime = {$gte:moment(today), $lt:moment(tomorrow)}
        query.status = 0
        query.room = box.room._id

        Booking.find(query).exec (err, bookings) ->
          return res.json {status:'failed', message:err.message} if err?
          for each in bookings
            each._doc.id = each._id
            each._doc.startTime = moment(each.startTime).format('YYYY/MM/DD HH:mm:ss')
            each._doc.endTime = moment(each.endTime).format('YYYY/MM/DD HH:mm:ss')
          box._doc.bookings = bookings
          Box.findByIdAndUpdate(box.id,{commands:[]}).exec (err,tt) ->
            return res.json {status:'failed', message:err.message} if err?
            res.json box

app.post '/box/:boxName', (req, res) ->
  boxName = req.params.boxName
  Box.find({name:boxName}).populate('room').exec (err, docs) ->
    return res.json {status:'failed', message:err.message} if err?
    return res.json {status:'failed', message:'终端名称不存在'} if docs?.length is 0

    box = docs[0]
    console.log req.body
    box[k] = v for k, v of req.body when k isnt 'snapshot'
#    box.online = true
    box.lastLinkTime = new Date()
    Snapshot[box._id] = req.body.snapshot
    box.save (err, doc) ->
      return res.json {'status':'failed', message:err.message} if err?
      res.json doc


