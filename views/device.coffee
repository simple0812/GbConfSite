
  div  id: 'box', ->
    div class:"modal fade", id:"boxCreate", 'tabindex':"-1", 'role':"dialog", 'aria-labelledby':"boxCreateLabel", 'aria-hidden':"true", ->
      div class:"modal-dialog", ->
        div class:"modal-content", ->
          div class:"modal-header", ->
            button type:"button",class:"close",'data-dismiss':"modal",'aria-hidden':"true", ->
              text '&times;'
            h4 class:"modal-title", id:"boxCreateLabel", ->
              text '新建播放器'
          div class:"modal-body", ->
            div ->
              div class :"row ", ->
                div class:"input-group col-xs-8 col-xs-offset-2", ->
                  span class:"input-group-addon spanAlignFiX", ->'设备ID:'
                  input type:"text", class:"form-control validator",validator:"deviceID",required:"",placeholder:"设备ID", id: 'nameInputCreate', ->
              br ->
              div class :"row", ->
                div class:"input-group col-xs-8 col-xs-offset-2", ->
                  span class:"input-group-addon spanAlignFiX", ->'名称:'
                  input type:"text", class:"form-control validator",validator:"username",placeholder:"名称", id: 'aliasInputCreate', ->
              br ->
            div class:"col-xs-offset-9 diabtnfix ", ->
              button type:"button",  class:"btn btn-primary ",id:"createBox", ->
                text '确定'
              button type:"button", class:"btn btn-default gap", 'data-dismiss':"modal",->
                text '关闭'

    div class:"modal fade", id:"groupCreateModal", 'tabindex':"-1", 'role':"dialog", 'aria-labelledby':"groupCreateModalLabel", 'aria-hidden':"true", ->
      div class:"modal-dialog", ->
        div class:"modal-content", ->
          div class:"modal-header", ->
            button type:"button",class:"close",'data-dismiss':"modal",'aria-hidden':"true", ->
              text '&times;'
            h4 class:"modal-title", id:"groupCreateModalLabel", ->
              text '创建分组'
          div class:"modal-body", ->
            div ->
              div class :"row ", ->
                div class:"input-group col-xs-8 col-xs-offset-2", ->
                  span class:"input-group-addon", ->'分组名:'
                  input type:"text", class:"form-control validator",validator:'groupName',description:'分组名', placeholder:"分组名", id: 'groupInputCreate', ->
              br ->

            div class:"col-xs-offset-9 diabtnfix ", ->
              button type:"button",  class:"btn btn-primary ",id:"createGroup", ->
                text '确定'
              button type:"button", class:"btn btn-default gap", 'data-dismiss':"modal",->
                text '关闭'


    div class:"modal fade", id:"groupAddModal", 'tabindex':"-1", 'role':"dialog", 'aria-labelledby':"groupAddModalLabel", 'aria-hidden':"true", ->
      div class:"modal-dialog", ->
        div class:"modal-content", ->
          div class:"modal-header", ->
            button type:"button",class:"close",'data-dismiss':"modal",'aria-hidden':"true", ->
              text '&times;'
            h4 class:"modal-title", id:"groupAddModalLabel", ->
              text '加入分组'
          div class:"modal-body", ->
            div ->
              div class :"row ", ->
                div class:"input-group col-xs-8 col-xs-offset-2", ->
                  span class: 'input-group-addon input-group-addon-format', -> '当前分组：'
                  select class: "form-control group-list", id: 'group-list-add', ->
              br ->


            div class:"col-xs-offset-9 diabtnfix ", ->
              button type:"button",  class:"btn btn-primary ",id:"addToGroup", ->
                text '确定'
              button type:"button", class:"btn btn-default gap", 'data-dismiss':"modal",->
                text '关闭'

    div class:"modal fade", id:"groupDeleteModal", 'tabindex':"-1", 'role':"dialog", 'aria-labelledby':"groupDeleteModalLabel", 'aria-hidden':"true", ->
      div class:"modal-dialog", ->
        div class:"modal-content", ->
          div class:"modal-header", ->
            button type:"button",class:"close",'data-dismiss':"modal",'aria-hidden':"true", ->
              text '&times;'
            h4 class:"modal-title", id:"groupDeleteModalLabel", ->
              text '设置分组'

          div class:"modal-body", ->
            button type:"button",  class:"btn btn-default ",id:"deleteGroups", ->
              text '批量删除'
            table class: 'table table-striped', style:"table-layout:fixed;word-wrap:break-word;", id: 'group-list', ->
              thead class:"thead-color",->
                tr ->
                  th class :"col-xs-4",->
                    span class:"col-xs-1 ", ->
                      input type: 'checkbox',id:"allGroups"
                    div class :"col-xs-10 ", ->
                      span class :" col-xs-7", ->
                        text '分组名'
                        b class:"caret ",sortColName:"name",style:"display:none",
              tbody ->
                script type:'text/template', id:'group-template', style: 'display: none', ->
                  td ->
                    span class:"col-xs-1 ", ->
                      input type:"checkbox",value:"{{id}}", class: 'groupChk'
                    div class:"col-xs-10", ->
                      span class:"col-xs-9 name cutstring", title:'{{name}}', -> '{{name}}'
                    div class:"col-xs-5 operation", style:'text-align: right;display:none', ->
                      a href:'javascript:void(0)', class: 'editGroup gap',title:'重命名',  ->'重命名'
                      #                        span class:'glyphicon glyphicon-edit',
                      a href:'javascript:void(0)', class: 'deleteGroup gap',title:'删除', ->'删除'
            #                        span class:'glyphicon glyphicon-trash',
            div class:"col-xs-offset-9 diabtnfix ", ->
