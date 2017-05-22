script src:'/js/index.js'
script src:'/lib/md5.js'
script src:'/socket.io/socket.io.js'
stylus '''
  img { width:100px; height:100px;}
'''

coffeescript ->
  socket = io.connect('http://localhost:3001')
  socket.on 'changed', (x)->
    alert(x)
#   console.log('tt')
#    socket.emit('my other event', { my: 'data' }
#    socket.emit('an event', { some: 'data' })

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
          button class:"btn btn-primary col-xs-offset-8 col-xs-4", id:"loginBtn", onclick:'putcommad(this)', type:"button", ->'登录'
  button class:"btn btn-primary col-xs-offset-8 col-xs-4", id:"loginBtn", type:"button",  onclick:'test(this)',->'点击'
coffeescript ->
  @putcommad = () ->
    console.log 'xxxx'
#    $.post '/command999', {'aa':'aa'}, () ->
#      console.log 'aa'
    $.ajax({
      type:'PUT',
      url:'/command999',
      data:JSON.stringify({boxes:[333,3]}),
      contentType: "application/json; charset=utf-8",
      dataType: "json",
      success:(json) ->
        console.log 'success'
      ,error:() ->
        console.log 'error'
    })
  @test = () ->
#    console.log 'xxxx'
#    #    $.post '/command999', {'aa':'aa'}, () ->
#    #      console.log 'aa'
#    a = { os: 'Android 4.2',
#    client_info: '',
#    boot: '2011/01/02 09:51:28',
#    pixel: '1920x1032',
#    snapshot: null,
#    name: 'changzhou_pad',
#    disk: '0% 5.73GB',
#    service: 'http://dev.shgbit.com:3001',
#    cpu: '0% 0.0MHz, ARMv7 Processor rev 0 (v7l) ',
#    network: { mask: '0.0.0.0', mac: '', gw: '0.0.0.0', ip: '0.0.0.0' },
#    memory: '18% 1.82GB'}
##    mversion:
##    { url: null,
##      code: 3,
##      force: false,
##      name: 'WAMonitor 1.0 20140725' },
##    version: { url: null, code: 1, force: false, name: '1.0' } }
#    $.ajax({
#      type:'post',
#      url:'/box/test',
#      data:JSON.stringify({dates:a}),
#      contentType: "application/json; charset=utf-8",
#      dataType: "json",
#      success:(json) ->
#        console.log 'success'
#    ,error:() ->
#        console.log 'error'
#    })



#    $.ajax({
#      type:'post',
#      url:'/bookings/540047b13801e4f33339cab4',
#      data:JSON.stringify({dates:['2014-8-29','2014-8-29']}),
#      contentType: "application/json; charset=utf-8",
#      dataType: "json",
#      success:(json) ->
#        console.log 'success'
#    ,error:() ->
#        console.log 'error'
#    })
    $.ajax({
      type:'post',
      url:'/booking/test',
      data:JSON.stringify({dates:{name:'tttt',startTime}}),
      contentType: "application/json; charset=utf-8",
      dataType: "json",
      success:(json) ->
      console.log 'success'
      ,error:() ->
        console.log 'error'
    })
