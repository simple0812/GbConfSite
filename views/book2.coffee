div id:'bookSubmitMainDetail',->
  div class: 'well well-sm', ->
    div class: 'container', ->
#      button class: 'btn btn-primary', onclick:'addBooking(this)',id:'bookingSave', -> '提交'
      button class: 'btn btn-primary', id:'bookingSave', ->
        span class:"glyphicon glyphicon-floppy-disk", ->
        text ' 提交'
      button class: 'btn btn-default gap',id:'bookingBack', ->
        span class:"glyphicon glyphicon-backward", ->
        text ' 返回'
  div class: 'container min-width-main', ->
    div class: "well well-sm", ->
      br ->
#      div class :'row fixed-width', ->
#        div class :"col-xs-1",->'时间表'
#        div class :"mainTimes-ing col-xs-10", ->
#          div class :"scale-time-start-ing", ->
#            div class :"scale-time-text",->"0:00"
#          for i in [1..23]
#            div class :"scale-time-ing", ->
#              div class :"scale-time-text",->"#{i}:00"
      div class :'row fixed-width', ->
#        div class :"col-xs-1",->'时间表'
#        div class :"mainTimes-ing col-xs-10", ->
        div class :"mainTimes-ing ", ->
          div class :"scale-time-start-ing bookingDetail", ->
            div class :"scale-time-text",->"0:00"
          for i in [1..23]
            div class :"scale-time-ing bookingDetail", ->
              div class :"scale-time-text",->"#{i}:00"
  #      img src:'img/scale.png', style:'width: 950px;', ->
      br ->
      div class: 'row',id:'bookingSubmitInfo', ->
        div class: "col-xs-3", ->
          div class:"room_info", ->
            h4 -> '已选会议室'
          div class: "thumbnail",id:"bookingRoomFix", ->
            img  id:"imgURL", src:"", ->
#              input type:"file", id:"changeimage", accept: "image/*", ->


#            img id:"imgURL",  src:"img/conf.png", alt:"...", style:'width: 200px; height: 200px;'
          div class:"room_info", ->
#              h2 -> '已选会议室'
            h5 id:"bookedRoomcapacity", ->'10ren'
            p id:"bookedDate", ->
        div class: "col-xs-9", ->
          form class:"form-horizontal", role:"form", id:"bookForm", ->
            div class: "form-group", ->
              label class: "col-xs-2 control-label", -> '会议时间：'
              div class: "col-xs-10", ->
                input class: "form-control gap-right validator",validator:'bookingDate',  required:'', description:'开始时间', type:"text", id:"txtStartTime", name:"startTime", style:'display:inline;width:100px', ->
                label class: "control-label", for:"txtEndTime", -> '－ '
                input class: "form-control gap-right validator",validator:'bookingDate', type:"text",  required:'', description:'结束时间',  id:"txtEndTime", name:"endTime", style:"display:inline;width:100px;", ->
            div class: "form-group", ->
              label class: "col-xs-2 control-label validator", required:"",description:'会议名称',  for:"conf_name", -> '会议名称：'
              div class: "col-xs-10", ->
                input class: "form-control validator", validator:'specialChar',  required:'', description:'会议名称', type:"text", id:"txtName", name:"name", ->
#            div class: "form-group", ->
#              label class: "col-xs-2 control-label", for:"host_name", -> '预约人：'
#              div class: "col-xs-10", ->
#                input class: "form-control", type:"text", disabled:'', id:"txtBooker", ->
            div class: "form-group", ->
              label class: "col-xs-2 control-label", -> '备注：'
              div class: "col-xs-10", ->
                textarea class: "form-control validator", rows:"2",  validator:'remarks',  description:'备注',  name:"remarks", id:"txtRemarks", ->
            div class: "form-group", ->
              label class: "col-xs-2 control-label", -> '内部与会人员：'
              div class: "col-xs-10 input-group", ->
                div class:'form-control', id:'divInternalArea', ->
