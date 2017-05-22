/**
 * Created by shgbit on 2014/6/27.
 */
$(function() {
    showEquipList('0');
});

var equipments = [];

function showAddModal(obj) {
    $('#searchInput').val('');
    $("tr[id^='equip']").show();
    $('#btnSaveEquip').attr('savetype', 'add');
    $('#txtEquipName').val('');
    $('#txtEquipModel').val('');
    $('#icon').attr('src','');

    $('#equipModal').modal('show');
}


function showUpdateModal(obj) {
    $('#btnSaveEquip').attr('savetype', 'update' + $(obj).attr('id'));
    $('#txtEquipName').val($(obj).attr('name'));
    $('#txtEquipModel').val($(obj).attr('model'));
    $('#icon').attr('src',$(obj).attr('icon'));

    $('#equipModal').modal('show');
}

function saveEquip() {
    var saveType = $('#btnSaveEquip').attr('savetype');
    if (saveType == "add") addEquip();
    else updateEquip(saveType.substr(6));
}

function addEquip() {
    if(!validator.validateAll('#equipModal')) return;
    var equip = {};
    equip.name = $('#txtEquipName').val();
    equip.model = $('#txtEquipModel').val();
    equip.icon = $('#icon').attr('src');
    $.post('/equipment', equip, function(json) {
        if(!json || json.status == 'fail') return popBy($('#btnSaveEquip'), false, json.result);
        if(!json.result.icon.length ||json.result.icon.length<=0) {
            icon = "/img/equip.png";
        }else{
            icon=json.result.icon;
        }
        equipments.push(json.result);
        $("#equipList").prepend($("#tmplEquipment").html().format(
            json.result._id,
            json.result.name,
            json.result.model,
            moment(json.result.createTime).format("YYYY-MM-DD HH:mm"),
            icon
        ));
        $('#equipModal').modal('hide');

    })
}

function updateEquip(id) {
    if(!validator.validateAll('#equipModal')) return;
    var equip = {};
    equip.id=id;
    equip.name = $('#txtEquipName').val();
    equip.model = $('#txtEquipModel').val();
    equip.icon = $('#icon').attr('src');
    $.ajax({
        type: "PUT",
        url: "/equipment",
        data: JSON.stringify(equip),
        contentType: "application/json; charset=utf-8",
        success: function(json){
            if(!json || json.status == 'fail') return popBy($('#btnSaveEquip'), false, json.result);
            $("#name" + id).html($("#txtEquipName").val());
            $("#model" + id).html($("#txtEquipModel").val());
            $("#" + id).attr('name', $("#txtEquipName").val());
            $("#" + id).attr('model', $("#txtEquipModel").val());
            $("#" + id).attr('icon', $('#icon').attr('src'));
            $("#" +'icon'+ id).attr('src', $('#icon').attr('src'));

            $('#equipModal').modal('hide');
        }
    });
}

function closeModel(){
    var saveType = $('#btnSaveEquip').attr('savetype');
    var icon = $('#icon').attr('src');
    var id;
    if(!icon||icon.length<=0){
        $('#equipModal').modal('hide');
        return;
    }
    if (saveType == "add"){
      id=0;
    }
    else
    {
      id=saveType.substr(6);
    }
    $.ajax({
        type: "DELETE",
        url: "/deleteIconFile",
        data: JSON.stringify({id: id,icon:icon }),
        contentType: "application/json; charset=utf-8",
        success: function (json) {
        }
    });
    $('#equipModal').modal('hide');
}

function delEquip(obj) {
    if (confirm("确定删除？")) {
        var id = $(obj).attr('equipid');

        if (!id) return;
            $.ajax({
                type: "DELETE",
                url: "/equipment",
                data: JSON.stringify({id: id}),
                contentType: "application/json; charset=utf-8",
                success: function(json){
                    if(!json || json.status == 'fail') return popBy($(obj).parent(), false, json.result);
                    $(obj).closest('tr').remove();
                    equipments = _.filter(equipments, function(ele) {
                        return ele._id === id? false: true;
                    });
                }

            });
    }

}

function delEquips(obj) {
    if($('.chkItem:checked').length == 0) return popBy(obj, false, "请先选中需要删除的设备");
    var ids = [];
    $('.chkItem:checked').each(function (i, o) {
        ids.push($(o).val());
    });
    if(confirm("确定删除？")) {
        $.ajax({
            type: "DELETE",
            url: "/equipments",
            data: JSON.stringify({ids: ids }),
            contentType: "application/json; charset=utf-8",
            success: function(json){
                if(!json || json.status == 'fail') return popBy($(obj).parent(), false, json.result);
                $('.chkItem:checked').closest('tr').remove();
                equipments = _.filter(equipments, function(ele) {
                    for(var i= 0; i<ids.length; i++) {
                        if(ids[i] === ele._id) {
                            return false;
                        }
                    }
                    return true;
                });
            }

        });
    }
}

//function Search() {
//    $("tr[id^='equip']").hide();
//    if ($("#searchInput").val() == "") {
//        $("tr[id^='equip']").show();
//    } else {
//        $("tr[id^='equip']").each(function (index, domEle) {
//            var divobj = $(this).find("span[id^='name']");
//            var divobjModel = $(this).find("td[id^='model']");
//            if (divobj.length > 0) {
//                if (divobj.html().indexOf($("#searchInput").val()) != -1) {
//                    $(this).show();
//                } else if (divobjModel.length > 0) {
//                    if (divobjModel.html().indexOf($("#searchInput").val()) != -1) {
//                        $(this).show();
//                    }
//                }
//            }
//        });
//    }
//}

