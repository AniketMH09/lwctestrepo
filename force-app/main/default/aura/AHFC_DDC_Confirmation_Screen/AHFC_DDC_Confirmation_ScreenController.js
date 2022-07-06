({
    doInit : function (component, event, helper){
        var url = window.location.href;
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
                  paramName = paramName.toLowerCase();
                  obj[paramName] = paramValue;
                }
          }
        
         component.set("v.fAid",obj.sacrecordid); 
       
    },
    
     redirectToDashboard : function(component,event,helper){
        event.preventDefault(); 
         sessionStorage.setItem('reloaded','false');
        var navService = component.find( "navService" );  
        var pageReference = {  
            type: "comm__namedPage",  
            attributes: {  
                pageName: "dashboard"  
            }
        };          
        navService.navigate(pageReference);  
    },
        
    
    redirectToHome : function(component,event,helper){
       //Return to MyAccount
       //
       //Adding custom label for domain [2/27/2019]
       var hondaDomain = $A.get("$Label.c.HONDA_DOMAIN");
       var acuraDomain = $A.get("$Label.c.ACURA_DOMAIN");
        
        var url = window.location.href
        if(url.includes(hondaDomain)){
             url = $A.get("$Label.c.AHFC_Return_to_My_Account");
        } else{
      	    url = $A.get("$Label.c.AHFC_Return_To_My_Account_Acura");
        }
        
         window.open(url,'_top');

    },
    enrollAccount : function(component,event,helper){
         window.open($A.get("$Label.c.AHFC_Communication_Preferences_URL"),'_top');
    }

    
})