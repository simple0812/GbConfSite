head ->
  title -> @title
div '.container.fix-top-2-tablelist-default.fixed-width', ->
  h3 '.pageInfo', ->
    img '.circlePic',src:'/img/header.png',alt:'header'
    ' 预约管理'
  div '.panel.panel-default', ->
    table '.table.table-striped', id:'bookingTable', style:'table-layout:fixed;word-wrap:break-word;',->
      thead '.thead-color', ->
        tr ->
          th '.col-xs-3.curpointer.sortBy', -> '时段'
          th '.col-xs-2', -> '会议室'
          th '.col-xs-2', -> '会议主题'
          th '.col-xs-2', -> '主持人'
          th '.col-xs-2', -> '操作'
          th '.col-xs-1', -> '状态'
      tbody ->
        tr ->
          td ->'2013年10月20日 14：00-16：00'
          td -> '301'
          td -> '关于XXXXX的会议'
          td -> '刘长春'
          td ->
            div '.btn-toolbar',role:'toolbar', ->
              div '.btn-group.btn-group-xs', ->
                button '.btn.btn-success',type:'button',->
                  i '.glyphicon.glyphicon-edit', ->
                  '编辑'
                button '.btn.btn-danger',type:'button',->
                  i '.glyphicon.glyphicon-remove', ->
                  '取消'
          td ->
            span '.label.meeting-status-start','未开始'
        tr ->
          td ->'2013年10月20日 14：00-16：00'
          td -> '301'
          td -> '关于XXXXX的会议'
          td -> '刘长春'
          td ->
            div '.btn-toolbar',role:'toolbar', ->
              div '.btn-group.btn-group-xs', ->
                button '.btn.btn-success',type:'button',->
                  i '.glyphicon.glyphicon-edit', ->
                  '编辑'
                button '.btn.btn-danger',type:'button',->
                  i '.glyphicon.glyphicon-remove', ->
                  '取消'
          td ->
            span '.label.meeting-status-ing','进行时'
        tr ->
          td ->'2013年10月20日 14：00-16：00'
          td -> '301'
          td -> '关于XXXXX的会议'
          td -> '刘长春'
          td ->
            div '.btn-toolbar',role:'toolbar', ->
              div '.btn-group.btn-group-xs', ->
                button '.btn.btn-success',type:'button',->
                  i '.glyphicon.glyphicon-edit', ->
                  '编辑'
                button '.btn.btn-danger',type:'button',->
                  i '.glyphicon.glyphicon-remove', ->
                  '取消'
          td ->
            span '.label.meeting-status-end','已结束'