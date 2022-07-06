({
    // @VM 10/17, T-736268 : Server call to get custom setting value for no. of days to be enable
    doInit : function (component, event, helper) {
        
        var Salutations = [
            { value: '--None--', label: '--None--' },
            { value: 'Mr.', label: 'Mr.' },
            { value: 'Mrs.', label: 'Mrs.' },
            { value: 'Ms.', label: 'Ms.' },
        ];       
            component.set("v.lstsalutations", Salutations);
            window.scroll(0, 0);
            
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
            }
            
            },
            
            onChange: function (component, event, helper) {
            
            
            var allValid = component.find('field').reduce(function (validSoFar, inputCmp) {
            // inputCmp.reportValidity();
            return validSoFar && inputCmp.checkValidity();
            }, true);
            if (allValid) {
            component.set("v.disabled",false);
            }
            else {
            component.set("v.disabled",true);
            }
            
            
            }, //end of on change
            
            
            redirectToHome : function(component,event,helper){
            //@KP Nov/08 - T-747962 Cancellation return to MyAccount Page
            var url = window.location.href;
            // Adding custom label for domain [3/01/2019]
            var hondaDomain = $A.get("$Label.c.HONDA_DOMAIN");
            if(url.includes(hondaDomain)){
            url = $A.get("$Label.c.SCRA_F_A_Q_Knowledge_Article_URL");
            } else{
            url = $A.get("$Label.c.SCRA_F_A_Q_Knowledge_Article_URL");
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
            
            handlePrevious : function(component, event, helper) {
            // When an option is selected, navigate to the next screen
            var response = event.getSource().getLocalId();
            component.set("v.value", response);
            var navigate = component.get("v.navigateFlow");
            navigate("BACK");
            },
            
            handleContinue : function(component, event, helper) {
            // When an option is selected, navigate to the next screen
            /*
            var inputCmp = component.find("inputCmp");
        var value = inputCmp.get("v.value");
            
            
            
            var navigate = component.get("v.navigateFlow");
            navigate("NEXT");*/
            
            var strFirstName=component.get('v.strFirstName');
            var strLastName=component.get('v.strLastName');
            
            var regex = /[A-Za-z, ]+$/; 
            
            if(strFirstName==null || strFirstName=='' || strFirstName=='undefined')
            {
            
            var inputCmp = component.find("inputCmp1");
            var value = inputCmp.get("v.value");
            inputCmp.setCustomValidity("Error: Enter First Name.");
            inputCmp.reportValidity();
            component.set("v.validFirstName",false); 
            }else{
            
            if(!strFirstName.match(regex))
            {
            inputCmp.setCustomValidity("Enter valid value");
            component.set("v.validFirstName",false);
            }else{
            component.set("v.validFirstName",true); 
            }
            }
            
            if(strLastName==null || strLastName=='' || strLastName=='undefined')
            {
            
            var inputCmp = component.find("inputCmp2");
            var value = inputCmp.get("v.value");
            inputCmp.setCustomValidity("Error: Enter Last Name.");
            inputCmp.reportValidity();   
            component.set("v.validLastName",false);   
            }else{
            
            if(!strLastName.match(regex))
            {
            inputCmp.setCustomValidity("Enter valid value");
            component.set("v.validLastName",false);
            }else{
            component.set("v.validLastName",true); 
            }
            
            }
            
            var fName_valid=component.get("v.validFirstName");
            var LName_valid=component.get("v.validLastName");
            var MName_valid=component.get("v.validMiddleName");
            var NSuffix_valid=component.get("v.validSuffix");
            
            if(fName_valid && LName_valid
            && MName_valid && NSuffix_valid)
            {
            // When an option is selected, navigate to the next screen
            var response = event.getSource().getLocalId();
            component.set("v.value", response);
            var navigate = component.get("v.navigateFlow");
            navigate("NEXT");
            
            }
            },
            
            contactUs : function(component, event, helper) {
            var href = $A.get("$Label.c.AHFC_Contact_Us_URL");
            window.open(href,'_top');
            }, 
            
            })