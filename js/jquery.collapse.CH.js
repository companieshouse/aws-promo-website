/*
 * Collapse plugin for jQuery
 * --
 * source: http://github.com/danielstocks/jQuery-Collapse/
 * site: http://webcloud.se/code/jQuery-Collapse
 *
 * @author Daniel Stocks (http://webcloud.se)
 * Copyright 2012, Daniel Stocks
 * Released under the MIT, BSD, and GPL Licenses.
 */
  new jQueryCollapse($("#accordion"), {
          open: function() {
            this.slideDown(150);
          },
          close: function() {
            this.slideUp(150);
          }
        });


	//the following code adds the expand/collapse functionality (source: http://jsfiddle.net/sinetheta/s5hAw/ )
	var headers = $('#accordion h3');
	var contentAreas = $('#accordion .content ').hide();
	var expandLink = $('.accordion-expand-all');

	headers.click(function() {
    var panel = $(this).next();
    var isOpen = panel.is(':visible');
 
    panel[isOpen? 'slideUp': 'slideDown']()
        .trigger(isOpen? 'hide': 'show');
    return false;
	});
	expandLink.click(function(){
    var isAllOpen = $(this).data('isAllOpen');
    
    contentAreas[isAllOpen? 'hide': 'show']()
        .trigger(isAllOpen? 'hide': 'show');
	});
	contentAreas.on({
    show: function(){
        var isAllOpen = !contentAreas.is(':hidden');   
        if(isAllOpen){
            expandLink.text('Hide all')
                .data('isAllOpen', true);
        }
    },
    hide: function(){
        var isAllOpen = !contentAreas.is(':hidden');
        if(!isAllOpen){
            expandLink.text('Show all')
            .data('isAllOpen', false);
        } 
    }
	});
	$(document).ready(function(){	
		$('a.accordion-expand-all').removeClass('hidden');
});