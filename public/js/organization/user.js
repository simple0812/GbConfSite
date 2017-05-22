$(function() {
    pager = new Pager(query_list.pagesize, 0, 1, query_list, showUserList, -1);

    pager.renderNumberStyleHtml($get("pager"));
    showUserList({ mode: 'nums', val: 1 });
})

function showUserList() {
    pager.moveIndicator(arguments[0]);
    $.getJSON("/users", pager.condition, function (json) {
        if(!json || json.status == 'fail') return alert('x');

        $("#userList").empty();
        $("#chkAllItems").prop('checked', false);
        var listd = "";

        $.each(json.result, function (i, o) {
            listd += $("#tmplUser").html().format(
                o._id,
                o.userName,
                o.name,
                o.organization.name,
                o.email,
                o.mobilePhone,
                o.telephone,
                o.role
            );
        });

        $("#userList").html(listd);

        pager.setRecordCount(json.recordCount);
        pager.renderNumberStyleHtml($get("pager"));
    });
}



function showUserModal(obj, saveType) {
    $('#btnSaveUser').data('saveType', saveType);
    $('.userModalBody').find('input').val('');
    $('.userModalBody').find('select').val('normal');
    if(saveType == 'add') {
        if($('.tree_select_item').length == 0 || $('.tree_select_item').siblings('.tree_item_text').data('id') == '')
            return popBy(obj, false, '请选择用户所属的组织');
    } else if(saveType == 'update') {


    }


    $('#userModal').modal('show');
}

function saveUser(obj) {
    if($(obj).data('saveType') == 'add') addUser(obj);
    else if($(obj).data('saveType') == 'update') updateUser(obj);
}

function addUser(obj) {

    if(!validator.validateAll('#userModal')) return;
    if(!confirmPassword('#txtConfirm')) return;
    var user = {};
    user.userName = $('#txtUserName').val();
    user.name = $('#txtName').val();
    user.password = hex_md5($('#txtPassword').val());
    user.mobilePhone = $('#txtPhone').val();
    user.telephone = $('#txtTel').val();
    user.housePhone = $('#txtHousePhone').val();
    user.email = $('#txtEmail').val();
    user.role = $('#selRole').val();
    user.gender = $('.rdMale:checked').length ? 1: 0;
    user.organization = $('.tree_select_item').siblings('.tree_item_text').data('id');
    if(user.organization.length == 0) return popBy(obj, false, '请选择用户所属的组织');

    $.post('/user', user, function(json) {
        if(!json || json.status == 'fail') return popBy(obj, false, json.result);
        $("#userList").prepend($("#tmplUser").html().format(
            json.result._id,
            json.result.userName,
            json.result.name,
            $('.tree_select_item').siblings('.tree_item_text').html(),
            json.result.email,
            json.result.mobilePhone,
            json.result.telephone,
            json.result.role
        ))
        $('#userModal').modal('hide');

    })
}

function confirmPassword(obj) {
    var confirm = $(obj).val();
    var password = $('#txtPassword').val();

    if(confirm == password) return true;

    popBy(obj, false, '两次输入的密码不匹配');
    return false;
}

function updateUser(obj, id) {

}

function searchUser(obj) {
    query_list.keyword = $('#txtKeyword').val();
    showUserList({ mode: 'nums', val: 1 });
}

function deleteUser(obj, id) {
   if(confirm("确认删除用户吗？")) {
       $.ajax({
           type: "DELETE",
           url: "/user",
           data: JSON.stringify({id: id }),
           contentType: "application/json; charset=utf-8",
           success: function(json){
               if(!json || json.status == 'fail') return popBy($(obj).parent(), false, json.result);
               $(obj).closest('tr').remove();
           }

       });
   }
}

function resetPassword(obj, id) {
    if(confirm("确认重置密码吗？")) {
        $.ajax({
            type: "PUT",
            url: "/user",
            data: JSON.stringify({id: id, password: hex_md5('111111') }),
            contentType: "application/json; charset=utf-8",
            success: function(json){
                if(!json || json.status == 'fail') return popBy($(obj).parent(), false, json.result);
                popBy($(obj).parent(), false, '重置成功');
            }

        });
    }
}

function selectAllChk() {
    $('.chkItem').prop('checked', $('#chkAllItems').prop('checked'));
}

function selectItemChk() {
    $('#chkAllItems').prop('checked', $(".chkItem:checked").length === $(".chkItem").length);
}

function deleteUsers(obj) {
    if($('.chkItem:checked').length == 0) return popBy(obj, false, "请选择需要删除的用户");
    var ids = [];
    $('.chkItem:checked').each(function (i, o) {
        ids.push($(o).val())
    });
    if(confirm("确认删除用户吗？")) {
        $.ajax({
            type: "DELETE",
            url: "/users",
            data: JSON.stringify({ids: ids }),
            contentType: "application/json; charset=utf-8",
            success: function(json){
                if(!json || json.status == 'fail') return popBy(obj, false, json.result);
                $('.chkItem:checked').closest('tr').remove();
            }

        });
    }
}