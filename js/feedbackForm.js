$(document).ready(function(){
	$(".expand").hide(); 
	$(".showForm").click(function() {
		$(".expand").slideToggle('slow'); 
	});
	
	$('input[name$="feedbackHelpful"]').each(function(){
        $(this).hide().after('<a href="" class="buttonLink" name="feedbackHelpful_link">Yes</a>');
    });
	
    $('a.buttonLink').bind("click", function(){
        var clickId = 'feedbackHelpful_link';
        clickId = clickId.replace('_link','');
        var selector = 'input[name="'+clickId+'"]';
        var $button = $(selector);
        window.onbeforeunload = null;
        $button.trigger('click');
        return false;
    });
	
	
}); // end on DOM

// Source: http://woork.blogspot.co.uk/2008/03/sliding-top-panel-using-mootools_05.html