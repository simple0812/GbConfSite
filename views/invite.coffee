head ->
  title -> @title
div '.well.well-sm.fix-top-2', ->
  div '.container.fixed-width', ->
    button type:"button", class:"btn btn-default gap",id:"removeBtn",  ->
      span class:"glyphicon glyphicon-trash", ->
      text ' 删除'
#    div '.btn-group.gap', ->
#    div '.col-xs-3.input-group.pull-right.searchPanel', ->
#      input '.form-control', id:'inputSearch', type:'text',placeholder:'请输入会议主题'
#      span '.input-group-btn', ->
#        button '.btn.btn-default',type:'submit',id:'searchBtn', -> '搜索'
div '.container.fix-top-2-tablelist-default.fixed-width', ->
  h3 '.pageInfo', ->
    img '.circlePic',src:'/img/header.png',alt:'header'
    ' 与会通知'
  div '.panel.panel-default', ->
    table '.table.table-striped', id:'bookingTable', style:'table-layout:fixed;word-wrap:break-word;',->
      thead '.thead-color', ->
        tr ->
          th style:'width:30px', ->
            input type: 'checkbox',id:"allNotices"
          th class: 'col-xs-2 curpointer time', ->
            text '会议时间'
            b class:"caret"
#          th '.col-xs-2', -> '时间'
          th class :"col-xs-3 curpointer room", ->
            text '会议室'
            b class:"caret"
          th class :"col-xs-4 curpointer name", ->
            text '会议主题'
            b class:"caret"
          th class :"col-xs-2 curpointer booker", ->
            text '预约人'
            b class:"caret"
          th class:'col-xs-1', ->
            text '操作'

      tbody ->

script id:"noticeTemplate", type:"text/template", style:"display: none", ->
 td ->
  input type:"checkbox", value:"{{id}}"
# td -> "{{date}}"
 td -> "{{duration}}"
 td class:"cutstring",-> "{{room}}"
 td class:"cutstring",id:"theme{{id}}",-> "{{theme}}"
 td class:"cutstring",-> "{{reservation}}"
 td ->
   div '.btn-group.btn-group-xs', ->
     button class: 'btn btn-default remove', id:'{{id}}', ->'删除'


script type:"text/javascript", src:"/js/notice/model/notice.js"
script type:"text/javascript", src:"/js/notice/view/index.js"
coffeescript ->
  new NoticesView {collection: new Notices()}


