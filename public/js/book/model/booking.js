Booking = Backbone.Model.extend({
    urlRoot:'/booking',
    idAttribute:"_id",
    defaults:{
        _id:undefined
    },
    parse:function(response) {
        var attr = {};
        if(response && response.message) {
            this.message = response.message;
            attr = response.result;
        } else{
            attr = response;
        }
        return attr
    }
});

Bookings = Backbone.Collection.extend({
    url:'/bookings',
    model:Booking,
    initialize:function() {
        this.on('remove',this.removeModel);
    },
    removeModel:function(model,collection) {
        model.trigger('removeSelf');
    }
});

var bookings = new Bookings;
