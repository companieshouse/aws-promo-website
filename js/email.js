function openurl(opt) {
   if (opt == "info") { 
      txt = document.dropdown.information.value;
   }
   if (opt == "tools") {
   txt = document.dropdown.tools.value;
   }
   if(txt != "") {
   window.location = txt;
   }
}

function doIt()
{
var S='Company information at your fingertips';
var text='I found this information on the Companies House website and thought that you would find it useful %0D%0D';
var link=document.location;
self.location="mailto:?subject="+S+"&body="+text+link;
}

function popup( url, width, height ) {
     window.open(url,'popup', 'toolbar=0,scrollbars=1,location=0,status=1,menubar=1,resizable=yes,width=' + width + ',height=' + height + '');
  }

function openurl(opt) {
   if (opt == "info") {
      txt = document.dropdown.information.value;
   }
   if (opt == "tools") {
   txt = document.dropdown.tools.value;
   }
   if(txt != "") {
   window.location = txt;
   }
}