/**
 * Created by Shgbit on 2014/8/4.
 */
Device = Backbone.Model.extend({
    urlRoot: '/device',
    idAttribute:"_id",
    initialize: function() {
    },

    defaults: {
        // persistent attributes
//        _id: null,
        name: '',
        alias: '',
        autoScreen: [],
        autoSnapshot: '60',
        debug: '0',
        network: {ip:'',gw:'',mac:'',mask:''},
        service: '',
        interval: '30',
        // normal attributes
        os: '',
        version: {name:'',code:''},
        mversion: {name:'',code:''},
        cpu: '',
        memory: '',
        disk: '',
        boot: '',
        schedule: [],
        snapshot: '',
        pixel: '',
//        client_info: '',
//        publish: [],
        commands: [],
        isScreenOn: 'off',
        online: false
    },

    update: function(arg) {
        this.save({
            alias: arg.alias || this.get('alias'),
            auto_screen: arg.auto_screen || this.get('auto_screen'),
            auto_snapshot: arg.auto_snapshot || this.get('auto_snapshot'),
            debug: arg.debug || this.get('debug'),
            network: arg.network || this.get('network'),
            service: arg.service || this.get('service'),
            interval: arg.interval || this.get('interval')
        });
    }
});

Devices = Backbone.Collection.extend({
    url: '/devices',
    model: Device
});
var devices = new Devices;