#              button type:"button",  class:"btn btn-primary ",id:"deleteGroups", ->
#                text '确定'
              button type:"button", class:"btn btn-default gap", 'data-dismiss':"modal",->
                text '关闭'

    div class:"modal fade", id:"roomModal", 'tabindex':"-1", 'role':"dialog", 'aria-labelledby':"roomModalLabel", 'aria-hidden':"true", ->
      div class:"modal-dialog", ->
        div class:"modal-content", ->
          div class:"modal-header", ->
            button type:"button",class:"close",'data-dismiss':"modal",'aria-hidden':"true", ->
              text '&times;'
            h4 class:"modal-title", id:"roomModalLabel", ->
              text '会议室'

          div class:"modal-body", ->
#            button type:"button",  class:"btn btn-default ",id:"deleteGroups", ->
#              text '批量删除'
            table class: 'table table-striped', style:"table-layout:fixed;word-wrap:break-word;", id: 'room-list', ->
              thead class:"thead-color", ->
                tr ->
                  th style:'width:30px', ->
#                    input type: 'checkbox',id:"allRooms"
                  th class :"col-xs-2 curpointer name", ->
                    text ' 会议室名称'
                    b class:"caret"
                  th class :"col-xs-1 curpointer capacity",->
                    text '人数'
                    b class:"caret"
                  th class :"col-xs-3",->
                    text '含有设备'
                    b class:"caret", style:"display: none"
#                  th class :"col-xs-2 curpointer authorization",->
#                    text '开放/审核/终端预约'
#                    b class:"caret"
#                  th class :"col-xs-3",->
#                    text '备注'
#                    b class:"caret",style:"display:none",
#                  th class:'col-xs-1', ->
#                    text '操作'
              tbody ->
            div class:"col-xs-offset-9 diabtnfix ", ->
              button type:"button",  class:"btn btn-primary ",id:"createBtnBox", ->
                text '确定'
              button type:"button", class:"btn btn-default gap", 'data-dismiss':"modal",->
                text '关闭'

    div class:"modal fade", id:"groupNameEditModal", 'tabindex':"-1", 'role':"dialog", 'aria-labelledby':"groupNameEditModalLabel", 'aria-hidden':"true", ->
      div class:"modal-dialog", ->
        div class:"modal-content", ->
          div class:"modal-header", ->
            button type:"button",class:"close",'data-dismiss':"modal",'aria-hidden':"true", ->
              text '&times;'
            h4 class:"modal-title", id:"groupNameEditModal", ->
              text '修改分组名'
          div class:"modal-body", ->
            div ->
              div class :"row ", ->
                div class:"input-group col-xs-6 col-xs-offset-3", ->
                  span class:"input-group-addon input-group-addon-format", ->'分组名:'
                  input type:"text", class:"form-control validator", validator:'groupName',placeholder:"分组名", id: 'nameInputGroupEdit', ->
              br ->

            div class:"col-xs-offset-9 diabtnfix ", ->
              button type:"button",  class:"btn btn-primary ",id:"nameBtnGroupEdit", ->
                text '确定'
              button type:"button", class:"btn btn-default gap", 'data-dismiss':"modal",->
                text '关闭'

    div class:"modal fade", id:"basicSettingModal", 'tabindex':"-1", 'role':"dialog", 'aria-labelledby':"basicSettingLabel", 'aria-hidden':"true", ->
      div class:"modal-dialog", ->
        div class:"modal-content", ->
          div class:"modal-header", ->
            button type:"button",class:"close",'data-dismiss':"modal",'aria-hidden':"true", ->
              text '&times;'
            h4 class:"modal-title", id:"basicSettingLabel", ->
              text '基本设置'
          div class:"modal-body", ->
            div class: 'row col-xs-12', ->
              div class :"col-xs-7", ->
                div class :"row nameSettingDiv",  ->
                  div class:"input-group ", ->
                    span class:"input-group-addon spanAlignFiX", ->'设备ID:'
                    input type:"text", class:"form-control", placeholder:"设备ID", readonly: 'readonly', id: 'nameSettingInput', ->
                  br ->
                div class :"row nameSettingDiv",  ->
                  div class:"input-group ", ->
                    span class:"input-group-addon spanAlignFiX", -> "名称:"
                    input type:"text", class:"form-control validator",validator:"username", placeholder:"名称",id: 'aliasSettingInput', ->
                  br ->
                div class :"row", id:"name", ->
                  div class:"input-group ", ->
                    span class:"input-group-addon input-group-addon-format spanAlignFiX", ->'运行模式:'
                    select class: "form-control ", id:"debugSetting", ->
                      option value:"0", -> '正常播放'
                      option value:"1", -> '调试一'
                      option value:"2", -> '调试二'
                  br ->
