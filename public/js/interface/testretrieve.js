var currentIndex = 0;
var pageSize = 6;
var interval = null;
var retrieveInterval = null;
var pageSpan = 5000;
var retrieveSpan = 1*60*1000;

$(function() {
    getBookings();
    retrieveInterval = setInterval(function() {
        getBookings();
    }, retrieveSpan);
});

function getBookings() {
    $.getJSON('/interface/bookings', {roomIds:[$('.roomname').attr('roomid')], date:moment().format("YYYY-MM-DD"), mid:Math.random()}, function(json) {
        if(!json || json.code == 'fail') json = [];
        showPageBooking(json);
    })
}

function renderBooking(bookings) {
    $('#bookings').children().slice(1).remove();

    if(bookings && bookings.length > 0 ) {

        $.each(bookings, function(i, o) {
            $('#bookings').append($('.tmplBooking').html().format(
                o.name ,
                o.booker.name,
                moment(o.startTime).format("HH:mm"),
                moment(o.endTime).format("HH:mm")))
        });

        if(bookings.length < pageSize)
            for(var i = 0; i < pageSize - bookings.length; i++) {
                $('#bookings').append($('.tmplBooking').html().format('','','',''))
            }
    } else if(currentIndex == 0) {
        for(var i = 0; i < pageSize; i++) {
            $('#bookings').append($('.tmplBooking').html().format('','','',''))
        }
    }
}

function showPageBooking(bookings) {
    if(bookings.length <= pageSize) return renderBooking(bookings);
    renderBooking(bookings.slice(0, pageSize));
    currentIndex = 0;
    interval = setInterval(function() {
        currentIndex ++;
        if(pageSize * currentIndex >= bookings.length) currentIndex = 0;
        var p = bookings.slice(currentIndex* pageSize, (currentIndex + 1) * pageSize);
        renderBooking(p);
    }, pageSpan);
}

