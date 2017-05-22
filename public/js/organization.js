//var data = [];
//data.push({id:1, title:'xx', parentid:''});
//data.push({id:2, title:'yy', parentid:''});
//data.push({id:3, title:'zz', parentid:''});
//data.push({id:4, title:'xx1', parentid:1});
//data.push({id:5, title:'xx2', parentid:1});
//data.push({id:6, title:'xx3', parentid:1});
//data.push({id:7, title:'yy1', parentid:2});
//data.push({id:8, title:'xx11', parentid:4});
//data.push({id:9, title:'xx12', parentid:4});
//data.push({id:10, title:'yy11', parentid:7});


function showChildren(obj) {
    if($(obj).hasClass('sp-plus')) {
        $(obj).parents('li').siblings('li').find('ul:visible').hide();
        $(obj).parent().parent().siblings('li').find('.sp-minus').addClass('sp-plus').removeClass('sp-minus');
        $(obj).addClass('sp-minus')
            .removeClass('sp-plus')
            .siblings('ul').show();
    } else if($(obj).hasClass('sp-minus')) {
        $(obj).addClass('sp-plus')
            .removeClass('sp-minus')
            .siblings('ul').hide();
    }
}

function showUsers(obj, id) {
    $('.tree_select_item').removeClass('tree_select_item');
    $(obj).siblings('.tree_item').addClass('tree_select_item');
}


function initTree() {
    var pid = arguments[0] || '';
    $.getJSON('/organizations',{}, function(json) {
        if(!json || json.status == 'fail' || json.result.length == 0) return;
        appendTreeNode(pid, json.result);

    })


}

function showOrganizationModal(obj, saveType) {
    $('#btnSaveOrganization').data('saveType', saveType);
    $('#txtOrganizationName').val('');
    if(saveType == 'update') {
        if($('.tree_select_item').length == 0) return popBy(obj, false, '请选择需要编辑的组织');
        $('#txtOrganizationName').val($('.tree_select_item').siblings('.tree_item_text').html());
    }


    $('#addOrganizationModal').modal('show');
}

function appendTreeNode(pid, results) {
    var pid = arguments[0] || '';
    var pNode = document.createElement('ul');
    pNode.className = 'tree_ul nav';
    $(pNode).attr('nodeid',pid);

    var data = _.filter(results, function(item) {return  item.parent == (pid || null)});
    if(data.length == 0)
        return $('.tree_li[nodeid='+pid+']').find('.selectedNode').addClass('sp-blank').removeClass('sp-plus');

    if(pid == '') {

        $(pNode).addClass('root_node');
        if($('.root_node').length == 0) $('.organization_tree').append(pNode);
    }
    else {
        $(pNode).addClass('col-xs-offset-1').hide();
        if($('.tree_li[nodeid='+pid+']').length == 0) return;

        if($('.tree_ul[nodeid='+pid+']').length == 0)
            $('.tree_li[nodeid='+pid+']').children('div').append(pNode);
    }

    pNode = $('.tree_ul[nodeid='+pid+']');

    $.each(data, function(i, o) {
        $(pNode).append($('#tmplTree').html().format(o._id, o.name, o.parent || ''));
        appendTreeNode(o._id, results);
    })

}

function saveOrganization(obj) {
    if($(obj).data('saveType') == 'add') addOrganization(obj);
    else if($(obj).data('saveType') == 'update') updateOrganization(obj);
}

function updateOrganization(obj) {
    var txtName = $('#txtOrganizationName').val();
    var nodeId = '';
    if($('.tree_select_item').length >0) nodeId = $('.tree_select_item').siblings('.tree_item_text').data('id');
    if(txtName.length == 0) return popBy(obj, false, "组织名称不能为空");

    $.ajax({
        type: "PUT",
        url: "/organization",
        data: JSON.stringify({name: txtName, id: nodeId }),
        contentType: "application/json; charset=utf-8",
        success: function(json){
            if(!json || json.status == 'fail') return popBy(obj, false, json.result);
            $('.tree_select_item').siblings('.tree_item_text').html(txtName);
            $('#addOrganizationModal').modal('hide');
        }

    });

}

function deleteOrganization(obj) {
    var nodeId = '';
    if($('.tree_select_item').length >0) nodeId = $('.tree_select_item').siblings('.tree_item_text').data('id');
    if(nodeId.length == 0) return popBy($(obj).parent(), false, "请选择需要删除的组织");
    $.ajax({
        type: "DELETE",
        url: "/organization",
        data: JSON.stringify({id: nodeId }),
        contentType: "application/json; charset=utf-8",
        success: function(json){
            if(!json || json.status == 'fail') return popBy(obj, false, json.result);
            $('.tree_select_item').parent().parent().remove();
            $('#addOrganizationModal').modal('hide');
        }

    });

}

function addOrganization(obj) {
    var txtName = $('#txtOrganizationName').val();
    var pid = '';
    if($('.tree_select_item').length >0) pid = $('.tree_select_item').siblings('.tree_item_text').data('id');
    if(txtName.length == 0) return popBy(obj, false, "组织名称不能为空");
    $.post('/organization', {name: txtName, parent:pid}, function(json) {
        if(!json || json.status == 'fail') return popBy(obj, false, json.result);
        console.log (pid)
        appendTreeNode(pid, [json.result])

        $('.tree_select_item').siblings('.selectedNode').addClass('sp-plus').removeClass('sp-blank').removeClass('sp-minus');
        $('#addOrganizationModal').modal('hide');
    })
}