({
    
    // @VM 10/17, T-736268 : Server call to get custom setting value for no. of days to be enable
    doInit : function (component, event, helper){
        sessionStorage.setItem('salesforce_id',component.get("v.FCId")); 
        var mPaymentAmount = component.get("v.monthlyPaymentAmount").toString();
       if(mPaymentAmount.lastIndexOf(".") == -1) {
            console.log("inside agenda");
            setTimeout($A.getCallback(function(){component.set("v.monthlyPaymentAmount", mPaymentAmount.concat(".00"))}),500);
        }        
        helper.initCal(component, event, helper);
        var action = component.get("c.getDDC");
        action.setCallback(this, function(response){
            if(component.isValid() && response !== null && response.getState() == 'SUCCESS'){
                var objResponse = response.getReturnValue();
                //saving custom setting to attribute                
                component.set("v.daysUnderDDC", objResponse.ddcDays);                
                if(component.get("v.startDueDate") != undefined){
                    //T-749443                    
                    if(component.get("v.selNextDueDate") != undefined && component.get("v.selNextDueDate") != ''){
                        component.set('v.disabled', false);
                        component.set('v.buttonDisabled', false);
                    }  
                    var dayValue = component.get("v.startDueDate").substring(component.get("v.startDueDate").lastIndexOf("-")+1);
                    var startDueDateValue =component.get("v.startDueDate");
                    /*US - 2247 - Start */
                    var startDueDateValue= $A.localizationService.formatDate(startDueDateValue, "MMM dd, YYYY");
                    /*US - 2247 - End */
                    component.set("v.currDueDate",startDueDateValue); 
                    //alert('startDueDateValue'+ startDueDateValue);
                    component.set("v.DueDate",parseInt(dayValue)); 
                    var DueDateValue= component.get("v.DueDate").toString();                   
                }else{                   
                }
            }
        });
        
        $A.enqueueAction(action);
        
    },
    
    //T-749443 | onChangeDate method
    onChangeDate: function (component, event, helper) {        
        component.set("v.selNextDueDateDay",component.get("v.selNextDueDate"));
        if(component.get("v.selNextDueDate") != undefined && component.get("v.selNextDueDate") != ''){
            component.set('v.disabled', false);
            component.set('v.buttonDisabled', false);
            component.set('v.isSelDate', true);
        }else{
            component.set('v.disabled', true);
            component.set('v.buttonDisabled', true);            
        }
    },
    
    redirectToHome : function(component,event,helper){
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
    
    closeModel: function(component, event, helper) {         
        component.set("v.isOpen", false);
    },
    openModel: function(component, event, helper) {
        component.set("v.isOpen", true);
    },
    
    closePopup: function(component, event, helper) {
        // for Hide/Close Model,set the "isOpen" attribute to "Fasle"  
        component.set("v.isPopupOpen", false);
    },
    /* US - 2247 - Start- This method will return the user to Help Payment Screen */
    redirectToHelpPayment : function(component,event,helper){
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
    /*US - 2247 - End */
    /* US - 2247 - Start - if the select date is filled, if still clicks BackArrow it will show Leave message or
     if false it will go to Help Payment Screen */ 
     openPopup : function(component, event, helper) {
        var selNextDueDate=component.get("v.selNextDueDate");
        if(selNextDueDate!= undefined && selNextDueDate!=null && selNextDueDate!='')
        {
            component.set("v.isPopupOpen", true);  
        }else{
            component.set("v.isPopupOpen", false);
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
        }
        
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
    
    /* US - 2247 End*/
    handleContinue : function(component, event, helper) {
        // When an option is selected, navigate to the next screen
        var response = event.getSource().getLocalId();
        component.set("v.value", response);
        var navigate = component.get("v.navigateFlow");
        navigate("NEXT");
    }
})