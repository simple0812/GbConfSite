link href:"/css/fileupload.css", rel:"stylesheet"
script src:'/js/equipment/equipment.js'

coffeescript ->
  @upFinish = (json)->
    $('#icon').attr('src','/upload/'+json.result)
  $ ->
    validator.bind();
#    fileUpload();
#  @isSave = true;
div class:"modal fade", id:"equipModal", 'tabindex':"-1", 'role':"dialog", 'aria-labelledby':"userLabel", 'aria-hidden':"true", ->
  div class:"modal-dialog", ->
    div class:"modal-content", ->
      div class:"modal-header", ->
        button type:"button",class:"close",'aria-hidden':"true", onclick:'closeModel()',->
          text '&times;'
        h4 class:"modal-title", id:"userLabel", ->
          text '添加设备'
      div class:"modal-body userModalBody", ->
        div class:"input-group", ->
          span class:"input-group-addon", ->'设备名称:'
          input type:"text", class:"form-control validator",'required':'',validator:'specialChar', placeholder:"请输入设备名称",id: 'txtEquipName', ->
        div class:"input-group ", ->
          span class:"input-group-addon ", ->'设备型号:'
          input type:"text", class:"form-control validator",validator:'specialChar', placeholder:"请输入设备型号",id: 'txtEquipModel', ->
#        div class:"input-group ", ->
#          span class:"input-group-addon", ->'设备图标:'
        form class:'', id: 'uploadForm ',style:"text-align:center", method:'post', enctype:"multipart/form-data", action:'/upload/icon',target:'summaryFrame',->
          iframe name:"summaryFrame", width:"0", height:"0", style:"display:none"
          span class: 'btn btn-default fileinput-button', ->
            i class: 'glyphicon glyphicon-upload'
            span -> ' 上传图标'
            input id: 'uploadInput', type: 'file', name: 'file', onchange:"/\.jpg|.JPG|.jpeg|.JPG|.jpg|.GIF|.gif|.png|.PNG|.ico|.ICO|.bmp|.BMP$/.test(value)?this.form.submit():alert('只能上传.jpg|.JPG|.jpeg|.JPG|.jpg|.GIF|.gif|.png|.PNG|.ico|.ICO|.bmp|.BMP的图片文件')", style: 'width: 100px; height: 30px'
        div style:"text-align:center", ->
          img id:"icon",src:'',style:"width:100px;height:100px;margin:10px;border:0;", ->
#          div class:"msg-edit-area", id:"input_container", itemindex:"1" ,style:"margin-top: 33px;", ->
#          form id:"uploadForm", method:'post', enctype:"multipart/form-data", action:'/upload', target:'summaryFrame', ->
#              iframe name:"summaryFrame", width:"0", height:"0", style:"display:none"
#              a class:"icon28 upload-btn", href:"javascript:void(0);" ,style:"z-index:2;", value:'上传'
#              input type:"file", name:"file",onchange:"this.form.submit()"
#              input type:"hidden", name:"index", value:"", id:"itemindex"
#              input type:"hidden" ,name:"type", value:"upnewpic"
                      input type:"text", class:"form-control", placeholder:"请输入组织名称",id: 'txtTel', ->
        br ->
        div class:"col-xs-offset-9 diabtnfix ", ->
          button type:"button",  class:"btn btn-primary ",id:"btnSaveEquip", onclick:'saveEquip()', ->
            text '确定'
          button type:"button", class:"btn btn-default gap",onclick:'closeModel()' ,->
            text '关闭'
#div class: 'container fixed-width', ->'data-dismiss':"modal"
#  ol class:"breadcrumb", id: 'mediaNav',currentId:'', ->
div class:"well well-sm fix-top-2", ->
  div class:"container fixed-width",id:"operateScheduleArea", ->
    button id:"btnShowCreateModal", class:"btn btn-default", type:"button",  onclick:'showAddModal(this)',->
      span class:"glyphicon glyphicon-new-window"
      '添加'
    button id:"deleteBtn", class:"btn btn-default gap", type:"button", onclick:'delEquips(this)',->
      span class:"glyphicon glyphicon-trash"
      '删除'
#    div class:"col-xs-3 input-group pull-right searchPanel", ->
#      input id:"searchInput", class:"form-control", type:"text",onkeyup:'Search()' ,placeholder:"请输入设备名称或型号"
#      span class:"input-group-btn", ->
#        button id:"searchBtn", class:"btn btn-default", onclick:'Search()',->'搜索'

div class:'container fix-top-2-tablelist-default fixed-width',->
  h3 class: 'pageInfo', ->
    img src: '/img/header.png',class: 'circlePic', ->
    text ' 设备管理'
  div class:"panel panel-default", ->
    table class:"table table-striped", style:"table-layout: fixed;word-wrap: break-word", ->
      thead class:"thead-color", ->
        tr class:"row", role:"label", for:"allMeeting", ->
          th class:"text-center", style:'width:40px', ->
            input id:"chkAllItems", type:"checkbox",onclick:'selectAllChk(this)'
          th class:"col-xs-4 curpointer",onclick:'sortByName(this)', ->
            text '名称'
            b class:"caret"
          th class:"col-xs-4  curpointer",onclick:'sortByModel(this)',->
            text '型号'
            b class:"caret"
          th class:"col-xs-3  curpointer",style:"cursor:pointer",onclick:'sortByTime(this)', ->
            text '添加时间'
            b class:"caret"
          th class:"col-xs-1", ->'操作'
      tbody id:"equipList", ->
script type:'text/template', id:'tmplEquipment', ->
  tr class:"row",id:'equip{0}',->
    td class:"text-center", ->
      input type:"checkbox",value:"{0}", class: 'chkItem', onclick:'selectItemChk(this)'
    td class:"cutstring", ->
      b class:"cutstring", ->
          img id:'icon{0}' ,src:'{4}',style:"width:40px;height:40px;border:0;",
        span class:"cutstring",id:'name{0}',-> '{1}'
    td class:" cutstring",id:'model{0}',->'{2}'
    td class:" cutstring", ->'{3}'
    td class:"", ->
      div '.btn-group.btn-group-xs', ->
          button '.btn.btn-default',id:'{0}',name:'{1}',icon:'{4}',model:'{2}',onclick:'showUpdateModal(this)', ->'编辑'
          button '.btn.btn-default', equipid:'{0}',onclick:'delEquip(this)', ->'删除'
