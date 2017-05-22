/**
 * Created by shgbit on 2014/7/14.
 */
_.templateSettings = {
    interpolate: /\{\{(.+?)\}\}/g
};

var NoticeView = Backbone.View.extend({
    tagName: "tr",

    id: function() {return "notice"+this.model.get("_id");},

    template: _.template($("#noticeTemplate").html()),

    events: {
        "click button.remove": "remove"
    },

    initialize: function() {
        this.listenTo(this.model, "change", this.render);
    },
    render: function() {
        var data = this.model.toJSON();
        data.id=data._id;
//        data.date = moment(data.booking.startTime).format("YYYY年MM月DD日");
        data.duration=moment(data.booking.startTime).format("YYYY-MM-DD")+" "+moment(data.booking.startTime).format("HH:mm") + "-" + moment(data.booking.endTime).format("HH:mm");
        data.room=data.booking.room.name;
        data.theme=data.booking.name;
        data.reservation=data.booker.name;
        this.$el.html(this.template(data));
        return this;
    },

    remove: function(event) {
        if(confirm("删除后将不能恢复，确认删除吗？")) {
            var noticeid = this.model.get("_id");
            var id=this.el.id;
            if (!id) return;
            $.ajax({
                type: "DELETE",
                url: "/notice",
                data: JSON.stringify({id: noticeid }),
                contentType: "application/json; charset=utf-8",
                success: function(json){
                    if(!json || json.status == 'fail') return popBy($(obj).parent(), false, json.result);
                    $('#'+id).remove();
                }
            });
        }
    }
});


var NoticesView = Backbone.View.extend({
    el: "body",

    events: {
        "click #removeBtn": "removeNotice",
        "click #allNotices": "selectAll",
        "click input[type='checkbox']": "selectOne",
        "click #searchBtn": "search",
        "keyup #inputSearch": "search",
        "click thead > tr > th.time": "sortByTime",
        "click thead > tr > th.room": "sortByRoom",
        "click thead > tr > th.name": "sortByName",
        "click thead > tr > th.booker": "sortByBooker"
    },

    initialize: function() {
        this.listenTo(this.collection, "add", this.addOne);
        this.listenTo(this.collection, "sort", this.render);
        this.listenTo(this.collection, 'remove', this.removeOne);

        this.collection.fetch();
    },

    render: function() {
        var that = this;
        this.$("tbody").empty();
        this.collection.each(function(model) {
            that.addOne(model);
        })
    },
    sort: function(e, keyword, getValue) {
        var option;
        if($(e.target).hasClass("dropup")) {
            option = "desc";
            $(e.target).removeClass("dropup");
        } else {
            option = "asc";
            $(e.target).addClass("dropup");
        }
        this.collection.comparator = function(m1, m2) {
            var n1, n2, result;
            if(getValue) {
                n1 = getValue(m1);
                n2 = getValue(m2);
            } else {
                n1 = m1.get(keyword);
                n2 = m2.get(keyword);
            }
//            console.log(n2)
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
        };
        this.collection.sort();
    },
    sortByTime:function(e) {
        var keyword = "startTime";
        var getValue = function(m) {
            return m.get("booking").startTime || 0;
        };
        this.sort(e, null, getValue);
    },
    sortByRoom:function(e) {
        var keyword = "room";
        var getValue = function(m) {
            return m.get("booking").room.name || '';
        };
        this.sort(e, null, getValue);
    },
    sortByName: function(e) {
        var keyword = "name";
        var getValue = function(m) {
            return m.get("booking").name || '';
        };
        this.sort(e, null, getValue);
    },
    sortByBooker: function(e) {
        var keyword = "booker";
        var getValue = function(m) {
            return m.get("booker").name || "";
        };
        this.sort(e, null, getValue);
    },
    removeOne: function(model, collection) {
        model.destroy();
    },
    selectAll: function() {
        var checked = this.$("#allNotices").prop("checked");
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
        var all = this.$("input[type='checkbox']:not(#allNotices)");
        var selected = this.$("input[type='checkbox']:not(#allNotices):checked");
        all.length === selected.length ? this.$("#allNotices").prop("checked", true) : this.$("#allNotices").prop("checked", false);
    },

    addOne: function(notice) {
        console.log(notice)
        var noticeView = new NoticeView({model: notice});
        this.$("tbody").append(noticeView.render().el);
    },
    removeNotice: function(event) {
        var ids = [];
        var that = this;
        this.$("input[type='checkbox']:not(#allNotices):checked").each(function(i,o) {
            ids.push(that.$(o).val());
        });

        if(0 === ids.length) return pop(event.target,"请先选择需要删除的通知");
        if(confirm("删除后将不能恢复，确认删除吗？")) {
                $.ajax({
                    type: "DELETE",
                    url: "/notices",
                    data: JSON.stringify({ids: ids }),
                    contentType: "application/json; charset=utf-8",
                    success: function(json){
                        if(!json || json.status == 'fail') return popBy($(obj).parent(), false, json.result);
                        that.$("input[type='checkbox']:not(#allNotices):checked").closest('tr').remove();
                    }

                });
        }
    },
    search: function(){
        $("tr[id^='notice']").hide();
        if ($("#inputSearch").val() == "") {
            $("tr[id^='notice']").show();
        } else {
            $("tr[id^='notice']").each(function (index, domEle) {
                var divobj = $(this).find("td[id^='theme']");
                if (divobj.length > 0) {
                    if (divobj.html().indexOf($("#inputSearch").val()) != -1) {
                        $(this).show();
                    }
                }
            });
        }
    },
    sortBy: function(attribute) {
// TODO sortBy
    }
});