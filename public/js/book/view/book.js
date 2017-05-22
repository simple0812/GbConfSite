//function

_.templateSettings = {
    interpolate: /\{\{(.+?)\}\}/g
};

/* book view*/
BookView = Backbone.View.extend({
    el: "#bookmain",
    events: {
        "click #clearBookDate":"clearBookDate",
        "click #addEquip":"addEquip",
        "click .book-search":"search",
        "click #previousDay":"previousDay",
        "click #nextDay":"nextDay",
        "click .bookingConfirm":"bookingConfirm",
        "click #closeBookingPop":"closeBookingPop"
    },
    initialize: function() {
        equips.reset();
        bookings.reset();
        rooms.reset();
        var that = this;
        $('#bookDate').val(new moment().format("YYYY-MM-DD"));
        $('#bookDateChange').val(new moment().format("YYYY-MM-DD"));
        this.createDatePicker('#bookDate');
        this.createDatePicker('#bookDateChange').on('changeDate',function(ev) {
            that.bookingsUpdate(that.$('#bookDateChange').val());
        });
        this.listenTo(equips,'add',this.addOneEquip);
        this.listenTo(equips,'checkConditionHeight',this.checkConditionHeight);
        this.listenTo(rooms,'add',this.addOneRoom);
        this.listenTo(rooms,'remove',this.removeOneRoom);
        this.listenTo(bookings,'add',this.addOneBooking);
        this.listenTo(bookings,'remove',this.removeOneBooking);
        this.bookRooms = {};
        validator.bind();
        equips.fetch({
            url:'/equipments/initialize',
            success:function(collection, response, options){
                that.search();
            },
            error:function(collection, response, options){

            }
        });
    },
    createDatePicker:function(ElId){
        return $(ElId).datetimepicker({
            format: 'yyyy-mm-dd',
            language:  'zh-CN',
            weekStart: 1,
            autoclose: 1,
            startDate:new Date(),
            endDate:null,
            initialDate:new Date(),
            startView: 2,
            minView: 2,
            forceParse: 0
        });
    },
    addEquip:function(){
        equips.fetch({
            success:function(collection, response, options){
                $('#equipList').modal('show');
            },
            error:function(collection, response, options){
            }
        });
    },
    addOneEquip:function(model,collection){
        var equipSettingView =new EquipSettingView({model:model})
        $('#equipSetting').append(equipSettingView.el);
        equipSettingView.getSwitchClass();
    },
    search:function(){
        var that = this;
        var date = this.$('#bookDate').val();
        this.$('#bookDateChange').val(date);
        this.$('#bookDateChange').datetimepicker('update');
        if(!validator.validateAll("#bookmain")) return false;
        var tasks = [];
        var fetchRooms = function(callback) {
            var checkEdequips = equips.map(function(equip) {
                if(equip.toJSON().checked) return equip.get('_id');
            });
            var roomCapacity = $('#roomCapacity').val();
            rooms.fetch({
                url:'/rooms',
                data:{equipments:checkEdequips,capacity:roomCapacity},
                success:function(collection, response, options){
                    var roomIds = collection.map(function(room){
                        return room.get('_id');
                    })
                    var timeLineHeight = 40*roomIds.length;
                    callback(null,roomIds);
                },
                error:function(collection, response, options){
                    callback('rooms获取错误');
                }
            });
        };
        tasks.push(fetchRooms);
        var fetchBookings = function(roomIds,callback) {
            that.roomIds = roomIds;
            bookings.fetch({
                url:'/bookings',
                data:{roomIds:roomIds,date:date},
                success:function(collection, response, options){
                    callback(null);
                },
                error:function(collection, response, options){
                    callback('bookings获取错误');
                }
            });
        };
        tasks.push(fetchBookings);
        async.waterfall(tasks,function(err,result) {
            if(err) alert(err);
        });

    },
    checkConditionHeight:function(){
        var topPadding = $('.fix-top-book').height() + 80;
        $('.fix-top-book-padding-day').css({top:topPadding});
        $('.fix-top-book-padding').css({paddingTop:topPadding});
    },
    addOneRoom:function(model,collection){
        this.bookRooms[model.get('_id')] =new BookRoom({model:model})
        $('#bookRooms').append(this.bookRooms[model.get('_id')].render().el);
        $(".roomRowChild").removeClass("roomRowOdd").removeClass("roomRowEven");
        $(".roomRow:nth-child(odd) .roomRowChild").addClass("roomRowOdd");
        $(".roomRow:nth-child(even) .roomRowChild").addClass("roomRowEven");
    },
    removeOneRoom:function(model,collection) {
        this.bookRooms[model.get('_id')] = undefined;
        $(".roomRowChild").removeClass("roomRowOdd").removeClass("roomRowEven");
        $(".roomRow:nth-child(odd) .roomRowChild").addClass("roomRowOdd");
        $(".roomRow:nth-child(even) .roomRowChild").addClass("roomRowEven");
    },
    addOneBooking:function(model,collection) {

        this.bookRooms[model.get('room')].renderBooking(model);
    },
    removeOneBooking:function(model,collection){
        if(this.bookRooms[model.get('room')]) this.bookRooms[model.get('room')].removeBooking(model);
    },
    previousDay:function(){
        var that = this ;
        var now = new Date(new moment().valueOf());
        now.setHours(0,0,0,0);
        var tmpDate = moment($('#bookDate').val()).valueOf();
        var queryDate =new Date(tmpDate);
        queryDate.setDate(queryDate.getDate()-1)
        if(now > queryDate) return popBy('#bookDateChange',false,'日期不能小于今天','top');
        var date = new moment(queryDate).format("YYYY-MM-DD")
        this.bookingsUpdate(date);
    },
    nextDay:function(){
        var tmpDate = moment($('#bookDate').val()).valueOf();
        var queryDate =new Date(tmpDate);
        queryDate.setDate(queryDate.getDate()+1)
        var date = new moment(queryDate).format("YYYY-MM-DD")
        this.bookingsUpdate(date);
    },
    bookingsUpdate:function(date){
        clearPop();
        var that = this;
        bookings.fetch({
            url:'/bookings',
            data:{roomIds:that.roomIds,date:date},
            success:function(collection, response, options){
                $('#bookDate').val(date);
                that.$('#bookDateChange').val(date);
                $('#bookDate').datetimepicker('update');
                that.$('#bookDateChange').datetimepicker('update');
            },
            error:function(collection, response, options){
                alert('bookings获取错误');
            }
        });
    },
    bookingConfirm:function(){
        var roomId = $('#bookDateChange').data('roomid');
        var startTime =$('#bookDateChange').data('starttime');
        var endTime = $('#bookDateChange').data('endtime');
        window.location.href = '#booking/'+roomId+'/'+startTime+'/'+endTime;

    },
    closeBookingPop:function(){
        clearPop();
//        clearTimeout($('#alertConfirm').data('timeOut'));
//        $('#bookSearchAlert').hide();
    }
})

