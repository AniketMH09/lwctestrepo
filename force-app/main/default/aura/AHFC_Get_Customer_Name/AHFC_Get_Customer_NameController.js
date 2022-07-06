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
            url = $A.get("$Label.c.AHFC_Honda_URL");
            } else{
            url = $A.get("$Label.c.AHFC_Acura_URL");
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
            
            var inputCmp = component.find("inputCmp");
        var value = inputCmp.get("v.value");
            
            
            
            var navigate = component.get("v.navigateFlow");
            navigate("NEXT");
            },
            
            contactUs : function(component, event, helper) {
            var href = $A.get("$Label.c.AHFC_Contact_Us_URL");
            window.open(href,'_top');
            }, 
            
            })