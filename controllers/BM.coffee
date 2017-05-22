# Controller of booking manage, "BM" for short.

Booking = require "../models/booking"
Room = require "../models/room"
User = require "../models/user"
moment = require "moment"
_ = require "underscore"
async = require "async"

sortIterator =
  startTime: (item) -> return moment(item.startTime).valueOf()
  name: (item) -> return item.name
  room: (item) -> return item.room?.name or ""
  booker: (item) -> return item.booker?.name or ""
  status: (item) ->
    priority =
      "unknown": 9
      "cancel": 6
      "end": 5
      "withdraw": 4
      "audit": 3
      "start": 2
      "before": 1
    p = "unknown"
    if 3 is item.status
      p = "cancel"
    else if 0 is item.status
      p = "uncancel"
    if "uncancel" is p
      if 2 is item.isAudit
        p = "withdraw"
      else if 0 is item.isAudit
        p = "audit"
      else if 1 is item.isAudit
        p = "pass"
    if "pass" is p
      stime = moment(item.startTime).valueOf()
      etime = moment(item.endTime).valueOf()
      now = moment().valueOf()
      if now < stime
        p = "before"
      else if now > etime
        p = "end"
      else
        p = "start"
    return priority[p]

app.get "/BM/index", authenticateCheck, (req, res) ->
  return res.redirect "/MB/index" if "normal" is req.user?.role
  return res.redirect "/audit" if "auditor" is req.user?.role
  return res.send 403, "您无权访问此页面" unless "admin" is req.user?.role
  res.render "BM/index", title: "预约管理"

# orderBy: startTime, room, name, booker, status
app.get "/BM/bookings", (req, res) ->
  return res.send 403 unless "admin" is req.user?.role
  page = parseInt(req.query.page or 1)
  orderBy = req.query.orderBy or "startTime"
  orderDesc = req.query.orderDesc or 'desc'
  pageSize = parseInt(req.query.pageSize or 15)
  start = (page - 1) * pageSize
  end = start +  pageSize
  results =
    totalResults: 0
    totalPages: 0
    currentPage: page
    pageSize: pageSize
    orderBy: orderBy
    orderDesc: orderDesc
    items: []
  Booking.find().populate("booker").populate("room").exec (err, bookings) ->
#TODO write to error LOG
    return res.send(400, err.message) if err?
    results.totalResults = bookings.length or 0
    results.totalPages = Math.ceil(results.totalResults/pageSize)
    range = ["_id", "name", "startTime", "endTime", "status", "isAudit", "reason", "remarks"]
    p = _.map bookings, (booking) ->
      x = {}
      x[each] = booking[each] for each in range
      x.room = {id: booking.room._id or null, name: booking.room.get("name") or null} if booking.room
      x.booker = {id: booking.booker._id or null, name: booking.booker.get("name") or null} if booking.booker
      return x
    if orderBy in ["startTime", "room", "name", "booker", "status"] then t = _.sortBy(p, sortIterator[orderBy]) else t = p
    t.reverse() if orderDesc is "desc"
    results.items = t[start...end]
    res.json results

# 批量取消
app.put "/BM/bookings/cancel", (req, res) ->
  return res.send 403 unless "admin" is req.user?.role
  ids = req.body or []
  async.each ids, (id, callback) ->
    Booking.findByIdAndUpdate id, {status: 3}, (err, result) -> if err? then callback err else callback()
  , (err) ->
# TODO write to error LOG
    return res.send(400, err.message) if err?
    res.json ids

# 单个取消
app.put "/BM/:bookingID/cancel", (req, res) ->
  return res.send 403 unless "admin" is req.user?.role
  id = req.params.bookingID
  Booking.findByIdAndUpdate id, {status: 3}, (err, results) ->
#TODO write to error LOG
    return res.send(400, err.message) if err?
    res.json results.id
