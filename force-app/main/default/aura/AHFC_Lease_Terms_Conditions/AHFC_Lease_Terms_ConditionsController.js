({
	doInit : function(component, event, helper) {
        
        window.scroll(0, 0);
		var redId= component.get("v.recordId");
        var url = window.location.href;
        
        // Adding custom label for domain [2/27/2019]
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
	},
    
    redirectToHome : function(component,event,helper){
        // Cancellation return to MyAccount Page
       	 var url = window.location.href;
        // Adding custom label for domain [3/01/2019]
        var hondaDomain = $A.get("$Label.c.HONDA_DOMAIN");
        var acuraDomain = $A.get("$Label.c.ACURA_DOMAIN");
        if(url.includes(hondaDomain)){
             url = $A.get("$Label.c.AHFC_Return_to_My_Account");
        } else if(url.includes(acuraDomain)){
      	    url = $A.get("$Label.c.AHFC_Return_To_My_Account_Acura");
        }
         window.open(url,'_top');
    },
    
    closeModel: function(component, event, helper) {
      // for Hide/Close Model,set the "isOpen" attribute to "Fasle"  
      component.set("v.isOpen", false);
    },
    
    openModel : function(component, event, helper) {
      // for Display Model,set the "isOpen" attribute to "true"
      component.set("v.isOpen", true);
    },
    
    handlePrevious : function(component, event, helper) {
      // When an option is selected, navigate to the Previous screen
      var response = event.getSource().getLocalId();
      component.set("v.value", response);
      var navigate = component.get("v.navigateFlow");
      navigate("BACK");
    },
    
    handleContinue : function(component, event, helper) {
       
     // When an option is selected, navigate to the next screen
      var response = event.getSource().getLocalId();
      component.set("v.value", response);
      var navigate = component.get("v.navigateFlow");
      navigate("NEXT");
       
   },
    
})