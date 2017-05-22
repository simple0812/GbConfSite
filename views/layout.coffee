doctype 5
html ->
  head ->
    meta name:"viewport", content="width=device-width, initial-scale=1.0", charset:'utf-8'
    link href:"/css/bootstrap.css", rel:"stylesheet"
    link href:"/css/common.css", rel:"stylesheet"
    ie 'gte IE8', ->
      link href:"/css/IE.css", rel:"stylesheet"
#    < !--[if IE]>
#      Only IE
#    <![endif]-->
#      link href:"/css/common.css", rel:"stylesheet"
#    <![endif]-->
    #link href:"/css/style.css", rel:"stylesheet"
    script src:"/lib/jquery-1.10.2.js"
    script src:"/lib/hashchange.js"
    script src: '/lib/respond.js'
    script src:"/lib/bootstrap.js"
    script src: '/lib/moment.js'
    script src: '/lib/common.js'
    script src: '/lib/underscore.js'
    script src: '/lib/backbone.js'
    script src: '/js/validator.js'
    script src:"/lib/jquery.cookies.js"
  body style:'min-width:1280px;', ->
    div class:"modal fade", id:"modelInformation", 'tabindex':"-1", 'role':"dialog", 'aria-labelledby':"modifyInformationModalLabel", 'aria-hidden':"true", ->
      div class:"modal-dialog", ->
        div class:"modal-content", ->
          div class:"modal-header", ->
            button type:"button",class:"close",'data-dismiss':"modal",'aria-hidden':"true", ->
              text '&times;'
            h2 class:"modal-title", id:"modifyInformationModalLabel", ->
              text '版本说明'
            h4 ->'english information introduction'
            p ->
              b ->'中文说明说明，感谢您对balabala的关注。请阅读下列说明。'
          div class:"modal-body", ->
            h4 ->
             b ->"企业信息"
            p ->"balabalbalabala..."
            p -> "电话：021-12345678"
            p -> "电子邮件：123@shgbit.com"
            p -> "网站：www.abc.com"
            hr ->
            h4 ->
              b ->"版权"
            p ->"
             © XX 公司 版权所有。 保留所有权利。文字、数字、图形、声音、动画和录像以及XX网站的设置均受版权和其他保护法保护。"
            p ->"本网站的内容不得以商业目的复制、分发、修改或透露给第三方。"
            hr ->
            h4 ->
              b ->"许可"
            p ->"XX网站上的知识产权（如专利、商标和版权）均受保护。 本网站不授予使用 XX知识产权的许可。"
            hr ->
            h4 ->
              b ->"问题"
            p ->"您对我们的产品有任何疑问吗？"
            p ->"我们乐于帮助: 12345@shgbit.com 或 021-66666666"
            p ->"有关网站问题请联系: abab@shgbit.com"



    div class:"modal fade", id:"modifyPersonalModal", 'tabindex':"-1", 'role':"dialog", 'aria-labelledby':"modifyPersonalModalLabel", 'aria-hidden':"true", ->
      div class:"modal-dialog", ->
        div class:"modal-content", ->
          div class:"modal-header", ->
            button type:"button",class:"close",'data-dismiss':"modal",'aria-hidden':"true", ->
              text '&times;'
            h4 class:"modal-title", id:"modifyPersonalModalLabel", ->
              text '修改个人信息'
          div class:"modal-body col-sm-offset-1", ->
            form class:"form-horizontal", id: 'newname', style: 'margin-top: 10px', ->
              div class:"form-group", ->
                label for:"nameTxt", class:"col-sm-3 control-label", ->'姓名'
                div class:"col-sm-6", ->
                  input type:"text", class:"form-control validator", 'required':'', validator:'specialChar', description:'姓名', id:"nameTxt", placeholder:"请输入姓名", ->
              div class:"form-group", ->
                div class:"col-sm-6 col-sm-offset-3", ->
                  button type:"button", id:'modifyNameBtn', class:"btn btn-primary col-sm-offset-8 formConFix", onclick:"modifyName()", ->
                    text '保存修改'
            form class:"form-horizontal", id: 'password', style: 'margin-top: 10px', ->
              #       h5 class:"modal-title", style:"margin-bottom:10px;", -> '修改密码:'
              div class:"form-group", ->
                label for:"originalPasswordTxt", class:"col-sm-3 control-label", ->'原密码'
                div class:"col-sm-6", ->
                  input type:"password", class:"form-control validator", 'required':'', validator:'password',  description:'原密码',id:"originalPasswordTxt", placeholder:"请输入原密码", ->
              div class:"form-group", ->
                label for:"newPasswordTxt", class:"col-sm-3 control-label", ->'新密码'
                div class:"col-sm-6", ->
                  input type:"password", class:"form-control validator", 'required':'', validator:'password', description:'新密码', id:"newPasswordTxt", placeholder:"请输入新密码", ->
              div class:"form-group", ->
                label for:"comfirmPasswordTxt", class:"col-sm-3 control-label", ->'确认新密码'
                div class:"col-sm-6", ->
                  input type:"password", class:"form-control validator", 'required':'', validator:'password', description:'确认新密码', id:"comfirmPasswordTxt", placeholder:"请再次输入新密码", ->
              div class:"form-group", ->
                div class:"col-sm-6 col-sm-offset-3", ->
                  button type:"button", id:'modifyPasswordBtn', class:"btn btn-primary col-sm-offset-8 formConFix", onclick:"modifyPassword()", ->
                    text '保存修改'
            form class:"form-horizontal", id: 'contact', style: 'margin-top: 10px', ->
              div class:"form-group", ->
                label for:"emailTxt", class:"col-sm-3 control-label", ->'邮箱'
                div class:"col-sm-6", ->
                  input type:"text", class:"form-control validator",  validator:'email', description:'邮箱', id:"emailTxt", placeholder:"请输入邮箱地址", ->
              div class:"form-group", ->
                label for:"mobilePhoneTxt", class:"col-sm-3 control-label", ->'手机'
                div class:"col-sm-6", ->
                  input type:"text", class:"form-control validator",  validator:'phone', description:'手机', id:"mobilePhoneTxt", placeholder:"请输入手机", ->
              div class:"form-group", ->
                label for:"telePhoneTxt", class:"col-sm-3 control-label", ->'电话'
                div class:"col-sm-6", ->
                  input type:"text", class:"form-control validator",  validator:'tel', description:'电话', id:"telePhoneTxt", placeholder:"请输入电话", ->
              div class:"form-group", ->
                div class:"col-sm-6 col-sm-offset-3", ->
                  button type:"button", id:'modifyContactBtn', class:"btn btn-primary col-sm-offset-8 formConFix", onclick:"modifyContact()", ->
                    text '保存修改'
