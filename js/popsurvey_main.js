function ShowPopup(iWidth, iHeight, iFile) {
	QBPopWin = window.open(iFile,'QBpopup','toolbar=no,directories=no,width='+iWidth+',height='+iHeight);
}

function OpenSurvey(iLink){
	NewWindow =	window.open(iLink,'QBSurvey','');
	ClosePopUp();
}

function ClosePopUp(iCookie){
	var didReply = getCookie(iCookie) || 0;
	//setCookie(iCookie,++didReply);
	self.close();
}

function checkPopUp(iCookie, iWidth, iHeight, iDelay, iFile, iPercent){
	res = getCookie(iCookie);
	var popPercent = iPercent;
	var popRandom = (100 *Math.random());
	if (!(res) && ((popRandom + popPercent)>100)) {
		setTimeout("ShowPopup("+iWidth+","+iHeight+",'"+iFile+"')",iDelay);
		var didReply = getCookie(iCookie) || 0;
		//setCookie(iCookie,++didReply);
	}
}

function setExpDate(){
	var today = new Date();
	var expire = new Date(today.getTime() + 7 * 24 * 60 * 60 * 1000); //7 days
	expire = expire.toGMTString();
	return expire;
}

function setCookie(cookieName, cookieValue) {
	var cookieLife = setExpDate();
	document.cookie = cookieName+ "=" +cookieValue+ "; expires=" +cookieLife+ "; path=/;";
}

function getCookie(name) {
	var currentCookie = document.cookie;
	var index = currentCookie.indexOf(name + "=");
	if (index == -1){ return null};
	index = currentCookie.indexOf("=", index) + 1; // first character 
	var endstr = currentCookie.indexOf(";", index);
	if (endstr == -1) endstr = currentCookie.length; // last character 
	return unescape(currentCookie.substring(index, endstr));
}
if(typeof $ !== 'undefined') {
	$(document).ready(function() {
		$('#survey input.surveyButton').click( function(e) {
			setCookie('ch_beta_free','1');
		});
	});
}