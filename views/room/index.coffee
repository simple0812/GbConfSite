head ->
  title -> @title

div class:" well well-sm fix-top-2", ->
  div class :"container fixed-width",id:"roomIndexView", ->
    button type: 'button', class: 'btn btn-default', id:'createBtn', ->
      span class:"glyphicon glyphicon-new-window", ->
      text ' 新建'
    button type:"button", class:"btn btn-default gap",id:"deleteBtn",  ->
      span class:"glyphicon glyphicon-trash", ->
      text ' 删除'

#    div class: 'input-group col-xs-3 pull-right searchPanel', ->
#      input type:"text", class:"form-control", id:"searchInput", placeholder:"请输入会议名称", ->
#      span class: 'input-group-btn', ->
#        button type:"submit", class:"btn btn-default", id:"searchBtn", -> '搜索'

div class:'container fix-top-2-tablelist-default fixed-width',->
  h3 class: 'pageInfo', ->
    img src: '/img/header.png',class: 'circlePic', ->
    text '&nbsp会议室管理'
  div class: 'panel panel-default', ->
    table class: 'table table-striped',style:"table-layout:fixed;word-wrap:break-word;", ->
      thead class:"thead-color", ->
        tr ->
          th style:'width:30px', ->
            input type: 'checkbox',id:"allRooms"
          th class :"col-xs-2 curpointer name", ->
            text ' 会议室名称'
            b class:"caret"
          th class :"col-xs-1 curpointer capacity",->
            text '容纳人数'
            b class:"caret"
          th class :"col-xs-3",->
            text '含有设备'
            b class:"caret", style:"display: none"
          th class :"col-xs-2 curpointer authorization",->
            text '开放/审核/终端预约'
            b class:"caret"
          th class :"col-xs-3",->
            text '备注'
            b class:"caret",style:"display:none",
          th class:'col-xs-1', ->
            text '操作'
      tbody ->

script id:"roomItemTemplate", type:"text/template", style:"display: none", ->
  td ->
    input type:"checkbox", value:"{{_id}}"
  td class:"cutstring", title:"{{name}}", -> "{{name}}"
  td class:"cutstring", title:"{{capacity}}", -> "{{capacity}}"
  td class:"cutstring", title:"{{equipments}}", -> "{{equipments}}"
  td -> "{{openAuditBox}}"
  td class:"cutstring", title:"{{remarks}}", -> "{{remarks}}"
  td ->
    div '.btn-group.btn-group-xs', ->
      button '.btn.btn-default.edit', -> "编辑"
      button '.btn.btn-default.delete', -> "删除"
script type:"text/javascript", src:"/js/equipment/model/equipment.js"
script type:"text/javascript", src:"/js/room/model/room.js"
script type:"text/javascript", src:"/js/room/view/index.js"
coffeescript ->
  new RoomsView {collection: new Rooms({comparator: "name"})}
