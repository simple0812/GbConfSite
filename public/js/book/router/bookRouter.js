BookRouter = Backbone.Router.extend({
    routes: {
        "":                 "main",    // /sadas/#
        "booking/:roomId/:startTime/:endTime":                 "booking",  // / ＃booking sadas/#
        "edit/:roomId/:bookingID/:startTime/:type":                 "edit"  // /sadas/#
    },
    initialize: function() {
        this.hasBooking = false;
    },
    main:function() {
        isSave = true;
        clearPop();
        this.bookerView = this.bookerView || new BookView;
        this.bookerView.search();
        $('#bookmain').show();
        this.bookerView.checkConditionHeight();
        $('#bookSearchAlert').hide();
        $('#bookSubmitMain').hide();
    },
    booking: function(roomId,startTime,endTime) {
        isSave = false;
        clearPop();
        var room = rooms.get(roomId) ? rooms.get(roomId) : new Room({_id:roomId});
        startTime = moment(parseInt(startTime)).format('YYYY-MM-DD HH:mm')
        endTime = moment(parseInt(endTime)).format('YYYY-MM-DD HH:mm')
        var bookingModle = new Booking({startTime:startTime,endTime:endTime,room:room.get('_id')})
        this.renderBookingView(room,bookingModle,'#');
    },
    edit:function(roomID,bookingID,startTime,type){
        var backUrl = this.getBackUrl(type);
        var that = this;
        isSave = false;
//        var that = this;
//        this.isSave = false;
//        window.onbeforeunload = function() {
//            if(!that.isSave) return ('确定要离开?未保存的数据将丢失')
//        }

        clearPop();
        var room = rooms.get(roomID) ? rooms.get(roomID) : new Room({_id:roomID});
        startTime = moment(parseInt(startTime)).format('YYYY-MM-DD HH:mm')
        var bookingModle = bookings.get(bookingID) ? bookings.get(bookingID) :  new Booking({room:room.get('_id'),_id:bookingID,startTime:startTime});
        console.log(JSON.stringify(bookingModle))
        if(type === '1' || type === '2') {

            bookingModle.fetch({
                success:function(model, response, options){
//                    console.log(JSON.stringify(model))
//                    console.log(JSON.stringify(response))
//                    console.log(JSON.stringify(options))
                    bookingModle = new Booking(bookingModle.toJSON());
                    that.renderBookingView(room,bookingModle,backUrl);
                },
                error:function(model, response, options){
                    callback('获取当前会议错误');
                }
            });

//            bookingModle.fetch();
//            this.renderBookingView(room,bookingModle,backUrl);
        } else {
            this.renderBookingView(room,bookingModle,backUrl);
        }

    },
    renderBookingView:function(room,bookingModle,returnUrl){
        var that = this;
        var tasks = [];
        if(!this.hasBooking) {
            if(!(navigator.userAgent.indexOf("MSIE 8.0")>0)) {
                tasks.push({id:'#dynamicJs',url:'js/book/model/externalUser.js'});
                tasks.push({id:'#dynamicJsUser',url:'js/book/model/user.js'});
                tasks.push({id:'#dynamicJs3',url:'js/organization/organization.js'});
                tasks.push({id:'#dynamicJs2',url:'js/book/booking.js'});
            }
            tasks.push({id:'#bookSubmitMain',url:'/book2 #bookSubmitMainDetail'});

        }
        var FN = function(obj,callback){
            $(obj.id).load(obj.url,function(response, status, xhr){
                var err = status == 'success'?null:'err';
                callback(err)
            })
        };
        async.eachSeries(tasks,FN,function(err) {
            if(!that.hasBooking) {
                initTree();
                scrollUserList();
            }
            if(!err)  that.bookingSubmitView ? that.bookingSubmitView.initData(room,bookingModle,returnUrl) : (that.bookingSubmitView = new BookingSubmitView({model:room,bookingModel:bookingModle,returnUrl:returnUrl}));
            that.hasBooking = true;

        });
        $('#bookmain').hide();
        $('#bookSubmitMain').show();
    },
    getBackUrl:function(type){
        var backUrl = '#';
        switch (type){
            case "0":backUrl = '#';break;
            case "1":backUrl = '/MB/index';break;
            case "2":backUrl = '/BM/index';break;
            default :backUrl = '#';break;
        }
        return backUrl;
    }
})
$(function(){
    var bookRouter = new BookRouter();
    Backbone.history.start();
})