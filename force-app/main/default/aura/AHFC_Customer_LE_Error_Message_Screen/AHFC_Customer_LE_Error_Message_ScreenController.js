({
    
    doInit : function (component, event, helper){
        window.scroll(0, 0);
        sessionStorage.setItem('salesforce_id',component.get("v.FCId"));
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
        }else
        { 
            component.set("v.communityName",'customerhelp');
        }
        //console.log('this is it:'+component.get('v.DDC_Eligibility'));
        console.log(component.get('v.Record_Not_Found'));
    },
    
    redirectToHomeWindow : function(component,event,helper){
        //On Make a Payment, Redirect to Payment Page
        var url = window.location.href
        // Adding custom label for domain [3/01/2019]
        var hondaDomain = $A.get("$Label.c.HONDA_DOMAIN");
        
        if(url.includes(hondaDomain)){
            url = $A.get("$Label.c.AHFC_Make_a_Payment_URL");
        } else{
            url = $A.get("$Label.c.AHFC_Make_a_Payment_Url_Acura");
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
    
    //Start US 5799 - functions created redirectToNeedHelp,redirectToPaymentPage

    redirectToNeedHelp : function(component,event,helper){
        event.preventDefault();
        var navService = component.find( "navService" );
        var pageReference = {
            type: "comm__namedPage",
            attributes: {
                pageName: "help-payment"
            },state: {
                    sacRecordId: component.get("v.FCId")
                }
        };
        navService.navigate(pageReference);
    },
    
    redirectToPaymentPage: function(component,event,helper){
        event.preventDefault();
        var navService = component.find( "navService" );
        var pageReference = {
            type: "comm__namedPage",
            attributes: {
                pageName: "make-a-payment"
            },state: {
                sacRecordId: component.get("v.FCId"),
                showOTPDefault : true
            }
        };
        navService.navigate(pageReference);
    },
    
     redirectToDashBoard : function(component,event,helper){
        event.preventDefault();
        var navService = component.find( "navService" );
        sessionStorage.setItem('reloaded','false');
        var pageReference = {
            type: "comm__namedPage",
            attributes: {
                pageName: "dashboard"
            }
        };
        navService.navigate(pageReference);
    },
    //End US 5799 - functions created redirectToDashBoard,redirectToPaymentPage

    //navigate to case details page US:5186 by edwin
    navigateToCaseDetails:function(component,event,helper){
        console.log('component.get("v.FlowCaseId"): '+component.get("v.FlowCaseId"));
        sessionStorage.setItem('supportRequestId', component.get("v.FlowCaseId"));
        event.preventDefault();
        var navService = component.find( "navService" );
        var pageReference = {
            type: "standard__recordPage",
            attributes: {
                recordId: component.get("v.FlowCaseId"),
                objectApiName: 'Case',
                actionName: 'view'
            },
        };
        navService.navigate(pageReference);
    },
})