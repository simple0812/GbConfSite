/** Model*/
Media = Backbone.Model.extend({
    urlRoot:'/media',
    initialize: function() {
    },
    defaults: {
        name: '全部文件',
        type:'folder',
        url:'',
        size:0,
        duration:'00:00:10',
        mtime:new Date().getTime(),
        parentId:''
    }
});
/** Collection */
Medias = Backbone.Collection.extend({
    model: Media
});
var medias = new Medias;


/** View */


MediaListView = Backbone.View.extend({
    el:"#mediaList",

    events: {

    },
    initialize: function() {


    },
    initializeRender:function() {

    }
})

MediaItemView = Backbone.View.extend({
    tagName:"tr",

    events: {

    },

    initialize: function() {

    },
    render: function() {

        return this;
    }

})

MeetingAdminRouter = Backbone.Router.extend({
    routes: {
//        "/":                 "main",    // /sadas/#
        ":type":                 "admin",    // /sadas/#
        ":type":                 "admin",    // /sadas/#
        "admin/:query":        "search",  // #search/kiwis
        "search/:query/p:page": "search"   // #search/kiwis/p7
    },
//    main:function() {
//        alert('s')
//        $('.myDemo').load('/meeting'+'.col-sm-10')
//        $('#meeting').addClass('active').siblings().removeClass('active');
//        $('#operateScheduleArea').load('/meeting '+'.fix-top-2');
//    },
    admin: function(type) {
//        ...
        $('.adminauthor').addClass('active');
        console.log('admin')
//        alert('admin');
//        $('#viewJS').load('/lib/pager.js',function(){alert('kkk')})
//        $(document).ready(function(){
//            $('#viewJS').load('/lib/'+type+'.js')
//        });
//        $('#viewJS').load('/lib/pager.js')
//        $('.myDemo').load('/'+type+' '+'.col-sm-10',function(){alert('1111')})
//        $('.myDemo').load('/'+type+' '+'.col-sm-10')
        $('.myDemo').load('/'+type );
        $('#'+type).addClass('active').siblings().removeClass('active');
//        $('#operateScheduleArea').load('/'+type+' '+'.fix-top-2',function(){alert('222')});
//        $('.fix-top-2').load('/'+type+' '+'#operateScheduleArea');
//        var oHead = document.getElementsByTagName('HEAD').item(0);

//        var oScript= document.createElement("script");
//
////        oScript.type = "text/javascript";
//
//        oScript.src="/js/test.js";
////        $('#viewJS').get(0).appendChild(oScript)
//        $('#viewJS').append(oScript)
//        $('body').get(0).appendChild(oScript);
//        oHead.appendChild( oScript);
//        var script = document.createElement('script');
//        script.src = '/js/test.js';
//
//        document.appendChild(script);
////        $('.myDemo').append(script);
//        $(script).load('/js/test.js')
//        $('#viewJS').load('/lib/md5.js')
//        $('#viewJS').load('/js/test.js',function(){alert('kkk')})
    },

    search: function(query, page) {
        alert(query);
        alert(page);
//        ...
    }
})
$(function(){
    var meetingAdminRouter = new MeetingAdminRouter();
    Backbone.history.start();
})

