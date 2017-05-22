/* BookingSubmitView */


BookingSubmitView = Backbone.View.extend({
    el:'#bookSubmitMain',
    events:{
        'click #bookingSave':'bookingSave',
        'click #btnAddInternal':'btnAddInternal',
        'click #btnAddExternal':'btnAddExternal',
        'mousedown .bookingDetail':'startSelect',
        'mousemove .mainTimes-ing':'selecting',
        'mouseup .mainTimes-ing':'selectedBooking',
        'mouseleave .mainTimes-ing':'selectFailed',
        'mouseenter .occupied-ing':'selectFailed',
        'click .tempTime':'cancelSelect',
        'blur #txtStartTime':'changeSelect',
        'blur #txtEndTime':'changeSelect',
        'click #btnSaveExternal':'btnSaveExternal',
        'click #btnAddMoreExternal':'btnAddMoreExternal',
        'click #addInternalConfirmBtn':'addInternalConfirmBtn',
        'click #addInternalContinue':'addInternalContinue',
        'click #bookingBack':'bookingBack'



    },
    initialize:function(options){
        this.initData(options.model,options.bookingModel,options.returnUrl);
        this.listenTo(this.model,'change',this.render);
        this.listenTo(externalUsers,'add',this.addOneExternalUser);
        this.listenTo(submitUsers,'add',this.addOneInternal);
        this.roomBookings = new Bookings;
        this.listenTo(this.roomBookings,'add',this.addOneOccupiedView);
        validator.bind();
    },
    initData:function(model,bookingModel,returnUrl) {
        this.returnUrl = returnUrl;
        this.$('.tempTime').remove();
        if(this.roomBookings) this.roomBookings.reset();
        this.$('.occupied-ing').remove();
        this.lastStart = ''
        this.lastEnd = ''
        this.bookingOccupiedViews = {};
        this.checkedTimes = [];
        var that = this;
        this.isSelecting = false;
        this.model = model;
        this.bookingModel = bookingModel;
        var tasks = [];
        this.date = moment((that.bookingModel.get('startTime'))).format('YYYY-MM-DD');
        this.$('#bookedDate').html(this.date);
        var fetchRoom = function(callback) {
            that.model.fetch({
                success:function(model, response, options){
                    $('#imgURL').attr('src','/img/room.png');
                    if(model.get('imgURL')) {
                        $('#imgURL').attr('src',model.get('imgURL'));
                    }
                    var roomIds = [];
                    roomIds.push(model.get('_id'));
                    callback(null,roomIds);
                },
                error:function(model, response, options){
                    callback('获取当前会议室错误');
                }
            });
        };
        tasks.push(fetchRoom);
        var fetchRoomBookings = function(roomIds,callback) {
            that.roomBookings.fetch({
                url:'/bookings',
                data:{roomIds:roomIds,date:that.date},
                success:function(collection, response, options){
                    if(that.bookingModel.get('_id')!== undefined) {
                        that.bookingModel = collection.get(that.bookingModel.get('_id')) ? collection.get(that.bookingModel.get('_id')) : that.bookingModel;
                    }
                    callback(null);
                },
                error:function(collection, response, options){
                    callback('roomBookings获取错误');
                }
            });
        };
        tasks.push(fetchRoomBookings);
        async.waterfall(tasks,function(err,result) {
            if(err) alert(err);
            that.render();
            externalUsers.reset();
            externalUsers.add(that.bookingModel.get('externalUsers'));
            submitUsers.reset();
            submitUsers.add(that.bookingModel.get('users'));
        });
    },
    render:function(){
//        console.log(groubBookingModel === this.bookingModel)
//        groubBookingModel = this.bookingModel
        var data = this.bookingModel.toJSON();
        var startTime =moment((data.startTime)).format('HH:mm');
        var endTime =moment((data.endTime)).format('HH:mm');
        var name  = data.name || '';
        var remarks  = data.remarks || '';
        if(!this.checkAllBookings(startTime,endTime)) {
            this.$('.tempTime').remove();
            this.$('#txtStartTime').val('');
            this.$('#txtEndTime').val('');
        }else{
            this.$('#txtStartTime').val(startTime);
            this.$('#txtEndTime').val(endTime);
            this.changeSelect();
        }
        this.$('.room_info h4').html(this.model.toJSON().name)
        this.$('#bookedRoomcapacity').html(this.model.toJSON().capacity+'人')
        this.$('#txtName').val(name);
        this.$('#txtRemarks').val(remarks);
    },
    bookingSave:function() {
        var that = this;
        if(!validator.validateAll("#bookingSubmitInfo")) return false;
        var name = this.$('#txtName').val();
        var startTime =this.$('#bookedDate').html()+' '+this.$('#txtStartTime').val();
        var endTime = this.$('#bookedDate').html()+' '+this.$('#txtEndTime').val();
        var start = moment(startTime);
        var startToNow = start.diff(moment(),'minute');
        if(startToNow <= 0) return popBy('#txtStartTime',false,'会议开始时间不能小于当前时间:'+moment().format('HH:mm'),'bottom');
        var remarks = this.$('#txtRemarks').val();
        var subUsers = submitUsers.map(function(user){
            return user.get('_id');
        });
        var subExter = externalUsers.map(function(extUser){
            var data = {};
            data.name = extUser.get('name');
            data.company = extUser.get('company');
            data.email = extUser.get('email');
            data.telephone = extUser.get('telephone');
            data.mobilePhone = extUser.get('mobilePhone');
            return data;
        })
        this.bookingModel.set({name:name,startTime:startTime,endTime:endTime,users:subUsers,externalUsers:subExter,remarks:remarks})
        this.bookingModel.save({wait:true}).done(function(response,message,jqXHR){
            isSave = true;
            window.location.href = that.returnUrl;
        }).fail(function(response,message,jqXHR){
                popBy('#bookingSave',false,response.responseText,'bottom');
            });


    },
    btnAddInternal:function(){
        $('#modalInternal').modal('show');
        this.$('#addInternalConfirmBtn').show();
        this.$('#addInternalContinue').hide();
        this.$('#addInternalCancelBtn').html('取消');
    },
    btnAddExternal:function(){
        $('#addExternalForm').find('input').val('');
        $('#btnSaveExternal').show();
        $('#btnAddMoreExternal').hide();
        $('#modalExternal').modal('show');

    },
    startSelect:function(event){
        this.$('.tempTime').remove();
        var event = event || window.event;
        var target = event.target || event.srcElement;
        getOffset(event);
        var targetIndex = this.$(target).index();
        if($(target).hasClass('scale-time-text')) return ;
        this.leftInit = 50*targetIndex+event.offsetX;
//        this.$('#room_info h2').html(this.offsetY);
        this.isSelecting = true;
        this.$('.mainTimes-ing').append('<div class="tempTime" style="position: absolute;width:0px;height: 49px; left: '+this.leftInit+'px;background-color:#800080 ;border-bottom: 1px solid #000000;"></div>')
        this.$('#txtStartTime').val(this.coordinateToTime(this.leftInit));
        this.$('#txtEndTime').val('');
    },
    selecting:function(event){
        if(!this.isSelecting) return;
        var event = event || window.event;
        var target = event.target || event.srcElement;
        getOffset(event);
        if($(target).hasClass('scale-time-text')) return ;
        var divIndex = this.$(target).index();
        if(divIndex < 24) {
            this.divX = 50*divIndex+event.offsetX;
            this.divWidth = this.divX > this.leftInit ? this.divX-this.leftInit : this.leftInit-this.divX;
            this.divLeft = this.divX > this.leftInit ? this.leftInit : this.divX;
        }else if (this.divLeft === this.leftInit) {
            this.divWidth = event.offsetX;
            this.divLeft = this.leftInit;
        } else {
            this.rightX = this.leftInit;
            this.divWidth = this.$('.tempTime').width() - event.offsetX;
            this.divLeft = this.rightX-this.divWidth;
        }
        this.$('.tempTime').css('left',this.divLeft);
        this.$('.tempTime').css('width',this.divWidth);
        this.$('#txtStartTime').val(this.coordinateToTime(this.divLeft));
        this.$('#txtEndTime').val(this.coordinateToTime(this.divLeft+this.divWidth));
    },
    selectedBooking:function(event){
        this.isSelecting = false;
    },
    coordinateToTime:function(number) {
        var seconds = (86400*number)/1200;
        var startTime = this.bookingModel.get('startTime');
        startTime = moment(startTime).valueOf()
        var time =moment(new Date((startTime)).setHours(0,0,seconds,0)).format('HH:mm');
        return time;

    },
    timeToCoordinate:function(time) {
        var startTime = this.bookingModel.get('startTime');
        var now = moment((startTime)).format('YYYY-MM-DD')+' '+time;
        now = moment(now).valueOf();
        var useingTime = new Date(now);
        var seconds = (useingTime.getHours())*60*60 + (useingTime.getMinutes())*60 + (useingTime.getSeconds());
        var coordinate = seconds*1200/86400;//24*60*60=86400
        return coordinate;
    },
    cancelSelect:function(){
        this.$('.tempTime').remove();
        this.$('#txtStartTime').val('');
        this.$('#txtEndTime').val('');
    },
    selectFailed:function(){
        if(!this.isSelecting) return;
        this.isSelecting = false;
    },
    changeSelect:function(){
        this.$('.tempTime').remove();
        var startTime = this.$('#txtStartTime');
        var endTime = this.$('#txtEndTime');
        if(!this.checkAllBookings(startTime.val(),endTime.val())) {
            var st = this.lastStart || '';
            var ed = this.lastEnd || '';
            startTime.val(st);
            endTime.val(ed);
        } else {
            this.lastStart =startTime.val();
            this.lastEnd =endTime.val();
        }

        var leftDiv = this.timeToCoordinate(startTime.val());
        var right = this.timeToCoordinate(endTime.val());

        var divWidth  = right-leftDiv;
        this.$('.mainTimes-ing').append('<div class="tempTime" style="position: absolute;width:'+divWidth+'px;height: 49px; left: '+leftDiv+'px;background-color: #800080;border-bottom: 1px solid #000000;"></div>')
    },
    btnSaveExternal:function(){
        if(!validator.validateAll("#addExternalForm")) return false;
        var name = this.$('#extName').val();
        var company = this.$('#extCompany').val();
        var email = this.$('#extEmail').val();
        var telephone = this.$('#extPhone').val();
        var mobilePhone = this.$('#extTel').val();
        var gender = this.$('.rdMale:checked').length>0 ? 1 :0 ;
        var tempExternalUser = new ExternalUser({name:name,company:company,email:email,telephone:telephone,mobilePhone:mobilePhone,gender:gender});
        externalUsers.add(tempExternalUser);
        this.$('#btnSaveExternal').hide();
        this.$('#btnAddMoreExternal').show();
    },
    btnAddMoreExternal:function(){
        this.$('#extName').val('');
        this.$('#extEmail').val('');
        this.$('#extPhone').val('');
        this.$('#extTel').val('');
        this.$('#btnSaveExternal').show();
        this.$('#btnAddMoreExternal').hide();
    },
    addOneExternalUser:function(model,collection){
        var view = new ExternalUserDisplayView({model:model});
        this.$('#divExternalArea').append(view.el)
    },
    addOneOccupiedView:function(model,collection){
        if(this.bookingModel.get('_id') === (model.get('_id'))) return;
        this.bookingOccupiedViews[model.get('_id')] = new BookingOccupiedView({model:model});
        this.$('.mainTimes-ing').append(this.bookingOccupiedViews[model.get('_id')].render().el);
        this.checkedTimes.push(this.bookingOccupiedViews[model.get('_id')].getTimes());
    },
    checkAllBookings:function(startTime,endTime){
        var startSeconds = this.timeToSeconds(startTime);
        var endSeconds = this.timeToSeconds(endTime);
        if (startSeconds > endSeconds) return false;
        var flag = true;
        $.each(this.checkedTimes,function(i,o) {
            if(!(o.startSeconds >endSeconds || o.endSeconds < startSeconds))  {
                flag = false;
                return false;
            }
        });
        return flag;
    },
    timeToSeconds:function(time) {
        var date = this.date;
        var now = date+' '+time;
        now = moment(now).valueOf();
        var time = new Date(now);
        var seconds = (time.getHours())*60*60 + (time.getMinutes())*60 + (time.getSeconds());
        return seconds;
    },
    addInternalConfirmBtn:function(){
        var chkItems = this.$('.chkItem:checked');
        var chkItemsFalse = this.$('.chkItem:not(:checked)');
        $.each(chkItems,function(i,o){
            submitUsers.add(users.get($(o).val()));
        })
        $.each(chkItemsFalse,function(i,o){
            submitUsers.remove(users.get($(o).val()));
        })
        this.$('#addInternalConfirmBtn').hide();
        this.$('#addInternalContinue').show();
        this.$('#addInternalCancelBtn').html('完成');
//        this.$('#addInternalComplete').show();
    },
    addInternalContinue:function(){
        this.$('#addInternalConfirmBtn').show();
        this.$('#addInternalContinue').hide();
        this.$('#addInternalCancelBtn').html('取消');
//        this.$('#addInternalComplete').hide();
    },
    addOneInternal:function(model,collection){
        var view = new UserDisplayView({model:model});
        this.$('#divInternalArea').append(view.el)
    },
    bookingBack:function() {
        if(this.returnUrl === '#') {
            if(confirm('返回后将丢失修改过的数据，确定返回？')) {
                window.location.href = this.returnUrl;
            }
        } else {
            window.location.href = this.returnUrl;
        }

    }
})

