({

    doInit : function (component, event, helper){
         window.scroll(0, 0);
        
         var url = window.location.href;
        
        // Adding custom label for domain [3/01/2019]
        var hondaDomain = $A.get("$Label.c.HONDA_DOMAIN");
        var acuraDomain = $A.get("$Label.c.ACURA_DOMAIN");
        
        
         if(url.includes(hondaDomain))
        {    
            component.set("v.communityName",'hondahelp');
        }
        else if(url.includes(acuraDomain))
        { 
             component.set("v.communityName",'acurahelp');
        }
        var msg = "Default Message";
        //component.set("v.strRequestType", "Default Request Type");
        var state =  component.get("v.strstate");
        if (state==='California') {
            msg = "Your case has been submitted. Your Case number is " +  component.get("v.strCaseNumber") ;
            component.set("v.strMessage", msg);
        }
        else {
            msg = "Sorry but you are not eligible for this request as you are not a California Resident";
            component.set("v.strMessage", msg);
        }
            
        console.log(component.get('v.Record_Not_Found'));
    },
    
    redirectToHomeWindow : function(component,event,helper){
        //On Make a Payment, Redirect to Payment Page
       var url = window.location.href
        // Adding custom label for domain [3/01/2019]
        var hondaDomain = $A.get("$Label.c.HONDA_DOMAIN");
       
        if(url.includes(hondaDomain)){
             url = $A.get("$Label.c.AHFC_Honda_URL");
        } else{
      	    url = $A.get("$Label.c.AHFC_Acura_URL");
        }
        window.open(url,'_top');
	},
    
    redirectToHome : function(component,event,helper){
        $A.get("e.force:navigateToURL").setParams({ 
           "url": "/"
        }).fire();
    },
    
    cancelButton : function(component,event,helper){
        var url = window.location.href;
        // Adding custom label for domain [3/01/2019]
        var hondaDomain = $A.get("$Label.c.HONDA_DOMAIN");
        
        if(url.includes(hondaDomain)) {
           window.open($A.get("$Label.c.AHFC_Return_to_My_Account"),'_top');
        } else {
           window.open($A.get("$Label.c.AHFC_Return_To_My_Account_Acura"),'_top'); 
        }
    },
    
    contactUs : function(component, event, helper) {
        var url = window.location.href;
        // Adding custom label for domain [3/01/2019]
        var hondaDomain = $A.get("$Label.c.HONDA_DOMAIN");
        
        if(url.includes(hondaDomain)){
            window.open($A.get("$Label.c.AHFC_Contact_Us_log_in_URL_Honda"),'_top')
            /*$A.get("e.force:navigateToURL").setParams({ 
           "url": $A.get("$Label.c.AHFC_Contact_Us_log_in_URL_Honda")
            }).fire();*/
        } else {
            window.open($A.get("$Label.c.AHFC_Contact_Us_log_in_URL_Acura"),'_top')
            /* $A.get("e.force:navigateToURL").setParams({ 
               "url": $A.get("$Label.c.AHFC_Contact_Us_log_in_URL_Acura")
            }).fire();*/
        }
	},
    
    redirectToMyAccount : function(component,event,helper){
       //Return to MyAccount
        var url = window.location.href;
             // Adding custom label for domain [3/01/2019]
        var hondaDomain = $A.get("$Label.c.HONDA_DOMAIN");
        
        if(url.includes(hondaDomain)){
           window.open($A.get("$Label.c.AHFC_Return_to_My_Account"),'_top');
        } else {
           window.open($A.get("$Label.c.AHFC_Return_To_My_Account_Acura"),'_top'); 
        }

    },

})