({
    
    
    doInit : function (component, event, helper){
        window.scroll(0, 0);
       // component.set("v.strRequestType","Do Not Sell");
       if (component.get("v.strRequestType") === $A.get('$Label.c.CCPA_DO_NOT_SELL')){
            component.set("v.strMessage",$A.get('$Label.c.CCPA_DNS_1ST_SCREEN'));
        }
        else if (component.get("v.strRequestType") === $A.get('$Label.c.CCPA_WHAT_INFO')){
            component.set("v.strMessage",$A.get('$Label.c.CCPA_INFO_1ST_SCREEN'));
        }
        else if (component.get("v.strRequestType") === $A.get('$Label.c.CCPA_DELETE_INFO')){
            component.set("v.strMessage",$A.get('$Label.c.CCPA_DELETE_1ST_SCREEN'));
        }
        
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
        
        console.log('inside doinit');
   },
      redirectToHome : function(component,event,helper){
        
        var hondaDomain = $A.get("$Label.c.HONDA_DOMAIN");
        var acuraDomain = $A.get("$Label.c.ACURA_DOMAIN");
        var url = window.location.href;
        
          if(url.includes(hondaDomain)){
             url = $A.get("$Label.c.AHFC_Honda_URL");
        } else{
      	    url = $A.get("$Label.c.AHFC_Acura_URL");
        }
       
       window.open(url,'_top');
    },
    
    closeModel: function(component, event, helper) {
       
        component.set("v.isOpen", false);
    },
    openModel: function(component, event, helper) {
        // for Display Model,set the "isOpen" attribute to "true"
        component.set("v.isOpen", true);
    },
    
    handleContinue : function(component, event, helper) {
        // When an option is selected, navigate to the next screen
        var response = event.getSource().getLocalId();
        component.set("v.value", response);
        var navigate = component.get("v.navigateFlow");
        //alert("navigate= "+navigate);
        navigate("NEXT");
    },
    contactUs : function(component, event, helper) {
        var url = window.location.href;
        
        var hondaDomain = $A.get("$Label.c.HONDA_DOMAIN");
        
        if(url.includes(hondaDomain)){
            window.open($A.get("$Label.c.AHFC_Contact_Us_URL_Honda"),'_top')

        } else {
            window.open($A.get("$Label.c.AHFC_Contact_Us_URL_Acura"),'_top')
           
        }
	},
})