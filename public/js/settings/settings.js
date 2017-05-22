/**
 * Created by shgbit on 2014/7/7.
 */
$(function() {
    showEmail();
    showCode();
});
function showEmail(){
    $.getJSON("/getEmail",function (json) {
        if(!json || json.status == 'fail') return ;
        $("#emailAddress").val(json.result.host);
        $("#emailPort").val(json.result.port);
        $("#emailUsername").val(json.result.username);
        $("#emailPassword").val(json.result.password);
    });
}
function showCode() {
    $.getJSON("/getCode",function (json) {
        if(!json || json.status == 'fail') return alert(json.result);
        $("#ANDVersion").html(json.result.android);
        $("#D4AVersion").html(json.result.deamon4android);
    });
}
function saveEmailSetting(){
    if(!validator.validateAll($('#emailSetting'))) return;
    var setting={};
    var email={};
    email.host=$('#emailAddress').val();
    email.port = $('#emailPort').val();
    email.username = $('#emailUsername').val();
    email.password = $('#emailPassword').val();
    setting.email=email;
    $.post('/settings', setting, function(json) {
        if(!json || json.status == 'fail') return popBy($('#saveEmailSetting'), false, json.result);
        alert('设置成功');
        window.location.reload();
//        $("#equipList").prepend($("#tmplEquipment").html().format(
//            json.result._id,
//            json.result.name,
//            json.result.model,
//            json.result.createTime,
//            json.result.icon
//        ));
//        $('#equipModal').modal('hide');

    })

}

function saveAdminPassword(){
    if(!validator.validateAll($('#passwordForm'))) return;
    password ={};
    password.oldpassword= hex_md5($('#oldpassword').val());
    password.newpassword= hex_md5($('#newPassword').val());
    $.ajax({
        type: "PUT",
        url: "/UpdateAdminPassword",
        data: JSON.stringify(password),
        contentType: "application/json; charset=utf-8",
        success: function(json){
            if(!json || json.status == 'fail') return popBy($('#savePassword'), false, json.result);
            alert('修改成功');
            window.location.reload();
        }
    });
}
function fileUpload () {
    'use strict';

    var getOptions = function(type) {
        var progress = '';
        var bar = '';
        var percent = '';
        var showVersion = ''
        switch(type) {
            case 'android':
                progress = $('#ANDProgress');
                bar = $('#ANDProgress .progress-bar');
                percent = $('#ANDProgresspercent');
                showVersion = $('#ANDVersion');
                break;
            case 'deamon4android':
                progress = $('#D4AProgress');
                bar = $('#D4AProgress .progress-bar');
                percent = $('#D4AProgresspercent');
                showVersion = $('#D4AVersion');
                break;
            default:
                return null;
        };
        var options = {
            url: '/upload/package?type=' + type,
            dataType: 'json',
//            formData: {update: type},
            add: function (e, data) {
                data.submit();
            },
            done: function (e, data) {
                if(!data.result) return alert('未知的错误');
                if(data.result.status == 'fail') {
                    var p = bar.width();
                    var x = progress.width();
                    progress.hide();
                    bar.css('width', 0 + '%');
                    return alert(data.result.result);
                }

                setTimeout(function() {
                    showVersion.html(data.result.result);
                    var p = bar.width();
                    var x = progress.width();
                    if(p === x) {
                        progress.hide();
                        bar.css('width', 0 + '%');
                    }
                }, 1000);
            },
            progressall: function (e, data) {
                var t = parseInt(data.loaded / data.total * 100, 10);
                progress.show();
                bar.css('width',t + '%');
                percent.html(t + '%');
            }
        };
        return options;
    };

    $('#ANDUploadInput').fileupload(getOptions('android')).prop('disabled', !$.support.fileInput).parent().addClass($.support.fileInput ? undefined : 'disabled');


    $('#D4AUploadInput').fileupload(getOptions('deamon4android')).prop('disabled', !$.support.fileInput).parent().addClass($.support.fileInput ? undefined : 'disabled');

}

function confirmPassword(obj) {
    var confirm = $(obj).val();
    var password = $('#newPassword').val();
    if(confirm == password) return true;
    popBy(obj, false, '两次输入的密码不匹配');
    return false;
}
