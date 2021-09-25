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

/*function isSafari() {
	browser = navigator.userAgent;
	//alert(browser);
	//alert(browser.search(/Firefox/));
	if (browser.search(/Safari/) != -1) {
		//alert('this is Safari');
		return;
	}
	hidedivs();
}*/

function hidedivs() {
	// add help text:
	if (document.getElementById("hoverMouse"))
	{
		hov = document.getElementById("hoverMouse");
		hov.innerHTML = "Hover your mouse over a date on the time line to view more information:";
	} 
	if (document.getElementById("hoverMouseW"))
	{
		hovw = document.getElementById("hoverMouseW");
		hovw.innerHTML = "Daliwch eich llygoden dros ddyddiad ar y llinell amser i weld rhagor o wybodaeth:";
	}
	
	divs = new Array("nov2005", "jan2006", "june2006", "aug2006", "nov2006", "feb2007"); // not hide first, as need to show something on page.
	for (i=0; i<divs.length; i++) {
		var j = divs[i];
		document.getElementById(j).style.display = "none";
		//$(j).style.display = "none";
	}
	imagemap();
}

function hidealldivs() { // hides all to flush out divs when another div is selected.
	divs = new Array("mar2005", "nov2005", "jan2006", "june2006", "aug2006", "nov2006", "feb2007"); 
	for (i=0; i<divs.length; i++) {
		var j = divs[i];
		document.getElementById(j).style.display = "none";
		//$(j).style.display = "none";
	}
}

function imagemap() {
	area = new Array("mar05", "nov05", "jan06", "jun06", "aug06", "nov06", "feb07");
	for (i=0; i<area.length; i++) {
			var j = area[i];

			document.getElementById(j).onmouseover = function() {
			//$(j).onmouseover = function() {
				hidealldivs();
				var id = this.getAttribute("title");
				//document.getElementById(id).style.display = "none";
				//Effect.toggle(id,'blind');
				//Effect.Grow(id);
				
				//Effect.Appear(id);
				id = document.getElementById(id);
				id.style.display = (id.style.display != 'none' ? 'none' : '');
				return false;
			}
	}

}

addLoadEvent(hidedivs);
