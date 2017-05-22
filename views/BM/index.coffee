head ->
  title -> @title

div class:" well well-sm fix-top-2", ->
  div class :"container fixed-width",id:"bookingManageView", ->
    button type:"button", class:"btn btn-default gap",id:"cancelBtn",  ->
      span class:"glyphicon glyphicon-ban-circle", ->
      text ' 取消'

#    div class: 'input-group col-xs-3 pull-right searchPanel', ->
#      input type:"text", class:"form-control", id:"searchInput", placeholder:"请输入会议主题", ->
#      span class: 'input-group-btn', ->
#        button type:"submit", class:"btn btn-default", id:"searchBtn", -> '搜索'

div class:'container fix-top-2-tablelist-default fixed-width',->
  h3 class: 'pageInfo', ->
    img src: '/img/header.png',class: 'circlePic', ->
    text '&nbsp预约管理'
  div class: 'panel panel-default', ->
    table class: 'table table-striped',style:"table-layout:fixed;word-wrap:break-word;", ->
      thead class:"thead-color", ->
        tr ->
          th style:'width:30px', ->
            input type: 'checkbox',id:"allBookings"
          th class :"col-xs-2 curpointer startTime", ->
            text '会议时间'
            b class:"caret"
          th class :"col-xs-3 curpointer room",->
            text '会议室'
            b class:"caret"
          th class :"col-xs-3 curpointer name",->
            text '会议主题'
            b class:"caret"
          th class :"col-xs-2 curpointer booker",->
            text '预约人'
            b class:"caret"
          th class :"col-xs-1 curpointer status",->
            text '会议状态'
            b class:"caret"
          th class:'col-xs-1 text-center', ->
            text '操作'
      tbody ->

  div id:"pager", class:"page_y", style:"margin-left:auto; margin-right:auto;", ->
    ul class:"pagination", ->
      li ->
        span class:"pageinfo", ->
          text "共 "
          strong class:"totalPages", ->
          text " 页 "
          strong class:"totalResults", ->
          text " 条"
      li class:"curpointer", ->
        a class: "page home", -> "首页"
      li class:"curpointer", ->
        a class: "page previous", -> "上一页"
      li class:"curpointer thisclass", ->
        a ->
          strong class:"page current", -> "1"
      li class:"curpointer", ->
        a class:"page next", -> "下一页"
      li class:"curpointer", ->
        a class:"page end", -> "末页"
      li ->
        span class:"pageinput", ->
          input class:"pagetxt", type:"text", id:"gopage", value:"1", ->
          span class:"curpointer", ->
            a class:"page go", -> "&nbsp GO"

script id:"bookingTemplate", type:"text/template", style:"display: none", ->
  td ->
    input type:"checkbox", value:"{{_id}}"
  td -> "{{duration}}"
  td class:"cutstring", title:"{{room.name}}", -> "{{room.name}}"
  td class:"cutstring", title:"{{name}}", -> "{{name}}"
  td class:"cutstring", title:"{{booker.name}}", -> "{{booker.name}}"
  td ->
    span class: "label booking-status-{{status}}", "{{statusText}}"
  td ->
    div '.btn-group.btn-group-xs.pull-right', ->
      button '.btn.btn-default.edit.button-when-{{status}}', -> "编辑"
      button '.btn.btn-default.cancel.button-when-{{status}}', -> "取消"
script type:"text/javascript", src:"/js/room/model/room.js"
script type:"text/javascript", src:"/js/BM/model/user.js"
script type:"text/javascript", src:"/js/BM/model/booking.js"
script type:"text/javascript", src:"/js/BM/view/index.js"
coffeescript ->
  new BookingsView {collection: new Bookings()}
