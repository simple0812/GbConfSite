head ->
  title -> @title

div class:" well well-sm fix-top-2", ->
  div class :"container fixed-width",id:"operateScheduleArea", ->
    button type: 'button', class: 'btn btn-default', id:'createBtn', onclick:"window.location.href='/schedule/create'", ->
      span class:"glyphicon glyphicon-new-window", ->
      text ' 新建'
    button type:"button", class:"btn btn-default gap",id:"removeSchedulesBtn",  ->
      span class:"glyphicon glyphicon-trash", ->
      text ' 删除'

    div class: 'input-group col-xs-3 pull-right searchPanel', ->
      input type:"text", class:"form-control", id:"searchInput", placeholder:"请输入会议名称", ->
      span class: 'input-group-btn', ->
        button type:"submit", class:"btn btn-default", id:"searchBtn", -> '搜索'

div class:'container fix-top-2-tablelist-default fixed-width',->
  div class :"myDemo",->
    h3 class: 'pageInfo', ->
      img src: '/img/header.png',class: 'circlePic', ->
      text '&nbsp会议室'
    div class: 'panel panel-default', ->
      table class: 'table table-striped',style:"table-layout:fixed;word-wrap:break-word;", id: 'schedules', ->
        thead class:"thead-color", ->
          tr ->
            th style:'width:30px', ->
              input type: 'checkbox',id:"allSchedules"
            th class :"col-xs-2", ->
              text ' 会议室名称'
            th class :"col-xs-1 curpointer",->
              text '人数'
              b class:"caret",style:"display:none",
            th class :"col-xs-3 curpointer",->
              text '会议设备'
              b class:"caret", style:"display:none",
            th class :"col-xs-1 curpointer",->
              text '是否开放'
              b class:"caret", style:"display:none",
            th class :"col-xs-1",->
              text '是否审核'
              b class:"caret", style:"display:none",
            th class :"col-xs-2",->
              text '备注'
              b class:"caret", sortColName:"stamp",style:"display:none",
            th class:'col-xs-2', ->
              text '操作'
        tbody ->
          tr ->
            td ->
              input type:"checkbox",value:"", class: 'scheduleChk'
            td -> '会议室0501'
            td -> '20'
            td -> '投影仪,话筒'
            td -> '是'
            td -> '否'
            td -> '第5层会议室'
            td ->
              div '.btn-group.btn-group-xs', ->
                button '.btn.btn-danger', ->'删除'
                button '.btn.btn-info', ->'编辑'
          tr ->
            td ->
              input type:"checkbox",value:"", class: 'scheduleChk'
            td -> '会议室0501'
            td -> '20'
            td -> '投影仪,话筒'
            td -> '是'
            td -> '否'
            td -> '第5层会议室'
            td ->
              div '.btn-group.btn-group-xs', ->
                button '.btn.btn-danger', ->'删除'
                button '.btn.btn-info', ->'编辑'
          tr ->
            td ->
              input type:"checkbox",value:"", class: 'scheduleChk'
            td -> '会议室0501'
            td -> '20'
            td -> '投影仪,话筒'
            td -> '是'
            td -> '否'
            td -> '第5层会议室'
            td ->
              div '.btn-group.btn-group-xs', ->
                button '.btn.btn-danger', ->'删除'
                button '.btn.btn-info', ->'编辑'
          tr ->
            td ->
              input type:"checkbox",value:"", class: 'scheduleChk'
            td -> '会议室0501'
            td -> '20'
            td -> '投影仪,话筒'
            td -> '是'
            td -> '否'
            td -> '第5层会议室'
            td ->
              div '.btn-group.btn-group-xs', ->
                button '.btn.btn-danger', ->'删除'
                button '.btn.btn-info', ->'编辑'
#    script src:"/js/routerDemo.js"
#    script id:"viewJS"
#    coffeescript ->
#      i = Math.random(3);
#      $('#viewJS').load "/js/#{i}test.js"
