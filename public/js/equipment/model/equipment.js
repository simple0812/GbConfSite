var Equipment = Backbone.Model.extend({
    urlRoot: '/equipment',

    idAttribute: "_id",

    initialize: function() {
    },

    defaults: {
        _id: null,
        name: '',
        createTime: '',
        status: 0,
        model: 0,
        icon: '',
        chose: false
    }
});


var Equipments = Backbone.Collection.extend({
    url: '/equipments',

    model: Equipment,

    comparator: "name",

    initialize: function() {
    }
});
