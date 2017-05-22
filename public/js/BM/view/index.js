_.templateSettings = {
    interpolate: /\{\{(.+?)\}\}/g
}

var BookingView = Backbone.View.extend({
    tagName: "tr",

    template: _.template($("#bookingTemplate").html()),

    events: {
        "mouseenter .booking-status-withdraw": "showReason",
        "mouseleave .booking-status-withdraw": "hideReason",
        "click .edit": "edit",
        "click .cancel": "cancel"
    },

    initialize: function() {
        this.listenTo(this.model, "change:status", this.render);
    },

    render: function() {
        var data = this.model.toJSON();
        data.duration = moment(data.startTime).format("YYYY-MM-DD") + " " + moment(data.startTime).format("HH:mm") + "-" + moment(data.endTime).format("HH:mm");
        if(3 === data.status) {
            data.status = "cancel";
            data.statusText = "已取消";
        } else if (0 === data.status) {
            if( 1 === data.isAudit) {
                var now = new moment().valueOf();
                var stime = moment(data.startTime).valueOf();
                var etime = moment(data.endTime).valueOf();
                if(now < stime) {
                    data.status = "before";
                    data.statusText = "未开始";
                } else if(now > etime) {
                    data.status = "end";
                    data.statusText = "已结束";
                } else {
                    data.status = "start";
                    data.statusText = "进行中";
                }
            } else if(0 === data.isAudit){
                data.status = "audit";
                data.statusText = "未审核";
            } else if(2 === data.isAudit) {
                data.status = "withdraw";
                data.statusText = "被退回";
            } else {
                data.status = "unknown";
                data.statusText = "未&nbsp&nbsp&nbsp知";
            }
        } else {
            data.status = "unknown";
            data.statusText = "未&nbsp&nbsp&nbsp知";
        }
        this.$el.html(this.template(data));
        this.$('.booking-status-withdraw').addClass('curpointer');
        return this;
    },

    showReason: function(event) {
        var reason = this.model.get("reason");
        this.$(event.target).popover({
            placement: 'bottom',
            trigger: 'manual',
            content:reason
        });
        this.$(event.target).popover('show');
    },
    hideReason:function(event) {
        this.$(event.target).popover('hide');
    },
    edit: function(event) {
        var ID = this.model.get("_id");
        var startTime = moment(this.model.get("startTime")).valueOf();
        var roomID = this.model.get("room").id || "";
        location.href = "/booking#edit/" + roomID + "/" + ID + "/" + startTime + "/2";
    },

    cancel: function(event) {
        if(confirm("取消后将不能恢复，确定取消？")) {
            this.model.save({status: 3}, {url:"/BM/" + this.model.get("_id") + "/cancel"}).done(function(model, jqXHR, options) {
            }).fail(function(model, jqXHR, options) {
                pop(event.target, "取消失败");
            });
        }
    }
});


