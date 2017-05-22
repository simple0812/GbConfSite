_.templateSettings = {
    interpolate: /\{\{(.+?)\}\}/g
}

EquipmentView = Backbone.View.extend({
    className: "check",

    template: _.template($("#equipmentTemplate").html()),

    events: {
        "click input[type='checkbox']": "choose"
    },

    initialize: function() {
        /*
         编辑会议室时，会获取含有设备的列表，并通过该列表改变equipment model的chose值，以初始化equipmentsView
         此处，不能用render，会造成选设备的时候需要点两次，原因未明
         */
        this.listenTo(this.model, "destroy", this.remove);
        this.render();
    },

    render: function() {
        var data = this.model.toJSON();
        this.$el.html(this.template(data));
        return this;
    },


    choose: function(event) {
        var checked = this.$("input[type='checkbox']").prop("checked");
        if(checked) {
            this.model.set("chose", true);
        } else {
            this.model.set("chose", false);
        }
        return this;
    }
});

EquipmentsView = Backbone.View.extend({
    el: "#equipmentsModal",

    events: {
        "click #addEquipmentsConfirmBtn": "addToRoom"
    },

    initialize: function() {
        this.listenTo(this.collection, "add", this.addOne);
        this.listenTo(this.collection, "remove", this.removeOne);
        this.listenTo(this.collection, "sort", this.render);
        this.collection.fetch();
    },

    render: function() {
        var that = this;
        this.$(".modal-body").empty();
        this.collection.each(function(model) {
            that.addOne(model);
        });
    },

    addOne: function(model) {
        var equipmentView = new EquipmentView({model: model});
        this.$(".modal-body").append(equipmentView.render().el);
    },

    removeOne: function(model) {
        model.destroy();
    },

    addToRoom: function() {
        var chose = this.collection.where({chose: true});
        $("#equipments").empty();
        $(chose).each(function(index, each) {
            var equipment = "<button class='btn btn-primary gap' eid=" + each.get("_id") + ">" + each.get("name") + "</button>";
            $('#equipments').append(equipment);
        });
        $("#equipments").change();
    }
})