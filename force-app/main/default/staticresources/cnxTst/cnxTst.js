let cnxFName = "cnxTst.js";

function getBasePath(file){
	let scr = document.getElementsByTagName("script");
	let lfile = file.toLowerCase();
	for (var i = 0; i < scr.length; i++){
		let srcElem = scr[i].src;
		if (srcElem.toLowerCase().endsWith(lfile) ){
			return srcElem.substr(0, srcElem.length - file.length);
		}
	}
	return "";
}

var basePath = getBasePath(cnxFName);


function cnxInit(){
	if (document.querySelector("body") == null)
		window.setTimeout(cnxInit, 100);
	else{
		  let x = document.createElement("script");
		  x.src = basePath+"/cnxTst2.js";
		  document.body.appendChild(x);
	}
}
cnxInit();