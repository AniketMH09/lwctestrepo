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
      event.getSource().set("v.disabled", true);
      component.set('v.buttonDisabled', true);
        
        //let submitclicks = component.get("v.SubmitClicks");
        //if (submitclicks > 0) return;
        //submitclicks = submitclicks + 1;
        //component.set("v.SubmitClicks", submitclicks);
        
        let fanumber = component.get("v.financeAccNumber");
        let faid = component.get("v.financeAccId");
        let reqNumMths = component.get("v.noOfMonthRequested");
        let action = component.get("c.callLEService");
        console.log("IN line 48 first set resultofwebsvc= "+component.get("v.resultofwebsvc"));
        action.setParams({
            "FinAcctId": faid,
            "reqExtLength": reqNumMths
        });
        //component.set("v.resultofwebsvc", "INCOMPLETE");
        
        action.setCallback(this, function (response) {
            console.log(response);
            var state = response.getState();
            var rslt = response.getReturnValue();
            console.log("IN setCallback line 55 and resultofwebsvc= "+component.get("v.resultofwebsvc"));
            if (state === "SUCCESS") {
                console.log("IN setCallback in Success line 60 and resultofwebsvc= "+component.get("v.resultofwebsvc"));
                console.log(JSON.stringify(response.getReturnValue()));
                component.set("v.resultofwebsvc", 'SUCCESS');
                console.log("IN setCallback in Success line 63 and resultofwebsvc= "+component.get("v.resultofwebsvc"));
            } else if (state === "ERROR") {
                component.set("v.resultofwebsvc", "ERROR");
                var errors = response.getError();
            }
            var response = event.getSource().getLocalId();
            component.set("v.value", response);
            console.log("IN setCallback in Success line 70 and resultofwebsvc= "+component.get("v.resultofwebsvc"));
            console.log("IN setCallback in Success line 70 and response= "+component.get("v.response"));
            var navigate = component.get("v.navigateFlow");
            navigate("NEXT");
            
        });
        // Enqueue action that returns a continuation
        $A.enqueueAction(action);
     
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