function showEquipList(orderBy) {
    $.getJSON("/equipments",orderBy, function (json, textStatus, jqXHR) {
        $("#equipList").empty();
        $("#chkAllItems").prop('checked', false);
        var listd = "";

        $.each(json, function (i, o) {
            var icon = "";
            var createTime=moment(o.createTime).format("YYYY-MM-DD HH:mm");

            if(!o.icon.length || o.icon.length<=0) {
                icon = "/img/equip.png";
            }else{
                icon= o.icon;
            }
            listd += $("#tmplEquipment").html().format(
                 o._id,
                 o.name,
                 o.model,
                 createTime,
                 icon
            );
        });
        equipments = json;

        $("#equipList").html(listd);
    });
}

function sort(e) {
    var option;
    if($(e).hasClass("dropup")) {
        option = "desc";
        $(e).removeClass("dropup");
    } else {
        option = "asc";
        $(e).addClass("dropup");
    }
    if("desc" === option) {
        equipments.reverse();
    }
    $("#equipList").empty();
    $("#chkAllItems").prop('checked', false);
    var listd = "";
    $.each(equipments, function (i, o) {
        icon="";
        var createTime=moment(o.createTime).format("YYYY-MM-DD HH:mm");

        if(!o.icon.length || o.icon.length<=0) {
            icon = "/img/equip.png";
        }else{
            icon= o.icon;
        }
        listd += $("#tmplEquipment").html().format(
            o._id,
            o.name,
            o.model,
            createTime,
            icon
        );
    });
    $("#equipList").html(listd);
}

function sortByName(e) {
    equipments = _.sortBy(equipments, function(ele) {
        return ele.name;
    });
    sort(e);
}

function sortByModel(e) {
    equipments = _.sortBy(equipments, function(ele) {
        return ele.model;
    });
    sort(e);
}

function sortByTime(e) {
    equipments = _.sortBy(equipments, function(ele) {
        return ele.createTime;
    });
    sort(e);
}

function selectAllChk() {
    $('.chkItem').prop('checked', $('#chkAllItems').prop('checked'));
}

function selectItemChk() {
    $('#chkAllItems').prop('checked', $(".chkItem:checked").length === $(".chkItem").length);
}

function validateMediaName($name) {
    var reg = /[<>\*\?:\^|"]/ig;
//    var reg = /^[a-zA-Z0-9_\.\(\)\-\u4e00-\u9fa5]+$/ig;
    var $result={};
    if($name.match(reg)) $result={status:false,message:'格式不正确'};
    else if($name.getRealLength() > 50 ) $result={status:false,message:'长度不能超过50字节'};
//    if(!$name.match(reg)) $result={status:false,message:'文件夹名或者媒体名只能为数字、中英文、点、下划线和中划线'};
//    else $result={status:true,message:''};
    else $result={status:true,message:''};
    return $result;
}

function validateImage(type) {
    var imageRegex = /image*/i;
    if(imageRegex.test(type)) return true;
    return false;
}
function fileUpload(){
    $.post('/upload', function(json) {
        if(!json || json.status == 'fail') return popBy($('#btnSaveEquip'), false, json.result);
        alert('OK');
    })
}
function onsubmit(obj){
  //$('#itemindex').val($('#input_container').attr('itemindex')) ;
    obj.form.submit();
}
//function fileUpload() {
//    'use strict';
//    var currentId = $('#mediaNav').attr('currentId') ? $('#mediaNav').attr('currentId') : '';
//    var url = '/upload/equipment?path=' + currentId;
//    $('#uploadInput').fileupload({
//        url: url,
//        dataType: 'json',
//        add: function (e, data) {
//            $.each(data.files, function (index, file) {
//            });
//            var $result=validateMediaName(data.files[0].name);
//            if(!$result.status) {
//                alert($result.message);
//            }else {
//                isSave = false;
//                data.submit();
//            }
//        },
//        done: function (e, data) {
//            isSave = true;
//            if(!data.result) return alert('未知的错误');
//            if(data.result.status == 'fail') return alert(data.result.result);
//
//            console.log(data.result);
////            var media = new Media(data.result.result);
////            var view = new MediaItemView({model:media});
////            $("#mediaList").children('tbody').prepend(view.render().el);
////            medias.add(media);
////            media = media.toJSON();
////            medias.get(media.parentId) ? medias.get(media.parentId).fetch() : null;
//        },
//        progressall: function (e, data) {
//            var progress = parseInt(data.loaded / data.total * 100, 10);
////            $('#progress').show();
////            $('#progress .progress-bar').css('width',progress + '%');
////            $('#progresspercent').html(progress + '%')
//            if(progress === 100) {
//                alert('OK');
////                $('#progress').hide();
////                $('#progress .progress-bar').css('width', 0 + '%');
//            }
//        }
//    }).prop('disabled', !$.support.fileInput).parent().addClass($.support.fileInput ? undefined : 'disabled');
//}
function orderEquips(orderBy, obj) {
    orderBy = $(obj).hasClass('dropup') ? 1 : 0;
    showDeviceList(orderBy);

    $(obj).parents("tr").find(".caret").remove();
    $(obj).append("<span class='caret'><span>");

    //顺序排序
    if ($(obj).hasClass('dropup')) {
        $(obj).removeClass('dropup');
    } else {
        $(obj).addClass('dropup');
    }
}

