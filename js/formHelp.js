window.onload = addHelp;

function addHelp()
{
	var strID, objHelp;
	
	if (document.getElementById && document.appendChild && document.removeChild)
	{
		var objHelpform = document.getElementById('transfer');
		
		var objAnchors = objHelpform.getElementsByTagName('a');
		for (var iCounter=0; iCounter<objAnchors.length; iCounter++)
		{
			if (objAnchors[iCounter].className != 'leave')
			{
				strID = getIDFromHref(objAnchors[iCounter].href);
				objHelp = document.getElementById(strID);
				objHelp.style.display = 'none';
		
				objAnchors[iCounter].onclick = function(event){return expandHelp(this, event);}
				objAnchors[iCounter].onkeypress = function(event){return expandHelp(this, event);}
		
				objAnchors[iCounter].parentNode.appendChild(objHelp);
			}
		}
		
		var objOldnode = document.getElementById('helpcontainer');
		
		objOldnode.parentNode.removeChild(objOldnode);
		
		// Release memory to prevent IE memory leak
		// Thanks to Mark Wubben <http://novemberborn.net/>
		// for highlightint the issue</span>
		
		objHelpform = null;
		objHelp = null;
		objAnchors = null;
	}
}

function getIDFromHref(strHref)
{
	var iOffset = strHref.indexOf('#') + 1;
	var iEnd = strHref.length;

	return strHref.substring(iOffset, iEnd);
}

function expandHelp(objAnchor, objEvent)
{
	var iKeyCode;

	if (objEvent && objEvent.type == 'keypress')
	{
		if (objEvent.keyCode)
			iKeyCode = objEvent.keyCode;
		else if (objEvent.which)
			iKeyCode = objEvent.which;
		
		if (iKeyCode != 13 && iKeyCode != 32)
			return true;
	}

	strID = getIDFromHref(objAnchor.href);
	objHelp = document.getElementById(strID);

	if (objHelp.style.display == 'none')
		objHelp.style.display = 'block';
	else
		objHelp.style.display = 'none';

	return false;
}
