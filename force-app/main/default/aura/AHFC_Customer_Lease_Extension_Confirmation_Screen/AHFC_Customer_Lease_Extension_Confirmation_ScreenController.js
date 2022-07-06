({
    doInit : function (component, event, helper){
        window.scroll(0, 0);
        console.log(component.get("v.accountStatusUpdatesViaEamil"));
        sessionStorage.setItem('salesforce_id',component.get("v.FCId")); 
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
    
    //Start US-4059 navigate user to dashboard 
    
    redirectToDashboard : function(component,event,helper){
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
    
    //End US-4059 navigate user to dashboard 

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