({
	contactUs : function(component, event, helper) {
		 $A.get("e.force:navigateToURL").setParams({ 
           "url": $A.get("$Label.c.AHFC_Contact_Us_URL")
        }).fire();
	},
})