ExternalUserDisplayView = Backbone.View.extend({
    tagName:'div',
    className:'btn btn-primary gap-right',
    events: {
        "click .deleteExternalUser":"deleteExternalUser"
    },
    initialize:function(){
        var data = this.model.toJSON();
        var button = "<button type='button' class='close deleteExternalUser'>&nbsp&times</button>"
        this.$el.html(button+data.name);
        this.listenTo(this.model, "removeSelf", this.remove);
        this.listenTo(externalUsers, "reset", this.remove);
    },
    deleteExternalUser:function(){
        externalUsers.remove(this.model);
    }
})

UserDisplayView = Backbone.View.extend({
    tagName:'div',
    className:'btn btn-primary gap-right',
    events: {
        "click .deleteUser":"deleteUser"
    },
    initialize:function(){
        var data = this.model.toJSON();
        var button = "<button type='button' class='close deleteUser'>&nbsp&times</button>"
        this.$el.html(button+data.name);
        this.listenTo(this.model, "removeSelf", this.remove);
        this.listenTo(submitUsers, "reset", this.remove);
    },
    deleteUser:function(){
        submitUsers.remove(this.model);
    }
})

/* BookingOccupiedView*/
BookingOccupiedView = Backbone.View.extend({
    tagName:'div',
    className:'occupied-ing',
    template: _.template($('#popBookingTemplate').html()) ,
    events:{
        'mouseenter ':'showBooking',
        'mouseleave ':'hideBooking'

    },
    initialize:function(){
        var data = this.model.toJSON();
        this.listenTo(this.model,'change',this.render);
        this.listenTo(this.model, "removeSelf", this.remove);
        var data = this.model.toJSON();
        var popData = {};
        popData.startTime = new moment(data.startTime).format("HH:mm");
        popData.endTime = new moment(data.endTime).format("HH:mm");
//        alert(rooms.get(data.room))
//        alert(rooms.length)
        var popContent = this.template(popData);
        $(this.$el).popover({
            placement: 'bottom',
            trigger: 'manual',
            title:this.model.toJSON().name,
            html:true,
            content:popContent
        });
    },
    render:function(){
        var data = this.model.toJSON();
        var checked = this.checkTimes();
        this.$el.html('<div class="occupied-child-ing"></div>');
        this.bookingToggle(checked.className);
        this.$el.css('width',checked.width);
        this.$el.css('left',checked.left);
        return this;
    },
    checkTimes:function(){
        var data = this.model.toJSON();
        var tmStartTime = moment(data.startTime).valueOf();
        var startDate =new Date(tmStartTime).setHours(0,0,0,0);
        var today =new Date().setHours(0,0,0,0);
        var startTime = this.timeToSeconds(data.startTime);
        var endTime = this.timeToSeconds(data.endTime);
        var startPercent = startTime / 86400 * 100;
        var withPercent = (endTime - startTime) / 86400 * 100;
        var className = 'notBegin';
        var now = this.timeToSeconds(new Date());
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
        this.$('.occupied-child-ing').removeClass('isAudit').removeClass('notBegin').removeClass('hasBegin').removeClass('isEnd').addClass(classname);
    },
    showBooking:function(){
        this.$el.popover('show')
    },
    hideBooking:function(){
        this.$el.popover('hide');
    },
    timeToSeconds:function(date) {
        date = moment(date).valueOf();
        var seconds = (new Date(date).getHours())*60*60 + (new Date(date).getMinutes())*60 + (new Date(date).getSeconds());
        return seconds;
    },
    getTimes:function() {
        var data = this.model.toJSON();
        var startSeconds = this.timeToSeconds(data.startTime);
        var endSeconds = this.timeToSeconds(data.endTime);
        return {startSeconds:startSeconds,endSeconds:endSeconds};
    }
})