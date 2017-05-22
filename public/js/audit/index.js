/**
 * Created by Shgbit on 2014/7/11.
 */
_.templateSettings = {
    interpolate:/\{\{(.+?)\}\}/g
};
var AuditingView=Backbone.View.extend({
    tagName: 'tr',

    template:_.template($("#auditTemplate").html()),

    events:{
        'click .edit':'pass',
        'click .back':'back'
    },
    initialize:function(){
        this.listenTo(this.model,'change',this.render);
        this.listenTo(this.model,'change:isAudit',this.remove)
    },
    render:function(){
        var data=this.model.toJSON();
        data.startTime0=new moment(data.startTime).format("YYYY-MM-DD");
        data.startTime1=new moment(data.startTime).format("HH:mm");
        data.endTime0=new moment(data.endTime).format("HH:mm");
        data.times=data.startTime0+ ' '+data.startTime1+"-"+data.endTime0;
        console.log(data)
        data.booker = data.booker || {}
        this.$el.html(this.template(data));

        var now = new moment().valueOf();
        var stime = moment(data.startTime).valueOf();
        var etime = moment(data.endTime).valueOf();
        if(now>stime && now<etime){
           this.$(".edit").hide();
        }
        return this;
    },
    pass:function(){
        this.model.set({isAudit:1});
        this.model.save({},{url: "/booking/audit/"+this.model.get('_id'),wait:true}).done(function(model,message,jqXHR){
            alert('提交成功')
        }).fail(function(){
            alert('提交失败')
        });
        this.remove();
    },
    back:function(){
        $('#myModel').modal('show');
        $('#myModel').data("bookId",this.model.get("_id"));

    }

});
var AuditingsView=Backbone.View.extend({
    el:"body",

    events:{
        "click thead > tr > th.time": "sortByTime",
        "click thead > tr > th.room": "sortByRoom",
        "click thead > tr > th.name": "sortByName",
        "click thead > tr > th.booker": "sortByBooker",
        "click #saving":"submit"
    },
    initialize:function() {
        this.listenTo(this.collection, 'add', this.addOne);
        this.listenTo(this.collection, 'sort', this.render);
        this.listenTo(this.collection, 'remove', this.removeOne);
        this.collection.fetch({url: "/booking/audit"});

    },
    render:function(){
        var that=this;
        this.$('tbody').empty();
        this.collection.each(function(model){
            that.addOne(model);
        });
    },
    sort: function(e, keyword, getValue) {
        var option;
        if($(e.target).hasClass("dropup")) {
            option = "desc";
            $(e.target).removeClass("dropup");
        } else {
            option = "asc";
            $(e.target).addClass("dropup");
        }
        this.collection.comparator = function(m1, m2) {
            var n1, n2, result;
            if(getValue) {
                n1 = getValue(m1);
                n2 = getValue(m2);
            } else {
                n1 = m1.get(keyword);
                n2 = m2.get(keyword);
            }
            if("desc" === option) {
                if(n1 > n2) {
                    result = -1;
                } else {
                    result = 1;
                }
            } else {
                if(n1 > n2) {
                    result = 1;
                } else {
                    result = -1;
                }
            }
            return result;
        };
        this.collection.sort();
    },
    sortByTime:function(e) {
        var keyword = "startTime";
        this.sort(e, keyword);
    },
    sortByRoom:function(e) {
        var keyword = "room";
        var getValue = function(m) {
            return m.get("room").name;
        };
        this.sort(e, keyword, getValue);
    },
    sortByName: function(e) {
        var keyword = "name";
        this.sort(e, keyword);
    },
    sortByBooker: function(e) {
        var keyword = "booker";
        var getValue = function(m) {
            return m.get("booker").name;
        };
        this.sort(e, keyword, getValue);
    },
    addOne:function(look){
        var auditView=new AuditingView({model:look});
        this.$("tbody").append(auditView.render().el);
    },

    submit:function() {
        var tempBookingModel = this.collection.get($('#myModel').data("bookId"));
        var text=$("#reason").val();
        tempBookingModel.set({reason: text, isAudit: 2});
        tempBookingModel.save({},{url: "/booking/audit/"+tempBookingModel.get('_id'),wait:true}).done(function(model,message,jqXHR){
            alert('提交成功1')
        }).fail(function(){
            alert('提交失败')
        });
    },
    removeOne: function(model, collection) {
        model.destroy();
    }
});