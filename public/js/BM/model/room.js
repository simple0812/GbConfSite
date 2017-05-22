var Room = Backbone.Model.extend({
    urlRoot: '/BM/room',

    idAttribute: "_id",

    initialize: function() {
    },

    defaults: {
        _id: null,
        name: ''
    }
});


var Rooms = Backbone.Collection.extend({
    url: '/BM/rooms',

    model: Room,

    comparator: "name",

    initialize: function() {
    }
});
