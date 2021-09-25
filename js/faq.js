// JavaScript Document
function addLoadEvent(func) {
  var oldonload = window.onload;
  if (typeof window.onload != 'function') {
    window.onload = func;
  } else {
    window.onload = function() {
      oldonload();
      func();
    }
  }
}

function faqshowhide() {
	var faqshowhide = new Array ("general", "implementation", "directors_addresses", "directors_other","secretaries", "accounts", "members_shareholders", "mandres", "nireland", "forms", "companynames", "trading", "memorandum", "capital", "branches", "correction", "articles", "other");
	for (j=0; j<faqshowhide.length; j++) {
		document.getElementById(faqshowhide[j]).style.display = "none";
	}
			// click on left hand side to close all...
			var menu = document.getElementById("themenu");
			menu.parentNode.onclick = function() {
			for (k=0; k<faqshowhide.length; k++) {
				document.getElementById(faqshowhide[k]).style.display = "none";
			}
		}
	
	var faqbody = document.getElementById('faqbody');
	var para = faqbody.getElementsByTagName('p');
	for (i=0;i<para.length;i++) {
		if (para[i].className == 'topic') {
			para[i].style.cursor = "pointer";
			para[i].onmouseover = function() {
				this.style.color = "#C51D56";
			}
			para[i].onmouseout = function() {
				this.style.color = "#00144D";
			}
			para[i].onclick = function() {
				var id = this.getAttribute("title");
				document.getElementById(id).style.padding = "10px";
				document.getElementById(id).style.margin = "10px 0 10px 0";
				//document.getElementById(id).style.background = '#F1F6FA url("/images/companiesAct/historyBG.jpg") repeat-x';
				// /images/ABobby.gif
				document.getElementById(id).style.background = '#FAFBFD url("/images/companiesAct/historyBG.jpg") repeat-x';
				document.getElementById(id).style.display = (document.getElementById(id).style.display != 'none' ? 'none' : '');
				document.getElementById(id).style.border = (document.getElementById(id).style.border != '1px solid #ccccccc' ? '1px solid #cccccc' : '');
			}
		}
	}
}

addLoadEvent(faqshowhide);
