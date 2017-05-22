Room = Backbone.Model.extend({
    urlRoot:'/room',
    idAttribute:"_id",
    defaults:{
        name:'def'
    }
});

Rooms = Backbone.Collection.extend({
    url:'/rooms',
    model:Room,
    initialize:function() {
        this.on('remove',this.removeModel);
    },
    removeModel:function(model,collection) {
        model.trigger('removeSelf');
    }
});

var rooms = new Rooms;