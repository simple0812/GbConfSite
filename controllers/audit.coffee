User = require "#{$WEBPATH}/models/user"
Booking =require "#{$WEBPATH}/models/booking"
Notice =require "#{$WEBPATH}/models/notice"
Email =require "#{$WEBPATH}/models/email"
moment = require "moment"
async = require "async"
_ = require 'underscore'

app.get '/booking/audit', (req,res) ->
#  ids = req.query.roomIds or []
#  date = req.query.date or ''
  Booking.find({status: 0,isAudit:0,endTime:{$gt:moment()}}).populate('room').populate('booker').exec (err, bookings) ->
  # TODO write to error LOG
    return res.send(400, err.message) if err?
    console.log(bookings)
    res.json bookings

app.put '/booking/audit/:id', (req,res) ->
  userId = req.session.passport.user._id
  return res.send(400, '您还没有登录') unless  userId?
  return res.send(400, '你没有权限审核') if req.session.passport.user.role is 'normal'
  reqBooking = new Booking()
  reqBooking[k] = v for k, v of req.body
  receivers = ''
  for each in reqBooking.externalUsers when each.email? and each.email.length >0
    receivers += each.email + ','
  Booking.findById(req.body._id).populate('room').exec (err, booking) ->
    return res.send(400, err.message) if err?
#    return res.send(400, '该会议室已经不需要审核') if booking.room?.isAudit is 0
    return res.send(400, '该预约已经审核完成') unless booking?.isAudit is 0
#    return res.send(400, '无法审核已经开始的会议') if booking.startTime <= moment()
    if reqBooking.isAudit is 1
      return res.send(400, '无法审核已经开始的会议') if booking.startTime <= moment()
      booking.isAudit = 1
      booking.save (err, doc) ->
        return res.send(400, err.message) if err?
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
            for each in doc.users when each.email? and each.email.length? >0
              receivers += each.email + ','
            return res.json doc if receivers.length is 0
            mail =
              to: receivers,
              subject: "与会通知 ",
              text: "与会通知",
              html: "请您于#{moment(doc.startTime).format('YYYY-MM-DD HH:mm')}在#{doc.room.name}参加会议"
            new Email(mail).send (err, t) ->
              console.log err if err?
#              return res.send(400, '预约成功，但邮件发送失败') if err?
            res.json doc
    else if reqBooking.isAudit is 2
      booking.isAudit = 2
      booking.reason = reqBooking.reason
      booking.save (err, doc) ->
        return res.send(400, err.message) if err?
        Booking.findById(doc._id).populate('booker').populate('room').exec (err, doc) ->
          return res.send(400, err.message) if err?
          receivers = []
          receivers.push(doc.booker.email) if doc.booker?.email?.length >0
          return res.json doc if receivers.length is 0
          mail =
            to: receivers,
            subject: "与会通知 ",
            text: "与会通知",
            html: "您预约的#{moment(doc.startTime).format('YYYY-MM-DD HH:mm')}在#{doc.room.name}的会议被退回了，退回理由#{doc.reason}"
          new Email(mail).send (err, t) ->
            console.log err if err?
#            return res.send(400, '预约退回成功，但邮件发送失败') if err?
          res.json doc

