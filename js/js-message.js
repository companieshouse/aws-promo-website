$("#chs-beta-close").removeClass("chs-beta-close-hidden");
$("#ch-beta-alert").removeClass("ch-beta-alert-visible");
$(document).ready(function() {

  if (!readCookie('ch_beta_message')) {
    $('#ch-beta-alert').show();
  }

  $('#chs-beta-close').click(function() {
    $('#ch-beta-alert').hide();
    createCookie('ch_beta_message', true, 1)
    return false;
  });

});

function createCookie(name,value,days) {
  if (days) {
    var date = new Date();
    date.setTime(date.getTime()+(days*7*24*60*60*1000)); //7 days
    var expires = "; expires="+date.toGMTString();
  }
  else var expires = "";
  document.cookie = name+"="+value+expires+"; path=/";
}

function readCookie(name) {
  var nameEQ = name + "=";
  var ca = document.cookie.split(';');
  for(var i=0;i < ca.length;i++) {
    var c = ca[i];
    while (c.charAt(0)==' ') c = c.substring(1,c.length);
    if (c.indexOf(nameEQ) == 0) return c.substring(nameEQ.length,c.length);
  }
  return null;
}

function eraseCookie(name) {
  createCookie(name,"",-1);
}