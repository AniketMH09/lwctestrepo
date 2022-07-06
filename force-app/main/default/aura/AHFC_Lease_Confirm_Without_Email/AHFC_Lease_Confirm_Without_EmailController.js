({
    doInit : function (component, event, helper){
         window.scroll(0, 0);
       
       
    },
        
    //I-353798 | Namita | 19 Nov 18
    redirectToMyAccount : function(component,event,helper){
       //Return to MyAccount
          var url = window.location.href;
         // Adding custom label for domain [3/01/2019]
        var hondaDomain = $A.get("$Label.c.HONDA_DOMAIN");
        if(url.includes(hondaDomain)){
             url = $A.get("$Label.c.AHFC_Return_to_My_Account");
        } else{
      	    url = $A.get("$Label.c.AHFC_Return_To_My_Account_Acura");
        }
       window.open(url,'_top');

    },
    
    enrollAccount : function(component,event,helper){
        // window.open($A.get("$Label.c.AHFC_Communication_Preferences_URL"),'_top');
        var url = window.location.href;
          // Adding custom label for domain [3/01/2019]
        var hondaDomain = $A.get("$Label.c.HONDA_DOMAIN");
        if(url.includes(hondaDomain)){
             url = $A.get("$Label.c.AHFC_Communication_Preferences_URL");
        } else{
      	    url = $A.get("$Label.c.AHFC_Communication_Preferences_URL_Acura");
        }
       window.open(url,'_top');
    }

    
})