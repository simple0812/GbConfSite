script src:'/js/organization/organization.js'
script src:'/js/organization/user.js'
script src:'/lib/pager.js'
script src:'/lib/md5.js'
coffeescript ->
  @pager = '';
  @query_list =
    pageindex: 1,
    pagesize: 10,
    orderby: 'createTime',
    ordermode: 'desc',


  $ ->
    initTree()
    validator.bind();


div class:"modal fade", id:"userModal", 'tabindex':"-1", 'role':"dialog", 'aria-labelledby':"userLabel", 'aria-hidden':"true", ->
  div class:"modal-dialog", ->
    div class:"modal-content", ->
      div class:"modal-header", ->
        button type:"button",class:"close",'data-dismiss':"modal",'aria-hidden':"true", ->
          text '&times;'
        h4 class:"modal-title", id:"userLabel", ->
          text '组织'
      div class:"modal-body userModalBody", ->
        div class:"input-group", ->
          span class:"input-group-addon", ->'登录名:'
          input type:"text", class:"form-control validator", 'required':'', validator:'specialChar', description:'登录名', placeholder:"请输入登录名",id: 'txtUserName', ->
        div class:"input-group ", ->
          span class:"input-group-addon", ->'姓名:'
          input type:"text", class:"form-control validator", 'required':'', validator:'username', description:'姓名', placeholder:"请输入姓名",id: 'txtName', ->
        div class:"input-group", ->
          span class:"input-group-addon col-xs-2", style:'width: 85px; padding:10px; text-align: right; ',  ->'性别:'
          div class:' form-control checkbox', ->
            label class:'checkbox', ->
              input type:'radio', class:'rdMale', name:'gender', checked:'checked',  value:'1', style:'margin-left:10px; margin-right:2px;'
              text '男'
            label class:'checkbox',->
              input type:'radio', class:'rdFemale', name:'gender', value:'0', style:'margin-left:10px;margin-right:2px;'
              text '女'
        div class:"input-group ", ->
          span class:"input-group-addon", ->'密码:'
          input type:"password", class:"form-control validator", 'required':'',  validator:'password', description:'密码', placeholder:"请输入密码",id: 'txtPassword', ->
        div class:"input-group ", ->
          span class:"input-group-addon", ->'确认密码:'
          input type:"password", class:"form-control", placeholder:"请确认密码",id: 'txtConfirm', onblur:'confirmPassword(this)', ->
        div class:"input-group ", ->
          span class:"input-group-addon", ->'手机号码:'
          input type:"text", class:"form-control validator", validator:'phone', description:'手机号码',  placeholder:"请输入手机号码",id: 'txtPhone', ->
        div class:"input-group ", ->
          span class:"input-group-addon", ->'固定电话:'
          input type:"text", class:"form-control validator",validator:'tel', description:'固定电话',  placeholder:"请输入固定电话",id: 'txtTel', ->
        div class:"input-group ", ->
          span class:"input-group-addon", ->'分机号:'
          input type:"text", class:"form-control validator",validator:'housePhone',description:'分机号', placeholder:"请输入分机号",id: 'txtHousePhone', ->
        div class:"input-group ", ->
          span class:"input-group-addon", ->'邮箱:'
          input type:"text", class:"form-control validator", 'required':'', validator:'email', description:'邮箱', placeholder:"请输入邮箱",id: 'txtEmail', ->
        div class:"input-group ", ->
          span class:"input-group-addon", ->'角色:'
          select class:"form-control", id:'selRole', ->
            option value:'admin', ->'管理员'
            option value:'auditor',->'审核员'
            option value:'normal', selected:'true', ->'普通用户'
#          input type:"text", class:"form-control", placeholder:"请输入组织名称",id: 'txtTel', ->
        br ->
        div class:"col-xs-offset-9 diabtnfix ", ->
          button type:"button",  class:"btn btn-primary ",id:"btnSaveUser", onclick:'saveUser(this)', ->
            text '确定'
          button type:"button", class:"btn btn-default gap", 'data-dismiss':"modal",->
            text '关闭'

div class:"modal fade", id:"addOrganizationModal", 'tabindex':"-1", 'role':"dialog", 'aria-labelledby':"addOrganizationLabel", 'aria-hidden':"true", ->
  div class:"modal-dialog", ->
    div class:"modal-content", ->
      div class:"modal-header", ->
        button type:"button",class:"close",'data-dismiss':"modal",'aria-hidden':"true", ->
          text '&times;'
        h4 class:"modal-title", id:"addOrganizationLabel", ->
          text '组织'
      div class:"modal-body", ->
        div class:"input-group ", ->
          span class:"input-group-addon", ->'名称:'
          input type:"text", class:"form-control validator", 'required':'', validator:'specialChar', description:'组织名称', placeholder:"请输入组织名称",id: 'txtOrganizationName', ->
        br ->
        div class:"col-xs-offset-9 diabtnfix ", ->
          button type:"button",  class:"btn btn-primary ",id:"btnSaveOrganization", onclick:'saveOrganization(this)', ->
            text '确定'
          button type:"button", class:"btn btn-default gap", 'data-dismiss':"modal",->
            text '关闭'