#                span class:'input-group-addon btn btn-primary', onclick:'showInternalModal(this)', id: 'btnAddInternal', ->
                span class:'input-group-addon btn btn-primary',  id: 'btnAddInternal', ->
                  span class: "glyphicon glyphicon-plus-sign", ->
                  '&nbsp;添加'
            div class: "form-group", ->
              label class: "col-xs-2 control-label", -> '外部与会人员：'
              div class: "col-xs-10 input-group", ->
                div class: 'form-control', id:'divExternalArea', ->
#                span class: "input-group-addon btn btn-primary", id:'btnAddExternal', onclick:"showExternalModal(this, 'add')", ->
                span class: "input-group-addon btn btn-primary", id:'btnAddExternal', ->
                  span class: "glyphicon glyphicon-plus-sign", ->
                  '&nbsp;添加'
      div class: "modal fade ", id:"modalInternal", role:"dialog", 'aria-labelledby':"myModalLabel", 'aria-hidden':"true", ->
        div class: "modal-dialog", ->
          div class: "modal-content", ->
            div class: "modal-header", ->
              button class: "close", 'data-dismiss':"modal", 'aria-hidden':"true", -> '&times;'
              h4 class: "center-block", -> '添加内部与会人员'
            div class: "modal-body", ->
              div class:'row', ->

                div '.col-xs-3.organization_tree', style:'overflow:hidden;padding: 0 ; ', onselectstart:'return false', ->
                  h3 class: 'pageInfo', ->
                    img src: '/img/header.png',class: 'circlePic', ->
                    text '&nbsp组织'
                  div class:'btn-primary',style:'height:39px; width:100%; border-top-right-radius: 4px;border-top-left-radius: 4px; ', ->
                  ul '.nav.org_tree.well',  style:'padding-top:5px; border-radius:0;',->
                    li ->
                      div title:"全部", ->
                        div '.tree_item',  ->
                        span class:"col-sm-offset-1 allItemNode  selectedNode sp-plus", onclick:'showChildren(this)', ->
                        b class:"node_img"
                        a href:"javascript:void(0)", 'data-id':'', class:"tree_item_text", onclick:"showScrollUser(this, '')", ->'全部'
                        ul class:"nav tree_ul root_node col-sm-offset-1", nodeid:'',->


                div '.col-xs-9',  ->
                  h3 class: 'pageInfo', ->
                    img src: '/img/header.png',class: 'circlePic', ->
                    text '&nbsp用户'
                  div class: 'panel panel-default', id:'scrollPage',  style:" max-height:350px; overflow-x:hidden; overflow-y:auto", ->
                    table class: 'table table-striped',style:"table-layout:fixed;word-wrap:break-word;",  ->
                      thead class:"thead-color", ->
                        tr ->
                          th style:'width:30px', ->
                            input type: 'checkbox',id:"chkAllItems", onclick:'selectAllChk(this)'
                          th class :"span4", ->
                            text '姓名'
                          th class :"span4 curpointer",->
                            text '部门'
                            b class:"caret",style:"display:none"
                          th class :"span4 curpointer",->
                            text '手机号码'
                            b class:"caret", style:"display:none",
                      tbody id:'userList', ->
                  coffeescript ->

                    @pager = '';
                    @query_list = {
                      pageindex: 1,
                      pagesize: 10,
                      orderby: 'createTime',
                      ordermode: 'desc'}

                script type:'text/template', id:'tmplTree', ->
                  li class:'tree_li', nodeid:'{0}', pid:'{2}', ->
                    div title:"{1}", ->
                      div '.tree_item', ->
                      span class:"col-sm-offset-1  selectedNode sp-plus", onclick:'showChildren(this)', ->
                      b class:"node_img"
                      a href:"javascript:void(0)", 'data-id':'{0}', class:"tree_item_text", onclick:"showScrollUser(this, '{0}')", ->'{1}'
                script type:'text/template', id:'tmplUser', ->
                  tr ->
                    td ->
                      input type:"checkbox",value:"{0}", class: 'chkItem', onclick:'selectItemChk(this)'
#                    td -> '{1}'
                    td -> '{2}'
                    td -> '{3}'
#                    td -> '{4}'
                    td -> '{5}'
