var User = Backbone.Model.extend({
    urlRoot: '/BM/user',

    idAttribute: "_id",

    initialize: function() {
    },

    defaults: {
        _id: null,
        userName: '',
        name: ''
    }
});


var Users = Backbone.Collection.extend({
    url: '/BM/users',

    model: User,

    initialize: function() {
    }
});