div class:" well well-sm fix-top-2", ->
  div class :"container fixed-width",id:"operateScheduleArea", ->
    button type: 'button', class: 'btn btn-primary', id:'btnAddOrganization', onclick:"showOrganizationModal(this, 'add')", ->
      span class:"glyphicon glyphicon-new-window", ->
      text ' 新建组织'
    button type: 'button', class: 'btn btn-default gap', id:'btnUpdateOrganization', onclick:"showOrganizationModal(this, 'update')", ->
      span class:"glyphicon glyphicon-new-window", ->
      text ' 编辑组织'
    button type:"button", class:"btn btn-default gap",id:"btnDeleteOrganization", onclick:'deleteOrganization(this)',  ->
      span class:"glyphicon glyphicon-trash", ->
      text ' 删除组织'
    button type: 'button', class: 'btn btn-default gap', id:'createBtn', onclick:"showUserModal(this, 'add')", ->
      span class:"glyphicon glyphicon-new-window", ->
      text ' 新建用户'
    button type:"button", class:"btn btn-default gap",id:"removeSchedulesBtn", onclick:'deleteUsers(this)',  ->
      span class:"glyphicon glyphicon-trash", ->
      text ' 删除用户'


#    div class: 'input-group col-xs-3 pull-right searchPanel', ->
#      input type:"text", class:"form-control", id:"txtKeyword", placeholder:"请输入登录名或者姓名", ->
#      span class: 'input-group-btn', ->
#        button type:"submit", class:"btn btn-default", id:"searchBtn", onclick:'searchUser(this)', -> '搜索'

div class:'', style:"margin: 0 auto; padding-top:60px; overflow: hidden; min-width:1280px; padding-left:10px;", ->

  div '.col-xs-2.organization_tree', style:'overflow:hidden;padding: 0 ; ', onselectstart:'return false', ->
    h3 class: 'pageInfo', ->
        img src: '/img/header.png',class: 'circlePic', ->
        text '&nbsp组织'
    div class:'btn-primary',style:'height:39px; width:100% ', ->
    ul '.nav.org_tree.well', style:'padding-top:5px; border-radius:0;', ->
      li ->
        div title:"全部", ->
          div '.tree_item',  ->
          span class:"col-sm-offset-1 allItemNode  selectedNode sp-minus", onclick:'showChildren(this)', ->
          b class:"node_img"
          a href:"javascript:void(0)", 'data-id':'', class:"tree_item_text", onclick:"showUsers(this, '')", ->'全部'
          ul class:"nav tree_ul root_node col-sm-offset-1", nodeid:'',->


  div '.col-xs-10', ->
    h3 class: 'pageInfo', ->
      img src: '/img/header.png',class: 'circlePic', ->
      text '&nbsp用户'
    div class: 'panel panel-default', ->
      table class: 'table table-striped',style:"table-layout:fixed;word-wrap:break-word;", id: 'schedules', ->
        thead class:"thead-color", ->
          tr ->
            th style:'width:30px', ->
              input type: 'checkbox',id:"chkAllItems", onclick:'selectAllChk(this)'
            th class :"col-xs-1", ->
              text '登录名'
            th class :"col-xs-1", ->
              text '姓名'
            th class :"col-xs-1 curpointer",->
              text '部门'
              b class:"caret",style:"display:none",
            th class :"col-xs-2 curpointer",->
              text '邮箱'
              b class:"caret", style:"display:none",
            th class :"col-xs-2 curpointer",->
              text '手机号码'
              b class:"caret", style:"display:none",
            th class :"col-xs-2",->
              text '电话号码'
              b class:"caret", style:"display:none",
            th class :"col-xs-1",->
              text '类型'
              b class:"caret", sortColName:"stamp",style:"display:none",
            th class :"col-xs-2 text-center",->
              text '操作'
        tbody id:'userList', ->

    div id:'pager', class:'page_y',->

  script type:'text/template', id:'tmplTree', ->
    li class:'tree_li', nodeid:'{0}', pid:'{2}', ->
      div title:"{1}", ->
        div '.tree_item', ->
        span class:"col-sm-offset-1  selectedNode sp-plus", onclick:'showChildren(this)', ->
        b class:"node_img"
        a href:"javascript:void(0)", 'data-id':'{0}', class:"tree_item_text", onclick:"showUsers(this, '{0}')", ->'{1}'
  script type:'text/template', id:'tmplUser', ->
    tr ->
      td ->
        input type:"checkbox",value:"{0}", class: 'chkItem', onclick:'selectItemChk(this)'
      td class:"cutstirng", title:"{1}", -> '{1}'
      td class:"cutstirng", title:"{2}", -> '{2}'
      td class:"cutstirng", title:"{3}", -> '{3}'
      td class:"cutstirng", title:"{4}", -> '{4}'
      td class:"cutstirng", title:"{5}", -> '{5}'
      td class:"cutstirng", title:"{6}", -> '{6}'
      td class:"cutstirng", title:"{7}", -> '{7}'
      td class:"text-center", ->
        div '.btn-group.btn-group-xs', ->
          button '.btn.btn-default', onclick:"resetPassword(this, '{0}')", ->'重置密码'
          button '.btn.btn-default', style:'display:none', onclick:"updateUser(this, '{0}')",-> '编辑'
          button '.btn.btn-default', onclick:"deleteUser(this, '{0}')", ->'删除'

