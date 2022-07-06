({
    
    doInit : function (component) {
        
        
        window.scroll(0, 0);
        
        // set values in attributes to show data on review page
        
        if (component.get("v.strAuthorizedUser")) component.set("v.strAuthorizedUser2", "Yes")
        else component.set("v.strAuthorizedUser2", "No");
        
        component.set("v.strFaAccountDisp", component.get("v.strFaAccount"));
        component.set("v.strVinDisp", component.get("v.strVin"));
        component.set("v.strSerialNoDisp", component.get("v.strSerialNo"));
        component.set("v.strContractNoDisp", component.get("v.strContractNo"));
        component.set("v.strssnDisp", component.get("v.strssn"));
        component.set("v.hasaccountDisp", component.get("v.hasaccount"));
        component.set("v.strdob2Disp", component.get("v.strdob2"));
        component.set("v.strFirstNameDisp", component.get("v.strFirstName"));
        component.set("v.strLastNameDisp", component.get("v.strLastName"));
        component.set("v.strMiddleNameDisp", component.get("v.strMiddleName"));
        component.set("v.strSalutationDisp", component.get("v.strSalutation"));
        component.set("v.strSuffixDisp", component.get("v.strSuffix"));
        component.set("v.strStreetDisp", component.get("v.strStreet"));
        component.set("v.strCityDisp", component.get("v.strCity"));
        component.set("v.strStateDisp", component.get("v.strState"));
        component.set("v.strCountryDisp", component.get("v.strCountry"));
        component.set("v.strPostalCodeDisp", component.get("v.strPostalCode"));
        component.set("v.strPerjuryAckDisp", component.get("v.strPerjuryAck"));
        component.set("v.strEmailDisp", component.get("v.strEmail"));
        component.set("v.strPhoneNumberDisp", component.get("v.strPhoneNumber"));
        component.set("v.strCommunicationPrefDisp", component.get("v.strCommunicationPref"));
        component.set("v.strAuthorizedUserDisp", component.get("v.strAuthorizedUser"));
        component.set("v.strmailaddressDisp", component.get("v.strmailaddress"));
        
        
        
    },
   
    //function calls when user check or uncheck the checkbox
    onChange: function (component) {
        
        var allValid = component.get("v.strPerjuryAck");
        
        if (allValid ) {
            component.set("v.disabled",false);
        }
        else component.set("v.disabled",true);   
    },  
    
    //navigate to dashboard if user is logged in otherwise prelogin page
    redirectToHome : function(component,event){
        var checkUser=sessionStorage.getItem('guestUser');   
        var sacRecId=sessionStorage.getItem('salesforce_id');
       
        if(checkUser=='false') // && sacRecId!='undefined' && sacRecId!=null && sacRecId!==''
        {
            
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
        } else{
            var communityUrl = window.location.href;
            var baseURL = communityUrl.substring(0, communityUrl.indexOf("/s"));
            window.location.href=baseURL;
        }  
    },
   
    // to close popup set isOpen flag to false
    closeModel: function(component) {
        component.set("v.isOpen", false);
    },
    
    // to open popup set isOpen flag to true
    openModel : function(component) {
        component.set("v.isOpen", true);
        
        const scrollOptions = {
            left: 4,
            top: 2,
            behavior: "smooth"
        };
        window.scrollTo(scrollOptions);   
        
    },
    //navigate to next screen
    handleContinue : function(component, event) {
        var response = event.getSource().getLocalId();
        component.set("v.value", response);
        var navigate = component.get("v.navigateFlow");
        navigate("NEXT");
    },
    //navigate to previous screen
    handlePrevious : function(component, event, helper) {
        var response = event.getSource().getLocalId();
        component.set("v.value", response);
        var navigate = component.get("v.navigateFlow");
        navigate("BACK");
    },
    
    
    
})