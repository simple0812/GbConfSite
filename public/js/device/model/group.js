/**
 * Created by Shgbit on 2014/8/13.
 */
Group = Backbone.Model.extend({
    urlRoot:'/group',
    idAttribute:"_id",
    initialize:function(){

    },
    defaults:{
//        _id:null,
        name:'',
        boxes:[]
    }
});
Groups =Backbone.Collection.extend({
    url:'/groups',
    model:Group
});
var groups=new Groups;