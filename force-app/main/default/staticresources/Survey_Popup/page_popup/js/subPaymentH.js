"use strict";

 
	  
function doPopunder(n, t, i, r, u, f) {
    var o = "toolbar=no,scrollbars=yes,location=yes,statusbar=yes,menubar=no,resizable=1,width=" + i.toString() + ",height=" + r.toString() + ",screenX=" + u + ",screenY=" + f,
        e = window.open(n, t, o);
    e && pop2under(e)
}

function pop2under(n) {
    try {
        n.blur();
        n.opener.window.focus();
        window.self.window.blur();
        window.focus();
        (browser.firefox || browser.chrome) && openCloseWindow();
        browser.webkit && openCloseTab()
    } catch (t) {}
}

function openCloseWindow() {
    var n = window.open("about:blank");
    n.focus();
    n.close()
}

function openCloseTab() {
    var n = document.createElement("a"),
        t;
    n.href = "about:blank";
    n.target = "PopHelper";
    document.getElementsByTagName("body")[0].appendChild(n);
    n.parentNode.removeChild(n);
    t = document.createEvent("MouseEvents");
    t.initMouseEvent("click", !0, !0, window, 0, 0, 0, 0, 0, !0, !1, !1, !0, 0, null);
    n.dispatchEvent(t);
    window.open("about:blank", "PopHelper").close()
}
 
function okBrowser() {  

		 
    var i = navigator.appName,
        t = parseInt(navigator.appVersion),
        n = !1;
    switch (i) {
        case "Microsoft Internet Explorer":
            t > 3 && (n = !0, isIE = !0);
            break;
        case "Netscape":
            t > 4 && (n = !0, isMoz = !0)
    }
    return navigator.userAgent == "Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1; KTXN)" && (n = !1), /Android|webOS|iPhone|iPad|iPod|BlackBerry|BB|PlayBook|IEMobile|Windows Phone|Kindle|Silk|Opera Mini/i.test(navigator.userAgent) && (n = !1), n
}

function logResponse(n) {
    clearInterval(centobj.savedIntervalId);
    var t = new Image;
    t.src = logGIF + "?state=" + n + "&job=" + job + "&x=" + Math.random();
    visInvite("hidden")
}

function acceptSurvey() {
    clearInterval(centobj.savedIntervalId);
    logResponse(2);
    doPopunder(launchURL, "SurveyLaunch", 300, 100, window.screenX, window.screenY);
    //window.focus()
	location.reload();
}

function declineSurvey() {
    clearInterval(centobj.savedIntervalId);
    logResponse(3);
	location.reload();
}

function createInvite() {
    var t = new Image,
        n;
    t.src = logGIF + "?state=1&job=" + job + "&x=" + Math.random();
    n = '<style type="text/css">         td{text-align: center;}         .normalStyle{font: 15px "Helvetica Neue", Helvetica, Arial, sans-serif}         .boldStyle{font: bold 20px "Helvetica Neue", Helvetica, Arial, sans-serif;}         .smallItalic{font: italic 10px "Helvetica Neue", Helvetica, Arial, sans-serif;}     <\/style>     <div style="background-color: #fff; position: absolute; width:' + inviteWidth + 'px; ">     <table style="width: 100%; margin: auto; border: 1px solid black;">         <tr><td><img src="/resource/Survey_Popup/page_popup/Images/HFSLogo_300.png" alt="HFS Logo" /><\/td><\/tr>         <tr><td class="boldStyle">We want to hear from you!<\/td><\/tr>         <tr><td class="normalStyle"><br />As a valued customer, you are invited to participate in a 3 minute online survey at the end of your visit which will be used to improve services we offer.<br /><br /><\/td><\/tr>         <tr><td class="boldStyle">Please click below to take the survey.<\/td><\/tr>         <tr><td><table style="margin: auto;"><tr><td style="width: 37px;">&nbsp;<\/td><td><a onclick="acceptSurvey();" style="cursor: pointer;"><img src="/resource/Survey_Popup/page_popup/Images/yes.png" alt="Yes! When I complete my transaction" /><\/a><\/td><td style="width: 37px;"><\/td><\/tr>             <tr><td>&nbsp;<\/td><td><a  onclick="declineSurvey();" style="cursor: pointer;"><img src=" /resource/Survey_Popup/page_popup/Images/no.png" alt="No, thanks. Maybe next time." /><\/a><\/td><td>&nbsp;<\/td><\/tr><\/table><\/td><\/tr>         <tr><td class="smallItalic">Review the <a href="https://survey3.sendyouropinions.com/images/privacy.htm" target="_blank">Privacy Statment<\/a> for this survey.<\/td><\/tr>     <\/table>     <\/div>';
    document.write('<div id="surveyCover" style="position:absolute; left:0; top:0; height: 0px; width: 100%; z-index:11; visibility: hidden; background-color: #000; opacity: 0.6; filter:alpha(opacity=60);"><\/div>');
    document.write('<div id="surveylayer" style="position:absolute; left:0; top:25%; margin-top: -' + inviteHeight / 2 + "px; z-index:12; visibility: hidden; border:1px #7d7d7d solid; width:" + (inviteWidth + 2) + "px;height=" + inviteHeight + 'px;">' + n + "<\/div>")
}

