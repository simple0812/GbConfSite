#script src:'/js/organization/organization.js'
#script src:'/js/organization/user.js'
#script src:'/lib/pager.js'
#script src:'/lib/md5.js'
script src:'/lib/scrollhelper.js'
coffeescript ->
  @isSave = true
  window.onbeforeunload = ->
    return ('返回后将丢失修改过的数据，确定返回？') unless(isSave)
coffeescript ->
  @pager = '';
  @query_list =
    pageindex: 1,
    pagesize: 10,
    orderby: 'createTime',
    ordermode: 'desc',
div id:"bookmain", ->
    div class: "modal fade", id:"equipList", role:"dialog", 'aria-labelledby':"myModalLabel", 'aria-hidden':"true", ->
      div class: "modal-dialog", ->
        div class: "modal-content", ->
          div class: "modal-header", ->
            button class: "close", 'data-dismiss':"modal", 'aria-hidden':"true", -> '&times;'
            h4 class: "center-block", -> '会议室设备'
          div class: "modal-body", ->
            div class :"row",id:'equipSetting',   ->
          div class: "modal-footer", ->
            button class: "btn btn-primary", 'data-dismiss':"modal", id:"addExternalConfirmBtn", -> '确定'
#            button class: "btn btn-default", 'data-dismiss':"modal", id:"addExternalCancelBtn", -> '取消'

    div class: 'well well-sm fix-top-book min-width-main', ->
      div class:'container', ->
        div class :'row', ->
          span class :"title-search", ->
            span class :"glyphicon glyphicon-search", ->
            text ' 搜索条件'
        div class :'row', ->
          div class :'col-xs-11',->
            div class:"row",style:'padding-bottom:5px',->
              div class :"col-xs-4", ->
                div class :"row", id:"date", ->
                  div class:"input-group ", ->
                    span class:"input-group-addon   span-addon-width-format", ->'日期:'
                    input type:"text", class:"form-control cursor-pointer validator", required:"",description:'会议日期', placeholder:"会议日期", id:"bookDate", onfocus:"$(this).blur()",  ->
#           q
              div class :"col-xs-4 col-xs-offset-4", ->
                div class :"row",id:'number',->
                  div class:"input-group col-xs-11 col-xs-offset-1 meeting-number-fixed pull-right ", ->
                    span class:"input-group-addon  span-addon-width-format", ->'会议人数:'
                    input type:"text", class:"form-control validator",  validator:'roomCapacity', description:'会议人数', placeholder:"如：10",id:"roomCapacity", ->
                    span class:"input-group-addon ", ->'人'
            div class :"row",id:'equip',->
              div class:"input-group  ", ->
                span class:"input-group-addon  span-addon-width-format", ->'设备条件:'
                div class :"form-control",id:'equipDisplay', ->
                span class:"btn btn-success input-group-addon ", id:"addEquip", ->
                  span class:"glyphicon glyphicon-plus-sign", ->
                  text ' 添加设备'
          div class :'col-xs-1 pull-right text-right',->
            button class :"btn btn-primary btn-lg book-search", ->
              text ' 查询'
    div class :"container", id:"fix-day",->
      div class :"row  fix-top-book-padding-day", ->
        div class:"input-group col-xs-4 col-xs-offset-5 book-room-day", ->
          span class :"btn btn-primary input-group-addon",id:'previousDay', ->'前一天'
          input type:"text", class:"form-control cursor-pointer", placeholder:"会议日期", id:"bookDateChange", onfocus:"$(this).blur()", ->
          span class :"btn btn-primary input-group-addon",id:'nextDay', ->'后一天'
        div class :"col-xs-1",->
          div class :"row", ->
            label class: "control-label", for:"isEnd", style:"margin-top:8px;",-> '已结束:'
            span class :'isEnd fix-day-span-width',id:"isEnd",->
        div class :"col-xs-1",->
          div class :"row", ->
            label class: "control-label", for:"hasBegin", style:"margin-top:8px;",-> '进行中:'
            span class :'hasBegin fix-day-span-width',id:"hasBegin",->
        div class :"col-xs-1",->
          div class :"row", ->
            label class: "control-label", for:"isAudit", style:"margin-top:8px;",-> '未审核:'
            span class :'isAudit fix-day-span-width',id:"isAudit",->
        div class :"col-xs-1",->
          div class :"row", ->
            label class: "control-label", for:"notBegin", style:"margin-top:8px;",-> '未开始:'
            span class :'notBegin fix-day-span-width',id:"notBegin",->
    div class:'container fix-top-book-padding ',id:'bookRooms', ->
      div class :'row fixed-width text-left',style:"position:relative", ->
        div class :"col-xs-2",->
          strong ->'会议室'
        div class :"mainTimes col-xs-10", ->
          div class :"scale-time-start", ->
            div class :"scale-time-text",->"0:00"
          for i in [1..22]
            div class :"scale-time", ->
              div class :"scale-time-text",->"#{i}:00"
          div class :"scale-time-end", ->
            div class :"scale-time-text",->"23:00"
