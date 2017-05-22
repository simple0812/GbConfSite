head ->
  title -> @title
  link rel:"stylesheet", href:"/css/bootstrap-switch.css"
  link rel:"stylesheet", href:"/css/jquery.fileupload.css"
  link rel:"stylesheet", href:"/css/jquery.fileupload-ui.css"

div class: "modal fade", id:"equipmentsModal", role:"dialog", 'aria-labelledby':"myModalLabel", 'aria-hidden':"true", ->
  div class: "modal-dialog", ->
    div class: "modal-content", ->
      div class: "modal-header", ->
        button class: "close", 'data-dismiss':"modal", 'aria-hidden':"true", -> '&times;'
        h4 class: "center-block", -> '会议室设备'
      div class: "modal-body", ->
      div class: "modal-footer", ->
        button class: "btn btn-primary", 'data-dismiss':"modal", id:"addEquipmentsConfirmBtn", -> '确定'
        button class: "btn btn-default", 'data-dismiss':"modal", id:"addEquipmentsCancelBtn", -> '取消'

div class:" well well-sm fix-top-2", ->
  div class :"container fixed-width",id:"roomIndexView", ->
    button type: 'button', class: 'btn btn-default save', ->
      span class:"glyphicon glyphicon-floppy-disk", ->
      text ' 提交'
    button type:"button", class:"btn btn-default gap back", ->
      span class:"glyphicon glyphicon-backward", ->
      text ' 返回'

div class:'container fix-top-2-tablelist-default fixed-width', id: "roomID", value:@id, ->
  h3 class: 'pageInfo', ->
    img src: '/img/header.png',class: 'circlePic', ->
    text '&nbsp会议室管理'
  div class:'panel panel-default', ->
    div class: "panel-body", ->
      div class: "col-xs-4 text-center", ->
        div class: "room-image-box", ->
          div class:"btn fileinput-button", ->
            img class:"curpointer", id:"showimage", src:"", ->
            input type:"file", id:"changeimage", accept: "image/*", ->
        span class:"label label-default", id:"imageinfo", filename:"", -> "点击图片可替换"
        br ->
        br ->
        button class:"btn btn-success", id:"replace", -> "确认替换"
      div class: "col-xs-8", ->
        div class:"form-group", ->
          label for:"name", -> "会议室名称"
          input type:"text",class:"form-control validator", validator:"specialChar", description:"会议室名称", required:"" ,id:"name",placeholder:"输入会议室名称"
        div class:"form-group", ->
          label for:"capacity", -> "可容纳人数"
          input type:"text",class:"form-control validator", validator:"roomCapacity", description:"容纳人数", required:"" ,id:"capacity",placeholder:"输入人数"
        div class :"form-group", ->
          label for:"equipments", -> "会议室设备"
          div class:"input-group", ->
            div class :"form-control",id:'equipments', style:"max-width:680px;", ->
            span class:"btn btn-success input-group-addon", id:"addEquipments", ->
              span class:"glyphicon glyphicon-plus-sign", ->
              text ' 增删设备'
        div class:"checkbox", ->
          label for:"isOpen", -> "会议室是否开放"
          #div class:"bootstrap-switch", ->
          input type:"checkbox",id:"isOpen", ->
        div class:"checkbox", ->
          label for:"isAudit", -> "会议室是否需要审核"
          input type:"checkbox",id:"isAudit", ->
        div class:"checkbox", ->
          label for:"isBoxBooking", -> "是否允许终端预约"
          input type:"checkbox",id:"isBoxBooking", ->
        div class:"form-group", ->
          label for:"remarks", -> "备注"
          textarea class:"form-control validator", validator:"remarks", description:"备注", id:"remarks", rows:"3", style:"max-width:782px;", ->

script id:"equipmentTemplate", type:"text/template", style:"display: none", ->
  div class:"checkbox cutstring", style:"max-width:400px;", ->
    label for:"equipment-{{_id}}", -> "{{name}}"
    input type:"checkbox", id:"equipment-{{_id}}", ->
script type:"text/javascript", src:"/js/equipment/model/equipment.js"
script type:"text/javascript", src:"/js/room/model/room.js"
script type:"text/javascript", src:"/js/room/view/edit.js"
script type:"text/javascript", src:"/js/room/view/equipment.js"

script type:"text/javascript", src:"/lib/bootstrap-switch.js"

script type:"text/javascript", src:"/lib/vendor/jquery.ui.widget.js"
script type:"text/javascript", src:"/lib/load-image.js"
script type:"text/javascript", src:"/lib/jquery.fileupload.js"
script type:"text/javascript", src:"/js/room/view/imgURL.js"
script type:"text/javascript", src:"/js/validator.js"
coffeescript ->
  roomID = $("#roomID").attr("value")
  if roomID
    x = new Room {_id: roomID}
    x.fetch().done ->
      new RoomView {model: x}
  else
    new RoomView {model: new Room()}
  equipments = new Equipments()
  new EquipmentsView {collection: equipments}
  $('#addEquipments').click ->
    equipments.reset()
    equipments.fetch().done ->
      p = []
      $("#equipments > button").each (index, element) -> p.push $(element).attr("eid")
      $("#equipment-" + each).click() for each in p
      $('#equipmentsModal').modal "show"