#            form class:"form-horizontal", id: 'newMobilePhone', style: 'margin-top: 10px', ->
#              div class:"form-group", ->
#                div class:"col-sm-6 col-sm-offset-3", ->
#                  button type:"button", id:'modifyMobilePhoneBtn', class:"btn btn-primary col-sm-offset-8 formConFix", onclick:"modifyMobilePhone()", ->
#                    text '保存修改'
#            form class:"form-horizontal", id: 'newTelePhone', style: 'margin-top: 10px', ->
#              div class:"form-group", ->
#                div class:"col-sm-6 col-sm-offset-3", ->
#                  button type:"button", id:'modifyTelePhoneBtn', class:"btn btn-primary col-sm-offset-8 formConFix", onclick:"modifyTelePhone()", ->
#                    text '保存修改'
          div class:"modal-footer",->
            button type:"button", class:"btn btn-default", 'data-dismiss':"modal",->
              text '关闭'

    div class:"navbar navbar-inverse navbar-fixed-top ", role:"navigation", ->
      div class:"container ", ->
        div class:"navbar-header", ->
          button type:"button", class:"navbar-toggle", 'data-toggle':"collapse", 'data-target':".navbar-collapse", ->
            span class:"sr-only", -> 'Toggle navigation'
            span class:"icon-bar"
            span class:"icon-bar"
            span class:"icon-bar"
          a class:"navbar-brand", href:"#", ->'会议预约管理系统'
        div class:"collapse navbar-collapse",style:"min-width:794px;", ->
          ul class:"nav navbar-nav", id:'headNav', ->
