function login(obj) {
    var userName = $('#txtUserName').val().trim();
    var password = $('#txtPassword').val().trim();

    if(! validator.validateAll()) return ;

    $.getJSON('/login', {userName:userName, password: hex_md5(password)}, function(json) {
        if(!json || json.status == 'fail') return popBy(obj, false, json.result);
        popBy(obj, false, '登录成功');
    })
}