#    div class :"row", ->
#      div class:'col-xs-5',->
#      div class:'alert  col-xs-4 ',id:'bookSearchAlert',role:'alert',->
#        button type:"button", class:"close",id:"hideAlert",  ->
#          span class :"", 'aria-hidden':"true", ->'&times;'
#          span class:"sr-only", ->'Close'
#        h4 id:'alertFirst',->'会议时间：10:10-10:45'
#        h4 id:'alertSecond',->'会议室：33333（0人)'
#        h4 id:'alertThird',->'会议室：33333（0人)'
#        div class :"row",id:'alertConfirm', ->
#          p class :'col-xs-4 col-xs-offset-4',->
#            button type:'button', class :"btn btn-success",id:"bookingConfirm", ->'确认预约'

  script type:"text/template", id:"bookRoomTemplate", style:"display:none", ->
#    div class :"col-xs-2 fixed-height",style:"overflow:hidden",->
    div class :"col-xs-2 fixed-height text-left", ->
      div class :"cutstring roomDetatil",title:"{{name}}",->'{{name}}'
#        span title:"{{name}}({{capacity}}人)",->'{{name}}({{capacity}}人)'
#        span title:"{{name}}({{capacity}}人)",->'{{name}}({{capacity}}人)'
#        span title:"{{name}}({{capacity}}人)",->'{{name}}({{capacity}}人)'
    div class :" roomRowChild col-xs-10 ", ->
      for i in [1..24]
#        div class :"scale-time-item booking booking-#{(i-1)%24}",'data-st':(i-1)%24,'data-ed':i%24, ->
        div class :"scale-time-item booking booking-#{(i-1)%24}",'data-st':(i-1)%24*60*60,'data-ed':(i-1)%24*60*60+59*60, ->
      for i in [0..24]
        div class :"",style:"left:#{i*44}px;width:1px;height: 40px;border-left: 1px solid #808080;z-index: 3; position:absolute;", ->

  script type:"text/template", id:"popTemplate",style:"display:none", ->
    div class :"row", ->
      button type:"button", class:"close",id:"closeBookingPop",  ->
        span class :"", 'aria-hidden':"true", ->'&times;'
    div class :"row text-center",->
      dl class :"dl-horizontal ", ->
        dt ->'会议室：'
        dd ->'{{roomName}}({{roomCapacity}}人)'
        dt ->'会议主题：'
        dd ->'{{name}}'
        dt ->'时间：'
        dd ->'{{startTime}}－{{endTime}}'
      button type:'button', class :"btn btn-default editbooking", 'data-bookingid':'{{_id}}',style:"display:{{display}}",->'{{buttonContext}}'

  script type:"text/template", id:"popBookingTemplate",style:"display:none", ->
    div class :"row text-center",->
      dl class :"dl-horizontal ", ->

        dt ->'时间：'
        dd ->'{{startTime}}－{{endTime}}'
  script type:"text/template", id:"popTemplateRoom",style:"display:none", ->
    div class :"row", ->
      button type:"button", class:"close",id:"closeBookingPop",  ->
        span class :"", 'aria-hidden':"true", ->'&times;'
    div class :"row text-center",->
      dl class :"dl-horizontal ", ->
        dt ->'会议室：'
        dd ->'{{roomName}}({{roomCapacity}}人)'
        dt ->'预约时间：'
        dd ->'{{bookingTime}}'
        dt ->'当前时间：'
        dd ->'{{now}}'
#        dt ->''
#        dt ->'{{messageTitle}}'
      div ->
        font color:'red',size:'4', ->'{{message}}'
      button type:'button', class :"btn btn-default bookingConfirm",style:"display:{{display}}",->'{{buttonContext}}'

  script type:"text/template", id:"popTemplateRoomDetail",style:"display:none", ->
#    div class :"row", ->
#      button type:"button", class:"close",id:"closeBookingPop",  ->
#        span class :"", 'aria-hidden':"true", ->'&times;'
    div class :"row text-center",->
      dl class :"dl-horizontal ", ->
        dt ->'会议室：'
        dd ->'{{roomName}}'
        dt ->'可容纳人数：'
        dd ->'{{roomCapacity}}人'
        dt ->'需要审核：'
        dd ->'{{needAudit}}'
#        dt ->'当前时间：'
#        dd ->'{{now}}'
#      #        dt ->''
#      #        dt ->'{{messageTitle}}'
#      div ->
#        font color:'red',size:'4', ->'{{message}}'
#      button type:'button', class :"btn btn-default bookingConfirm",style:"display:{{display}}",->'{{buttonContext}}'


  script id:'dynamicJs',->

  script id:'dynamicJsUser',->
  script id:'dynamicJs1',->
  script id:'dynamicJs2',->
  script id:'dynamicJs3',->
  div id:"bookSubmitMain", onselectstart:'return false', ->

  ie 'ite IE8', ->
    script src:"/js/book/model/externalUser.js", ->
    script src:"/js/book/model/user.js", ->
    script src:"/js/organization/organization.js", ->
    script src:"/js/book/booking.js", ->

  link href:"/css/bootstrap-datetimepicker.css", rel:"stylesheet"
  link href:"/css/bootstrap-switch.css", rel:"stylesheet"
  script src:"/lib/bootstrap-switch.js"
  script src:"/lib/moment.js"
  script src:"/lib/bootstrap-datetimepicker.js"
  script src:"/lib/bootstrap-datetimepicker.zh-CN.js"
  script src:"/lib/async.js"
  script src:"/js/validator.js"
  script src: '/js/book/model/equip.js'
  script src: '/js/book/model/room.js'
  script src: '/js/book/model/booking.js'
  script src: '/js/book/view/book.js'
  script src: '/js/book/view/booking.js'
  script id:'dynamicJs4',->
  script src: '/js/book/router/bookRouter.js'



