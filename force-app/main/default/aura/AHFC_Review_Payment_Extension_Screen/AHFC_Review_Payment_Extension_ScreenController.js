({
    doInit : function (component, event, helper){
        window.scroll(0, 0);
	var PaymentAmountDecimal='';
        var n= parseFloat(component.get("v.nextPaymentAmount"));
        PaymentAmountDecimal=n.toFixed(2).toString();
        component.set('v.nextPaymentAmountDecimal', PaymentAmountDecimal);  
        
         // I-359479 | 02/25/2019 | Rahul 
        if(component.get("v.faNumber") != undefined && component.get("v.faNumber") != ''){
            var financeAccNo = component.get("v.faNumber");
            financeAccNo = Number(financeAccNo).toString();
            component.set("v.financeAccNumber",financeAccNo);
        }
    },
    
    redirectToHome : function(component,event,helper){
       // On Cancellation redirect to MyAccount Page
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
    

    handleContinue : function(component, event, helper) {
     	// When an option is selected, navigate to the next screen
      var response = event.getSource().getLocalId();
      component.set("v.value", response);
      var navigate = component.get("v.navigateFlow");
      navigate("NEXT");
   },
    
   handlePrevious:function(component, event, helper) {
      // When an option is selected, navigate to the Previous screen
      var response = event.getSource().getLocalId();
      component.set("v.value", response);
      var navigate = component.get("v.navigateFlow");
      navigate("BACK");
   },
    
    closeModel: function(component, event, helper) {
      // for Hide/Close Model,set the "isOpen" attribute to "Fasle"  
      component.set("v.isOpen", false);
   },
    openModel: function(component, event, helper) {
      // for Display Model,set the "isOpen" attribute to "true"
      component.set("v.isOpen", true);
   }    
    
})