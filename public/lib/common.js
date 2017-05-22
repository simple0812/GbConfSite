if(!window.console) window.console = {
    log:function(){}
}


function popBy(obj, flag, message, direct) {
    $(obj).popover('destroy');
    $(obj).popover({
        placement: direct ||'bottom',
        trigger: 'manual',
        content: message
    });
    if (!flag) {

        clearTimeout($(obj).data('timeout'));
        $(obj).popover('show');
        var timeout = setTimeout(function () { $(obj).popover('hide'); }, 3000);
        $(obj).data('timeout',timeout);
        return false;
    }
    else {
        $(obj).popover('hide');
        return true;
    }
}

function getQueryString(key) {
    var value = "";
    var sURL = window.document.URL;

    if (sURL.indexOf("?") > 0) {
        var arrayParams = sURL.split("?");
        var arrayURLParams = arrayParams[1].split("&");

        for (var i = 0; i < arrayURLParams.length; i++) {
            var sParam = arrayURLParams[i].split("=");

            if ((sParam[0] == key) && (sParam[1] != "")) {
                value = sParam[1];
                break;
            }
        }
    }

    return value;
}

function selectAllChk() {
    $('.chkItem').prop('checked', $('#chkAllItems').prop('checked'));
}

function selectItemChk() {
    $('#chkAllItems').prop('checked', $(".chkItem:checked").length === $(".chkItem").length);
}

function $get() { return document.getElementById(arguments[0]); }

function pagerDelegate(obj, method, mode) {
    var delegate = function () {
        var args = [];
        args.push(mode);
        method.apply(obj, args);
    }

    return delegate;
}

String.format = function () {
    if (arguments.length == 0)
        return null;

    var str = arguments[0];
    for (var i = 1; i < arguments.length; i++) {
        var re = new RegExp('\\{' + (i - 1) + '\\}', 'gm');
        str = str.replace(re, arguments[i]);
    }

    return str;
}

String.prototype.format = function () {
    var args = arguments;
    return this.replace(/\{(\d+)\}/g, function (m, i) {
        return args[i];
    });
}

function readonly() {
    this.blur();
    return false;
}

function clearPop() {
    $('.book-room-day .popover').remove();
    $.each($('#bookRooms .occupied'),function(i,o) {
        if($(o).next().hasClass('popover')) {
            $(o).next().remove();
        }
    })
}

function  pop(obj, content, position) {
    $(obj).popover("destroy");
    $(obj).popover({
        placement: position || "bottom",
        content: content,
        trigger: "click"
    });
    $(obj).popover("show");
    setTimeout(function() {$(obj).popover("hide");}, 3000);
}

function modalInputFocus($modalid,$txtid) {
    var id = $.cookie('userid');
    $.get('/user/'+id).done(function(result) {
        $('#nameTxt').val(result.name);
        $('#emailTxt').val(result.email);
        $('#mobilePhoneTxt').val(result.mobilePhone);
        $('#telePhoneTxt').val(result.telephone);
        $($modalid).modal('show');
        $($modalid).on('shown.bs.modal', function (e) {
            $($txtid).focus();
        })
    }).error(function(){alert('未知错误请联系管理员！')});
}

function modifyName() {
    var name = $("#nameTxt").val().trim();
    if(!validator.validateAll("#newname")) return;

    var data = {};
    data.id = $.cookie('userid');
    data.name = name;
    $.ajax({
        type: "PUT",
        url: "/user/name",
        data: data,
//        contentType: "application/json; charset=utf-8",
//        dataType: "json",
        success: function (json) {
            if(!json)  return alert('未知的错误');
            if(json.status === 'failed') {
                popBy('#newname',false,json.result);//result为错误信息
            } else {
                popBy('#newname',false,'修改成功');
                setTimeout(function() {
                    $("#modifyPersonalModal").modal('hide')
                },500);
            }
        },
        error: function (err) {
            alert(err.responseText);
        }
    });
}

