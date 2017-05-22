Equip = Backbone.Model.extend({
    urlRoot:'/equipment',
    idAttribute:"_id",
    defaults:{
        checked:false
    },
    initialize:function() {
        this.on('change:checked',this.changeChecked);
    },
    changeChecked:function() {
        if(this.toJSON().checked)
            this.trigger('addDisplayView');
        else {
            this.trigger('removeDisplay');
            equips.trigger('checkConditionHeight');
        }

    }
});

Equips = Backbone.Collection.extend({
    url:'/equipments',
    model:Equip,
    initialize:function() {
        this.on('remove',this.removeModel);
    },
    removeModel:function(model,collection) {
        model.trigger('removeSelf');
        collection.trigger('checkConditionHeight')
    }
});
var equips = new Equips;