#                    td -> '{6}'
#                    td -> '{7}'
#                    td ->
#                      div '.btn-group.btn-group-xs', ->
#                        button '.btn.btn-danger', onclick:"deleteUser(this, '{0}')", ->'删除'
#                        button '.btn.btn-info', style:'display:none', onclick:"updateUser(this, '{0}')",-> '编辑'
#                        button '.btn.btn-warning', onclick:"resetPassword(this, '{0}')", ->'重置密码'
#
            div class: "modal-footer", ->
              button class: "btn btn-primary", id:"addInternalConfirmBtn",  -> '确认'
              button class: "btn btn-primary", id:"addInternalContinue", style:"display:none", -> '继续添加'
              button class: "btn btn-default", 'data-dismiss':"modal", id:"addInternalCancelBtn", -> '取消'
      div class: "modal fade", id:"modalExternal", role:"dialog", 'aria-labelledby':"myModalLabel", 'aria-hidden':"true", ->
        div class: "modal-dialog", ->
          div class: "modal-content", ->
            div class: "modal-header", ->
              button class: "close", 'data-dismiss':"modal", 'aria-hidden':"true", -> '&times;'
              h4 class: "center-block", -> '添加外部与会人员'
            div class: "modal-body", ->
              form class: "form-input ", id:"addExternalForm", ->
                div class :"row", ->
                  div class: "input-group col-xs-12 ", ->
                    span class: 'input-group-addon addon-width-4 ', ->
                      '姓名：'
#                      input class: "form-control validator", validator:'specialChar', id:'extName', description:'姓名', required:'', type:"text", name:"name", style:'width:443px;', ->
                    input class: "form-control validator", validator:'username', id:'extName', description:'姓名', required:'', type:"text", name:"name",->
                  br ->
                div class :"row", ->
                  div class:"input-group col-xs-12", ->
                    span class:"input-group-addon col-xs-2 ",style:'width: 95px; padding:10px; text-align: right; ',  ->'性别：'
                    div class:' form-control checkbox ', ->
                      label class:'checkbox', ->
                        input type:'radio', class:'rdMale', name:'gender', checked:'checked',  'value':'1', style:'margin-left:10px; margin-right:2px;'
                        text '男'
                      label class:'checkbox',->
                        input type:'radio', class:'rdFemale', name:'gender', 'value':'0', style:'margin-left:10px;margin-right:2px;'
                        text '女'
                  br ->
                div class :"row", ->
                  div class: "input-group col-xs-12", ->
                    span class: 'input-group-addon addon-width-4', -> '公司名称：'
                    input class: "form-control validator",  validator:'specialChar', id:'extCompany', description:'公司名称', type:"text", name:"company", ->
                  br ->
                div class :"row", ->
                  div class: "input-group col-xs-12", ->
                    span class: 'input-group-addon addon-width-4', -> '邮箱：'
                    input class: "form-control validator",  validator:'email', id:'extEmail', description:'邮箱', type:"text", name:"email", ->
                  br ->
                div class :"row", ->
                  div class: "input-group col-xs-12", ->
                    span class: 'input-group-addon addon-width-4', -> '电话号码：'
                    input class: "form-control validator", type:"text",  validator:'tel', id:'extPhone', description:'电话号码', name:"phone", ->
                  br ->
                div class :"row", ->
                  div class: "input-group col-xs-12", ->
                    span class: 'input-group-addon addon-width-4', -> '手机号码：'
                    input class: "form-control validator", validator:'phone', id:'extTel', description:'手机号码',  required:'', type:"text", name:"phone", ->
            div class: "modal-footer", ->
#              button class: "btn btn-primary",  id:"btnSaveExternal", onclick:'saveExternal(this)',  -> '确定'
              button class: "btn btn-primary",  id:"btnAddMoreExternal",style:'display:none',   -> '继续添加'
              button class: "btn btn-primary",  id:"btnSaveExternal",   -> '确认'
              button class: "btn btn-default", 'data-dismiss':"modal", id:"addExternalCancelBtn", -> '取消'

script type:'text/template', id:'tmplExternal', ->
  div class:"btn btn-primary gap-right",  onclick:"showExternalModal(this,'update')",  ->
    button type:"button", class:"close deleteEquip", onclick:"removeExternal(this)",->
      text '&nbsp;×'
    span '{0}'
