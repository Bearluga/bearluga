$(document).ready(function(){

	$('#navigationul li .normalMenu').each(function(){

		$(this).before($(this).clone().removeClass().addClass('hoverMenu'));

	});
	
	$('#navigationul li').hover(function(){
	
		$(this).find('.hoverMenu').stop().animate({marginTop:'0px'},200);

	},
	
	function(){
	
		$(this).find('.hoverMenu').stop().animate({marginTop:'-37px'},200);

	});
	
});
