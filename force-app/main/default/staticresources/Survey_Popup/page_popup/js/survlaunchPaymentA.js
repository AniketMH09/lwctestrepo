function hideWindow() {
    window.resizeTo(0, 0);
    window.moveTo(0, window.screen.availHeight + 10);
    window.blur();
    window.opener.focus()
}

function checkpar() {
    Initialize = 1;
    var n = "";
    try {
        n = opener.location.hostname
    } catch (t) {
        n = "LEFT"
    }
    n != location.hostname && flg != 1 && (clearTimeout(tMW), window.moveTo(0, 0), gotosurvey())
}

function gotosurvey() {
    flg = 1;
    window.focus();
    window.moveTo(0, 0);
    window.resizeTo(screen.width, screen.height - 50);
    window.self.alert("Your survey will now begin.");
    location.assign(surveyURL + getCookie(icName, "0"))
}

function getCookie(n, t) {
	var name = "apex__webID=";
    var ca = document.cookie.split(';');
	for(var i=0; i<ca.length; i++) {
        var c = ca[i];
		while (c.charAt(0)==' ') c = c.substring(1);
        if (c.indexOf(name) == 0) 
		{
			return c.substring(name.length,c.length);
		}
    }
    return t;
	
}

var tID = "",
    tMW = "",
    job = "w6277HAPW",
    icName = "iHondaAcuraSurvey",
    delay, sec = 3,
    surveyURL = "https://survey3.sendyouropinions.com/honacufin?v=a&wid=",
    flg = 0;
delay = sec * 1e3;
tID = setInterval("checkpar();", delay);
hideWindow();