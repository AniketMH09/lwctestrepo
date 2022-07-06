	let spaFName = "SPA.js";

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
	window.basePath=getBasePath(spaFName);
	
	let pages = [
      { pageId: 1, Nth: 0.12, route:'https://poc.americanhondafinance.com/s/dashboard' },{ pageId: 2, Nth: 0.12, route:'https://poc.americanhondafinance.com/s/dashboard' }
    ];
	
    function removeResources() {
      document.querySelectorAll("script").forEach((script) => {
        if (script.src.indexOf(window.basePath + "cnx_bundle.js") != -1)
          script.parentNode.removeChild(script);
      });
      document.querySelectorAll("link").forEach((link) => {
        if (link.href.indexOf(window.basePath +"cnx_style.css") != -1)
          link.parentNode.removeChild(link);
      });
      document.querySelectorAll("div").forEach((div) => {
        if (div.id == "cnx_toolkit") div.parentNode.removeChild(div);
      });
    }
	
    function addResources() {
      let y = document.createElement("link");
      y.href = window.basePath + "cnx_style.css";
      y.rel = "stylesheet";
      document.head.appendChild(y);
      let z = document.createElement("div");
      z.id = "cnx_toolkit";
      document.body.appendChild(z);
      let x = document.createElement("script");
      x.src = window.basePath + "cnx_bundle.js";
      document.body.appendChild(x);
    }
	
    function loadWebPop(pageId, Nth) {
      window.pageId = pageId;
      window.Nth = Nth;
      removeResources();
      addResources();
    }
	
    window.LoadNextWebpop = function (index) {
      loadWebPop(pages[index].pageId, pages[index].Nth);
    };
	
    let oldHref = '';
	let bodyList = null;
	
	function cnxInit(){
		if (document.querySelector("body") == null)
			window.setTimeout(cnxInit, 100);
		else{		
			let bodyList = document.querySelector("body"),
			  observer = new MutationObserver(function (mutations) {
				mutations.forEach(function (mutation) {
				  if (oldHref != document.location.href) {
					oldHref = document.location.href;
					for (let i = 0; i < pages.length; i++){
						if (oldHref == pages[i].route){
						  loadWebPop(pages[i].pageId, pages[i].Nth);
						}
					}
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