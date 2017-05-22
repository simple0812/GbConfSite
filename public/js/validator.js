validator = {
    className:'validator',
    actions :{
        email:{reg:/^([a-zA-Z0-9_\.\-])+\@(([a-zA-Z0-9\-])+\.)+([a-zA-Z0-9]{2,4})+$/, err:'格式不正确'},
        phone:{reg:/^(1(([35][0-9])|(47)|[8][01236789]))\d{8}$/, err:'格式不正确'},
        tel:{reg:/^(\+?\d{1,3})?\s*(0\d{2,3}(\-)?)?\d{7,8}$/, err:'格式不正确'},
        specialChar:{reg:/^[a-zA-Z0-9_\(\)\-\u4e00-\u9fa5《》,，]+$/, err:'格式不正确, 只能为字母、数字、汉字、下划线、《、》等'},
        password:{reg:/^.{4,18}$/, err:'长度必须为4到18个字符'},
        housePhone:{reg:/\d{1,6}/, err:'格式不正确, 只能为6位以内的数字'},
        roomCapacity:{reg:/^\+?[1-9][0-9]*$/, err:'格式不正确, 只能为大于零的数字'},
        bookingDate:{reg:/^((0?\d)|(1\d)|(2[0-3])):([0-5]\d)$/, err:'格式不正确, 时间格式为00:00'},
        remarks:{reg:/^[^<>]+$/, err:"格式不正确, 不能含有 <、>"},
        username:{reg:/^[a-zA-Z0-9_\.\(\)\-\u4e00-\u9fa5]+$/, err:'格式不正确, 只能为字母、数字、汉字、下划线、点等'},
        deviceID:{reg:/^[a-zA-Z0-9_\.\(\)\-]+$/, err:'格式不正确, 只能为数字、英文、下划线和减号'},
        IP:{reg:/^(25[0-5]|2[0-4][0-9]|[0-1]{1}[0-9]{2}|[1-9]{1}[0-9]{1}|[1-9])\.(25[0-5]|2[0-4][0-9]|[0-1]{1}[0-9]{2}|[1-9]{1}[0-9]{1}|[1-9]|0)\.(25[0-5]|2[0-4][0-9]|[0-1]{1}[0-9]{2}|[1-9]{1}[0-9]{1}|[1-9]|0)\.(25[0-5]|2[0-4][0-9]|[0-1]{1}[0-9]{2}|[1-9]{1}[0-9]{1}|[0-9])$/,
            err:'IP地址格式错误'},
        mask:{reg:/^(25[0-5]|2[0-4][0-9]|[0-1]{1}[0-9]{2}|[1-9]{1}[0-9]{1}|[1-9])\.(25[0-5]|2[0-4][0-9]|[0-1]{1}[0-9]{2}|[1-9]{1}[0-9]{1}|[1-9]|0)\.(25[0-5]|2[0-4][0-9]|[0-1]{1}[0-9]{2}|[1-9]{1}[0-9]{1}|[1-9]|0)\.(25[0-5]|2[0-4][0-9]|[0-1]{1}[0-9]{2}|[1-9]{1}[0-9]{1}|[0-9])$/,
            err:'子网掩码格式错误'},
        gw:{reg:/^(25[0-5]|2[0-4][0-9]|[0-1]{1}[0-9]{2}|[1-9]{1}[0-9]{1}|[1-9])\.(25[0-5]|2[0-4][0-9]|[0-1]{1}[0-9]{2}|[1-9]{1}[0-9]{1}|[1-9]|0)\.(25[0-5]|2[0-4][0-9]|[0-1]{1}[0-9]{2}|[1-9]{1}[0-9]{1}|[1-9]|0)\.(25[0-5]|2[0-4][0-9]|[0-1]{1}[0-9]{2}|[1-9]{1}[0-9]{1}|[0-9])$/,
            err:'网关格式错误'},
        service:{reg: "^((https|http|ftp|rtsp|mms)?://)"
            + "?(([0-9a-z_!~*'().&=+$%-]+: )?[0-9a-z_!~*'().&=+$%-]+@)?" //ftp的user@
            + "(([0-9]{1,3}.){3}[0-9]{1,3}" // IP形式的URL- 199.194.52.184
            + "|" // 允许IP和DOMAIN（域名）
            + "([0-9a-z_!~*'()-]+.)*" // 域名- www.
            + "([0-9a-z][0-9a-z-]{0,61})?[0-9a-z]." // 二级域名
            + "[a-z]{2,6})" // first level domain- .com or .museum
            + "(:[0-9]{1,5})?" // 端口- :80
            + "((/?)|" // a slash isn't required if there is no file name
            + "(/[0-9a-z_!~*'().;?:@&=+$,%#-]+)+/?)$",err:'服务器地址格式错误'},
        groupName:{reg: /^[a-zA-Z0-9_\-\u4e00-\u9fa5]+$/,err:'组名只能为数字、中英文、下划线和减号'}
        },

    validate:function(obj) {
        var p = $(obj).attr(this.className) || '';
        var des = $(obj).attr('description') || '';

        var txt = arguments[1] || $(obj).val() || $(obj).html();

        var isRequired = $(obj).attr('required');

        if($.trim(txt).length == 0) {
            if(isRequired == null) return true;
            else {
                popBy(obj, false, des+ "不能为空");
                return false;
            }
        }


        if(p.length == 0)  return true;

        var action = this.actions[p];

        if(action == null) {
            popBy(obj, false, '对应的正则表达式不存在');
            return false;
        }
//        console.log(typeof action.reg)
        if(action.reg.constructor !== RegExp)
            action.reg = new RegExp(action.reg, 'i');

        if(!action.reg.test(txt)) {
            popBy(obj, false, des+ action.err);
            return false;
        }

        return true;

    },

    bind:function(parent) {
        var obj = $('.validator');
        if(parent != null)
        obj =$(parent).find('.validator');
        var _this = this;
        obj.blur(function() {
            _this.validate(this)
        })
    },

    delegate: function(parent) {
      var _this = this;
      $(parent).delegate('.validator','blur', function() {
          _this.validate(this);
      })
    },

    validateAll:function(parent) {
        var _this = this;
        var ret = 0;
        var obj = $('.validator');
        if(parent != null)
            obj =$(parent).find('.validator');

        obj.each(function(i, o) {
            if( !_this.validate(o)) ret ++;
        });

        return ret == 0;
    }


};
