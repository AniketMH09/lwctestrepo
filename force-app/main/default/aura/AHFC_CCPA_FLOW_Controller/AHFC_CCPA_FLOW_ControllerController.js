({
    doInit : function (component) {
        
        
        var flow = component.find("CCPAFlow");
        
        var url = window.location.href;
        
        var strCommunityName = "";
        console.log(url);
        
        /* Addition for domain */
        
          
        
        // Adding custom label for domain [3/01/2019]
        var hondaDomain = $A.get("$Label.c.HONDA_DOMAIN");
        var acuraDomain = $A.get("$Label.c.ACURA_DOMAIN");
        
         if(url.includes(hondaDomain))
        {    
            component.set("v.communityName",'hondahelp');
            strCommunityName = 'hondahelp';
        }
        else if(url.includes(acuraDomain))
        { 
             component.set("v.communityName",'acurahelp');
            strCommunityName = 'acurahelp';
        }
        
        /*End of addition for domain */
        
        
        var recordId =url.substr(url.indexOf('=') + 1);
        var srchstr = '';
        var paramname = 't';
       
        var strRequestType = 'Do Not Sell Request';
        var strSource = 'Footer';
        var strCaseType = 'Do Not Sell';
        
        var queryString = url.substring(url.indexOf("?")+1);
            var obj = {};
            if (queryString) {
                // split our query string into its component parts
                var arr = queryString.split('&');
                console.log(arr);
                for (var i = 0; i < arr.length; i++) {
                  var aTemp = arr[i];
                  var paramName = aTemp.substring(0,aTemp.indexOf("="));
                  var paramValue = aTemp.substring(aTemp.indexOf("=")+1);
                  //paramName = paramName.toLowerCase();
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
        
        console.log(obj);
        var inputVariables = [{name:'strRequestType', type:'String', value:strRequestType}, 
                                          {name:'strSource', type:'String', value:strSource},
                              {name:'strCaseType', type:'String', value:strCaseType}
                             ];
        console.log(inputVariables);
        
        flow.startFlow($A.get('$Label.c.CCPA_FLOW'),inputVariables);
        
        /*
         var inputVariables = [{name:'caseIntId', type:'String', value:component.get("v.caseInteractionId")}, 
                                          {name:'userId', type:'String', value:component.get("v.userId")}];
                    flow.startFlow(flowId, inputVariables);     
                    
                    */

      
        
       
    },
})