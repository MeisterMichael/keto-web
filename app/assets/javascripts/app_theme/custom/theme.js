
$('.singlepage-nav').singlePageNav({
    offset: 0,
    filter: ':not(.external)',
    updateHash: true,
    currentClass: 'current',
    easing: 'swing',
    speed: 750,
    beforeStart: function () {
        if ($(window).width() < 991) {
            $('.singlepage-nav > ul').hide();
        };
    },
    onComplete: function () {
        console.log('done scrolling');
    }
});
