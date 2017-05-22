# Controller of my booking, "MB" for short.

Booking = require "../models/booking"
Room = require "../models/room"
User = require "../models/user"
moment = require "moment"
_ = require "underscore"
async = require "async"

sortIterator =
  startTime: (item) -> return moment(item.startTime).valueOf()
  name: (item) -> return item.name
  room: (item) -> return item.room.name or ""
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

app.get "/MB/index", authenticateCheck, (req, res) ->
  res.render "MB/index", title: "我的预约"

app.get "/MB/bookings", (req, res) ->
  userid = req.user?._id or ''
  page = parseInt(req.query.page or 1)
  orderBy = req.query.orderBy or "startTime"
  orderMode = req.query.orderMode or "desc"
  pagesize = parseInt(req.query.size or 15)
  start = (page - 1) * pagesize
  end = start + pagesize
  results =
    totalItems: 0
    total: 0
    current: page
    pagesize: pagesize
    orderBy: orderBy
    orderMode: orderMode
    items: []
  Booking.find({booker: userid}).populate("booker").populate("room").exec (err, bookings) ->
# TODO write to error LOG
    return res.send(400, err.message) if err?
    range = ["_id", "name", "startTime", "endTime", "status", "isAudit", "reason", "remarks"]
    results.totalItems = bookings.length or 0
    results.total = Math.ceil(results.totalItems/pagesize)
    p = _.map bookings, (booking) ->
      x = {}
      x[each] = booking[each] for each in range
      x.room = {id: booking.room._id or null, name: booking.room.get("name") or null} if booking.room
      x.booker = {id: booking.booker._id or null, name: booking.booker.get("name") or null} if booking.booker
      return x
    if orderBy in ["startTime", "room", "name", "status"] then t = _.sortBy(p, sortIterator[orderBy]) else t = p
    t.reverse() if orderMode is "desc"
    results.items = t[start...end]
    res.json results

# 批量取消
app.put "/MB/bookings/cancel", (req, res) ->
  ids = req.body or []
  async.each ids, (id, callback) ->
    Booking.findByIdAndUpdate id, {status: 3}, (err, result) -> if err? then callback err else callback()
  , (err) ->
# TODO write to error LOG
    return res.send(400, err.message) if err?
    res.json ids

# 单个取消
app.put "/MB/:bookingID/cancel", (req, res) ->
  id = req.params.bookingID
  Booking.findByIdAndUpdate id, {status: 3}, (err, results) ->
# TODO write to error LOG
    return res.send(400, err.message) if err?
    res.json results.id