/* EquipSettingView */
EquipSettingView = Backbone.View.extend({
    tagName:'div',
    className:'col-xs-4',
    events: {
        "click .bootstrap-switch":"changeChecked"
    },
    initialize:function(){
        var data = this.model.toJSON();
        var equipInput = document.createElement('input');
        equipInput.type = 'checkbox';
        equipInput.id = data._id;
        equipInput.checked =data.checked;
        this.$el.html(equipInput);
        this.listenTo(this.model, "removeSelf", this.remove);
        this.listenTo(this.model, "addDisplayView", this.renderDisplayView);
        if(this.model.toJSON().checked) this.renderDisplayView();
    },
    getSwitchClass:function(){
        var data = this.model.toJSON();
        var name = (data.name.length > 3) ? data.name.substring(0,3) : data.name
        $('#'+data._id).bootstrapSwitch({onText:name,offText:name});
        $('#'+data._id).siblings('span').attr('title',data.name);
    },
    render:function(){
    },
    changeChecked:function(){
        var data = this.model.toJSON();
        this.model.set({"checked":$('#'+data._id).prop('checked')})
    },
    renderDisplayView:function(){
        var data = this.model.toJSON();
        var tempModel = this.model;
        $('#'+data._id).bootstrapSwitch('state',true);
        var equipDisplayView =new EquipDisplayView({model:tempModel})
        $('#equipDisplay').append(equipDisplayView.el);
        equips.trigger('checkConditionHeight');
    }
})

