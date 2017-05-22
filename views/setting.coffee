link href:"/css/style.css", rel:"stylesheet"
link href:"/css/fileupload.css", rel:"stylesheet"
script src:"/js/jquery.ui.widget.js"
script src:'/lib/md5.js'
script src:"/js/fileupload.js"
script src:'/js/settings/settings.js'
coffeescript ->
  $ ->
    validator.bind()
    fileUpload()
div class:'container fix-top-2-tablelist-default fixed-width', ->
  div class:"row row-offcanvas row-offcanvas-left", ->
    div class:"panel panel-default", id:"container-panel", ->
      div class:"panel-heading", ->
        span ->'系统设置'
      div class:"panel-body", ->
        div class:"bs-callout bs-callout-info", ->
          span ->'邮箱设置'
          button type:"button", class:"btn btn-xs btn-primary", style:"float: right", id:"saveEmailSetting",onclick:'saveEmailSetting()',->'保存'
#          div class:"alert fade out alert-success",style:"float:right;width:100px padding:0px;margin:0 15px 0 0;", id:"emailAlert", ->
#            span style:"margin-left: 20px;", ->'保存成功'
        div class:"row", ->
          form class:"form-horizontal", id:"emailSetting", ->
            div class:"form-group row", ->
              label class:"control-label col-sm-2", ->'协议'
              div class:"col-sm-4", ->
                label class:"radio-inline", ->
                  input type:"radio", name:"bookMode", checked:"true", ->
                  text 'SMTP'
            div class:"form-group", ->
              label class:"control-label col-sm-2", ->'地址'
              div class:"col-sm-4", ->
                input type:"text", class:"form-control validator", id:"emailAddress",description:'地址', placeholder:"Example:smtp.example.com"
            div class:"form-group", ->
              label class:"control-label col-sm-2", ->'端口'
              div class:"col-sm-4", ->
                input type:"text", class:"form-control validator", id:"emailPort", description:'端口',placeholder:"Example:25"
            div class:"form-group", ->
              label class:"control-label col-sm-2", ->'用户名'
              div class:"col-sm-4", ->
                input type:"text", class:"form-control validator", 'required':'',validator:'email', id:"emailUsername",description:'用户名', placeholder:"Example:example@email.com"
            div class:"form-group", ->
              label class:"control-label col-sm-2", ->'密码'
              div class:"col-sm-4", ->
                input type:"password", class:"form-control validator",'required':'',validator:'password', id:"emailPassword",description:'密码', placeholder:"Example:abc123456"

        div class:"bs-callout bs-callout-info", ->
          span ->'管理员密码'
          button type:"button", class:"btn btn-xs btn-primary", style:"float: right", id:"savePassword", onclick:'saveAdminPassword()', ->'修改'
#          div class:"alert fade out alert-success", style:"float:right;width:100px padding:0px;margin:0 15px 0 0;", id:"passwordAlert", ->
#            span style:"margin-left: 20px", id:"passwordMsg"
        form class:"form-horizontal", id:"passwordForm", ->
          div class:"form-group", ->
            label class:"control-label col-sm-2", ->'原密码'
            div class:"col-sm-4", ->
              input type:"password", id:"oldpassword", class:"form-control validator",'required':'',validator:'password',description:'原密码'
          div class:"form-group", ->
            label class:"control-label col-sm-2", ->'新密码'
            div class:"col-sm-4", ->
              input type:"password", id:"newPassword", class:"form-control validator",'required':'',validator:'password',description:'新密码'
          div class:"form-group", ->
            label class:"control-label col-sm-2", ->'重复新密码'
            div class:"col-sm-4", ->
              input type:"password", id:"newPassword2", class:"form-control validator",'required':'',onblur:'confirmPassword(this)'
        div class:"bs-callout bs-callout-info", ->
          span ->'固件升级'
        div class:"form-horizontal", ->
          div class:"form-group", ->
            label class:"control-label col-sm-2", ->'预约固件升级'
          div class:"form-group", ->
            label class:"control-label col-sm-2",-> '当前版本号:'
            div class:"col-sm-4", ->
              label class:"control-label",id: 'ANDVersion',->
          div class: 'progress progress-striped active', id: 'ANDProgress',style:"display:none",  ->
            div class:"progress-bar progress-bar-primary",style:"width: 0%;"
            p id:'ANDProgresspercent', style:'width:100%; text-align:center;position:absolute;top:0;left:0;', -> '0%'
          div class:"form-group", ->
            form class:'control-label col-sm-2', id: 'ANDForm ', method:'post', enctype:"multipart/form-data",->
                iframe name:"summaryFrame", width:"0", height:"0", style:"display:none"
                span class: 'btn btn-primary fileinput-button', ->
                  i class: 'glyphicon glyphicon-upload'
                  span -> ' 升级'
                  input id: 'ANDUploadInput', type: 'file', name: 'file', style: 'width: 90px; height: 30px'
          hr ->
          div class:"form-group", ->
            label class:"control-label col-sm-2", ->'控制固件升级'
          div class:"form-group", ->
            label class:"control-label col-sm-2",-> '当前版本号:'
            div class:"col-sm-4", ->
              label class:"control-label",id:'D4AVersion',->
          div class: 'progress progress-striped active', id: 'D4AProgress',style:"display:none",  ->
            div class:"progress-bar progress-bar-primary" ,style:"width: 0%;"
            p id:'D4AProgresspercent', style:'width:100%; text-align:center;position:absolute;top:0;left:0;', -> '0%'
          div class:"form-group", ->
            form class:'control-label col-sm-2', id: 'D4AForm ', method:'post', enctype:"multipart/form-data",->
              span class: 'btn btn-primary fileinput-button', ->
                i class: 'glyphicon glyphicon-upload'
                span -> ' 升级'
                input id: 'D4AUploadInput', type: 'file', name: 'file', style: 'width: 90px; height: 30px'


#div class:"navbar navbar-fixed-bottom", style:"background-color:#EFEFEF;padding:15px;", ->
#  div class:"container", ->
#    span ->'© 上海金桥 2014'