#              div class :"col-xs-3 col-xs-offset-1", ->
              div class :"col-xs-4 col-xs-offset-1", ->
                div class :"row",  ->
                  div class:"input-group ", ->
                    span class:"input-group-addon spanAlignFiX", ->'截屏周期:'
                    input type:"text", class:"form-control", placeholder:"秒",id:"auto_snapshot", ->
                  br ->
                div class :"row", ->
                  div class:"input-group ", ->
                    span class:"input-group-addon spanAlignFiX", ->'更新周期:'
                    input type:"text", class:"form-control", placeholder:"秒",id:"interval", ->
                  br ->
                  br class :"nameSettingDiv", ->
                  br class :"nameSettingDiv", ->
                  br class :"nameSettingDiv", ->
            div class: '', id:"timeSetting",style:"max-height:350px;overflow-y:auto", ->
              script type:'text/template', id:'timeSetting-template', style: 'display: none', ->
                button type:"button", class:"close removeTimeSetting", ->'&times'
                div class :"row ",id:'week{{id}}',  ->
                  div class :"weekItem", ->
                    button class:"btn {{btnClass1}} gap weekday", 'day':"1", ->'周一'
                    button class:"btn {{btnClass2}} gap weekday", 'day':"2",  ->'周二'
                    button class:"btn {{btnClass3}} gap weekday", 'day':"3", ->'周三'
                    button class:"btn {{btnClass4}} gap weekday", 'day':"4",  ->'周四'
                    button class:"btn {{btnClass5}} gap weekday", 'day':"5",  ->'周五'
                    button class:"btn {{btnClass6}} gap weekday", 'day':"6",  ->'周六'
                    button class:"btn {{btnClass7}} gap weekday", 'day':"7",  ->'周日'
                  br ->
                    #                  div class :"row", id:"timeSettings", ->
                div class :"row", ->
                  div class:"input-group timeItem",timeSetting:"{{id}}", ->
                    span class:"input-group-addon input-group-addon-format", ->'时间:'
                    input type:"text", class:"form-control", value:"{{from}}" , placeholder:"开始时间",'readonly':'readonly',id:"startTime{{id}}", onclick:"timePick('#startTime{{id}}','#endTime{{id}}',true)",onfocus:"$(this).blur()", ->
                    span class:"input-group-addon curpointer",onclick:"clearDateTime('#startTime{{id}}')",title:"清除时间", ->
                      span class:"glyphicon glyphicon-remove ", ->
                    span class:"input-group-addon input-group-addon-format", ->'至'
                    input type:"text", class:"form-control ",value:"{{to}}", placeholder:"结束时间",'readonly':'readonly', id:"endTime{{id}}", onclick:"timePick('#endTime{{id}}','#startTime{{id}}',false)",onfocus:"$(this).blur()", ->
                    span class:"input-group-addon curpointer",onclick:"clearDateTime('#endTime{{id}}')",title:"清除时间",  ->
                      span class:"glyphicon glyphicon-remove ", ->
#                      span class:"input-group-addon curpointer input-group-addon-format removeTimeSetting",title:"删除条目",  ->
#                        span class:"glyphicon glyphicon-remove ", ->
                  br ->
