$(document).ready(function(){
	$("#page-url").val(window.location); 
	$("#pageFeedbackForm").show(); 
	$(".expand").hide(); 
	$(".showForm").click(function() {
		$(".expand").slideToggle('slow'); 
	});
	
	$('input[name$="positive-feedback"]').each(function(){
		$(this).hide().after('<a href="#" class="buttonLink" name="positive-feedback_link">Yes</a>');
	});
	
	$('a.buttonLink').bind("click", function(){
		var clickId = 'positive-feedback_link';
		clickId = clickId.replace('_link','');
		var selector = 'input[name="'+clickId+'"]';
		var $button = $(selector);
		window.onbeforeunload = null;
		$button.trigger('click');
		return false;
	});
}); // end on DOM