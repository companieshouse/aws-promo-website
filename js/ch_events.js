(function($,W,D)
{
    var JQUERY4U = {};

    JQUERY4U.UTIL =
    {
        setupFormValidation: function()
        {
            //form validation rules
            $("#transfer").validate({
                rules: {
                    event: "required",
					name: "required",
					job_title: "required",
					company_name: "required",
                    email: {
                        required: true,
                        email: true
                    },
					 confirm_email: {
                        email: true,
						equalTo: "#email"
                    },
					group1: "required",
					group2: "required",
					maths_question: "required"
                },
                messages: {
                   	event: "Please select an event/time",                    
					name: "Please enter your name",
					job_title: "Please enter your job title",
					company_name: "Please enter your company name",
                    email: "Please enter a valid email address",
					confirm_email: "Email addresses must match",
					group1: "Please tell us how you currently file with Companies House",
					group2: "Please tell us how you found out about today's seminar",
					maths_question: "Please answer this question to prove you are not a spambot!"
                },
                submitHandler: function(form) {
                    form.submit();
                }
            });
        }
    };

    //when the dom has loaded setup form validation rules
    $(D).ready(function($) {
        JQUERY4U.UTIL.setupFormValidation();
    });

})(jQuery, window, document);

    $(".otherfind, .otherjobtitle").css('display', 'none');
	$("#job_title").change(
		function(){
				var item = $("#job_title").val();
			if(item == "other"){
				$(".otherjobtitle").show("fast");
    			$(".otherjobtitle input").focus();
			} else{
				$(".otherjobtitle").hide("slow");
			}
		}
	);	
 	$("#group2").change(
		function(){
				var item = $("#group2").val();
			if(item == "other"){
				$(".otherfind").show("fast");
    			$(".otherfind input").focus();
			} else{
				$(".otherfind").hide("slow");
			}
		}
	);	