#            li class:"", -> a href:"/index", -> '首页'
            li class:"", -> a href:"/booking", -> '预约'
            li class:"", -> a href:"/MB/index", -> '我的预约'
            li class:"", -> a href:"/invite", ->
              text '与会通知&nbsp'
              span class:"badge", ->'0'
            li class:"auditor", -> a href:"/audit", -> '审批'
            li class:"adminauthor mouseoper administrator", ->
              a class:'managerarea', href:"javascript:void(0)", ->
                text '管理'
                b class:"caret"
              div class:"child-nav", id:'managernav',  ->
                ul ->
                  li ->
                    a class:'', href:'/room/index',id:"meeting", ->
                      i class:'glyphicon glyphicon-tasks'
                      ' 会议室管理'
                  li ->
                    a class:'', href:'/equipment',id:"equipment",->
                      i class:'glyphicon glyphicon-usd'
                      ' 设备管理'
                  li ->
                    a class:'', href:'/BM/index',id:"device",->
                      i class:'glyphicon glyphicon-list'
                      ' 预约管理'
                  li ->
                    a class:'', href:'/device',id:"device",->
                      i class:'glyphicon glyphicon-hdd'
                      ' 预约机管理'
                  li ->
                    a class:'', href:'/user', id:"user",->
                      i class:'glyphicon glyphicon-user'
                      ' 用户管理'
                  li class:'', ->
                    a href:'/setting',id:"setting",->
                      i class:'glyphicon glyphicon-cog'
                      ' 系统设置'
            li class:"mouseoper", ->
              a class:'helparea', href:"javascript:void(0)", ->
                text ' 帮助'
                b class:"caret"
              div class:"child-nav", id:'helpernav',   ->
                ul ->
                  li ->
                    a href:'javascript:void(0)',class:'',onclick:"modalInputFocus('#modelInformation')",id:"", ->
                      i class:'glyphicon glyphicon-file'
                      ' 信息'
                  li ->
                    a class:'', href:'',id:"",->
                      i class:'glyphicon glyphicon-hand-right'
                      ' 操作手册'
          coffeescript ->
            #$('.child-nav').width(screen.width)
            actived = location.pathname
            type = $.cookie('type')

            #当前用户不是管理员
#            $('.adminauthor').hide() if type? isnt 'admin'
            p = $('a[href="'+actived+'"]')
            if p.parents('.child-nav').length > 0
              p.parents('.child-nav').parent('li').addClass('active').siblings('li').removeClass('active')
            else
              p.parent().addClass('active').siblings('li').removeClass('active')

            role = $.cookie("usertype") or ''
            switch role
              when "admin" then null
              when "auditor" then $(".administrator").remove()
              else
                $(".auditor").remove()
                $(".administrator").remove()



          ul class:"nav navbar-nav navbar-right", ->
            li class:"dropdown", ->
              a href:'javascript:void(0)', class:"dropdown-toggle", 'data-toggle':"dropdown", ->
                b id: "usertype", style:"display:none", -> ''
                b id: "username", -> ''
                coffeescript ->
                  $('#username').html($.cookie('nickname') or '')
                  $('#usertype').html($.cookie('usertype') or '')
                b class:"caret"
              ul class:"dropdown-menu", ->
                li ->
                  a href:'javascript:void(0)', onclick:"modalInputFocus('#modifyPersonalModal', '#newMailTxt')", -> '修改个人信息'
                li class:'divider', ->
                li ->
                  a href:'/logout', -> '退出'

        coffeescript ->
          $('.mouseoper').click (e) ->
            return $(this).find('.child-nav').slideUp 50 if $(this).find('.child-nav:visible').length
            $('.child-nav').hide()
            $(this).find('.child-nav').slideDown  50

          $(window).click (e) ->
            e = e || window.event
            target = e.target || e.srcElement;

            if(!($(target).hasClass('managerarea') || $(target).hasClass('helparea')))
              $('.child-nav').hide()

          $ ->
            validator.bind('#modifyPersonalModal');
            $.get "/notices/#{$.cookie('userid')}/count",{}, (json) ->
              if(json && json.status == 'success')
                $('.badge').html(json.result).show()



    @body


