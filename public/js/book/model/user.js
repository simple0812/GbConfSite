User = Backbone.Model.extend({
    idAttribute:"_id",
    defaults:{
        userName:'',
        name:'',
        password:'',
        email:'',
        mobilePhone:'',
        telephone:'',
        housePhone:'',
        role:'',
        createTime:'',
        organization:'',
        hasNewNotice:''
    }
})

Users = Backbone.Collection.extend({
    model:User,
    initialize:function() {
        this.on('remove',this.removeModel);
    },
    removeModel:function(model,collection) {
        model.trigger('removeSelf');
//        collection.trigger('checkConditionHeight')
    }
});
var users = new Users;
var submitUsers = new Users;
