_.templateSettings = {
    interpolate: /\{\{(.+?)\}\}/g
}

// edit room index 页面
var RoomView;
RoomView = Backbone.View.extend({
    el: 'body',

    events: {
        "change #name": "rename",
        "change #capacity": "changeCapacity",
        "change #equipments": "changeEquipments",
        "click #isOpen": "changeIsOpen",
        "click #isAudit": "changeIsAudit",
        "click #isBoxBooking": "changeIsBoxBooking",
        "change #remarks": "changeRemarks",
        "change #imageinfo": "changeImgURL",
        "click .save": "save",
        "click .back": "back"
    },

    initialize: function () {
//        this.listenTo(this.model, "change", this.render);
        this.render();
        validator.bind();
    },

    render: function () {
        var that = this;
        var data = this.model.toJSON();
        this.$('#name').val(data.name);
        this.$('#capacity').val(data.capacity);
        data.imgURL = data.imgURL || "/img/room.png";
        this.$('#showimage').attr("src", data.imgURL);
        this.$("#equipments").empty();
        $(data.equipments).each(function(index, each) {
            var equipment = "<button class='btn btn-primary gap' eid=" + each.id + ">" + each.name + "</button>";
            that.$('#equipments').append(equipment);
        });
        this.$('#isOpen').prop("checked", data.isOpen === 1? true: false);
        this.$('#isAudit').prop("checked", data.isAudit === 1? true: false);
        this.$('#isBoxBooking').prop("checked", data.isBoxBooking === 1? true: false);
        this.$("#remarks").val(data.remarks);
    },

    rename: function () {
        var newName = $.trim(this.$("#name").val());
//        if(!validator.validateAll("#name")) return;
        this.model.set("name", newName);
        return this;
    },

    changeCapacity: function () {
        var newCapacity = this.$("#capacity").val();
//        if(!validator.validateAll("#capacity")) return;
        this.model.set("capacity", newCapacity);
        return this;
    },

    changeEquipments: function () {
        var that = this;
        var equipments = this.$("#equipments > button");
        var p = [];
        equipments.each(function (index, element) {
            var x = $(element);
            p.push({id: x.attr("eid"), name: x.text()});
        });
        that.model.set("equipments", p);
        return this;
    },

    changeIsOpen: function () {
        var checked = this.$("#isOpen").prop("checked");
        if (checked) {
            this.model.set("isOpen", 1);
        } else {
            this.model.set("isOpen", 0);
        }
        return this;
    },

    changeIsAudit: function () {
        var checked = this.$("#isAudit").prop("checked");
        if (checked) {
            this.model.set("isAudit", 1);
        } else {
            this.model.set("isAudit", 0);
        }
        return this;
    },

    changeIsBoxBooking: function () {
        var checked = this.$("#isBoxBooking").prop("checked");
        if (checked) {
            this.model.set("isBoxBooking", 1);
        } else {
            this.model.set("isBoxBooking", 0);
        }
        return this;
    },

    changeRemarks: function () {
        var newRemarks = this.$("#remarks").val();
//        if(!validator.validateAll("#remarks")) return;
        this.model.set("remarks", newRemarks);
        return this;
    },

    changeImgURL: function () {
        var filename = $("#imageinfo").attr("filename");
        if (filename) {
            this.model.set("imgURL", filename);
        } else {
            this.model.set("imgURL", null);
        }
    },

// 用于设置equipments为id构成的数组
    e2eid: function() {
        var p = [];
        $(this.model.get("equipments")).each(function(index, each){
            p.push(each.id);
        });
        this.model.set("equipments", p);
        return this;
    },

    save: function (event) {
// ToDo 处理结果显示的美化效果
        this.e2eid();

        if(!validator.validateAll('#roomID')) return;
        this.model.save({}, {wait: true})
            .done(function (model, message, jqXHR) {
                console.log("success", model, message, jqXHR);
                location.href = "/room/index";
            }).fail(function (jqXHR, result, message) {
                console.log("fail", jqXHR, result, message);
                if (409 === jqXHR.status) {
                    alert("重复会议室，提交失败");
                } else {
                    alert('提交失败');
                }
                location.reload();
            });
    },

    back: function (e) {
        if(confirm("返回后新增或修改后的数据将丢失，确定返回？")) {
            location.href = "/room/index";
        }
    }
});
