div class:'col-xs-4 col-sm-2 siderbar-offcanvas', style:'margin-top:53px', role:'navigation',->
  div class:'list-group affix',style:'min-width:150px;text-align:center;',->
    a class:'list-group-item active', href:'#','data-url':'/c/pageRoom',->
      i class:'glyphicon glyphicon-tasks'
      '  会议室管理'
    a class:'list-group-item', href:'#','data-url':'/c/pageUser',->
      i class:'glyphicon glyphicon-user'
      '    用户管理'
    a class:'list-group-item', href:'#','data-url':'/c/pageDevice',->
      i class:'glyphicon glyphicon-hdd'
      '    设备管理'
    a class:'list-group-item', href:'#','data-url':'/c/pageSetting',->
      i class:'glyphicon glyphicon-cog'
      '    系统设置'