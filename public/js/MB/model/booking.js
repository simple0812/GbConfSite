var Booking = Backbone.Model.extend({
    urlRoot: '/MB/booking',

    idAttribute: "_id",

    initialize: function() {
    },

    defaults: {
        _id: null,
        name: '',
        startTime: '',
        endTime: '',
        booker: {},
        room: {},
        status: 0,
        isAudit: 0,
        reason: '',
        users: [],
        externalUsers: [],
        remarks: ''
    }
});


var Bookings = Backbone.Collection.extend({
    url: '/MB/bookings',

    model: Booking,

    totalItems: 0,

    total: 0,

    current: 0,

    pagesize: 15,

    orderBy: "startTime",

    orderMode: 'desc',

    initialize: function() {
    },

    parse: function(response) {
        var p = false;
        if(this.totalItems === response.totalItems) p = true;
        if(this.total === response.total) p = true;
        if(this.current === response.current) p = true;
        if(this.pagesize === response.pagesize) p = true;
        if(this.orderBy === response.totalItems) p = true;
        if(this.orderMode === response.totalItems) p = true;
        this.totalItems = response.totalItems;
        this.total = response.total;
        this.current = response.current;
        this.pagesize = response.pagesize;
        this.orderBy = response.orderBy;
        this.orderMode = response.orderMode;
        if(p) this.trigger("page");
        return response.items;
    }
});
