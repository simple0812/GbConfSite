doctype 5
html ->
  head ->
    meta name:"viewport", content="width=device-width, initial-scale=1.0", charset:'utf-8'
    link href:"/css/interface.css", rel:"stylesheet"
    script src:"/lib/jquery-1.10.2.js"
    script src: '/lib/common.js'
    script src: '/lib/moment.js'
    script src: '/js/interface/testpage.js'
    script src: '/lib/underscore.js'
    script src:"/lib/jquery.cookies.js"


  body  ->
    div class:'header', ->
      div '.header-top', ->
        p '.unitname', ->
          span '.chinaname', -> '中山医院'
          span '.englishname',-> 'zhongshanyiyuan'
        p '.roomname', roomid:"#{@room._id}", -> "#{@room.name}"
      div '.header-bot', ->
        span 'Conference I'

    div '.content', ->
      ul '#bookings', ->
        li ->
          span '.sp-meeting', -> ''
          coffeescript ->
            $('.sp-meeting').html(moment().format('YYYY-MM-DD'))
          span '.sp-user', -> '预约人'
          span '.sp-stime', -> '开始时间'
          span '.sp-etime', -> '结束时间'


    script type:'text/template', class:'tmplBooking', ->
      li ->
        span '.sp-meeting', -> '{0}'
        span '.sp-user', -> '{1}'
        span '.sp-stime', -> '{2}'
        span '.sp-etime', -> '{3}'