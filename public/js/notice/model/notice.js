/**
 * Created by shgbit on 2014/7/14.
 */
var Notice = Backbone.Model.extend({
    urlRoot: '/notice',

    idAttribute: "_id",

    initialize: function() {
    },

    defaults: {
        _id: null,
        booker: null,
        receiver: null,
        booking: null
    }
});


var Notices = Backbone.Collection.extend({
    url: '/notices',

    model: Notice,

    initialize: function() {
    }
});