var BookingsView = Backbone.View.extend({
    el: "body",

    events: {
        "click #cancelBtn": "cancelBooking",
        "click #allBookings": "selectAll",
        "click input[type='checkbox']": "selectOne",
        "click .page": "page",
        "click thead > tr > th.startTime": "sortByTime",
        "click thead > tr > th.room": "sortByRoom",
        "click thead > tr > th.name": "sortByName",
        "click thead > tr > th.booker": "sortByBooker",
        "click thead > tr > th.status": "sortByStatus"
    },

    initialize: function() {
        this.listenTo(this.collection, "add", this.addOne);
        this.listenTo(this.collection, "reset", this.clear);
        this.listenTo(this.collection, "page", this.loadPage);

        this.collection.fetch();
    },

    loadPage: function() {
        var data = this.collection;
        this.$("#pager .totalPages").text(data.totalPages);
        this.$("#pager .totalResults").text(data.totalResults);
        this.$("#pager .page.current").text(data.currentPage);
    },

    clear: function() {
        this.$("tbody").empty();
    },

    cancelBooking: function(event) {
        var ids = [];
        var that = this;
        var selected = this.$("input[type='checkbox']:not(#allBookings):checked").parent().siblings();
        var canceled = selected.has(".booking-status-cancel");
        var ended = selected.has(".booking-status-end");
        if(canceled.length > 0 || ended.length > 0)
            return pop(event.target, "请不要选择已取消或已结束的预约会议");

        this.$("input[type='checkbox']:not(#allBookings):checked").each(function(i,o) {
            ids.push(that.$(o).val());
        });

        if(0 === ids.length) return pop(event.target, "请先选择需要取消的预约会议");
        if(confirm("取消后将不能恢复，确定取消？")) {
            $.ajax({
                type: "PUT",
                url: "/BM/bookings/cancel",
                data: JSON.stringify(ids),
                contentType: "application/json; charset=utf-8"
            }).done(function(data, message, jqXHR) {
                    $(data).each(function(index, each) {
                        that.collection.get(each).set("status", 3);
                    })
                }).fail(function(a,b,c) {
                    pop(event.target, "取消失败");
                })
        }
    },

    selectAll: function() {
        var checked = this.$("#allBookings").prop("checked");
        var that = this;
        if(checked) {
            this.$("input[type='checkbox']").each(function(i, o) {
                that.$(o).prop("checked", true);
            })
        } else {
            this.$("input[type='checkbox']").each(function(i, o) {
                that.$(o).prop("checked", false);
            })
        }
    },

    selectOne: function() {
        var all = this.$("input[type='checkbox']:not(#allBookings)");
        var selected = this.$("input[type='checkbox']:not(#allBookings):checked");
        all.length === selected.length ? this.$("#allBookings").prop("checked", true) : this.$("#allBookings").prop("checked", false);
    },

    page: function(e) {
        var data = {};
        var p = this.collection;
        var which = $(e.target).attr("class");
        switch(which) {
            case "page previous":
                data.page = p.currentPage - 1;
                if(0 === data.page) {
                    return false;
                }
                break;
            case "page next":
                data.page = p.currentPage + 1;
                if(data.page > p.totalPages) {
                    return false;
                }
                break;
            case "page home":
                data.page = 1;
                if(data.page === p.currentPage) {
                    return false;
                }
                break;
            case "page end":
                data.page = p.totalPages;
                if(data.page === p.currentPage) {
                    return false;
                }
                break;
            case "page go":
                data.page = parseInt($("#gopage").val());
                if(data.page === p.currentPage || data.page < 1 || data.page > p.totalPages) {
                    return false;
                }
                break;
            default:
                return false;
        }
        data.pageSize = this.collection.pageSize;
        data.orderBy = this.collection.orderBy;
        data.orderDesc = this.collection.orderDesc;
        this.collection.reset();
        this.collection.fetch({data: data, wait: true});
    },

    sort: function(e, options) {
        if($(e.target).hasClass("dropup")) {
            $(e.target).removeClass("dropup");
            options.orderDesc = "desc";
        } else {
            $(e.target).addClass("dropup");
            options.orderDesc = "asc";
        }
        this.collection.reset();
        this.collection.fetch({data: options, wait: true});
    },

    sortByTime: function(e) {
        var options = {};
        options.orderBy = "startTime";
        this.sort(e, options);
    },

    sortByRoom: function(e) {
        var options = {};
        options.orderBy = "room";
        this.sort(e, options);
    },

    sortByName: function(e) {
        var options = {};
        options.orderBy = "name";
        this.sort(e, options);
    },

    sortByBooker: function(e) {
        var options = {};
        options.orderBy = "booker";
        this.sort(e, options);
    },

    sortByStatus: function(e) {
        var options = {};
        options.orderBy = "status";
        this.sort(e, options);
    },

    addOne: function(booking) {
        var bookingView = new BookingView({model: booking});
        this.$("tbody").append(bookingView.render().el);
    }
});