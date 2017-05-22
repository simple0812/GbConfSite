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
//        this.listenTo(this.model, "change", this.render);
        this.listenTo(this.model, "change:status", this.render);

    },

    render: function() {
        var data = this.model.toJSON();
        data.duration = moment(data.startTime).format("YYYY-MM-DD") + " " + moment(data.startTime).format("HH:mm") + "-" + moment(data.endTime).format("HH:mm");
/* 用于前台排序（我的预约，一次性返回所有数据）
        if (0 === data.status) {
            if( 1 === data.isAudit) {
                var now = new moment().valueOf();
                var stime = moment(data.startTime).valueOf();
                var etime = moment(data.endTime).valueOf();
                if(now < stime) {
                    data.status = "before";
                    data.statusText = "未开始";
                    data.editable = "block";
                    data.cancelable = "block";
                } else if(now > etime) {
                    data.status = "end";
                    data.statusText = "已结束";
                    data.editable = "none";
                    data.cancelable = "none";
                } else {
                    data.status = "start";
                    data.statusText = "进行中";
                    data.editable = "none";
                    data.cancelable = "block";
                }
            } else {
                data.status = "audit";
                data.statusText = "未审核";
                data.editable = "block";
                data.cancelable = "block";
            }
        } else {
            data.status = "unknown";
            data.statusText = "未知";
            data.editable = "none";
            data.cancelable = "none";
        }
*/
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
                data.statusText = "被退回"

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
//        pop(event.target, this.model.get("reason"));
    },
    hideReason:function(event) {
        this.$(event.target).popover('hide');
    },
    edit: function(event) {
        var ID = this.model.get("_id");
        var startTime = moment(this.model.get("startTime")).valueOf();
        var roomID = this.model.get("room").id;
        location.href = "/booking#edit/" + roomID + "/" + ID + "/" + startTime + "/1";
    },

    cancel: function(event) {
        if(confirm("取消后将不能恢复，确定取消？")) {
            this.model.save({status:3},{url:"/MB/" + this.model.get("_id") + "/cancel"}).done(function(model, jqXHR, options) {
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
        "click thead > tr > th.time": "sortByTime",
        "click thead > tr > th.room": "sortByRoom",
        "click thead > tr > th.name": "sortByName",
        "click thead > tr > th.status": "sortByStatus"
    },

    initialize: function() {
        this.listenTo(this.collection, "add", this.addOne);
        this.listenTo(this.collection, "reset", this.clear);
//        this.listenTo(this.collection, "sort", this.render);
        this.listenTo(this.collection, "page", this.loadPage);

        this.collection.fetch();
    },

    loadPage: function() {
        var data = this.collection;
        this.$("#pager .total").text(data.total);
        this.$("#pager .totalItems").text(data.totalItems);
        this.$("#pager .page.current").text(data.current);
    },

    clear: function() {
        this.$("tbody").empty();
    },
/* 用于获取所有数据时的排序
    render: function() {
        var that = this;
        this.$("tbody").empty();
        this.collection.each(function(model) {
            that.addOne(model);
        })
    },
*/
    cancelBooking: function(event) {
        var ids = [];
        var that = this;
        if(this.$("input[type='checkbox']:not(#allBookings):checked").parent().siblings().has(".booking-status-cancel").length > 0)
            return pop(event.target, "请不要选择已取消的预约会议");

        this.$("input[type='checkbox']:not(#allBookings):checked").each(function(i,o) {
            ids.push(that.$(o).val());
        });

        if(0 === ids.length) return pop(event.target, "请先选择需要取消的预约会议");
        if(confirm("取消后将不能恢复，确定取消？")) {
            $.ajax({
                type: "PUT",
                url: "/MB/bookings/cancel",
                data: JSON.stringify(ids),
                contentType: "application/json; charset=utf-8"
            }).done(function(data, message, jqXHR) {
                    $(data).each(function(index, each) {
                        that.collection.get(each).set("status", 3);
                    });
                }).fail(function(a,b,c) {
                    console.log('error',a,b,c);
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
                data.page = p.current - 1;
                if(0 === data.page) {
                    return false;
                }
                break;
            case "page next":
                data.page = p.current + 1;
                if(data.page > p.total) {
                    return false;
                }
                break;
            case "page home":
                data.page = 1;
                if(data.page === p.current) {
                    return false;
                }
                break;
            case "page end":
                data.page = p.total;
                if(data.page === p.current) {
                    return false;
                }
                break;
            case "page go":
                data.page = parseInt($("#gopage").val());
                if(data.page === p.current || data.page < 1 || data.page > p.total) {
                    return false;
                }
                break;
            default:
                return false;
        }
        data.pagesize = this.collection.pagesize;
        data.orderBy = this.collection.orderBy;
        data.orderMode = this.collection.orderMode;
        this.collection.reset();
        this.collection.fetch({data: data, wait: true});
    },

    sort: function(e, options) {
        if($(e.target).hasClass("dropup")) {
            $(e.target).removeClass("dropup");
            options.orderMode = "desc";
        } else {
            $(e.target).addClass("dropup");
            options.orderMode = "asc";
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

    sortByStatus: function(e) {
        var options = {};
        options.orderBy = "status";
        this.sort(e, options);
    },
/* 用于获取所有数据时的排序
    sort: function(e, keyword, getValue) {
        if($(e.target).hasClass("dropup")) {
            option = "desc";
            $(e.target).removeClass("dropup");
        } else {
            option = "asc";
            $(e.target).addClass("dropup");
        }
        this.collection.comparator = function(m1, m2) {
            var n1,n2, result;
            if(getValue) {
                n1 = getValue(m1);
                n2 = getValue(m2);
            } else {
                n1 = m1.get(keyword);
                n2 = m2.get(keyword);
            }
            if("desc" === option) {
                if(n1 > n2) {
                    result = -1;
                } else {
                    result = 1;
                }
            } else {
                if(n1 > n2) {
                    result = 1;
                } else {
                    result = -1;
                }
            }
            return result;
        }
        this.collection.sort();
    },

    sortByTime: function(e) {
        var getValue = function(m) {
            return moment(m.get("startTime")).valueOf();
        }
        this.sort(e, null, getValue);
    },

    sortByRoom: function(e) {
        var getValue = function(m) {
            return m.get("room").name || "";
        }
        this.sort(e, null, getValue);
    },

    sortByName: function(e) {
        var keyword = "name";
        this.sort(e, keyword);
    },

    sortByStatus: function(e) {
        var getValue = function(m) {
            var status = {unknown: 5, audit: 4, end: 3, start: 2, before: 1};
            var data = m.toJSON();
            var value;
            if (0 === data.status) {
                if( 1 === data.isAudit) {
                    var now = new moment().valueOf();
                    var stime = moment(data.startTime).valueOf();
                    var etime = moment(data.endTime).valueOf();
                    if(now < stime) {
                        value = status.before;
                    } else if(now > etime) {
                        value = status.end;
                    } else {
                        value = status.start;
                    }
                } else {
                    value = status.audit;
                }
            } else {
                value = status.unknown;
            }
            return value;
        }
        this.sort(e, null, getValue);
    },
*/

    addOne: function(booking) {
        var bookingView = new BookingView({model: booking});
        this.$("tbody").append(bookingView.render().el);
    }
});