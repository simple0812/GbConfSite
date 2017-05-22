var Room = Backbone.Model.extend({
    urlRoot: '/room',

    idAttribute: "_id",

    initialize: function() {
    },

    defaults: {
        _id: null,
        name: '',
        createTime: '',
        capacity: '',
        isOpen: 0,
        isAudit: 0,
        isBoxBooking: 0,
        status: 0,
        remarks: '',
        imgURL: null,
        equipments: [],
        boxes: []
    }
});


var Rooms = Backbone.Collection.extend({
    url: '/roomall',

    model: Room,

    initialize: function() {
    }
});
