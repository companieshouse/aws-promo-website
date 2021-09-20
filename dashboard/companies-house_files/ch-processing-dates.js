function newDate(displayDate){
     displayDay = displayDate.substring(0,2);
            displayMonth = displayDate.substring(3,5);
            displayYear= displayDate.substring(6,10);
            switch(displayMonth){
                    case "01":
                    displayDate = displayDay + " " + "January" + " " + displayYear;
                    break;
                    case "02":
                    displayDate = displayDay + " " + "February" + " " + displayYear;
                    break;
                    case "03":
                    displayDate = displayDay + " " + "March" + " " + displayYear;
                    break;
                    case "04":
                    displayDate = displayDay + " " + "April" + " " + displayYear;
                    break;
                    case "05":
                    displayDate = displayDay + " " + "May" + " " + displayYear;
                    break;
                    case "06":
                    displayDate = displayDay + " " + "June" + " " + displayYear;
                    break;
                    case "07":
                    displayDate = displayDay + " " + "July" + " " + displayYear;
                    break;
                    case "08":
                    displayDate = displayDay + " " + "August" + " " + displayYear;
                    break;
                    case "09":
                    displayDate = displayDay + " " + "September" + " " + displayYear;
                    break;
                    case "10":
                    displayDate = displayDay + " " + "October" + " " + displayYear;
                    break;
                    case "11":
                    displayDate = displayDay + " " + "November" + " " + displayYear;
                    break;
                    case "12":
                    displayDate = displayDay + " " + "December" + " " + displayYear;
                    break;
                }
        return displayDate;
}

    $(function () {

	var displayDate=0;
	var displayDay=0;
	var displayMonth=0;
	var displayYear=0;
    var lastUpdatedDate=0;
    var lastUpdatedTime=0;
    var annualReturnDate=0;
    var accountsDate=0;
    var confirmationStatementDate=0;
    var mortgageDate=0;
    var otherDocsDate=0;
	resultArray=[];
	
		$.getJSON("/dashboard/json/processedDates.json", function(result) {	
		   $.each(result, function(key, value) {
				resultArray.push(value);					
			});	
		   resultArray[0].sort(function(a,b){
   			 
       	 		return a.datetime - b.datetime;
			 });	
		    resultArray[0].reverse();
            lastUpdatedTime = resultArray[0][0].time;
			lastUpdatedDate = resultArray[0][0].date;
//          annualReturnDate  = resultArray[0][0].annualReturn;
            accountsDate = resultArray[0][0].accounts;
            confirmationStatementDate = resultArray[0][0].confirmationStatement;
            mortgageDate = resultArray[0][0].mortgage;
            otherDocsDate = resultArray[0][0].otherDocuments;

			
			if(lastUpdatedTime > 11){				
			lastUpdatedTime = lastUpdatedTime -12;
				if (lastUpdatedTime == "00") {
					lastUpdatedTime = "12"}
				lastUpdatedTime = lastUpdatedTime + ":00 pm";
				}
			
			else{
				if (lastUpdatedTime == "00") {
					lastUpdatedTime = "12"}
				lastUpdatedTime = lastUpdatedTime + ":00 am";
			}
				
		  document.getElementById("time").innerHTML = lastUpdatedTime;
		  document.getElementById("date").innerHTML = newDate(lastUpdatedDate);
//		  document.getElementById("annualReturn").innerHTML = newDate(annualReturnDate);
		  document.getElementById("accounts").innerHTML = newDate(accountsDate);
		  document.getElementById("confirmationStatement").innerHTML =  newDate(confirmationStatementDate);
		  document.getElementById("mortgage").innerHTML =  newDate(mortgageDate);
		  document.getElementById("otherDocuments").innerHTML =  newDate(otherDocsDate);
   
  });
	
 });// JavaScript Document