#            div class:"col-xs-3 col-xs-offset-4", ->
#              button type:"button",  class:"btn btn-primary ",id:"createFolderConfirmBtn",onclick:"displaySetting()", ->
#                text '增加开屏时间段'
#            div class:"col-xs-offset-9 diabtnfix ", ->
            div class:"row", ->
              div class:"col-xs-3 col-xs-offset-4", ->
                button type:"button",  class:"btn btn-primary ",id:"createFolderConfirmBtn", ->
                  text '增加开屏时间段'
              div class:"col-xs-offset-9  ", ->
                button type:"button",  class:"btn btn-primary gap",id:"saveBasicSetting", ->
                  text '确定'
                button type:"button", class:"btn btn-default gap", 'data-dismiss':"modal",->
                  text '关闭'


    div class:"modal fade", id:"netSettingModal", 'tabindex':"-1", 'role':"dialog", 'aria-labelledby':"netSettingLabel", 'aria-hidden':"true", ->
      div class:"modal-dialog", ->
        div class:"modal-content", ->
          div class:"modal-header", ->
            button type:"button",class:"close",'data-dismiss':"modal",'aria-hidden':"true", ->
              text '&times;'
            h4 class:"modal-title", id:"netSettingLabel", ->
              text '网络设置'
          div class:"modal-body", ->
            div class:"input-group ", ->
              span class:"input-group-addon spanAlignFiX", ->'服务器地址:'
              input type:"text", class:"col-xs-7 form-control validator",validator:"service",require:"", placeholder:"如：http://192.168.1.1:8888",id: 'serviceInput', ->
            div class :"netBoxes", ->
              hr ->
              div class:"input-group ", ->
                span class:"input-group-addon spanAlignFiX", ->'IP地址:'
                input type:"text", class:"form-control validator",validator:"IP",require:"", placeholder:"如：192.168.1.1",id:"ipInput", ->
              br ->
              div class:"input-group ", ->
                span class:"input-group-addon spanAlignFiX", ->'子网掩码:'
                input type:"text", class:"form-control validator",validator:"mask",require:"", placeholder:"如：255.255.255.0",id: 'maskInput', ->
              br ->
              div class:"input-group ", ->
                span class:"input-group-addon spanAlignFiX", ->'网关:'
                input type:"text", class:"form-control validator",validator:"gw", require:"",placeholder:"如：192.168.1.1",id:"gwInput", ->
            br ->
            div class:"col-xs-offset-9 diabtnfix ", ->
              button type:"button",  class:"btn btn-primary ",id:"saveNetSetting", ->
                text '确定'
              button type:"button", class:"btn btn-default gap", 'data-dismiss':"modal",->
                text '关闭'
#  script type:'text/template', id:'box-detail', style: 'display: none', ->
    div class:"modal fade", id:"boxDetail", 'tabindex':"-1", 'role':"dialog", 'aria-labelledby':"boxDetailLabel", 'aria-hidden':"true", ->
      div class:"modal-dialog", ->
        div class:"modal-content", ->
          div class:"modal-header", ->
            button type:"button",class:"close",'data-dismiss':"modal",'aria-hidden':"true", ->
              text '&times;'
            h4 class:"modal-title", id:"boxDetailLabel", ->
              text '详细信息'
          div class:"modal-body detailfix", ->
            script type:'text/template', id:'box-detail', style: 'display: none', ->
              div class :"row", ->
                div class :"col-xs-6 ", ->
                  div class:"thumbnail text-center", ->
    #                  div id :"detailimageBox ",style:"width:245px;height:245px;", ->
                    div class :"detailimageBox ", ->
                      i ->
    #                  img src:"", width:"255", height:"160",id:"snapshot",onerror:"this.src = '/images/default.jpg'", ->
                      img src:"",id:"snapshot",onerror:"this.src = '/images/default.jpg'",width:"100%",height:"100%", ->
    #                  div class :"detailimageBox ",style:'height:245px; width:245px;  line-height:245px; text-align:center; vertical-align:middle; display:table-cell;_display:line-block; ',->
    #                    i style:'line-height:100% ; _display:line-block; vertical-align:middle;',->
    ##                  img src:"", width:"255", height:"160",id:"snapshot",onerror:"this.src = '/images/default.jpg'", ->
    #                    img src:"",id:"snapshot",onerror:"this.src = '/images/default.jpg'", style:"vertical-align:middle;", ->
                div class :"col-xs-6 ", ->
                  dl class: "dl-horizontal", ->
                    dt ->'设备ID：'
                    dd id:'boxName',class:'cutstring', ->'{{boxName}}'
                    dt ->'名称：'
                    dd id:'boxAlias',class:'cutstring',->'{{boxAlias}}'
                    dt ->'更新周期：'
                    dd id:'boxInterval',class:'cutstring', ->'{{boxInterval}}'
                    dt ->'截屏周期：'
                    dd id:'boxAuto_snapshot',class:'cutstring', ->'{{boxAuto_snapshot}}'
                    dt ->'信号输出：'
                    dd id:'boxScreen',class:'cutstring', ->'{{boxScreen}}'
                    dt ->'启动时间：'
                    dd id:'boxBoot',class:'cutstring', ->'{{boxBoot}}'

              #
              div class :"row ", ->
                div class :"col-xs-6", ->
                  dl class: "dl-horizontal", ->
                    dt ->'系统版本：'
                    dd id:'boxOs',class:'cutstring', ->'{{boxOs}}'
                    dt ->'播放软件版本号：'
                    dd id:'boxVersionCode',class:'cutstring', ->'{{boxVersionCode}}'
                    dt ->'播放软件版本名：'
                    dd id:'boxVersionName',class:'cutstring', ->'{{boxVersionName}}'
                    dt class :"boxDsmversion", ->'控制软件版本号：'
                    dd id:'boxDsmversionCode', class :"boxDsmversion cutstring", ->'{{boxDsmversionCode}}'
                    dt class :"boxDsmversion", ->'控制软件版本名：'
                    dd id:'boxDsmversionName', class :"boxDsmversion cutstring", ->'{{boxDsmversionName}}'
                    dt ->'磁盘情况：'
                    dd id:'boxDisk',class:'cutstring', ->'{{boxDisk}}'
                    dt ->'分辨率：'
                    dd id:'boxPixel',class:'cutstring', ->'{{boxPixel}}'

                div class :"col-xs-6", ->
                  dl class: "dl-horizontal", ->
                    dt ->'CPU情况：'
                    dd id:'boxCpu', class:'cutstring',->'{{boxCpu}}'
                    dt ->'内存情况：'
                    dd id:'boxMemory', class:'cutstring',->'{{boxMemory}}'
                    dt ->'服务器地址：'
                    dd id:'boxService',class:'cutstring', ->'{{boxService}}'
                    dt ->'IP：'
                    dd id:"boxIP",class:'cutstring', ->'{{boxIP}}'
                    dt ->'MAC：'
                    dd id:"boxMAC",class:'cutstring', ->'{{boxMAC}}'
                    dt ->'MASK：'
                    dd id:"boxMASK", class:'cutstring',->'{{boxMASK}}'
                    dt ->'GW：'
                    dd id:"boxGW",class:'cutstring', ->'{{boxGW}}'

