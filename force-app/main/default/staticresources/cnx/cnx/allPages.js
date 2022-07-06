function addScript(ref){
	var js = document.createElement('script');
	js.src = ref;
	document.getElementsByTagName("body")[0].appendChild(js);
}
function addCSS(ref){
	var lnk = document.createElement('link');
	lnk.src = ref;
	js.rel = "stylesheet";
	document.getElementsByTagName("head")[0].appendChild(lnk);
}
function addDiv(divID){
	var newDiv = document.createElement('div');
	newDiv.setAttribute("id", divID);
	document.getElementsByTagName("body")[0].appendChild(newDiv);
}

addDiv("cnx_toolkit");
addScript(window.basePath + "cnx_bundle.js");
addCSS(window.basePath + "cnx_style.css");