function resizeCover() {
    var n;
    isIE ? (n = document.all.surveyCover, n.style.height = (window.innerHeight || document.documentElement.clientHeight || 0) + "px", n.style.top = (window.pageYOffset || document.body.scrollTop || document.documentElement.scrollTop) + "px", n.style.width = (window.innerWidth || document.documentElement.clientWidth || 0) + "px", n.style.left = (window.pageXOffset || document.body.scrollLeft || document.documentElement.scrollLeft) + "px") : isMoz && (n = document.getElementById("surveyCover"), n.style.height = (window.innerHeight || document.documentElement.clientHeight || 0) + "px", n.style.top = (window.pageYOffset || document.body.scrollTop || document.documentElement.scrollTop) + "px", n.style.width = (window.innerWidth || document.documentElement.clientWidth || 0) + "px", n.style.left = (window.pageXOffset || document.body.scrollLeft || document.documentElement.scrollLeft) + "px")
}

function visInvite(n) {
    if (isIE) {
        var t = document.all.surveyCover;
        document.all.surveylayer.style.visibility = n;
        t.style.visibility = n
    } else isMoz && (document.getElementById("surveylayer").style.visibility = n, document.getElementById("surveyCover").style.visibility = n);
    if (n == "visible") tVar = setInterval("resizeCover()", 100);
    else try {
        clearInterval(tVar)
    } catch (i) {}
}

function leftPos() {
    return window.pageOffset || document.body.scrollLeft || 0
}

function topPos() {
    return window.pageYOffset || document.body.scrollTop || 0
}

function winWidth() {
    return window.innerWidth || document.body.offsetWidth - 20 || 0
}

function winHeight() {
    return window.innerHeight || document.body.offsetHeight || 0
}

function moveInvite(n) {
    n < 0 && (n = 0);
    isIE ? document.all.surveylayer.style.posLeft = n : document.getElementById("surveylayer").style.left = n + "px"
}

function centerObj() {
    function n(n) {
        visInvite("visible");
        this.w = inviteWidth;
        this.h = inviteHeight;
        this.lastX = n;
        this.resize();
        this.adjust();
        window.onresize = new Function("centobj.resize()");
        this.savedIntervalId = setInterval("centobj.adjust()", this.delay)
    }

    function t() {
        var t = this.delay,
            n = this.lastX,
            f = this.lastY,
            i = Math.abs(leftPos() + this.marginX - n),
            r = Math.abs(topPos() + this.marginY - f),
            e = Math.sqrt(i * i + r * r),
            u = Math.round(e / 50);
        leftPos() + this.marginX > n && (n = n + t + u);
        leftPos() + this.marginX < n && (n = n - t - u);
        moveInvite(n);
        this.lastX = n
    }

    function i() {
        this.marginX = Math.round(winWidth() / 2) - Math.round(this.w / 2);
        this.marginY = Math.round(winHeight() / 2) - Math.round(this.h / 2)
    }
    return this.test = 0, this.delay = 5, this.w = this.h = 0, this.lastX = this.lastY = 0, this.marginX = this.marginY = 0, this.savedIntervalId = 0, this.init = n, this.adjust = t, this.resize = i, this
}

function createCookie(n, t, i) {
    var r = new Date,
        u;
    return r.setTime(r.getTime() + i * 864e5), u = n + "=" + t + "; path=/; expires=" + r.toGMTString() + ";", document.cookie = u, !0
}

function haveCookie(n) { 
    return document.cookie.indexOf(n) != -1
	//return false;
}

function CheckNth(n) {   
			
			return n == 1 ? !0 : n > Math.random() ? !0 : !1
		 
}
var isIE = !1,
    isMoz = !1,
    logGIF = "https://survey3.sendyouropinions.com/WebPop/log.gif",
    inviteHeight = 495,
    inviteWidth = 384,
    job = "w6277HAPW",
    imageDir = "./Images/",
    launchURL = "apex/slaunchPaymentH",
    icName = "iHondaAcuraSurvey",
    tVar, iPopDel = 0,
    webID, browser, NthVal = 0, centobj, Nth;
webID || (webID = "0");
browser = function() {  
	
	 
	
	AccountRemoter.getHonda(function(result, event){   
		 Nth = parseInt(result);  
		 okBrowser() && (NthVal = 0, NthVal = typeof Nth == "undefined" ? 1 : Nth, haveCookie(icName) || CheckNth(NthVal) && (createCookie(icName, webID, 60), createInvite(), centobj = new centerObj, setTimeout("centobj.init(0)", iPopDel)));
	});
		
	
    var n = navigator.userAgent.toLowerCase(),
        t = {
            webkit: /webkit/.test(n),
            mozilla: /mozilla/.test(n) && !/(compatible|webkit)/.test(n),
            chrome: /chrome/.test(n),
            msie: /msie/.test(n) && !/opera/.test(n),
            firefox: /firefox/.test(n),
            safari: /safari/.test(n) && !/chrome/.test(n),
            opera: /opera/.test(n)
        };
    return t.version = t.safari ? (n.match(/.+(?:ri)[\\/: ]([\\d.]+)/) || [])[1] : (n.match(/.+(?:ox|me|ra|ie)[\\/: ]([\\d.]+)/) || [])[1], t
}();

 






