#            div class :"row text-center",id:"boxScheduleBtn", style:"display:none", ->
#              div class:"col-xs-8  col-xs-offset-2", ->
#                button type:"button",  class:"btn btn-primary col-xs-8  col-xs-offset-2",id:"createFolderConfirmBtn",onclick:"displaySetting()", ->
#                  text '点击查看当前持有的排期'
#            div id :'boxSchedule',style:"display:none", ->
#              div class :"row alert alert-info", ->
#                div class :"col-xs-6", ->
#                  dl class :"dl-horizontal", ->
#                    dt ->'排期名：'
#                    dd id:'sssssname', ->'213'
#                    dt ->'播放状态：'
#                    dd id:'sssssname', ->'213'
#                div class :"col-xs-6", ->
#                  dl class :"dl-horizontal", ->
#                    dt ->'下载状态：'
#                    dd id:'sssssname', ->'213'
#                    dt ->'下载百分比：'
#                    dd id:'sssssname', ->'213'
#              div class :"row alert alert-info", ->
#                div class :"col-xs-6", ->
#                  dl class :"dl-horizontal", ->
#                    dt ->'排期名：'
#                    dd id:'sssssname', ->'213'
#                    dt ->'播放状态：'
#                    dd id:'sssssname', ->'213'
#                div class :"col-xs-6", ->
#                  dl class :"dl-horizontal", ->
#                    dt ->'下载状态：'
#                    dd id:'sssssname', ->'213'
#                    dt ->'下载百分比：'
#                    dd id:'sssssname', ->
#                      div class: 'progress progress-striped active', id: 'progress',style:"position:relative; ", ->
#                        div class:"progress-bar progress-bar-primary",style:"width:50%;"
#                        p id:'progresspercent', style:'width:100%; text-align:center;position:absolute;top:0;left:0;color:orange', -> '50%'

              div class:"col-xs-offset-9 diabtnfix ", ->
                button type:"button", class:"btn btn-default gap", 'data-dismiss':"modal",->
                  text '关闭'
    div class:"modal fade", id:"deleteBoxesAlert", 'tabindex':"-1", 'role':"dialog", 'aria-labelledby':"createFolderLabel", 'aria-hidden':"true", ->
      div class:"modal-dialog", ->
        div class:"modal-content", ->
          div class:"modal-header", ->
            button type:"button",class:"close",'data-dismiss':"modal",'aria-hidden':"true", ->
              text '&times;'
            h4 class:"modal-title", id:"deleteBoxesAlertLabel", ->
              text '警告'
          div class:"modal-body", ->
            h4 class:"col-xs-offset-1", ->
              text '确认要删除所选播放器吗？'
            div class:"col-xs-offset-9 diabtnfix", ->
              button type:"button",  class:"btn btn-primary ",'data-dismiss':"modal", ->
                text '确定'
              button type:"button", class:"btn btn-default gap", 'data-dismiss':"modal",->
                text '关闭'
    div class:"modal fade", id:"createGroupAlert", 'tabindex':"-1", 'role':"dialog", 'aria-labelledby':"createFolderLabel", 'aria-hidden':"true", ->
      div class:"modal-dialog", ->
        div class:"modal-content", ->
          div class:"modal-header", ->
            button type:"button",class:"close",'data-dismiss':"modal",'aria-hidden':"true", ->
              text '&times;'
            h4 class:"modal-title", id:"createFolderLabel", ->
              text '警告'
          div class:"modal-body", ->
            h4 class:"col-xs-offset-1", ->
              text '请先选择您要加入分组的播放器'
            div class:"col-xs-offset-9 diabtnfix", ->
              button type:"button",  class:"btn btn-primary ",'data-dismiss':"modal", ->
                text '确定'
    div class:"modal fade", id:"addToGroupAlert", 'tabindex':"-1", 'role':"dialog", 'aria-labelledby':"createFolderLabel", 'aria-hidden':"true", ->
      div class:"modal-dialog", ->
        div class:"modal-content", ->
          div class:"modal-header", ->
            button type:"button",class:"close",'data-dismiss':"modal",'aria-hidden':"true", ->
              text '&times;'
            h4 class:"modal-title", id:"addToGroupAlertLabel", ->
              text '警告'
          div class:"modal-body", ->
            h4 class:"col-xs-offset-1", ->
              text '请先选择您要加入分组的播放器'
            div class:"col-xs-offset-9 diabtnfix", ->
              button type:"button",  class:"btn btn-primary ",'data-dismiss':"modal", ->
                text '确定'
    div class:"modal fade", id:"boxesOutOfGroupAlert", 'tabindex':"-1", 'role':"dialog", 'aria-labelledby':"createFolderLabel", 'aria-hidden':"true", ->
      div class:"modal-dialog", ->
        div class:"modal-content", ->
          div class:"modal-header", ->
            button type:"button",class:"close",'data-dismiss':"modal",'aria-hidden':"true", ->
              text '&times;'
            h4 class:"modal-title", id:"boxesOutOfGroupAlertLabel", ->
              text '警告'
          div class:"modal-body", ->
            h4 class:"col-xs-offset-1", ->
              text '请先选择您要移出分组的播放器'
            div class:"col-xs-offset-9 diabtnfix", ->
              button type:"button",  class:"btn btn-primary ",'data-dismiss':"modal", ->
                text '确定'
    div class:"modal fade", id:"settingsAlert", 'tabindex':"-1", 'role':"dialog", 'aria-labelledby':"createFolderLabel", 'aria-hidden':"true", ->
      div class:"modal-dialog", ->
        div class:"modal-content", ->
          div class:"modal-header", ->
            button type:"button",class:"close",'data-dismiss':"modal",'aria-hidden':"true", ->
              text '&times;'
            h4 class:"modal-title", id:"settingsAlertLabel", ->
              text '警告'
          div class:"modal-body", ->
            h4 class:"col-xs-offset-1", ->
              text '请先选择您要设置的播放器'
            div class:"col-xs-offset-9 diabtnfix", ->
              button type:"button",  class:"btn btn-primary ",'data-dismiss':"modal", ->
                text '确定'
    div class:"modal fade", id:"controlsAlert", 'tabindex':"-1", 'role':"dialog", 'aria-labelledby':"createFolderLabel", 'aria-hidden':"true", ->
      div class:"modal-dialog", ->
        div class:"modal-content", ->
          div class:"modal-header", ->
            button type:"button",class:"close",'data-dismiss':"modal",'aria-hidden':"true", ->
              text '&times;'
            h4 class:"modal-title", id:"controlsAlertLabel", ->
              text '警告'
          div class:"modal-body", ->
            h4 class:"col-xs-offset-1", ->
              text '请先选择您要控制的播放器'
            div class:"col-xs-offset-9 diabtnfix", ->
              button type:"button",  class:"btn btn-primary ",'data-dismiss':"modal", ->
                text '确定'
    div class: 'well well-sm fix-top-2', ->
      div class: 'container fixed-width',id:"operateScheduleArea", ->
        div class: 'btn-group', ->
