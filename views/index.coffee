script src:'/js/index.js'
script src:'/lib/md5.js'
stylus '''
  img { width:100px; height:100px;}
'''

coffeescript ->
  $ ->
    validator.bind()

div id:"goTop", ->
  div class:"panel panel-primary",  id:'indexHead',style:"min-width:1280px;", ->
    div class :" text-center  panel-heading ", ->
      div class:"container fixed-width", ->
        h1 id:"indexLogo", ->'GBCONF'
        p id:"indexName", ->
          text '预订管理系统'
          span id:"indexVer", -> ' R3'
#        p id:"indexText", ->'操作指南文档'
  div class :"container fixed-width", ->
    div '.col-xs-8', ->
      p -> 'x'
      p -> 'x'
      p -> 'x'
      p -> 'x'
      p -> 'x'
      p -> 'x'
      p -> 'x'
      p -> 'x'
      p -> 'x'
      p -> 'x'
    div '.col-xs-4', style:'padding-top:40px;', ->
      div class:"form-horizontal well", 'role':"form", style:'overflow:hidden; padding-top:40px;', ->
        div class:"input-group col-xs-12", ->
          span '.input-group-addon', style:'width:80px', -> '用户名:'
          input type:"text", class:"form-control validator", required:'', validator:'specialChar', description:'登录名',  id:'txtUserName', placeholder:'请输入用户名', ->
        div class:"input-group col-xs-12", style:"margin:20px 0;", ->
          span '.input-group-addon', style:'width:80px',  -> '密  码:'
          input type:"password", class:"form-control validator",  validator:'password',required:'', description:'密码',  id:'txtPassword',  placeholder:'请输入密码', ->
        div '.col-xs-12',->
          button class:"btn btn-primary col-xs-offset-8 col-xs-4", id:"loginBtn", onclick:'login(this)', type:"button", ->'登录'