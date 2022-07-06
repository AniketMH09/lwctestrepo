({
    // @VM 10/17, T-736268 : Server call to get custom setting value for no. of days to be enable
    doInit : function (component, event, helper) {
        window.scroll(0, 0);
        
        var url = window.location.href;
        
        // Adding custom label for domain [3/01/2019]
        var hondaDomain = $A.get("$Label.c.HONDA_DOMAIN");
        var acuraDomain = $A.get("$Label.c.ACURA_DOMAIN");
        
        sessionStorage.setItem('salesforce_id',component.get("v.FCId")); 
        
        if(url.includes(hondaDomain))
        {
            component.set("v.communityName",'hondahelp');
        }
        else if(url.includes(acuraDomain))
        {   
            component.set("v.communityName",'acurahelp');
        }
         //Start US-4059 set community name var depends on domain  
         else 
        { 
            component.set("v.communityName",'customerhelp');
        }
        //End US-4059 set community name var depends on domain 
        var PaymentAmountDecimal='';
        var payment_amoumt= parseFloat(component.get("v.nextPaymentAmount"));
        //PaymentAmountDecimal=n.toFixed(2).toString();
        
        PaymentAmountDecimal=payment_amoumt.toLocaleString("en-US", {minimumFractionDigits: 2,maximumFractionDigits: 2});
        
        component.set('v.nextPaymentAmountDecimal', PaymentAmountDecimal);
        // alert('v.nextPaymentAmountDecimal'+PaymentAmountDecimal);
        if(component.get("v.selRequestedMonths") != undefined && component.get("v.selRequestedMonths") != ''){
            component.set('v.disabled', false);
        }
        if(component.get('v.currentMaturityDate') != undefined && component.get('v.currentMaturityDate') != ''){
            var curMaturityDate = $A.localizationService.formatDate(component.get("v.currentMaturityDate"), "MM/dd/YYYY");
             //Start US-4059 change date format
            var maturity_date = $A.localizationService.formatDate(component.get("v.currentMaturityDate"), "MMM dd, YYYY");    
            component.set('v.maturityDate',maturity_date);
            component.set('v.selMonthDisable',false);
            //end US-4059 change date format
        }else{
            component.set('v.maturityDate','');
        }
    },
    
    //T-749443 | onChangeDate method
    onChangeDate: function (component, event, helper) {
        var estmitedLE_Tax = '';
        if(component.get("v.selRequestedMonths") != undefined && component.get("v.selRequestedMonths") != ''){
            component.set('v.disabled', false);
            if(component.get("v.extensionTaxRate") != undefined && component.get("v.extensionTaxRate") != '' && component.get("v.nextPaymentAmount") != undefined && component.get("v.nextPaymentAmount") != ''){
                var tax_cal = (parseInt(component.get("v.selRequestedMonths")) * parseFloat(component.get("v.extensionTaxRate")) * parseFloat(component.get("v.nextPaymentAmount")))/100;
                estmitedLE_Tax=tax_cal.toLocaleString("en-US", {minimumFractionDigits: 2,maximumFractionDigits: 2});
            
            }
            
            component.set('v.int_selRequestedMonths',parseInt(component.get("v.selRequestedMonths")));
                
            
            component.set('v.estimatedLETax',estmitedLE_Tax);
            
            //T-762014 | Namita | 6 Dec 18 
            if(component.get("v.currentMaturityDate") != undefined){
                console.log('&&&&&&&'+component.get("v.currentMaturityDate"));
                var n =  parseInt(component.get("v.selRequestedMonths"));
                var currentMd = component.get("v.currentMaturityDate");
                console.log('before calling method');
                var action = component.get("c.getNextMaturityDate");
                
                action.setParams({"currentMdate":component.get("v.currentMaturityDate"), "months":n});
                action.setCallback(this,function(response){
                    console.log('inside setCallback');
                    if(component.isValid() && response !== null && response.getState() == 'SUCCESS'){
                        
                        var objResponse = response.getReturnValue();
                        console.log('objResponse:'+objResponse);
                        var nxtMaturityDate = $A.localizationService.formatDateTimeUTC(objResponse, "MM/dd/YYYY");
                       //Start US-4059 change date format
                        var nxt_MaturityDate = $A.localizationService.formatDateTimeUTC(objResponse, "MMM dd, YYYY");
                        //end US-4059 change date format
                        component.set('v.nextMaturityDate',nxt_MaturityDate);
                        
                    }
                });
                
                $A.enqueueAction(action); 
            }
            
        }else{
            component.set('v.disabled', true);
            component.set('v.estimatedLETax',extensionRate);
        } 
        //alert('v.estimatedLETax '+ extensionRate);
        //var newDate = new Date(curMD.substring(curMD.lastIndexOf("/")+1)+'-'+curMD.substring(0,curMD.indexOf("/"))+'-'+curMD.substring(curMD.indexOf("/")+1,curMD.lastIndexOf("/")));         
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
        
        const scrollOptions = {
            left: 4,
            top: 2,
            behavior: "smooth"
        };
        window.scrollTo(scrollOptions);
    },
    
    // Start US-4059 close popup 
    closePopup: function(component, event, helper) {
        // for Hide/Close Model,set the "isOpen" attribute to "Fasle"  
        component.set("v.isPopupOpen", false);
    },
    
    // end  US-4059 close popup 
    
    //Start US-4059 open popup on click of back arrow if user fills any data
    openPopup : function(component, event, helper) {
        // for Display Model,set the "isPopupOpen" attribute to "true"
        var selReqMonths=component.get("v.selRequestedMonths");
        if(selReqMonths!= undefined && selReqMonths!=null && selReqMonths!='')
        {
            component.set("v.isPopupOpen", true);  
            
            
            
        }else{
            component.set("v.isPopupOpen", false);
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
        }
        
    },
    
    //end US-4059 open popup on click of back arrow if user fills any data
    
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
    
    // Start US-4059 navigate user to dashboard  
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
    
    // End US-4059 navigate user to dashboard
    
    // Start US-4059 navigate user to help payment  
    redirectToHelpPaymentPage : function(component,event,helper){
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
    
    // End US-4059 navigate user to help payment 
})