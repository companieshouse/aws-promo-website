$.expr[":"].containsNoCase = function(el, i, m) {
	var search = m[3];
	if (!search) return false;
	return eval("/" + search + "/i").test($(el).text());
};

$(document).ready(function() 
    {	
		$('p.jsOnly').removeClass('jsOnly');
		
		// hide the cancel search image
		$('#imgSearch').hide();
		
		// reset the search when the cancel image is clicked
		$('#imgSearch').click(function() {
    		resetSearch();
		});
		
		// cancel the search if the user presses the ESC key
		$('#txtSearch').keyup(function(event) {
		    if (event.keyCode == 27) {
				resetSearch();
			}
		});

		// execute the search
		$('#txtSearch').keyup(function() {
			
			// only search when there are 3 or more characters in the textbox
			if ($('#txtSearch').val().length > 2) {
			
				// hide all rows
				$('.generalTable tr').hide();
				
				// show the header row
				$('.generalTable tr:first').show();
				
				// show the matching rows (using the containsNoCase from Rick Strahl)
				$('.generalTable tr td:containsNoCase(\'' + jQuery('#txtSearch').val() + '\')').parent().show();
				
				// show the cancel search image
				$('#imgSearch').show();

    		}

    		else if ($('#txtSearch').val().length == 0) {
			    // if the user removed all of the text, reset the search
				resetSearch();
			}
		
		// if there were no matching rows, tell the user
		if ($('.generalTable tr:visible').length == 1) {
			
			// remove the norecords row if it already exists
			$('.norecords').remove();
			
			// add the norecords row
			$('.generalTable').append('<tr class="norecords"><td colspan="5" class="Normal">No records were found</td></tr>');
		
		}
	});
});
		
		function resetSearch() {
    		// clear the textbox
			$('#txtSearch').val('');

    		// show all table rows
			$('.generalTable tr').show();

    		// remove any no records rows
			$('.norecords').remove();

    		// remove the cancel search image
			$('#imgSearch').hide();

    		// make sure we re-focus on the textbox for usability
			$('#txtSearch').focus();
		}