#          button type: 'button', class: 'btn btn-default gap', id:'createBtn', ->
          button type: 'button', class: 'btn btn-default gap', id:'loadRoom', ->
            span class: 'glyphicon glyphicon-new-window', ->
            text ' 新建'
        button type: 'button', class: 'btn btn-default gap', id:'deleteBoxes', ->
          span class: 'glyphicon glyphicon-trash', ->
          text ' 删除'
        coffeescript ->
          [$('#createBtn').hide(), $('#deleteBoxes').hide()] if $.cookie('type') is 'normal'
        div class: 'btn-group gap', ->
          button type: 'button', class: 'btn btn-default dropdown-toggle', id:'groupBtn', 'data-toggle': "dropdown", ->
            span class: 'glyphicon glyphicon-th-list', ->
            text ' 分组'
            span class: "caret", ->
          ul class: "dropdown-menu", role: "menu", ->
            li ->
              a href: "#", id:"createGroupModal", -> '创建分组'
            li class: "divider", ->
            li ->
              a href: "#",id:"deleteGroupModal", -> '设置分组'
            li class: "divider", ->
            li ->
              a href: "#", id:"addToGroupModal", -> '加入分组'
            li class: "divider boxesOutOfGroup", style:"display:none",  ->
            li class :"boxesOutOfGroup", style:"display:none", ->
              a href: "#",id:"boxesOutOfGroup",-> '移出分组'
        div class: 'btn-group gap', ->
          button type: 'button', class: 'btn btn-default dropdown-toggle', 'data-toggle': "dropdown", ->
            span class: 'glyphicon glyphicon-cog', ->
            text ' 设置'
            span class: "caret", ->
          ul class: "dropdown-menu", role: "menu", ->
            li ->
              a href: "#", id: 'loadBasicSettings', -> '基本设置'
            li class: "divider", ->
            li ->
              a href: "#", id: 'loadNetSettings', -> '网络设置'
        div class: 'btn-group gap', ->
          button type: 'button', class: 'btn btn-default dropdown-toggle', id:'commandBtn', 'data-toggle': "dropdown", ->
            span class: 'glyphicon glyphicon-transfer', ->
            text ' 控制'
            span class: "caret", ->
          ul class: "dropdown-menu", role: "menu", ->
            li ->
              a href: "javascript:void(0)", id: 'snapshotCommand', -> '截屏'
            li class: "divider", ->
            li ->
              a href: "javascript:void(0)", id: 'screenOnCommand', -> '开屏'
            li class: "divider", ->
            li ->
              a href: "javascript:void(0)", id: 'screenOffCommand', -> '关屏'
            li class: "divider", ->
  #            li ->
  #              a href: "", id: 'powerOnCommand', -> '开机'
  #            li class: "divider", ->
            li ->
              a href: "javascript:void(0)", id: 'powerOffCommand', -> '关机'
            li class: "divider", ->
            li ->
              a href: "javascript:void(0)", id: 'rebootCommand', -> '重启'
            li class: "divider", ->
            li ->
              a href: "javascript:void(0)", id: 'resetCommand', -> '重置'

