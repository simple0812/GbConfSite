var Booking = Backbone.Model.extend({

    idAttribute: "_id",

    initialize: function() {
    },

    defaults: {
        _id: null,
        name: '',
        startTime: '',
        endTime: '',
        booker: '',
        room: '',
        status: 0,
        isAudit: 0,
        reason: '',
        users: [],
        externalUsers: [],
        remarks: ''
    }
});


var Bookings = Backbone.Collection.extend({
    url: '/BM/bookings',

    model: Booking,

    totoalResults: 0,

    totoalPages: 0,

    currentPage: 0,

    pageSize: 15,

    orderBy: "startTime",

    orderDesc: 'desc',

    parse: function(response) {
        var p = false;
        if(this.totalResults === response.totalResults) p = true;
        if(this.totalPages === response.totalPages) p = true;
        if(this.currentPage === response.currentPage) flag = true;
        if(this.pageSize === response.pageSize) p = true;
        if(this.orderBy === response.orderBy) p = true;
        if(this.orderDesc === response.orderDesc) p = true;
        this.totalResults = response.totalResults;
        this.totalPages = response.totalPages;
        this.currentPage = response.currentPage;
        this.pageSize = response.pageSize;
        this.orderBy = response.orderBy;
        this.orderDesc = response.orderDesc;
        if(p) this.trigger("page");
        return response.items;
    },

    comparator: "startTime",

    initialize: function() {
    }
});