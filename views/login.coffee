doctype 5
html ->
  head ->
    meta name:"viewport", content="width=device-width, initial-scale=1.0", charset:'utf-8'
    link href:"css/bootstrap.css", rel:"stylesheet"
    link href:"css/common.css", rel:"stylesheet"
    title 'GBCONF'
    script src:"/lib/jquery-1.10.2.js"
    script src:"/lib/bootstrap.js"
    script src:"/lib/underscore.js"
    script src:"/lib/backbone.js"
    script src:"/lib/md5.js"
    script src:"/lib/common.js"


  body style:"height:100%; background-color: #428bca;",->
    form method:'post',action:'/login',->
      div class:"container fixed-width center-block", id:'createUserModal', style:'margin-top:200px;', ->
        div class:"center-block", id:"loginPanel", ->
          p class:"text-center", id:'loginLogo', ->'GBCONF会议预约管理系统'
          br ->
          div class:"form-horizontal", 'role':"form", ->
            div class:"form-group ", ->
              div class:"col-xs-12", ->
                input type:"text", class:"form-control",style:'border-radius:6px 6px 0 0; height: 45px;', id:'nameTxt', name:'username', placeholder:'用户名', ->
                input type:"password", class:"form-control ",style:'border-radius:0 0 6px 6px;margin-top:-1px;height:45px;', id:'passwordTxt', name:'password', placeholder:'密码', ->
            coffeescript ->
              $('#nameTxt').focus()
            div class:"form-group", ->
              div class:"col-xs-12", ->
                button class:"btn btn-default col-xs-12 ", style:"height:45px;", id:"loginBtn",type:"button",onclick:'login()', ->'登录'
            div ->
              if @error?
                div '#status',style:'display:none;', ->"#{@error}"

    div class:"navbar navbar-default  input-group-addon-format navbar-fixed-bottom ", role:"navigation", ->
      div class:"container fixed-width", ->
        a class:"center-block text-center", id:"loginNav", href:"#", ->'© 上海金桥信息股份有限公司 2014'

  coffeescript ->
    $ ->
      err = $.trim($("#status").text())
      return popBy('#passwordTxt', false, err) unless err is ''

    @login = ->
      name = $.trim($('#nameTxt').val())
      pwd = $.trim($('#passwordTxt').val())

      return popBy('#nameTxt', false, '用户名不能为空') if(name == '' )
      return popBy('#nameTxt', false, '用户名长度只能为4－16位') if(name.length > 16 || name.length < 4  )
      return popBy('#passwordTxt', false, '密码不能为空') if(pwd == '')
      return popBy('#passwordTxt', false, '密码长度只能为4－16位') if(pwd.length > 16 || pwd.length < 4 )
      $("#passwordTxt").val(hex_md5(pwd))
      $("form").submit()

    window.document.onkeydown = (e)->
      e = e || window.event;
      login() if e.keyCode is 13