#        div class: 'col-xs-3 input-group pull-right searchPanel', ->
#          input type:"text", class:"form-control", id:"searchInput", placeholder:"请输入预约机名称", ->
#          span class: 'input-group-btn', ->
#            button type:"submit", class:"btn btn-default", id:"searchBtn", -> '搜索'
        div id: "settingTwo", ->
          div class: 'col-xs-4 input-group', id: "groupSelect", ->
            span class: 'input-group-addon input-group-addon-format', -> '当前分组：'
            select class: "form-control group-list ", id: 'group-list-index', ->
              option value:"all", -> '全部'
              script type:'text/template', id:'groupSelect-template', style: 'display: none', ->
                '{{name}}'
          div class: "btn-group pull-right", ->
            button type:"button", class: "btn btn-primary", id:'boxListBtn', -> '列表'
            button type:"button", class: "btn btn-default", id: 'boxViewBtn', -> '视图'


    div class:'container fix-top-2-tablelist-box fixed-width',->

      h3 class: 'pageInfo', ->
        img src: '/img/header.png',class: 'circlePic', ->
        text '&nbsp预约机'
      div class: 'panel panel-default showOnList', ->
        table class: 'table table-striped', style:"table-layout:fixed;word-wrap:break-word;", id: 'box-list', ->
          thead class:"thead-color", ->
            tr ->
              th class :"col-xs-4 curpointer sortByName sortBy",->
                span class:"col-xs-1 ", ->
                  input type: 'checkbox',id:"allBoxes"
                div class :" ", ->
                  span class :" col-xs-7", ->
                    text ' 设备ID'
                    b class:"caret ",sortColName:"name",
              th class :"col-xs-2 curpointer sortByAlias sortBy",->
                text '名称'
                #
                b class:"caret", sortColName:"alias",
              th class :"col-xs-2 ",->
                text '会议室'
                #
                b class:"caret", sortColName:"~",style:'display:none',
              th class :"col-xs-2 ",->
                text '地址'
                #
                b class:"caret", sortColName:"~",style:'display:none',
              th class :"col-xs-1 curpointer sortByOnline sortBy",  ->
                text '在线状态'
                #
                b class:"caret", sortColName:"online",
              th class :"col-xs-1 curpointer sortByScreen sortBy", ->
                text '屏幕状态'
                #
                b class:"caret", sortColName:"screen",
          tbody ->
      div id:"box-view", ->

  script type:'text/template', id:'box-template', style: 'display: none', ->
    td ->
      span class:"col-xs-1 ", ->
        input type:"checkbox",value:"{{_id}}", class: 'boxChk'
      div class:"col-xs-10", ->
        span class:"col-xs-9 name cutstring", title:'{{name}}', -> '{{name}}'
      div class:"col-xs-5 operation", style:'text-align: right;display:none', ->
        a href:'javascript:void(0)', class: 'detail',title:'详细',  -> '详细'
        span class: 'gap', ->
        a href:'javascript:void(0)',class:"dropdown-toggle", 'data-toggle':"dropdown",title:'更多操作', ->
          text '更多操作'
          ul class:"dropdown-menu",style:"min-width:80px;margin-top: 0px;margin-left:50px;", ->
            li ->
              a href:'javascript:void(0)',class:'loadBasicSetting', title:'基本设置', -> '基本设置'
            li ->
              a href:'javascript:void(0)', class: 'loadNetSetting', title:'网络设置',  ->  '网络设置'
            li class:'divider delbox-li', ->
            li ->
              a href:'javascript:void(0)', class: 'outOfGroup', title:'移出分组',style:"display:none",  -> '移出分组'
            li class:'delbox-li', ->
              a href:'javascript:void(0)', class: 'delete',title:'删除', -> '删除'
    td class:"cutstring", ->
      span class:"td-alias ", -> '{{alias}}'
    td -> '{{room}}'
    td -> '{{ip}}'
    td class :"text-center", ->
      span class: '{{online}}'
    td class :"text-center",  ->
      span class: '{{screen}}'
  script type:'text/template', id:'boxView-template',->
    div class :"row col-xs-12", ->
      div class:'thumbnail', ->
        div class :"caption", ->
          div class:"checkbox cutstring", ->
            label  ->
              input type:"checkbox",value:"{{id}}", class: 'boxChk', title:'{{name}}'
              '{{name}}'
        div class:"imageBox detailimageBox", ->
          i ->
