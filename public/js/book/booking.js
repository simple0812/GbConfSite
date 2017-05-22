
function scrollUserList() {
    $.getJSON("/users", query_list, function (json) {
        if(!json || json.status == 'fail' || json.result.length == 0 ) {

            if(query_list.pageindex > 1) query_list.pageindex--;
            if($('.nodata').length == 0) {
                var tr = document.createElement('tr');
                tr.className = 'nodata';

                var td = document.createElement('td');
                td.className ="alert alert-warning";
                $(td).attr('colspan', 4);
                $(td).css('text-align', 'center');

                $(td).append("<span class='alert-link'>没有更多数据</span>");
                $(tr).append(td);

                $("#userList").append(tr);
            }
            $("#chkAllItems").prop('checked', false);

            return;
        }

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


        $('.nodata').remove();
        $("#userList").append(listd);
        users.add(json.result);
        var selectIds = submitUsers.map(function(user){
            return user.get('_id');
        })
        $.each($('#userList .chkItem'),function(i,o) {
            if(_.contains(selectIds,$(o).val())) {
                $(o).prop('checked',true);
            }
        })
        if($('#userList .chkItem').length === $('#userList .chkItem:checked').length && $('#userList .chkItem').length!==0) {
            $("#chkAllItems").prop('checked', true);
        }
    });
}

$('#scrollPage').scroll(function() {

    if(reachBottomBy('scrollPage')) {
        query_list.pageindex ++;
        scrollUserList();
    }
});

