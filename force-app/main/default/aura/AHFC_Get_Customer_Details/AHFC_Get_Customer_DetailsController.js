({
    // @VM 10/17, T-736268 : Server call to get custom setting value for no. of days to be enable
    doInit : function (component, event, helper) {
        component.set("v.countryOptions", helper.getCountryOptions());
        component.set("v.provinceOptions", helper.getProvinceOptions(component.get("v.country")));
        
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
       
    },
    
    updateProvinces: function(component, event, helper) {
        cmp.set("v.provinceOptions", helper.getProvinceOptions(component.get("v.country")));
    },
    
    redirectToHome : function(component,event,helper){
        //@KP Nov/08 - T-747962 Cancellation return to MyAccount Page
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
    
    closeModel: function(component, event, helper) {
      // for Hide/Close Model,set the "isOpen" attribute to "Fasle"  
      component.set("v.isOpen", false);
    },
    
    openModel : function(component, event, helper) {
      // for Display Model,set the "isOpen" attribute to "true"
      component.set("v.isOpen", true);
    },
    
    handleContinue : function(component, event, helper) {
     // When an option is selected, navigate to the next screen
      var response = event.getSource().getLocalId();
      component.set("v.value", response);
      var navigate = component.get("v.navigateFlow");
      navigate("NEXT");
   },
    
   contactUs : function(component, event, helper) {
        var href = $A.get("$Label.c.AHFC_Contact_Us_URL");
        window.open(href,'_top');
	}, 
    updateStates : function(component, event, helper) {
        if(component.get("v.selectedCountry")){
            helper.getStates(component, event, helper);
        }
	},
})