({
    doInit: function (component, event, helper) {
        sessionStorage.setItem('salesforce_id',component.get("v.FCId")); 
        var mPaymentAmount = component.get("v.monthlyPaymentAmount").toString();
        if (mPaymentAmount.lastIndexOf(".") == -1) {
            console.log("inside agenda");
            setTimeout($A.getCallback(function () {
                component.set("v.monthlyPaymentAmount", mPaymentAmount.concat(".00"))
            }), 500);
        }
        // I-355507 | 5 Dec 2018 | Namita 
        if (component.get("v.accountN") != undefined && component.get("v.accountN") != '') {
            var financeAccNo = component.get("v.accountN");
            financeAccNo = Number(financeAccNo).toString();
            component.set("v.financeAccNumber", financeAccNo);
        }
        if (component.get("v.requestedDueDate") != undefined && component.get("v.requestedDueDate") != '') {
            //var reqDueDate = new Date(component.get("v.requestedDueDate"));
            var reqDueDate = component.get("v.requestedDueDate");
            if (reqDueDate == '1' || reqDueDate == '21' || reqDueDate == '31') {
                component.set("v.reqDueDateVal", reqDueDate + 'st');
            } else if (reqDueDate == '2' || reqDueDate == '22') {
                component.set("v.reqDueDateVal", reqDueDate + 'nd');
            } else if (reqDueDate == '3' || reqDueDate == '23') {
                component.set("v.reqDueDateVal", reqDueDate + 'rd');
            } else {
                var testdate = reqDueDate + 'th';
                component.set("v.reqDueDateVal", testdate);
                
            }
        } else {
            component.set("v.reqDueDateVal", '');
        }
        console.log(component.get("v.reqDueDateVal"));
    },
    
    redirectToHome: function (component, event, helper) {
        
    },
    redirectToMyAccount: function (component, event, helper) {
        event.preventDefault();  
        var navService = component.find( "navService" );  
        var pageReference = {  
            type: "comm__namedPage",  
            attributes: {  
                pageName: "dashboard"  
            }
        };          
        navService.navigate(pageReference);  
    },
     back:function(component, event, helper) {
        // When an option is selected, navigate to the Previous screen
        var response = event.getSource().getLocalId();
        component.set("v.value", response);
        var navigate = component.get("v.navigateFlow");
        navigate("BACK");
    },
    handleContinue: function (component, event, helper) {        
        component.set("v.spinner", true);
         event.getSource().set("v.disabled", true);
        component.set('v.buttonDisabled', true);
        
        let submitclicks = component.get("v.SubmitClicks");
        if (submitclicks > 0) return;
        submitclicks = submitclicks + 1;
        component.set("v.SubmitClicks", submitclicks);
        
        let fanumber = component.get("v.accountN");
        let faid = component.get("v.financeAccId");
        let reqDueDay = component.get("v.requestedDueDate");
        let action = component.get("c.callDDCService");
        
        action.setParams({
            "FinAcctId": faid,
            "reqDueDay": reqDueDay
        });
        component.set("v.resultofwebsvc", "INCOMPLETE");
        action.setCallback(this, function (response) {            
            component.set("v.spinner", false);
            var state = response.getState();            
            var rslt = response.getReturnValue();
            if (state === "SUCCESS") {
                console.log(JSON.stringify(response.getReturnValue()));
                component.set("v.resultofwebsvc", 'SUCCESS');
                 var response = event.getSource().getLocalId();
            component.set("v.value", response);
            var navigate = component.get("v.navigateFlow");
            navigate("NEXT");
            
            } else if (state === "ERROR") {
                 component.set("v.resultofwebsvc", "ERROR");
                component.set("v.isSubmitError", true);
                var errors = response.getError();
                console.log('errors-->'+errors);
            } 
           
        });
        // Enqueue action that returns a continuation
        $A.enqueueAction(action);
        
    },
    
    
    redirectToHelpPayment : function(component,event,helper){
        console.log('FCId'+component.get("v.FCId"));
        var navService = component.find( "navService" );
            var pageReference = {
                type: "comm__namedPage",
                attributes: {
                    pageName: "help-payment"
                },
                state: {
                    sacRecordId: component.get("v.FCId")
                }
            };
            navService.navigate(pageReference);
    },
    
    
    
    handlePrevious: function (component, event, helper) {
        // When an option is selected, navigate to the Previous screen
        var response = event.getSource().getLocalId();
        component.set("v.value", response);
        var navigate = component.get("v.navigateFlow");
        navigate("BACK");
    },
    
    closeModel: function (component, event, helper) {
        // for Hide/Close Model,set the "isOpen" attribute to "Fasle"  
        component.set("v.isOpen", false);
    },
    openModel: function (component, event, helper) {
        // for Display Model,set the "isOpen" attribute to "true"
        component.set("v.isOpen", true);
        
        const scrollOptions = {
            left: 4,
            top: 2,
            behavior: "smooth"
        };
        window.scrollTo(scrollOptions);
    },
    
     closePopup: function(component, event, helper) {
        // for Hide/Close Model,set the "isOpen" attribute to "Fasle"  
        component.set("v.isOpen", false);
    },
    
    //Call by aura:waiting event  
    handleShowSpinner: function(component, event, helper) {
        //component.set('v.buttonDisabled', true);
    },
    
    //Call by aura:doneWaiting event 
    handleHideSpinner : function(component,event,helper){
        //component.set('v.buttonDisabled', true);
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
    
})