#            img src:"{{snapshot}}",onerror:"this.src = '/images/default.jpg'", ->
          img src:"data:image/png;base64, {{snapshot}}", class:"snapshot", onerror:"this.src = '/images/default.jpg'", ->
        div class :"caption", ->
          div class: 'btn-group', ->
            button type: 'button', class: 'btn btn-primary btn-xs detail',  -> '详细'
            div class:"btn-group", ->
              a href:'javascript:void(0)', type: 'button', class: 'btn btn-primary btn-xs dropdown-toggle','data-toggle': 'dropdown', ->
                text '更多操作'
                span class: 'caret'
              ul class:"dropdown-menu", ->
                li ->
                  a href:'javascript:void(0)',class:'loadBasicSetting', title:'基本设置', -> '基本设置'
                li ->
                  a href:'javascript:void(0)', class: 'loadNetSetting', title:'网络设置',  ->  '网络设置'
                li class:'divider', ->
                li ->
                  a href:'javascript:void(0)', class: 'outOfGroup', title:'移出分组',style:"display:none",  -> '移出分组'
                li ->
                  a href:'javascript:void(0)', class: 'delete',title:'删除', -> '删除'
#  script type:'text/template', id:'boxSchedule-template',->
##    div class :"row alert alert-info", ->
#    div class :"col-xs-6", ->
#      dl class :"dl-horizontal", ->
#        dt ->'排期名：'
#        dd class:'', style:'white-space:nowrap;text-overflow:ellipsis;-o-text-overflow:ellipsis;overflow: hidden; display:block;', title:"{0}", ->'{0}'
#        dt ->'播放状态：'
#        dd  style:"position:relative; top:5px;",  ->'{1}'
#    div class :"col-xs-6", ->
#      dl class :"dl-horizontal", ->
#        dt ->'下载状态：'
#        dd ->'{2}'
#        dt ->'下载百分比：'
#        dd ->
#          div class: 'progress progress-striped active', id: 'progress',style:"position:relative; ", ->
#            div class:"progress-bar progress-bar-primary",style:"width:{3}%;"
#            p id:'progresspercent', style:'width:100%; text-align:center;position:absolute;top:0;left:0;color:orange', -> '{3}%'

  script id:"roomItemTemplate", type:"text/template", style:"display: none", ->
    td ->
      input type:"radio",name:'room', value:"{{_id}}", id:'room{{_id}}'
    td class:"cutstring", title:"{{name}}", -> "{{name}}"
    td class:"cutstring", title:"{{capacity}}", -> "{{capacity}}"
    td class:"cutstring", title:"{{equipments}}", -> "{{equipments}}"
#    td -> "{{openAuditBox}}"
#    td class:"cutstring", title:"{{remarks}}", -> "{{remarks}}"
#    td ->
#      div '.btn-group.btn-group-xs', ->
#        button '.btn.btn-default.edit', -> "编辑"
#        button '.btn.btn-default.delete', -> "删除"
  link href:"/css/bootstrap-datetimepicker.css", rel:"stylesheet"
  link href:"/css/bootstrap-switch.css", rel:"stylesheet"
  script src:"/lib/bootstrap-datetimepicker.js"
  script src:"/lib/bootstrap-datetimepicker.zh-CN.js"
  script src:"/lib/common.js"
  script src:"/js/validator.js"
  script type:"text/javascript",src:"/js/room/model/room.js"
  script type:"text/javascript",src:"/js/room/view/index.js"
  script type:"text/javascript",src:"/js/device/model/device.js"
  script type:"text/javascript",src:"/js/device/model/group.js"
  script type:"text/javascript",src:"/js/device/view/group.js"
  script type:"text/javascript",src:"/js/device/view/index.js"