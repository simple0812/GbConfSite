/**
 * Created by Shgbit on 2014/8/4.
 */
//var devices=new Devices;

if(!Array.prototype.filter) {
    Array.prototype.filter =  function(func) {
        var result = [];
        for(var i=0;i< this.length;i++) {
            if(func(this[i]))   result.push(this[i]);
        }
        return result;
    }
}

_.templateSettings = {
    interpolate:/\{\{(.+?)\}\}/g
};

DeviceView=Backbone.View.extend({
    tagName:'tr',
    template: _.template($('#box-template').html()),
    template1: _.template($('#box-detail').html()),
    events:{
        'mouseover': 'showOperation',
        'mouseout': 'hideOperation',
        'click .detail'    : 'detail',
        'click .delete' : 'clear',
        'click .loadBasicSetting' : 'loadBasicSetting',
        'click .loadNetSetting'   : 'loadNetSetting',
        'click .outOfGroup'   : 'outOfGroup'


    },
    initialize:function(){
        this.listenTo(this.model,'destroy',this.remove);
        this.listenTo(this.model,'remove',this.remove);
        this.listenTo(this.model,'change',this.render);
    },
    render:function(){

        if($('#boxViewBtn').hasClass('btn-primary')){
//            alert('t')
            this.renderView();
        }
        else{
            var data=this.model.toJSON();

            this.$el.html(this.template({_id:data._id,name:data.name,alias:data.alias,
                ip:data.network.ip||'',online: (data.online === true ? 'online' : 'offline'),
                screen: (data.isScreenOn === 'on' ? 'screenOn': 'screenOff'),room:(data.room.name) ? data.room.name : ''}))

        }
        return this;
    },
    renderView:function() {
//        alert('a')
        var viewtemplate = _.template($('#boxView-template').html());
        var that = this;
        this.$el.addClass('col-xs-4');
        var data = this.model.toJSON();

        this.$el.html(viewtemplate({id: data._id , name: data.name, alias: data.alias,
            ip: data.network.ip || '', online: (data.online === true ? 'online' : 'offline'), screen: (data.screen === 'on' ? 'screenOn': 'screenOff'),snapshot:data.snapshot}));
        var image = new Image();
        image.onload = function() {
            if(image.width > image.height) {
                that.$el.find('.imageBox').children().attr('width','100%');
            } else {
                that.$el.find('.imageBox').children().attr('height','100%');
            }
        }
        image.onerror = function() {
            that.$el.find('.imageBox').children().attr('width','100%');
            that.$el.find('.imageBox').children().attr('height','100%');
        }
        image.src = 'data:image/png;base64,' + data.snapshot;

        this.$('.snapshot').attr('src','/img/isloading.gif');
        $.get('/snapshot/'+data._id,function(result){
            if(result.status === 'success') {
                that.$('.snapshot').attr('src','data:image/png;base64,' + result.snapshot);
            } else {
                that.$('.snapshot').attr('src','/images/default.jpg');
            }
        })
        return this;
    },
    detail:function(){
        var data = this.model.toJSON();
        console.log(this.template1)
        console.log(this.template)
        console.log( this.$('#boxDetail .modal-body').length)
        $('#boxDetail .modal-body').html(this.template1({
            boxName:data.name,
            boxAlias:data.alias,
            boxInterval:data.interval,
            boxAuto_snapshot:data.autoSnapshot,
            boxScreen:data.isScreenOn,
            boxBoot:data.boot,
            boxOs:data.os,
            boxVersionCode:data.version.code,
            boxVersionName:data.version.name,
            boxDsmversionCode:data.mversion.code,
            boxDsmversionName:data.mversion.name,
            boxDisk:data.disk,
            boxPixel:data.pixel,
            boxCpu:data.cpu,
            boxMemory:data.memory,
            boxService:data.service,
            boxIP:data.network.ip,
            boxMAC:data.network.mac,
            boxMASK:data.network.mask,
            boxGW:data.network.gw
    }));
        $('#snapshot').attr('src','/img/isloading.gif');
        $('#boxDetail').modal('show');
        $.get('/snapshot/'+data._id,function(result){
            if(result.status === 'success') {
                $('#snapshot').attr('src','data:image/png;base64,' + result.snapshot);
            } else {
                $('#snapshot').attr('src','/images/default.jpg');
            }
        })



    },
    clear:function(){
        if(confirm("确认删除吗？")){
//            alert(this.model._id)
            this.model.destroy();
            return this;
        }
    },
    loadBasicSetting:function(){
        var data = this.model.toJSON();
        $('.nameSettingDiv').show();
        $('#nameSettingInput').val(data.name);
        $('#aliasSettingInput').val(data.alias);
        $('#debugSetting').val(data.debug);
        $('#auto_snapshot').val(data.autoSnapshot);
        $('#interval').val(data.interval);
        $('#basicSettingModal').attr('boxId',data._id);
        $('#basicSettingModal').prop('isBoxes',false);
        $('#basicSettingModal').modal('show');
    },
    loadNetSetting:function(){
        var data=this.model.toJSON();
        $('#serviceInput').val(data.service);
        $('#ipInput').val(data.network.ip);
        $('#maskInput').val(data.network.mask);
        $('#gwInput').val(data.network.gw);
        $('#netSettingModal').attr('boxId',data._id);
        $('#netSettingModal').prop('isBoxes',false);
        $('.netBoxes').show();
        $('#netSettingModal').modal().show();

    },
    showOperation: function() {
        if($('#boxListBtn').hasClass('btn-primary')) {
            $(this.el).find('.name').parent().removeClass("col-xs-10").addClass("col-xs-5");
            $(this.el).find('.operation').show();
        }

    },

    hideOperation: function() {
        if($('#boxListBtn').hasClass('btn-primary')) {
            $(this.el).find('.name').parent().removeClass("col-xs-5").addClass("col-xs-10");
            $(this.el).find('.operation').hide();
        }

    },
    outOfGroup: function() {
        var groupId = $('#group-list-index').val();

        if(groupId === 'all') return;
        else {
            var that = this;
            var boxId = $(this.el).find('.boxChk').val();
            var tmpGroup = groups.get(groupId);
            var data = tmpGroup.toJSON();
            data.boxes = _.without(data.boxes,boxId);
            tmpGroup.save(data).done(function(a,b,c){
                that.$el.remove();
            }).error(function(model, jqXHR, o){
                if(jqXHR.status === 400) {
                    alert('未知错误，请联系管理员')
                }

            });
        }
        // ToDo remove this box out of group
    }

});
DevicesView=Backbone.View.extend({
    el:'#box',
    events:{
        'click #loadRoom': 'loadRoom',
        'click #createBtnBox': 'createBtn',
        'click #createBox': 'createBox',
        'click #allBoxes' : 'selectAll',
        'click .boxChk' :'selectOne',
        'click #allGroups': 'selectAllGroups',
        'change #group-list-index':'renderGroupBoxes',
        'click .groupChk': 'selectOneGroup',
        'click .sortByName': 'sortByName',
        'click .sortByAlias': 'sortByAlias',
        'click .sortByOnline': 'sortByOnline',
        'click .sortByScreen': 'sortByScreen',
        'click #deleteBoxes': 'deleteBoxes',
        'click #loadBasicSettings': 'loadBasicSettings',
        'click #saveBasicSetting': 'saveBasicSetting',
        'click #loadNetSettings': 'loadNetSettings',
        'click #saveNetSetting': 'saveNetSetting',
        'click #boxListBtn' : 'boxList',
        'click #boxViewBtn' : 'boxView',
        'click #createFolderConfirmBtn' : 'createFolderConfirmBtn',
        'click #snapshotCommand': 'sendSnapshot',
        'click #screenOnCommand': 'sendScreenOn',
        'click #screenOffCommand': 'sendScreenOff',
        'click #powerOnCommand': 'sendPowerOn',
        'click #powerOffCommand': 'sendPowerOff',
        'click #rebootCommand': 'sendReboot',
        'click #resetCommand': 'sendReset',
        'click #createGroupModal': 'createGroupModal',
        'click #createGroup': 'createGroup',
        'click #deleteGroupModal': 'deleteGroupModal',
        'click #deleteGroups': 'deleteGroups',
        'click #addToGroupModal': 'addToGroupModal',
        'click #addToGroup': 'addToGroup',
        'click #boxesOutOfGroup': 'boxesOutOfGroup',
        'click #nameBtnGroupEdit': 'nameGroupEdit'

    },
    initialize:function(){
        validator.bind();
        this.listenTo(devices,'add',this.addOne);
        this.listenTo(groups, 'remove', this.renderGroupBoxes);
        this.collection=devices;
        var that = this;
        devices.fetch();
        if($("#group-list-index").length>0) {
            groups.fetch().done(function() {
                var tmpGroups = groups.filter(function(){
                    return true;
                });
                that.renderGroup(tmpGroups);
            });
        }
    },
    sortByName:function() {
        this.sortBy('Name');
    },
    sortByAlias:function() {
        this.sortBy('Alias');
    },

    sortByOnline:function() {
        this.sortBy('Online');
    },


    sortByScreen:function() {
        this.sortBy('Screen');
    },
    sortBy: function(sortColNname) {
        var taget ='.sortBy'+sortColNname;
//        $(taget).find('.caret').show();
//        $(taget).siblings().removeClass('dropup').find('.caret').hide();
        if(!$(taget).hasClass('dropup')) {
            $(taget).addClass('dropup');
        } else {
            $(taget).removeClass('dropup');
        }
        var tmpBoxes = devices.sortBy(function (box) {
            return box.get(sortColNname.toLowerCase());
        });



//        var query = $('#searchInput').val().trim();
//        if(query !== '') {
//            tmpBoxes = tmpBoxes.filter(function(box) {
//                return box.toJSON().name.indexOf(query) > -1 || box.toJSON().alias.indexOf(query) > -1;
//            });
//        } else {
//            tmpBoxes = tmpBoxes.filter(function() {
//                return true;
//            });
//        }
        var groupId = $('#group-list-index').val();
        if(groupId !== 'all') {
            var tmpGroup = groups.get(groupId);
            var tmpBoxIds = tmpGroup.toJSON().boxes;
            tmpBoxes = tmpBoxes.filter(function(box){
                return _.contains(tmpBoxIds,box.toJSON()._id);
            });
        } else {
            tmpBoxes = tmpBoxes.filter(function(){
                return true;
            });
        }

        this.render(tmpBoxes);
        $('#allBoxes').prop('checked',false);
    },

    addOne:function(model,collection){
        var deviceView=new DeviceView({model:model});
        this.$('#box-list').prepend(deviceView.render().el);
    },
    render:function(tmpBoxes){
        var that=this;
        $('#box-list').children('tbody').empty();
        $('#box-view').empty();
//        this.collection.each(function(model){
//            that.addOne();
//        })
        var $sortFlag = $('#box-list').find('.caret:visible').parents('.sortBy').hasClass('dropup');
        if(!$sortFlag) {
            this.renderDesc(tmpBoxes);
        } else {
            this.renderAsc(tmpBoxes);
        }
        var groupId = $('#group-list-index').val();
        if(groupId === 'all') {
            $('.outOfGroup').hide();
            $('.boxesOutOfGroup').hide();
        } else {
            $('.outOfGroup').show();
            $('.boxesOutOfGroup').show();
        }
        $('#allBoxes').prop('checked', false);

    },
    renderAsc:function(tmpBoxes) {
        if($('#boxListBtn').hasClass('btn-primary')) {
            $.each(tmpBoxes, function(i, o) {
                var view = new DeviceView({model: o});
                $('#box-list').children('tbody').append(view.render().el);

            })
        } else {
            $.each(tmpBoxes, function(i, o) {
                var view = new DeviceView({model: o});
                $('#box-view').append(view.renderView().el);

            })
        }

    },
    renderDesc:function(tmpBoxes) {
        if($('#boxListBtn').hasClass('btn-primary')) {
            $.each(tmpBoxes, function(i, o) {
                var view = new DeviceView({model: o});
                $('#box-list').children('tbody').prepend(view.render().el);
            })
        } else {
            $.each(tmpBoxes, function(i, o) {
                var view = new DeviceView({model: o});
                $('#box-view').prepend(view.renderView().el);
            })

        }

    },
    boxList:function() {
        if(!$('#boxListBtn').hasClass('btn-primary')) {
            $('.showOnList').show();
//            $('#searchInput').val('');
            $('#boxListBtn').removeClass('btn-default').addClass('btn-primary')
        }
        $('#boxViewBtn').removeClass('btn-primary').addClass('btn-default');
        this.renderToggle();
    },
    boxView:function() {
        if(!$('#boxViewBtn').hasClass('btn-primary')) {
            $('.showOnList').hide();
//            $('#searchInput').val('');
            $('#boxViewBtn').removeClass('btn-default').addClass('btn-primary');
        }
        $('#boxListBtn').removeClass('btn-primary').addClass('btn-default');
        this.renderToggle();
    },
    renderToggle:function() {

//        var query = $('#searchInput').val().trim();
//        var sortColNname = $('#box-list').find('.caret:visible').attr('sortColName') ?
//            $('#box-list').find('.caret:visible').attr('sortColName') : 'name';
//        var tmpBoxes = devices.sortBy(function (box) {
//            return box.get(sortColNname);
//        });
//        if(query !== '') {
//            tmpBoxes = tmpBoxes.filter(function(box) {
//                return box.toJSON().name.indexOf(query) > -1 || box.toJSON().alias.indexOf(query) > -1;
//            });
//        } else {
//            tmpBoxes = tmpBoxes.filter(function(box) {
//                return true;
//            });
//        }
        var groupId = $('#group-list-index').val();
        if(groupId !== 'all') {
            var tmpGroup = groups.get(groupId);
            var tmpBoxIds = tmpGroup.toJSON().boxes;
            var tmpBoxes = devices.filter(function(box){
                return _.contains(tmpBoxIds,box.toJSON()._id);
            });
        } else {
            var tmpBoxes = devices.filter(function(){
                return true;
            });
        }
        this.render(tmpBoxes);
    },
    createBtn:function() {
        var roomId  = this.$(':radio:checked').val();
        if(!roomId) return popBy('#createBtnBox',false,'请选择预约机所属会议室','bottom')
        this.roomId = roomId;
        $('#roomModal').modal('hide');
        $('#boxCreate').modal('show');
    },
    createBox:function(){
        var that=this;
        var data={};
        var createName=$('#nameInputCreate'),
            createAlias = $('#aliasInputCreate');
        data.room = this.roomId
        data.name=$.trim(createName.val());
        if(data.name.length>40) return popBy('#nameInputCreate',false,'设备ID长度不能超过40字节');
        data.alias=$.trim(createAlias.val());
        if(data.alias.length>40) return popBy('#aliasInputCreate',false,'设备名称长度不能超过40字节');
        if(!validator.validateAll('#boxCreate')) return;
        devices.create(data,{
            wait:true,
            success:function(model,json,jqXHR){
                $("#group-list-index").val('all');
                that.renderGroupBoxes();
                $('#boxCreate').modal('hide');
                createName.val('');
                createAlias.val('');
                console.log(model)
                console.log(json)
                console.log(jqXHR)
            },
            error:function(model,json,jqXHR){
//                createBox
                devices.remove(model);
                popBy('#createBox',false,json.responseText,'bottom')
//                console.log(model)
//                console.log(json.responseText)
//                console.log(jqXHR)
//                console.log('shibai')

            }
        })
    },
    deleteBoxes:function(event){
        var ids=[];
        $('.boxChk:checked').each(function(i,o){
            ids.push($(o).val());
        });
        if(ids.length === 0)  return popBy("#deleteBoxes",false,"请先选择您要删除的预约机");
        models=[];
        $.each(ids,function(i,o){
            models.push(devices.get(o));
        });
        if(confirm("确认删除吗？")){
            $.ajax({
                type:"DELETE",
                url: "/devices",
                data: JSON.stringify(ids),
                contentType: "application/json; charset=utf-8"
            }).done(function (jqXHR) {
                devices.remove(models);
                $(".boxChk:checked").parents('tr').remove();
                $('#allBoxes').prop('checked',false);
            }).fail(function(a,b,c) {
                pop(event.target, "删除失败");
            })
        }

    },
    createGroupModal: function() {
        var ids=[];
        $('.boxChk:checked').each(function(i,o){
            ids.push($(o).val());
        });
        if(ids.length===0) return popBy("#createGroupModal", false, '请先选择您要加入分组的预约机');
        $('#groupCreateModal').modal('show');
    },
    createGroup:function() {
        var that=this;
        var data={};
        var ids=[];
        $('.boxChk:checked').each(function(i,o){
            ids.push($(o).val());
        });
        data.name = $.trim($('#groupInputCreate').val());
        data.boxes = ids;
        data.owner = $.cookie('token');
        if(data.name === '') return popBy('#groupInputCreate',false,'分组名不能为空');
        else if(data.name.length >40) return popBy('#groupInputCreate',false,'分组名长度不能超过40字节');
        alert(validator.validateAll('#groupCreateModal'))
        if(!validator.validateAll('#groupCreateModal')) return;
        groups.create(data,{
            wait:true,
            success:function(model,json,jqXHR){
                $('#groupCreateModal').modal('hide');
                var view = new GroupView({model:model});
                var groupSelectViewIndex = new GroupSelectView({model:model});
                var groupSelectViewAdd = new GroupSelectView({model:model});
                $('#group-list').children('tbody').append(view.render().el);
                $("#group-list-index").append(groupSelectViewIndex.render().el);
                $("#group-list-add").append(groupSelectViewAdd.render().el);
                $('#groupInputCreate').val('');
                $('#group-list-index').val(model.toJSON()._id);
                console.log(groups.length)
                console.log('kljaslkjdlsajdl')
                that.renderGroupBoxes();
            },
            error: function(model, jqXHR, o) {
                devices.remove(model);
                if(jqXHR.status === 400) {
                    popBy('#createGroup',false,jqXHR.responseText,'bottom');
//                    return popBy("#groupInputCreate",false,"分组名已存在");
                } else {
                    alert('未知错误，请联系管理员');
                }
            }
        });

    },
    renderGroupBoxes:function() {
        var groupId = $('#group-list-index').val();
        $('#searchInput').val('');
        if(groupId !== 'all') {
            var tmpGroup = groups.get(groupId);
            console.log(groupId)
            console.log(tmpGroup)
            var tmpBoxIds = tmpGroup.toJSON().boxes;
            var tmpBoxes = devices.filter(function(box){
                return _.contains(tmpBoxIds,box.toJSON()._id);
            });
        } else {
            var tmpBoxes = devices.filter(function(){
                return true;
            });
        }
        this.render(tmpBoxes);
//      $('#allBoxes').prop('checked', false);
    },
    renderGroup:function(tmpGroups) {
        var that = this;
        $.each(tmpGroups, function(i, o) {
            var view = new GroupView({model:o});
            var groupSelectViewIndex = new GroupSelectView({model:o});
            var groupSelectViewAdd = new GroupSelectView({model:o});
            $('#group-list').children('tbody').append(view.render().el);
            $("#group-list-index").append(groupSelectViewIndex.render().el);
            $("#group-list-add").append(groupSelectViewAdd.render().el);
        })
    },
    deleteGroupModal:function() {

        $('#groupDeleteModal').modal('show');
    },
    deleteGroups:function() {
        var that = this;
        var ids = [];
        $(".groupChk:checked").each(function (i, o) {
            ids.push($(o).val());
        });
        if(ids.length == 0) return  popBy("#deleteGroups",false,'请先选择您要删除分组名');
//        $('#groupDeleteModal').modal('hide');
        models = [];
        $.each(ids,function(i,o) {
            models.push(groups.get(o));
        });
        if(confirm("确认删除吗？")) {
            $.ajax({
                type: "DELETE",
                url: "/groups",
                data: JSON.stringify(ids),
                contentType: "application/json; charset=utf-8"
            }).done(function (jqXHR) {
                groups.remove(models);
//                    $('#groupDeleteModal').modal('hide');
                $('#allGroups').prop('checked',false);
                that.renderGroupBoxes();

            }).fail(function(a,b,c) {
                console.log('error',a,b,c);
            });
        }
    },
    addToGroupModal:function() {
        var ids = [];
        $(".boxChk:checked").each(function(i, o) {
            ids.push($(o).val());
        });
        if(ids.length == 0) return popBy("#addToGroupModal", false, '请先选择您要加入分组的预约机');
        models = [];
        $.each(ids,function(i,o) {
            models.push(devices.get(o));
        });
        $('#groupAddModal').modal('show');
    },
    addToGroup:function() {
        var that = this;
        var groupid = $('#group-list-add').val();
        var tmpGroup = groups.get(groupid);
        var data = tmpGroup.toJSON();
        var ids = [];
        $(".boxChk:checked").each(function(i, o) {
            ids.push($(o).val());

        });
        data.boxes = _.union(ids, data.boxes);
        tmpGroup.save(data).done(function(a,b,c){
            $('#groupAddModal').modal('hide');
            $('#group-list-index').val(groupid);
            that.renderGroupBoxes();
        }).error(function(model, jqXHR, o){
            if(jqXHR.status === 400) {
                alert('未知错误，请联系管理员')
            }

        });
    },
    boxesOutOfGroup:function() {
        var groupId = $('#group-list-index').val();
        if(groupId === 'all') return;
        else {
            var ids = [];
            $(".boxChk:checked").each(function(i, o) {
                ids.push($(o).val());
            });
            if(ids.length == 0) return popBy("#boxesOutOfGroup", false, '请先选择您要移出分组的播放器');
            else {
                var that = this;
                var tmpGroup = groups.get(groupId);
                var data = tmpGroup.toJSON();
                data.boxes = _.difference(data.boxes,ids);
                tmpGroup.save(data).done(function(a,b,c){
                    $('.boxChk:checked').parent().parent().parent().remove();
                }).error(function(model, jqXHR, o){
                    if(jqXHR.status === 400) {
                        alert('未知错误，请联系管理员')
                    }

                });
            }
        }
    },
    nameGroupEdit:function() {
        var id = $('#groupNameEditModal').prop('groupId');
        var tmpGroupName =$.trim( $('#nameInputGroupEdit').val());
        if(!validator.validateAll('#groupNameEditModal')) return;
        var oldName = $('#groupNameEditModal').prop('oldName');
        if(oldName === tmpGroupName) return $('#groupNameEditModal').modal('hide');
        if(tmpGroupName === '') return popBy('#nameInputGroupEdit',false,'分组名不能为空');
        if(tmpGroupName.length >40) return popBy('#nameInputGroupEdit',false,'分组名长度不能超过40字节');
//        if(!validator.validateAll('#groupCreateModal')) return;
//        var reg = /^[a-zA-Z0-9_\-\u4e00-\u9fa5]+$/ig;
//        var validateName = validatePublicName(tmpGroupName);
//        var message = '分组名' +  validateName.message;
//        if(!validateName.status) return popBy('#nameInputGroupEdit',false,message);
//        if(!tmpGroupName.match(reg)) return popBy('#nameInputGroupEdit',false,'组名只能为数字、中英文、下划线和中划线');
        var tmpGroup = groups.get(id);
        tmpGroup.save({name:tmpGroupName}).done(function(a,b,c){
            $('#groupNameEditModal').modal('hide');
        }).error(function(jqXHR,o, status){
            tmpGroup.set({name:oldName});
            if(jqXHR.status === 400) {
                popBy('#nameBtnGroupEdit',false,jqXHR.responseText,'bottom');
//                return popBy("#nameInputGroupEdit",false,"分组名已存在");
            } else {
                alert('未知错误，请联系管理员')
            }

        });
    },
    loadBasicSettings: function() {
        var ids=[];
        $(".boxChk:checked").each(function(i,o){
            ids.push($(o).val());
        });
        if(ids.length == 0) return popBy("#loadBasicSettings", false, '请先选择您要设置的预约机');
        timeSettings.reset();
        $('.nameSettingDiv').hide();
        $('#aliasSettingInput').val('');
        $('#debugSetting').val('0');
        $('#timeSetting').empty();
        $('#auto_snapshot').val('60');
        $('#interval').val('30');
        $('#basicSettingModal').prop('isBoxes',true);
        $('#basicSettingModal').modal('show');
    },
    saveBasicSetting: function() {
        var isBoxes =  $("#basicSettingModal").prop('isBoxes');
        var data={};
        var tmpauto_screen = [];
        var weekdays =$("#timeSetting").children('div');
        var flag = true;
        $.each(weekdays,function(i,o) {
            var tmpauto_screenItem = {};
            var tmpweek = '0'
            var count = 0;
            var weekItem = $(o).find('.weekItem').children('.weekday');
            var timeItem = $(o).find('.timeItem');
            $.each(weekItem,function(i,o){
                if($(o).hasClass('btn-primary')) {
                    tmpweek = tmpweek + '1';
                    count ++;
                } else {
                    tmpweek = tmpweek + '0';
                }
            });
            if(timeItem.children('input').first().val() === '' ||
                timeItem.children('input').last().val() === '' ||
                tmpweek === '00000000') return flag = false;
            tmpauto_screenItem.from = timeItem.children('input').first().val();
            tmpauto_screenItem.to = timeItem.children('input').last().val();
            tmpauto_screenItem.week = tmpweek;
            tmpauto_screen.push(tmpauto_screenItem);
        });
        if(!flag) return popBy('#saveBasicSetting',flag,'显示时间设置不完整');
        data.alias =$.trim( $('#aliasSettingInput').val());
//        var validateName = validatePublicName(data.alias);
//        var message = '名称' +  validateName.message;
//        if(!validateName.status) return popBy('#saveBasicSetting',false,message);
        data.debug = $('#debugSetting').val();
        data.autoSnapshot =$.trim( $('#auto_snapshot').val());
        data.interval = $.trim( $('#interval').val());
        data.autoScreen = tmpauto_screen;
        var int_auto_snapshot = parseInt(data.autoSnapshot);
        var int_interval = parseInt(data.interval);
        var regNumber = /^\d+$/;
        if(!regNumber.test(data.autoSnapshot)) return popBy('#auto_snapshot',false,'截屏周期格式不对');
        else if(!(int_auto_snapshot >= 60 && int_auto_snapshot <= 300) && !(int_auto_snapshot === 0)) return popBy('#auto_snapshot',false,'截屏周期必须大于60小于300秒或等于0(不截屏)');
        if(!regNumber.test(data.interval)) return popBy('#interval',false,'更新周期格式不对');
        else if(int_interval < 30 || int_interval > 150) return popBy('#interval',false,'更新周期必须大于30小于150秒');
        if(!validator.validateAll('#basicSettingModal')) return;
        if(isBoxes) {
            putDate = _.pick(data, 'debug', 'autoSnapshot', 'interval', 'auto_screen');
            var ids = [];
            $(".boxChk:checked").each(function(i, o) {
                ids.push($(o).val());
            });
            if(confirm("确认批量修改吗？")) {
                $.ajax({
                    type: "put",
                    url: "/devices",
                    data: JSON.stringify({ids:ids,data:putDate}),
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (json) {
                        if(json.status === 'success') {
                            $.each(ids,function(i,o) {
                                devices.get(o).set(putDate);
                            });
                            $('#basicSettingModal').modal('hide');
                            $('#allBoxes').prop('checked', false);
                            $(".boxChk:checked").prop('checked', false);
                        }
                    },
                    error: function (err) {
                        alert(err.responseText)
                    }
                });
            }

        } else {
            var id = $("#basicSettingModal").attr('boxId');
            var putData = _.omit(data, 'room');
            console.log(putData)
            var tmmodel = devices.get(id);
            tmmodel.set('room',tmmodel.get('_id'))
            tmmodel.save(putData).done(function(json,status,jqXHR) {
                $('#basicSettingModal').modal('hide');
                $('#allBoxes').prop('checked', false);
                $(".boxChk:checked").prop('checked', false);
            }).fail(function(a,b,c) {
                pop(event.target, "修改失败");
                console.log(a,b,c);
                alert('xxxx');
            });
        }
    },
    loadNetSettings: function() {
        var ids =[];
        $(".boxChk:checked").each(function(i,o){
            ids.push($(o).val());
        })
        if(ids.length===0) return popBy('#loadNetSettings',false,'请先您要设置的预约机');
        $('#serviceInput').val('');
        $('#maskInput').val('');
        $('#ipInput').val('');
        $('#gwInput').val('');
        $('.netBoxes').hide();
        $('#netSettingModal').prop('isBoxes',true);
        $('#netSettingModal').modal('show');
    },
    saveNetSetting:function(){
        var isBoxes =  $("#netSettingModal").prop('isBoxes');
        var data = {};
             networker ={};
        data.service = $.trim($('#serviceInput').val());

        if(!validator.validateAll('#netSettingModal')) return;
        if(isBoxes){
        var ids=[];
        $(".boxChk:checked").each(function(i,o){
            ids.push($(o).val());
        });
        if(confirm("确认批量修改吗？")){
            $.ajax({
                type: "put",
                url: "/devices",
                data: JSON.stringify({ids:ids,data:data}),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (json) {
                    if(json.status === 'success') {
                        $.each(ids,function(i,o){
                            devices.get(o).set(data);
                        });
                        $('#netSettingModal').modal('hide');
                        $('#allBoxes').prop('checked', false);
                        $(".boxChk:checked").prop('checked', false);
                    }
                },
                error:function(err){
                    alert(err.responseText)
                }
            })
          }
        }else{
            data.network =networker;
            networker.ip = $.trim($('#ipInput').val());
            networker.mask = $.trim($('#maskInput').val());
            networker.gw =  $.trim($('#gwInput').val());
            var id = $("#netSettingModal").attr('boxId');

            devices.get(id).save(data).done(function(json, status, jqXHR) {
                $('#netSettingModal').modal('hide');
                $('#allBoxes').prop('checked', false);
                $(".boxChk:checked").prop('checked', false);
                // ToDo clear the data of this modal
            }).fail(function(a,b,c) {
                pop(event.target, "修改失败");
                console.log(a,b,c);
            });
        }

    },
    createFolderConfirmBtn:function(){
        var timeSetting =new TimeSetting();
        timeSetting.set({id:timeSetting.cid});
        timeSettings.add(timeSetting);
        var timeSettingItemView =new TimeSettingItemView({model:timeSetting});
        $('#timeSetting').append(timeSettingItemView.render().el);
    },
    selectAll:function(e){
        if($('#allBoxes:checked').length > 0){
            $('.boxChk').prop('checked',true);
        }else{
            $('.boxChk').prop('checked',false);
        }
        if (e && e.stopPropagation) {
            //支持W3C
            e.stopPropagation();
        }
        else {
            //IE的方式
            window.event.cancelBubble = true;
        }
    },
    selectOne:function(){
        if($(".boxChk:checked").length===$(".boxChk").length){
            $('#allBoxes').prop('checked',true)
        }else{
            $('#allBoxes').prop('checked',false)
        }
    },
    selectAllGroups:function(e) {
        if($('#allGroups:checked').length > 0) {
            $('.groupChk').prop('checked', true);
        } else {
            $('.groupChk').prop('checked', false);
        }
        if (e && e.stopPropagation) {
            //支持W3C
            e.stopPropagation();
        }
        else {
            //IE的方式
            window.event.cancelBubble = true;
        }
    },
    selectOneGroup:function(e) {
        if($(".groupChk:checked").length === $('.groupChk').length) {
            $('#allGroups').prop('checked', true);
        } else {
            $('#allGroups').prop('checked', false);
        }
    },
    sendCommand:function(command){
       var ids=[];
       var content={};
       $('.boxChk:checked').each(function(i,o){
           ids.push($(o).val());
       });
       content={command:command,boxes:ids};
       if(confirm("确认发送命令吗？")){
           $.ajax({
               type:'PUT',
               url:"/command",
               data: JSON.stringify(content),
               contentType: "application/json; charset=utf-8"
           }).done(function (jqXHR) {
               $(".boxChk:checked").prop('checked',false);
               $("#allBoxes").prop('checked',false);
               alert('命令已发送');
           }).fail(function(a,b,c){
               console.log('error',a,b,c);
           })
       }
    },

    sendSnapshot: function(e) {
        if($(".boxChk:checked").length == 0) return popBy("#snapshotCommand", false, '请先选择您要控制的播放器');
        this.sendCommand('snapshot');
    },
    sendScreenOn: function(e) {
        if($(".boxChk:checked").length == 0) return popBy("#screenOnCommand", false, '请先选择您要控制的播放器');
        this.sendCommand('screenon');
    },
    sendScreenOff: function(e) {
        if($(".boxChk:checked").length == 0) return popBy("#screenOffCommand", false, '请先选择您要控制的播放器');
        this.sendCommand('screenoff');
    },
    sendPowerOn: function(e) {
        if($(".boxChk:checked").length == 0) return popBy("#powerOnCommand", false, '请先选择您要控制的播放器');
        this.sendCommand('startup');
    },
    sendPowerOff: function(e) {
        if($(".boxChk:checked").length == 0) return popBy("#powerOffCommand", false, '请先选择您要控制的播放器');
        this.sendCommand('shutdown');
    },
    sendReboot: function(e) {
        if($(".boxChk:checked").length == 0) return popBy("#rebootCommand", false, '请先选择您要控制的播放器');
        this.sendCommand('reboot');
    },
    sendReset: function(e) {
        if($(".boxChk:checked").length == 0) return popBy("#resetCommand", false, '请先选择您要控制的播放器');
        this.sendCommand('reset');
    },
    loadRoom:function(e) {
        $('#roomModal').modal('show');
        var rooms = new Rooms({comparator: "name"});
        new RoomsView({el:'#roomModal',collection:rooms})
    }
});

