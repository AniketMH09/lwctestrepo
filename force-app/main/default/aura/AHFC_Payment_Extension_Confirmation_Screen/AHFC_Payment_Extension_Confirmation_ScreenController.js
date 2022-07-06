({
    doInit : function (component, event, helper){
         window.scroll(0, 0);
       console.log(component.get("v.accountStatusUpdatesViaEamil"));
       console.log(component.get("v.hasEzPay"));
       
    },
    
    redirectToHome : function(component,event,helper){
       //Return to MyAccount
               
          var url = window.location.href;
         // Adding custom label for domain [2/27/2019]
        var hondaDomain = $A.get("$Label.c.HONDA_DOMAIN");
        if(url.includes(hondaDomain)){
             url = $A.get("$Label.c.AHFC_Return_to_My_Account");
        } else{
      	    url = $A.get("$Label.c.AHFC_Return_To_My_Account_Acura");
        }
       window.open(url,'_top');

    },
    redirectToEzpay : function(component,event,helper){
       //Return to MyAccount
               
          var url = window.location.href;
         
        var hondaDomain = $A.get("$Label.c.HONDA_DOMAIN");
        if(url.includes(hondaDomain)){
             url = $A.get("$Label.c.AHFC_Return_to_EzPay_Honda");
        } else{
      	    url = $A.get("$Label.c.AHFC_Return_to_EzPay_Acura");
        }
       window.open(url,'_top');

    },

    
})