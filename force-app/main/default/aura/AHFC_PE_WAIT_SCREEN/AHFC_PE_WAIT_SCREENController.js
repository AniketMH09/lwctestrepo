({
    
    doInit : function (component, event, helper) {
        window.scroll(0, 0);
        
        var url = window.location.href;
        
        
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
        
        
        var fanumber = component.get("v.faNumber");
        var numOfMonths = component.get("v.NumberofMonthsRequested");
        var action = component.get("c.callPymtExtService");
        
        action.setParams({ "FinAcctNbr" : fanumber, 
                           "NumOfMths" : numOfMonths });
        component.set("v.resultofwebsvc","INCOMPLETE" );

        action.setCallback(this, function(response) {
            var state = response.getState();
            var rslt = response.getReturnValue();
            if (state === "SUCCESS") {
                console.log("From server: "
                            + response.getReturnValue()
                            + '\n' + JSON.stringify(response.getReturnValue()));
                console.log(JSON.stringify(response.getReturnValue()));
                component.set("v.resultofwebsvc",response.getReturnValue() );
            }
            else if (state === "INCOMPLETE") {
                //alert("Continuation action is INCOMPLETE");
                component.set("v.resultofwebsvc","INCOMPLETE" );
            }
            else if (state === "ERROR") {
                    component.set("v.resultofwebsvc","ERROR" );
                    var errors = response.getError();
                    /*if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.log("Error message: " +
                                        errors[0].message);
                            component.set("v.resultofwebsvc","ERROR: " +
                                        errors[0].message );
                        }
                    } else {
                        console.log("Unknown error");
                        component.set("v.resultofwebsvc","ERROR: Unknown error"  );
                    }*/
                
                }
            var trackpref = component.get("v.trackpref");
            if (trackpref) component.set("v.trackpref",false)
            else component.set("v.trackpref",true);
        });
        // Enqueue action that returns a continuation
        $A.enqueueAction(action);
    },
    
    
    redirectToHome : function(component,event,helper){
        
        var url = window.location.href;
        
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
    handleClick: function (cmp, event) {
        cmp.set('v.loaded', !cmp.get('v.loaded'));
    },
    // function automatic called by aura:waiting event  
    showSpinner: function(component, event, helper) {
        // remove slds-hide class from mySpinner
        var spinner = component.find("mySpinner");
        $A.util.removeClass(spinner, "slds-hide");
    },
    
    // function automatic called by aura:doneWaiting event 
    hideSpinner : function(component,event,helper){
        // add slds-hide class from mySpinner    
        var spinner = component.find("mySpinner");
        $A.util.addClass(spinner, "slds-hide");
    },
})