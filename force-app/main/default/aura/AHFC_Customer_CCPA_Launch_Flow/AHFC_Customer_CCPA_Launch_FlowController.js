({
    doInit : function (component) {
        
        var flow = component.find("CCPAFlow");
        var url = window.location.href;
        var recordId =url.substr(url.indexOf('=') + 1);
        var strRequestType = 'Do Not Sell Request';
        var strSource = 'Footer';
        var strCaseType = 'Do Not Sell';
        
        var queryString = url.substring(url.indexOf("?")+1);
            var obj = {};
            if (queryString) {
                // split our query string into its component parts
                var arr = queryString.split('&');
                for (var i = 0; i < arr.length; i++) {
                  var aTemp = arr[i];
                  var paramName = aTemp.substring(0,aTemp.indexOf("="));
                  var paramValue = aTemp.substring(aTemp.indexOf("=")+1);
                  obj[paramName] = paramValue;
                }
          }
       if (obj['T'] === 'DNS') {
            strRequestType = $A.get('$Label.c.CCPA_DO_NOT_SELL');
            strCaseType = $A.get('$Label.c.CCPA_DO_NOT_SELL_TYPE');
        }
        else if (obj['T'] === 'WI') {
            strRequestType = $A.get('$Label.c.CCPA_WHAT_INFO');
            strCaseType = $A.get('$Label.c.CCPA_WHAT_INFO_TYPE');
            
        }
        else if (obj['T'] === 'DMI') {
            strRequestType = $A.get('$Label.c.CCPA_DELETE_INFO');
            strCaseType = $A.get('$Label.c.CCPA_DELETE_INFO_TYPE');
            
        };
        
        if (obj['S'] === 'F') {
            strSource  = 'Footer';
        }
        else if (obj['S'] === 'P') {
            strSource = 'Privacy';
        }
        else if (obj['S'] === 'A') {
            strSource = 'Agent';
        }; 
        
        var inputVariables = [{name:'strRequestType', type:'String', value:strRequestType}, 
                                          {name:'strSource', type:'String', value:strSource},
                              {name:'strCaseType', type:'String', value:strCaseType}
                             ];
        
        flow.startFlow('AHFC_CCPA_Flow',inputVariables); 
        
      
    },
})