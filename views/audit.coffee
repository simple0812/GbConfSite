#link href:"/css/pager.css", rel:"stylesheet"
#link href:"/css/bootstrap-datetimepicker.css", rel:"stylesheet"
#link href:"/css/bootstrap-switch.css", rel:"stylesheet"

head ->
  title -> @title
div class:"modal  fade",id:"myModel",'tabindex':"-1",role:"dialog",'aria-labelledby':"myModalLabel", 'aria-hidden':"true", ->
  div class: "modal-dialog", ->
    div class: "modal-content", ->
      div class:"modal-header", ->
        button type:"button", class:"close",'data-dismiss':"modal", 'aria-hidden':"true", -> '&times;'
        h4 class:"modal-title", id:"myModalLabel", ->"退回理由"
      div class:"modal-body", ->
        textarea class:"form-control",rows:"3",style:"max-width:538px", id:"reason", ->
      div class:"modal-footer", ->
        button type:"button", class:"btn btn-primary", id:"saving", 'data-dismiss':"modal", ->"提交"
        button type:"button", class:"btn btn-default", id:"cancelSaving", 'data-dismiss':"modal", ->"取消"

div class:" well well-sm fix-top-2", ->
  div class :"container fixed-width",id:"auditManageView",style:"height:34px;", ->
#    button type:"button", class:"btn btn-default gap",id:"cancelBtn",  ->
#      span class:"glyphicon glyphicon-ban-circle", ->
#      text ' 取消'

div '.container.fix-top-2-tablelist-default.fixed-width', ->
  h3 '.pageInfo', ->
    img '.circlePic',src:'/img/header.png',alt:'header'
    ' 审批'
  div '.panel.panel-default', ->
    table '.table.table-striped', id:'bookingTable', style:'table-layout:fixed;word-wrap:break-word;',->
      thead '.thead-color', ->
        tr ->
          th class: 'col-xs-2 curpointer time', ->
            text '会议时间'
            b class:"caret"
          th class :"col-xs-3 curpointer room", ->
            text '会议室'
            b class:"caret"
          th class :"col-xs-4 curpointer name", ->
            text '会议主题'
            b class:"caret"
          th class :"col-xs-2 curpointer booker", ->
            text '预约人'
            b class:"caret"
          th class :"col-xs-1", -> '操作'
#          th '.col-xs-1', -> '状态'
      tbody ->
#
script id:"auditTemplate", type:"text/template", style:"display: none", ->
  td -> "{{times}}"
  td class:"cutstring", -> "{{room.name}}"
  td class:"cutstring",-> "{{name}}"
  td class:"cutstring",-> "{{booker.name}}"
  td ->
    div '.btn-toolbar',role:'toolbar', ->
      div '.btn-group.btn-group-xs', ->
        button '.btn.btn-default.edit',type:'button',->
#          i '.glyphicon.glyphicon-edit', ->
          '通过'
        button '.btn.btn-default.back',type:'button',->
#          i '.glyphicon.glyphicon-remove', ->
          '退回'
#  td ->
#    span class:"label booking-status-{{status}}", "{{statusText}}"
script type:"text/javascript",src:"/js/audit/index.js"
script type:"text/javascript",src:"/js/book/model/booking.js"
script type:"text/javascript",src:"/lib/moment.js"
#script type:"text/javascript",src:"/lib/bootstrap.js"
#
coffeescript ->
    new AuditingsView {collection:new Bookings()}
#        tr ->
#          td ->'2013年10月20日 14：00-16：00'
#          td -> '301'
#          td -> '关于XXXXX的会议'
#          td -> '刘长春'
#          td ->
#            div '.btn-toolbar',role:'toolbar', ->
#              div '.btn-group.btn-group-xs', ->
#                button '.btn.btn-success',type:'button',->
#                  i '.glyphicon.glyphicon-edit', ->
#                  '编辑'
#                button '.btn.btn-danger',type:'button',->
#                  i '.glyphicon.glyphicon-remove', ->
#                  '退回'
#          td ->
#            span '.label.meeting-status-start','未开始'
#        tr ->
#          td ->'2013年10月20日 14：00-16：00'
#          td -> '301'
#          td -> '关于XXXXX的会议'
#          td -> '刘长春'
#          td ->
#            div '.btn-toolbar',role:'toolbar', ->
#              div '.btn-group.btn-group-xs', ->
#                button '.btn.btn-success',type:'button',->
#                  i '.glyphicon.glyphicon-edit', ->
#                  '编辑'
#                button '.btn.btn-danger',type:'button',->
#                  i '.glyphicon.glyphicon-remove', ->
#                  '退回'
#          td ->
#            span '.label.meeting-status-ing','进行时'
#        tr ->
#          td ->'2013年10月20日 14：00-16：00'
#          td -> '301'
#          td -> '关于XXXXX的会议'
#          td -> '刘长春'
#          td ->
#            div '.btn-toolbar',role:'toolbar', ->
#              div '.btn-group.btn-group-xs', ->
#                button '.btn.btn-success',type:'button',->
#                  i '.glyphicon.glyphicon-edit', ->
#                  '编辑'
#                button '.btn.btn-danger',type:'button',->
#                  i '.glyphicon.glyphicon-remove', ->
#                  '退回'
#          td ->
#            span '.label.meeting-status-end','已结束'