/* EquipDisplayView */
EquipDisplayView = Backbone.View.extend({
    tagName:'div',
    className:'btn btn-primary gap-right',
    events: {
        "click .deleteEquip":"deleteEquip"
    },
    initialize:function(){
        var data = this.model.toJSON();
        var button = "<button type='button' class='close deleteEquip'>&nbsp&times</button>"
        this.$el.html(button+data.name);
        this.listenTo(this.model, "removeSelf", this.remove);
        this.listenTo(this.model, "removeDisplay", this.remove);
    },
    deleteEquip:function(){
        var data = this.model.toJSON();
        this.model.set({"checked":false});
        $('#'+data._id).bootstrapSwitch('state',false);
        this.remove();
    }
})

/* BookRoom */
BookRoom = Backbone.View.extend({
    tagName:'div',
    template: _.template($('#bookRoomTemplate').html()) ,
    className:'row fixed-width roomRow',
    events:{
        'mousedown .booking':'down',
        'mouseup .booking':'up',
        'mouseenter .booking':'select',
        'mouseenter .occupied':'selectFailed',
        'mouseleave .roomRowChild':'selectFailed',
        'click .editbooking':'editbooking',
        'mouseenter .roomDetatil':'showRoomDetail',
        'mouseleave .roomDetatil':'hideRoomDetail'


    },
    initialize:function(options){
        this.$('.roomRow').addClass(options.className);
        this.listenTo(this.model,'removeSelf',this.remove);
        this.listenTo(this.model,'change',this.render);
        this.bookingViews = {};
        this.isSelecting = false;
        this.popTemplate = _.template($('#popTemplateRoom').html());


    },
    render:function(){
        var data = this.model.toJSON();
        this.$el.html(this.template(data));
        return this;
    },
    renderBooking:function(booking) {
        var that = this;
        this.bookingViews[booking.get('_id')] = new BookingView({model:booking});
        this.$('.roomRowChild').append(that.bookingViews[booking.get('_id')].render().el);
        this.bookingViews[booking.get('_id')].setBookingDiv();
    },
    removeBooking:function(booking) {
        this.bookingViews[booking.get('_id')] = undefined
    },
    down:function(event){
        this.isSelecting = true;
        var event = event || window.event;
        var target = event.target || event.srcElement;
        $(target).addClass('selectedTime')
    },
    select:function(event){
        if(!this.isSelecting) return;
        var event = event || window.event;
        var target = event.target || event.srcElement;
        $(target).addClass('selectedTime');
        var first =this.$('.selectedTime').eq(0).index();
        var last =this.$('.selectedTime').last().index();
        for(var i=first;i<=last;i++) {
            $(target).parent().children('.booking:eq('+i+')').addClass('selectedTime');
        }
    },
    up:function(event) {
        if(!this.isSelecting) return;
        this.isSelecting = false;
        var startTime = this.$('.selectedTime').eq(0).data('bookend');

        if(!startTime) startTime = this.$('.selectedTime').eq(0).data('st');

        var endTime = this.$('.selectedTime').last().data('bookstart');
        if(!endTime) endTime = this.$('.selectedTime').last().data('ed');
        this.$('.selectedTime').removeClass('selectedTime');
//        $('#bookDateChange').val();
        var momentStart = moment($('#bookDateChange').val()).valueOf();
        startTime =new Date(new Date(momentStart).setHours(0,0,startTime,0)).getTime();
        endTime =new Date(new Date(momentStart).setHours(0,0,endTime,0)).getTime()
        var start = moment(parseInt(startTime));
        var end = moment(parseInt(endTime));
        var formatDate = start.format('YYYY-MM-DD');
        var formatStart = start.format('HH:mm');
        var formatEnd = end.format('HH:mm');
        var startToEnd = end.diff(start,'minute');
        var startToNow = start.diff(moment(),'minute');
//        var hide = function() {
//            $('#bookSearchAlert').fadeOut();
//        }
//        var timeOut ;
//        $('#bookSearchAlert').css('left',$('body').width()/2-150);
//        $('#bookSearchAlert').css('top',$('body').height()/2+100);

        var popData ={};
//        popData._id = this.model.get('_id');
        popData.now = moment().format("HH:mm");
        popData.bookingTime ="<font color='red'>"+formatStart+'-'+formatEnd+"</font>";
        popData.startTime = formatStart;
        popData.endTime = formatEnd;
        popData.roomName = this.model.get('name');
        popData.roomCapacity = this.model.get('capacity');
        popData.buttonContext = '预约';
//        popData.display = 'inline';
//        popData.message ='时间错误'
        if(startToEnd <= 0) {
            popData.bookingTime ="<font color='red'>"+formatStart+'-'+formatEnd+"</font>";
            popData.message ='预约时间错误'
            popData.display = 'none';
//            $('#alertFirst').html('会议时间:'+formatStart+'-'+formatEnd+'错误');
//            $('#alertSecond').html('请选择一个正确得时间段');
//            $('#alertThird').html('');
//            $('#alertConfirm').hide();
////            $('#bookSearchAlert').addClass('alert-danger').removeClass('alert-success');
//            $('#bookSearchAlert').show();
//            clearTimeout($('#alertConfirm').data('timeOut'));
//            timeOut = setTimeout(hide,2000);
//            $('#alertConfirm').data('timeOut',timeOut);
        } else if(startToEnd < 30) {
            popData.bookingTime ="<font color='red'>"+formatStart+'-'+formatEnd+"</font>";
            popData.message ='会议最小时间为半小时'
            popData.display = 'none';
//            $('#alertFirst').html('会议时间:'+formatStart+'-'+formatEnd);
//            $('#alertSecond').html('一次会议必须大于半小时');
//            $('#alertThird').html('');
//            $('#alertConfirm').hide();
////            $('#bookSearchAlert').addClass('alert-danger').removeClass('alert-success');
//            $('#bookSearchAlert').show();
//            clearTimeout($('#alertConfirm').data('timeOut'));
//            timeOut = setTimeout(hide,2000);
//            $('#alertConfirm').data('timeOut',timeOut);
        }
        else if(startToNow <=0){
            popData.bookingTime ="<font color='red'>"+formatStart+'-'+formatEnd+"</font>";
            popData.message ='预约的时间已经过期'
            popData.display = 'none';
//            $('#alertFirst').html('会议时间:'+formatStart+'-'+formatEnd);
//            $('#alertSecond').html('当前时间:'+moment().format("HH:mm"));
//            $('#alertThird').html('预约会议必须超过当前时间');
//            $('#alertConfirm').hide();
////            $('#bookSearchAlert').addClass('alert-danger').removeClass('alert-success');
//            $('#bookSearchAlert').show();
//            clearTimeout($('#alertConfirm').data('timeOut'));
//            timeOut = setTimeout(hide,2000);
//            $('#alertConfirm').data('timeOut',timeOut);
        } else {
            popData.bookingTime =formatStart+'-'+formatEnd;
            popData.message =''
            popData.display = 'inline';
//            $('#alertFirst').html('会议日期:'+formatDate);
//            $('#alertSecond').html('会议时间:'+formatStart+'-'+formatEnd);
//            $('#alertThird').html('会议室:'+this.model.get('name')+'('+this.model.get('capacity')+'人)');
            $('#bookDateChange').data('roomid',this.model.get('_id'));
            $('#bookDateChange').data('starttime',startTime);
            $('#bookDateChange').data('endtime',endTime);
//            $('#alertConfirm').show();
//            $('#bookSearchAlert').removeClass('alert-danger').addClass('alert-success');
//            clearTimeout($('#alertConfirm').data('timeOut'));
//            $('#bookSearchAlert').show();
        }
        var popContent = this.popTemplate(popData);
//        var popTitle = $('#popTitle').html();
        this.popoverEl(popContent);
        $('#bookDateChange').popover('show');
//        $('#bookDateChange').data('roomid',this.model.get('_id'));
//        $('#bookDateChange').data('starttime',startTime);
//        $('#bookDateChange').data('endtime',endTime);
    },
    selectFailed:function(event) {
        if(!this.isSelecting) return;
        var event = event || window.event;
        var target = event.target || event.srcElement;
        this.isSelecting = false;
        this.$('.selectedTime').removeClass('selectedTime');
    },
    editbooking:function(event) {
        var event = event || window.event;
        var target = event.target || event.srcElement;
        var bookingId = $(target).data('bookingid');
        if(bookingId) {
            this.bookingViews[bookingId].editBooking();
        }
    },
    popoverEl:function(popContent){
        clearPop();
        $('#bookDateChange').popover('destroy');
        $('#bookDateChange').popover({
            placement: 'bottom',
            trigger: 'manual',
//            title:'   ',
            html:true,
//            viewport:'body',
            content:popContent
        });
    },
    showRoomDetail:function(){
//        var popContent = this.popTemplate(popData);
////        var popTitle = $('#popTitle').html();
//        this.popoverEl(popContent);
        this.roomDetailTemplate = _.template($('#popTemplateRoomDetail').html());
        var roomDetail = {};
        roomDetail.roomName = this.model.get('name');
        roomDetail.roomCapacity = this.model.get('capacity');
        roomDetail.needAudit = (this.model.get('isAudit') === 0) ? '否': '是';
        var popContentRoomDetail = this.roomDetailTemplate(roomDetail);
        this.popoverRoom(popContentRoomDetail)
//        this.$('.roomDetatil').popover({
//            placement: 'left',
//            trigger: 'manual',
//            html:true,
//            content:popContentRoomDetail
//        });
        this.$('.roomDetatil').popover('show');
    },
    hideRoomDetail:function(){
        this.$('.roomDetatil').popover('hide');
    },
    popoverRoom:function(popContentRoomDetail){
        this.$('.roomDetatil').popover('destroy');
        this.$('.roomDetatil').popover({
            placement: 'right',
            trigger: 'manual',
            html:true,
            content:popContentRoomDetail
        });
    }
})

