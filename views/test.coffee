stylus '''
  ul li {list-style:none}
'''
div ->
  text '会员列表'
  ul id:'persons', ->
div ->
  text '故事列表'
  ul id:'stories', ->
div id:'addperson', ->
  span -> '姓名：'
  input type:'text', id:'txtName', ->
  button onclick:'addPerson(this)', ->'添加'
div id:'addstory', ->
  span -> '标题：'
  input type:'text', id:'txtTitle', ->
  button onclick:'addStory(this)', -> '添加'
script type:'text/template', id:'tmplPerson'

coffeescript ->
  @addPerson = (obj) ->
    $.getJSON '/addperson', {name:$('#txtName').val() }, (json) ->
      o = json.result
      $('#persons').append("<li><input type='checkbox' class='chkItem' value=#{o._id} /> #{o.name} <a href='#' id='#{o._id}'  onclick='delPerson(this)'>删除</a><li>")

  @addStory = (obj) ->
#    return alert('error') if $('.chkItem:checked').length is 0
    $.getJSON '/addstory', {title:$('#txtTitle').val(), uid:$('.chkItem:checked').eq(0).val()}, (json) ->
      o = json.result
      $('#stories').append("<li>#{o.title} <a href='#' id='#{o._id}' onclick='addFans(this)'>添加fans</a> <a href='#' id='#{o._id}' onclick='delStory(this)'>删除</a><li>")

  @delPerson = (obj) ->
    $.getJSON '/deletePerson',{id:$(obj).attr('id')}, (json) ->
      if json.code is 'succ'
        window.location.reload()
#        $(obj).parent('li').remove()


  @delStory = (obj) ->
    $.getJSON '/deleteStory',{id:$(obj).attr('id')}, (json) ->
      if json.code is 'succ'
        $(obj).parent('li').remove()

  $.getJSON '/persons', (json) ->
    $('#persons').empty()
    $.each json.result, (i, o) ->
      $('#persons').append "<li><input type='checkbox' class='chkItem' value=#{o._id} /> #{o.name} <a href='#' onclick='addPerson()'>添加</a> <a href='#' id='#{o._id}'  onclick='delPerson(this)'>删除</a></li>"
      $.each o.stories , (j, s)->
        $('#persons li').last().append("<p style='text-indent: 30px;'>#{s.title}</p>")
  $.getJSON '/stories', (json) ->
    $('#stories').empty()
    $.each json.result, (i, o) ->

      $('#stories').append "<li>#{o.title} <a href='#'  id='#{o._id}' onclick='addFans(this)'>添加fans</a> <a href='#' id='#{o._id}' onclick='delStory(this)'>删除</a></li>"

      $.each o.fans , (j, s)->
        $('#stories li').last().append("<p style='text-indent: 30px;'><span> #{s.name} </span> <b sid=#{o._id} uid=#{s._id} onclick='delFans(this)'>删除fan</b> </p>")

  @addFans = (obj) ->
    uid = []
    return alert('error') if $('.chkItem:checked').length is 0
    $('.chkItem:checked').each (i, o) ->
      uid.push $(o).val()
    $.getJSON '/addfans', {sid:$(obj).attr('id'), uid:uid}, (json) ->
      window.location.reload()

  @delFans = (obj) ->
    $.getJSON '/delfans', {sid:$(obj).attr('sid'), uid:$(obj).attr('uid')}, (json) ->
      window.location.reload()

