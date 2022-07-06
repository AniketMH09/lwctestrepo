let pages = [
  {
    pageId: 1,
    Nth: 1.0,
    route: "https://webproj6-hondafinance.cs35.force.com/customer/s/survey",
  },
];

let basePath="https://uat2.sendyouropinions.com/ClientFiles/Honda/cnx";

function removeResources() {
  document.querySelectorAll("script").forEach((script) => {
    if (script.src.indexOf(basePath+"/cnx_bundle.js") != -1)
      script.parentNode.removeChild(script);
  });
  document.querySelectorAll("link").forEach((link) => {
    if (link.href.indexOf(basePath+"/cnx_style.css") != -1)
      link.parentNode.removeChild(link);
  });
  document.querySelectorAll("div").forEach((div) => {
    if (div.id == "cnx_toolkit") div.parentNode.removeChild(div);
  });
}

function addResources() {
  let x = document.createElement("script");
  x.src = basePath+"/cnx_bundle.js";
  document.body.appendChild(x);
  let y = document.createElement("link");
  y.href = basePath+"/cnx_style.css";
  y.rel = "stylesheet";
  document.head.appendChild(y);
  let z = document.createElement("div");
  z.id = "cnx_toolkit";
  document.body.appendChild(z);
}

function loadWebPop(pageId, Nth) {
  window.pageId = pageId;
  window.Nth = Nth;
  // RELOAD RESOURCES
  removeResources();
  addResources();
}
let oldHref = "";
let bodyList = null;

function cnxInit(){
	if (document.querySelector("body") == null)
		window.setTimeout(cnxInit, 100);
	else{
		// LISTEN TO URL CHANGES
		bodyList = document.querySelector("body"),
		  observer = new MutationObserver(function (mutations) {
			mutations.forEach(function (mutation) {
			  if (oldHref != document.location.href) {
				oldHref = document.location.href;
				pages.forEach((page) => {
				  console.log(page.route);
				  if (page.route == oldHref) loadWebPop(page.pageId, page.Nth);
				});
			  }
			});
		  });
		const config = {
		  childList: true,
		  subtree: true,
		};
		observer.observe(bodyList, config);
	}
}
cnxInit();