path = require 'path'
winston = require 'winston'
moment = require 'moment'

class JsonData
  constructor: (@timestamp, @level, @msg, @action, @source) ->

class Logger
  log: {}

  constructor: () ->
    @action =
      add: 'add'
      edit: 'edit'
      delete : 'delete'
      request: 'request'

    @source =
      user: 'user'
      box: 'box'
      playlist: 'playlist'
      schedule: 'schedule'
      tast: 'task'
      media: 'media'
      url: 'url'
      weathercnService: 'weathercn service'
      pm25inService: 'pm25in service'
      serviceManager: 'service manager'

    @log = new (winston.Logger)
      transports: [
        new (winston.transports.File)
          filename: path.join 'files/log', '/log'
          timestamp: -> new moment().format 'YYYY-MM-DD HH:mm:ss'
          json: true
          maxsize: 100 * 1024  * 1024
      ]
      exitOnError: false
      levels: @levels
      level: 'info'

    return @

  level: (arg) ->
    @log.transports.file.level = arg

  info: (message, meta) ->
    if @levels.info >= @getLevels @log.transports.file.level
      @log.info new JsonData('info', @log.transports.file.timestamp(), message, meta.action, meta.source )

  error: (message, meta) ->
    if @levels.error >= @getLevels @log.transports.file.level
      @log.error new JsonData('error', @log.transports.file.timestamp(), message, meta.action, meta.source )

  warn: (message, meta) ->
    if @levels.warn >= @getLevels @log.transports.file.level
      @log.warn new JsonData('warn', @log.transports.file.timestamp(), message, meta.action, meta.source )

  debug: (message, meta) ->
    if @levels.debug >= @getLevels @log.transports.file.level
      @log.debug  new JsonData('debug', @log.transports.file.timestamp(), message, meta.action, meta.source )

  getLevels: (arg) ->
    switch arg
      when 'debug' then 0
      when 'warn' then 1
      when 'info' then 2
      else 3

  levels:
    debug: 0,
    warn: 1,
    info: 2,
    error: 3

exports = module.exports = new Logger