var devicesView=new DevicesView;


TimeSetting =Backbone.Model.extend({
    defaults:{
        from:'',
        to:'',
        week:"00000000"
    }
});
TimeSettings =Backbone.Collection.extend({
    model:TimeSetting
});
var timeSettings = new TimeSettings;
TimeSettingItemView =Backbone.View.extend({
    tagName:'div',
    template: _.template($('#timeSetting-template').html()),
    events:{
        'click .removeTimeSetting': 'removeTimeSetting',
        'click .weekday' : 'weekday'
    },
    initialize:function(){

    },
    render:function(){
        var data=this.model.toJSON();
        var btnClass =[];
        for(var i= 1;i<8;i++){
            if(data.week[i]==="0"){
                btnClass[i]='btn-default';
            }else{
                btnClass[i]='btn-primary';
            }
        }
        this.$el.addClass('alert alert-info');
        this.$el.html(this.template({id:data.id,from:data.from,to:data.to,btnClass1:btnClass[1], btnClass2:btnClass[2], btnClass3:btnClass[3],
            btnClass4:btnClass[4], btnClass5:btnClass[5],btnClass6:btnClass[6], btnClass7:btnClass[7]}));
         return this;
    },
    weekday:function(e){
       if( $(e.target).hasClass('btn-default')){
           $(e.target).addClass('btn-primary').removeClass('btn-default');
       }else{
           $(e.target).addClass('btn-default').removeClass('btn-primary');
       }
    },
    removeTimeSetting:function() {
        timeSettings.remove(this.model);
        $(this.el).remove();
    }

});