function modifyPassword() {
    if(!validator.validateAll('#password')) return;

    var originalPassword = $("#originalPasswordTxt").val().trim();
    var newPassword = $("#newPasswordTxt").val().trim();
    var confirm = $('#comfirmPasswordTxt').val().trim();

    if(confirm != newPassword) return popBy('#modifyPasswordBtn', false, '新密码两次输入不一致');
    var data = {};
    data.id = $.cookie('userid');
    data.oldpassword = hex_md5(originalPassword);
    data.newpassword = hex_md5(newPassword);
    $.ajax({
        type: "PUT",
        url: "/user/password",
        data: data,
//        contentType: "application/json; charset=utf-8",
//        dataType: "json",
        success: function (json) {
            if(!json)  return alert('未知的错误');
            if(json.status === 'failed') {
                popBy('#modifyPasswordBtn',false,json.result);//result为错误信息
            } else {
                popBy('#modifyPasswordBtn',false,'修改成功');
                setTimeout(function() {
                    $("#modifyPersonalModal").modal('hide');
                    $("#originalPasswordTxt").val('');
                    $("#newPasswordTxt").val('');
                    $("#comfirmPasswordTxt").val('');
                },500);

            }
        },
        error: function (err) {
            alert(err.responseText)
        }
    });
}

function modifyContact() {
    var email = $("#emailTxt").val().trim();
    var mobilePhone = $("#mobilePhoneTxt").val().trim();
    var telephone = $("#telePhoneTxt").val().trim();

    if(!validator.validateAll('#contact')) return;
    var data = {};
    data.id = $.cookie('userid')
    data.email = email;
    data.mobilePhone = mobilePhone;
    data.telephone = telephone;
    $.ajax({
        type: "PUT",
        url: "/user",
        data: data,
//        contentType: "application/json; charset=utf-8",
//        dataType: "json",
        success: function (json) {
            if(!json)  return alert('未知的错误');
            if(json.status === 'failed') {
                popBy('#contact',false,json.result);//result为错误信息
            } else {
                popBy('#contact',false,'修改成功');
                setTimeout(function() {
                    $("#modifyPersonalModal").modal('hide');
                },500);
            }
        },
        error: function (err) {
            alert(err.responseText);
        }
    });
}
function timePick(stId,edId,isStart){
    $(edId).datetimepicker('remove');
    var now = new Date();
    var month = parseInt(now.getMonth())+1;
    var dateFomat = now.getFullYear()+'/'+month+'/'+now.getDate()+' ';
    var dateFomatEd = dateFomat+'23:59:59';
    var tmpdateSt = new Date(dateFomat);
    var tmpdateEd = new Date(dateFomatEd);
    var tmpdateInit = new Date(dateFomat);
    var timeFormat = isStart ? "hh:ii:00" : "hh:ii:59";
    if($(edId).val() !== '') {
        if(!isStart) {
            tmpdateSt = new Date(dateFomat+$(edId).val());
            tmpdateInit = new Date(dateFomat+$(edId).val());
        } else {
            tmpdateEd= new Date(dateFomat+$(edId).val());
        }
    }
    $(stId).datetimepicker({
        format: timeFormat,
        minuteStep:1,
        startDate:tmpdateSt,
        endDate:tmpdateEd,
        initialDate:tmpdateInit,
        language:  'zh-CN',
        autoclose: 1,
        startView: 1,
        minView: 0,
        maxView: 1,
        forceParse: 0
    }).on('show',function(ev) {
            if($('#basicSettingModal').length>0) {
                var rootSTop = basicSettingModal.scrollTop;
                console.log(rootSTop)
                var rootTop = parseFloat( $('.datetimepicker:visible').css('top'));
                console.log(rootTop)
                $('.datetimepicker:visible').data('rootSTop', rootSTop);
                $('.datetimepicker:visible').data('rootTop', rootTop);
            }
            console.log('show')
            var height = $('#basicSettingModal .modal-dialog').height()
            height = height+500;
            $('#basicSettingModal .modal-dialog').css('height',height)
        }).on('hide',function(ev) {
            console.log('hide')
            var height = $('#basicSettingModal .modal-dialog').height()
            height = height-500;
            $('#basicSettingModal .modal-dialog').css('height',height)
        });
    $(stId).datetimepicker('show');
}
function clearDateTime(obj) {
    $(obj).val('');
    $(obj).datetimepicker('remove');
}


$('.modal').scroll(function() {
    var sTop = this.scrollTop;
    var rootSTop = $('.datetimepicker:visible').data('rootSTop');
    var rootTop = $('.datetimepicker:visible').data('rootTop');
    if($('.datetimepicker:visible').length == 0) return;

    var top = parseFloat( $('.datetimepicker:visible').css('top'));

    var xx = rootSTop + rootTop - sTop;

    $('.datetimepicker:visible').css('top', xx);

})

