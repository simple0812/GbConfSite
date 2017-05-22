_.templateSettings = {
    interpolate: /\{\{(.+?)\}\}/g
}

// room index 页面的一条room的view
var RoomView = Backbone.View.extend({
    tagName: 'tr',

    template: _.template($("#roomItemTemplate").html()),

    events: {
        'click .edit': 'edit',
        'click .delete': 'clear'
    },

    initialize: function() {
        this.listenTo(this.model, 'change', this.render);
        this.listenTo(this.model, 'destroy', this.remove);
    },

    render: function() {
        var data = this.model.toJSON();
        data.openAuditBox = data.isOpen + '' + data.isAudit + '' + data.isBoxBooking;
        var p = '';
        $(data.equipments).each(function(index, each){
            var x = each.name + '； ';
            p += x;
        });
        data.equipments = p;
        switch(data.openAuditBox) {
            case "000":
                data.openAuditBox = "否/不需要/不允许";
                break;
            case "001":
                data.openAuditBox = "否/不需要/允许";
                break;
            case "010":
                data.openAuditBox = "否/需要/不允许";
                break;
            case "011":
                data.openAuditBox = "否/需要/允许";
                break;
            case "100":
                data.openAuditBox = "是/不需要/不允许";
                break;
            case "101":
                data.openAuditBox = "是/不需要/允许";
                break;
            case "110":
                data.openAuditBox = "是/需要/不允许";
                break;
            case "111":
                data.openAuditBox = "是/需要/允许";
                break;
        }
        this.$el.html(this.template(data));
        return this;
    },

    edit: function(event) {
        var id = $(this.$("input[type='checkbox']")).val();
        location.href = '/room/edit/' + id;
    },

    clear: function(event) {
        if(confirm("确认删除吗?")) {
            this.model.destroy({wait: true})
                .done(function(model,jqXHR,options) {
                }).fail(function(model,jqXHR,options) {
                    pop(event.target, '删除失败');
                });
        }
    }
});


// room index 页面的总view
var RoomsView = Backbone.View.extend({
    el: "body",

    events: {
        'click #createBtn': 'createRoom',
        'click #deleteBtn': 'deleteRooms',
        'click #allRooms': 'selectAll',
        "click input[type='checkbox']": "selectOne",
        "click thead > tr > th.name": "sortByName",
        "click thead > tr > th.capacity": "sortByCapacity",
        "click thead > tr > th.equipments": "sortByEquipments",
        "click thead > tr > th.authorization": "sortByAuthorization"
// ToDo add search event listener and sort listener
    },

    initialize: function() {
        this.listenTo(this.collection, 'add', this.addOne);
        this.listenTo(this.collection, 'remove', this.removeOne);
        this.listenTo(this.collection, 'sort', this.render);
        this.collection.fetch();
    },

    render: function() {
        var that = this;
        this.$('tbody').empty();
        this.collection.each(function(model) {
            that.addOne(model);
        });
    },

    createRoom: function(event) {
        location.href = '/room/create';
    },

    deleteRooms: function(event) {
        var ids = [];
        var that = this;
        this.$("input[type='checkbox']:not(#allRooms):checked").each(function(i,o) {
            ids.push(that.$(o).val());
        });

        if(ids.length === 0) return pop(event.target,"请先选择需要删除的会议室");
        if(confirm("确认删除吗?")) {
            $.ajax({
                type: "DELETE",
                url: "/rooms",
                data: JSON.stringify(ids),
                contentType: "application/json; charset=utf-8"
            }).done(function(data, message, jqXHR) {
                    $(data).each(function(index, each) {
                        that.collection.remove(that.collection.get(each));
                    });
                    if(data.length === ids.length) {
                    } else {
                        pop(event.target, "部分删除失败");
                    }
                }).fail(function(a,b,c){
// ToDo 美化错误提示
                    pop(event.target, "删除失败");
                });
        }

        /* 挨个删除
        ids.forEach(function(id) {
            var room = rooms.get(id);
            room.destroy({wait: true})
                .done(function(a,b,c) {
                    console.log(a,b,c);
                }).fail(function(a,b,c) {
                    console.log('fail');
                    console.log(a,b,c);
                });
        });
        */
    },

    selectAll: function() {
        var checked = this.$("#allRooms").prop("checked");
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
        var all = this.$("input[type='checkbox']:not(#allRooms)");
        var selected = this.$("input[type='checkbox']:not(#allRooms):checked");
        all.length === selected.length ?  this.$("#allRooms").prop("checked", true) : this.$("#allRooms").prop("checked", false);
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

    sortByName: function(e) {
        var keyword = "name";
        this.sort(e, keyword);
    },

    sortByCapacity: function(e) {
        var keyword = "capacity";
        this.sort(e, keyword);
    },

    sortByEquipments: function(e) {
    },

    sortByAuthorization: function(e) {
        var getValue = function(m) {
            var value;
            var data = m.toJSON();
            data.openAuditBox = data.isOpen + '' + data.isAudit + '' + data.isBoxBooking;
            switch(data.openAuditBox) {
                case "000":
                    value = 0;
                    break;
                case "001":
                    value = 1;
                    break;
                case "010":
                    value = 2;
                    break;
                case "011":
                    value = 3;
                    break;
                case "100":
                    value = 4;
                    break;
                case "101":
                    value = 5;
                    break;
                case "110":
                    value = 6;
                    break;
                case "111":
                    value = 7;
                    break;
            }
            return value;
        }
        this.sort(e, null, getValue);
    },

    addOne: function(room) {
        var roomView = new RoomView({model: room});
        this.$("tbody").append(roomView.render().el);
    },

    removeOne: function(model, collection) {
        model.destroy();
    }
});

