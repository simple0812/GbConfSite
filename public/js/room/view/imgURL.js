$(function() {
//    function changeImage() {
    $("#changeimage").change(function(e){
        loadImage(e.target.files[0], function(img) {
            img.id = "showimage";
            $("#showimage").replaceWith(img);
        }, {maxHeight: 300, maxWidth: 300});
    });
//}

//function uploadImage() {
    'use strict';
    $("#changeimage").fileupload({
        url: "/upload/room/image",
        autoUpload: false,
        dataType: "json",
        maxFileSize: 5000000,
        add: function(e, data) {
            $("#imageinfo").html("点击确认替换以上传");
            data.context = $("#replace").off("click").on("click", function() {
                data.submit();
            })
        },

        done: function(e, data) {
            var info = $("#imageinfo");
            info.attr("filename", data.result);
            info.change();
            info.html("替换成功");
        },

        fail: function(e, data) {
            var info = $("#imageinfo");
            var message = data.jqXHR.responseText;
            if(message) {
                console.log(message);
            }
            info.html("替换失败");
        }
    })

//}
});

