ExternalUser = Backbone.Model.extend({
//    idAttribute:"_id",
    defaults:{
        name:'',
        company:'',
        email:'',
        telephone:'',
        mobilePhone:''
    }
})

ExternalUsers = Backbone.Collection.extend({
    model:ExternalUser,
    initialize:function() {
        this.on('remove',this.removeModel);
    },
    removeModel:function(model,collection) {
        model.trigger('removeSelf');
//        collection.trigger('checkConditionHeight')
    }
});
var externalUsers = new ExternalUsers;
