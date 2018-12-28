$('ul li:has(ul)').addClass('has-submenu');
$('ul li ul').addClass('sub-menu');

var $menu = $('#menu'), 
	$menulink = $('#menu-ckb'), 
	$menuTrigger = $('.has-submenu > a');


$menulink.click(function (e) {
    $menulink.toggleClass('active');
    $menu.toggleClass('active');
});

$menuTrigger.click(function (e) {
    e.preventDefault();
    var t = $(this);
    t.toggleClass('active').next('ul').toggleClass('active');
});

$('.menu .depth1 .item').mouseover(function(){
	$(this).addClass('on');
	$menu.addClass('on');
	$('.bx_sub > .wrap').children('.title').eq($(this).index()).addClass('on').siblings().removeClass('on');
});

$('.menu .depth1 .item').mouseout(function(){
	$(this).removeClass('on');
	$menu.removeClass('on');
});