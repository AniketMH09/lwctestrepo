({

    doInit : function (component, event, helper){
         var url = window.location.href;
    var queryString = url.substring(url.indexOf("?")+1);
            var obj = {};
            if (queryString) {
                // split our query string into its component parts
                var arr = queryString.split('&');
                console.log(arr);
                for (var i = 0; i < arr.length; i++) {
                  var aTemp = arr[i];
                  var paramName = aTemp.substring(0,aTemp.indexOf("="));
                  var paramValue = aTemp.substring(aTemp.indexOf("=")+1);
                  paramName = paramName.toLowerCase();
                  obj[paramName] = paramValue;
                }
          }
        
         component.set("v.fAid",obj.sacrecordid);                                                 
         sessionStorage.setItem('salesforce_id',component.get("v.fAid"));                                                         
        // commented the below lines as discussed with Erich for the US - 4024, 4027, 4029
      
        /* console.log('this is it:'+component.get('v.DDC_Eligibility'));
        console.log(component.get('v.Record_Not_Found'));
        window.scroll(0, 0);
        
        var url = window.location.href;
        
        // Adding custom label for domain [3/01/2019]
        var hondaDomain = $A.get("$Label.c.HONDA_DOMAIN");
        var acuraDomain = $A.get("$Label.c.ACURA_DOMAIN");
        var ahfcCustDomain = $A.get("$Label.c.AHFC_CUSTOMER");
        
        
        if(url.includes(hondaDomain))
        {    
            component.set("v.communityName",'hondahelp');
        }
        else if(url.includes(acuraDomain))
        { 
            component.set("v.communityName",'acurahelp');
        }else if(url.includes(ahfcCustDomain))
        { 
            component.set("v.communityName",'customerhelp');
        }
        //console.log('this is it:'+component.get('v.DDC_Eligibility'));
        console.log(component.get('v.Record_Not_Found')); */
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
    
    redirectToPaymentPage: function(component,event,helper){
        console.log('FCId'+component.get("v.FCId"));
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
     redirectToMakePayment : function(component,event,helper){
         console.log('FCId'+component.get("v.FCId"));
         event.preventDefault();
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
    
    
    redirectToHomeWindow : function(component,event,helper){
        //On Make a Payment, Redirect to Payment Page
       // Adding custom label for domain [2/27/2019]
       var hondaDomain = $A.get("$Label.c.HONDA_DOMAIN");
       var acuraDomain = $A.get("$Label.c.ACURA_DOMAIN");
        
       var url = window.location.href
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
        // Adding custom label for domain [2/27/2019]
        var hondaDomain = $A.get("$Label.c.HONDA_DOMAIN");
        var acuraDomain = $A.get("$Label.c.ACURA_DOMAIN");
        
        if(url.includes(hondaDomain)) {
           window.open($A.get("$Label.c.AHFC_Return_to_My_Account"),'_top');
        } else {
           window.open($A.get("$Label.c.AHFC_Return_To_My_Account_Acura"),'_top'); 
        }
    },
    
    contactUs : function(component, event, helper) {
        var url = window.location.href;
        // Adding custom label for domain [2/27/2019]
        var hondaDomain = $A.get("$Label.c.HONDA_DOMAIN");
        var acuraDomain = $A.get("$Label.c.ACURA_DOMAIN");
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
        // Adding custom label for domain [2/27/2019]
        var hondaDomain = $A.get("$Label.c.HONDA_DOMAIN");
        var acuraDomain = $A.get("$Label.c.ACURA_DOMAIN");
        
        if(url.includes(hondaDomain)){
           window.open($A.get("$Label.c.AHFC_Return_to_My_Account"),'_top');
        } else {
           window.open($A.get("$Label.c.AHFC_Return_To_My_Account_Acura"),'_top'); 
        }

    },
     redirectToHelpPayment : function(component,event,helper){
        var navService = component.find( "navService" );
         console.log('FAAAID'+component.get("v.fAid"));
            var pageReference = {
                type: "comm__namedPage",
                attributes: {
                    pageName: "help-payment"
                },
                state: {
                    sacRecordId: component.get("v.fAid")
                }
            };
            navService.navigate(pageReference);
    }, 
    
     redirectToDashBoard : function(component,event,helper){
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

})