/* BookingView*/
BookingView = Backbone.View.extend({
    tagName:'div',
    className:'occupied',
    template: _.template($('#popTemplate').html()) ,
    events:{
//        'focus .occupied-child':'showBooking',
//        'click .mybutton':'editBooking',
//        'blur .occupied-child':'hideBooking'
        'click ':'togglePopover'

    },
    initialize:function(){
        var data = this.model.toJSON();
        this.listenTo(this.model,'change',this.render);
        this.listenTo(this.model, "removeSelf", this.removeSelf);
        this.on('setBookingDiv',this.setBookingDiv);
//        var popData = {};
//        popData._id = data._id;
//        popData.startTime = new moment(data.startTime).format("HH:mm");
//        popData.endTime = new moment(data.endTime).format("HH:mm");
//        popData.roomName = (rooms.get(data.room)).get('name');
//        popData.roomCapacity = (rooms.get(data.room)).get('capacity');
//        popData.display = 'inline';
//        if(data.booker === $.cookie('userid')) {
//            popData.buttonContext = '编辑';
//        } else {
//            popData.buttonContext = '编辑';
//        }
//        var popContent = this.template(popData);
//        this.popoverEl(popContent);
//        $(this.$el).popover({
//            placement: 'top',
//            trigger: 'manual',
//            title:this.model.toJSON().name,
//            html:true,
//            viewport:'body',
//            content:popContent
//        });
    },
    render:function(){
        var data = this.model.toJSON();
        var checked = this.checkTimes();
        this.$el.html('<div class="occupied-child" ></div>');
//        this.$el.html('<div class="occupied-child" tabindex="-1" onfocus="console.log(\'focus\')" onblur="console.log(\'blur\')"></div>');
        this.bookingToggle(checked.className);
        this.$el.css('width',checked.width);
        this.$el.css('left',checked.left);
        this.trigger('setBookingDiv');
      return this;
    },
    setBookingDiv:function(){
        var previsousSt = this.model.previous('startTime');
        this.clearDivData(previsousSt,'bookstart');
        var previsousEnd = this.model.previous('startTime');
        this.clearDivData(previsousEnd,'bookend');
        var data = this.model.toJSON();
        this.setDivData(data.startTime,'bookstart');
        this.setDivData(data.endTime,'bookend');
//        var previsousSt = this.model.previous('startTime');
//        this.clearDivData(previsousSt,'bookstart');
//        var previsousEnd = this.model.previous('startTime');
//        this.clearDivData(previsousEnd,'bookend');
    },
    removeSelf:function(){
        var data = this.model.toJSON();
        this.clearDivData(data.startTime,'bookstart');
        this.clearDivData(data.endTime,'bookend');
        this.remove();
    },
    clearDivData:function(time,dataname){
        if(time) {
            time = moment(time).valueOf();
            var divNumber = new Date(time).getHours()
            this.$el.siblings('.booking-'+divNumber).data(dataname,null)
        } else {
//            console.log('elseTime')
        }
    },
    setDivData:function(time,dataname){
        if(time) {
            time = moment(time).valueOf();
            var divNumber = new Date(time).getHours();
            var divSeconds = this.timeToSeconds(time);
            this.setDivDetail(dataname,divNumber,divSeconds);
        } else {
//            console.log('elseTimeSet')
        }
    },
    setDivDetail:function(dataname,divNumber,divSeconds){
        (dataname === 'bookend')? divSeconds = divSeconds+60 :divSeconds = divSeconds-60;
        this.$el.siblings('.booking-'+divNumber).data(dataname,divSeconds)

    },
    checkTimes:function(){
        var data = this.model.toJSON();
        var tmStartTime = moment(data.startTime).valueOf();
        var startDate =new Date(tmStartTime).setHours(0,0,0,0);
        var today =new Date().setHours(0,0,0,0);
        var startTime = this.timeToSeconds(data.startTime);//(new Date(data.startTime).getHours())*60*60 + (new Date(data.startTime).getMinutes())*60 + (new Date(data.startTime).getSeconds());
        var endTime = this.timeToSeconds(data.endTime);//(new Date(data.endTime).getHours())*60*60 + (new Date(data.endTime).getMinutes())*60 + (new Date(data.endTime).getSeconds());
        var startPercent = startTime / 86400 * 100;
        var withPercent = (endTime - startTime) / 86400 * 100;
        var className = 'notBegin';
        var now = this.timeToSeconds(new Date());//(new Date().getHours())*60*60 + (new Date().getMinutes())*60 + (new Date().getSeconds());
        if(startDate>today || now < startTime ) {
            className ='notBegin';
        } else if(now < endTime) {
            className = 'hasBegin';
        } else {
            className = 'isEnd';
        }
        className = this.checkAudit(className);
        return {className:className,width:withPercent+'%',left:startPercent+'%'};
    },
    checkAudit:function(className){
        var data = this.model.toJSON();
        if(!data.isAudit){
            className = 'isAudit'
        }
        return className
    },
    bookingToggle:function(classname) {
        this.$('.occupied-child').removeClass('isAudit').removeClass('notBegin').removeClass('hasBegin').removeClass('isEnd').addClass(classname);
    },
//    showBooking:function(){
//        this.$el.popover('show')
//    },
//    hideBooking:function(){
//        this.$el.popover('hide');
//    },
    timeToSeconds:function(date) {
        date = moment(date).valueOf();
        var seconds = (new Date(date).getHours())*60*60 + (new Date(date).getMinutes())*60 + (new Date(date).getSeconds());
        return seconds;
    },
    editBooking:function(){
        var roomid = this.model.get('room');
        var id = this.model.get('_id');
        var startTime = this.model.get('startTime');
//        var endTime = this.model.get('endTime');
//        var start = moment(startTime);
//        var end = moment(endTime);
        startTime = moment(startTime).valueOf();

//        var formatStart = start.format('HH:mm');
//        var formatEnd = end.format('HH:mm');
//        var startToNow = start.diff(moment(),'minute');
//        var timeOut;
//        var hide = function() {
//            $('#bookSearchAlert').fadeOut();
//        }
//        $('#bookSearchAlert').css('left',$('body').width()/2-150);
//        $('#bookSearchAlert').css('top',$('body').height()/2+100);
//        if(startToNow <= 0) {
//            $('#alertFirst').html('会议时间:'+formatStart+'-'+formatEnd);
//            $('#alertSecond').html('当前时间:'+moment().format("HH:mm"));
//            $('#alertThird').html('超过开始时间得会议无法修改');
//            $('#alertConfirm').hide();
////            $('#bookSearchAlert').addClass('alert-danger').removeClass('alert-success');
//            $('#bookSearchAlert').show();
//            clearTimeout($('#alertConfirm').data('timeOut'));
//            timeOut = setTimeout(hide,2000);
//            $('#alertConfirm').data('timeOut',timeOut);
//            return ;
//        }
//        else if(startToNow <30){
//            $('#alertFirst').html('会议时间:'+formatStart+'-'+formatEnd);
//            $('#alertSecond').html('当前时间:'+moment().format("HH:mm"));
//            $('#alertThird').html('会议开始前半小时内无法再修改了');
//            $('#alertConfirm').hide();
//            $('#bookSearchAlert').addClass('alert-danger').removeClass('alert-success');
//            $('#bookSearchAlert').show();
//            clearTimeout($('#alertConfirm').data('timeOut'));
//            timeOut = setTimeout(hide,2000);
//            $('#alertConfirm').data('timeOut',timeOut);
//            return ;
//        }
        if(this.checkEdit()) window.location.href = '#edit/'+roomid+'/'+id+'/'+startTime+'/0';
    },
    togglePopover:function(){
        if(this.$el.next().hasClass('popover')) {
            this.$el.popover('hide');
        } else {
            clearPop();
            this.checkEdit();
            this.$el.popover('show');
        }

    },
    popoverEl:function(popContent){
        $(this.$el).popover('destroy');
        $(this.$el).popover({
            placement: 'top',
            trigger: 'manual',
//            title:this.model.get('name'),
            html:true,
            content:popContent
        });
    },
    checkEdit:function(){
        var startTime = this.model.get('startTime');
        var endTime = this.model.get('endTime');
        var start = moment(startTime);
        var end = moment(endTime);
        var room = this.model.get('room')
        var booker = this.model.get('booker')
        startTime = moment(startTime).valueOf();
//        var formatStart = start.format('HH:mm');
//        var formatEnd = end.format('HH:mm');

        var popData = {};
        popData._id = this.model.get('_id');
        popData.name = this.model.get('name');
        popData.startTime = new moment(startTime).format("HH:mm");
        popData.endTime = new moment(endTime).format("HH:mm");
        popData.roomName = (rooms.get(room)).get('name');
        popData.roomCapacity = (rooms.get(room)).get('capacity');

        var startToNow = start.diff(moment(),'minute');
        popData.buttonContext = '';
        popData.display = 'none';
        if(startToNow <= 0) {
//            var popData = {};
//            popData._id = this.model.get('_id');
//            popData.startTime = new moment(startTime).format("HH:mm");
//            popData.endTime = new moment(endTime).format("HH:mm");
//            popData.roomName = (rooms.get(room)).get('name');
//            popData.roomCapacity = (rooms.get(room)).get('capacity');
            popData.buttonContext = '';
//            popData.display = 'inline';
            popData.display = 'none';
            var popContent = this.template(popData);
            this.popoverEl(popContent);
            $(this.$el).popover('show');
//            this.popoverEl(popContent);
            return false;
        }
        if(booker === $.cookie('userid')) {
            popData.buttonContext = '编辑';
            popData.display = 'inline';
        }
        var popContent = this.template(popData);
        this.popoverEl(popContent);
        $(this.$el).popover('show');
        return true;
    }
})
