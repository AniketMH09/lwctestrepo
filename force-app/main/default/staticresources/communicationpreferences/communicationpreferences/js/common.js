//Rename Details

$(document).ready(function(){
$(".enable-fld, .save-btn-section").hide();
  	$('.rename-btn').click(function(){
		$(".enable-fld, .save-btn-section").show();
		$(".disabled-fld, .rename-btn-section").hide();
	
	});
	//Show Text Field	
	$('.save-btn-section .primary-btn').click(function(){
		$(".enable-fld, .save-btn-section").hide();
		$(".disabled-fld, .rename-btn-section").show();
	});
	
	$('.save-btn-section .cancel-btn').click(function(){
		 $(".enable-fld, .save-btn-section").hide();
		$(".disabled-fld, .rename-btn-section").show();
		
	});
}); 
 
 
// Model Box
 $(function(){

var appendthis =  ("<div class='modal-overlay js-modal-close'></div>");

  $('.overview-link, button[data-modal-id]').click(function(e) {
    e.preventDefault();
    $("body").append(appendthis);
    $(".modal-overlay").fadeTo(500, 0.7);
    //$(".js-modalbox").fadeIn(500);
    var modalBox = $(this).attr('data-modal-id');
    $('#'+modalBox).fadeIn($(this).data());
  });  
	
  
$(".js-modal-close, .modal-overlay").click(function() {
  $(".modal-box, .modal-overlay").fadeOut(500, function() {
    $(".modal-overlay").remove();
  });
});
 
$(window).resize(function() {
  $(".modal-box").css({
    top: ($(window).height() - $(".modal-box").outerHeight()) / 2,
    left: ($(window).width() - $(".modal-box").outerWidth()) / 2
  });
});
 
$(window).resize();
 
});


//Communication Preferences

$(document).ready(function(){
 $(".due-date-info").click(function() { 
	if ( $(".due-date-info .due-info").is(":visible") ) { 
	$(".due-date-info .due-info").slideUp(); 
	$('.due-date-info.active').removeClass('active');
	}
 else if ( $(".due-date-info .due-info").is(":hidden") ) { 
	$(this).addClass('active');
	$(".due-date-info .due-info").slideDown(); 
}
});
});