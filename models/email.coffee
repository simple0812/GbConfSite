nodemailer = require "nodemailer"
Setting = require "#{$WEBPATH}/models/setting"
#$ = require 'jquery'


class Email

#  @DefaultFrom = "1992134042@qq.com"
#  smtpTransport = nodemailer.createTransport "SMTP",{
#    service: "qq",
#    auth: {
#      user: "1992134042@qq.com",
#      pass: "qioushuo8215"
#    }
#  }

  constructor: (@mailOptions) ->

  send: (callback) ->
    mailOptions = @mailOptions

    Setting.find (err, docs) ->
      return callback(err, null) if err?
      return callback({message:'邮箱未设置'}) if docs.length is 0
      email = docs[0].email
      return callback({message:'邮箱未设置'}) unless email?
      console.log email

      transport = nodemailer.createTransport "SMTP", {
        host:email.host
        secure: true
        auth: {
          user:email.username,
          pass:email.password
        }
      }

      mailOptions.from = email.username
      console.log mailOptions
      transport.sendMail mailOptions, (error, response) ->
        console.log(error)
        console.log(response)
        callback(error, response)


exports = module.exports = Email