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
        
        if (component.get("v.strAuthorizedUser")) component.set("v.strAuthorizedUser2", "Yes")
        else component.set("v.strAuthorizedUser2", "No");
        
       
       //var ssn = component.get("v.strssn");
       //component.set("v.refresh1",ssn);
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
    
    reInit : function(component, event, helper) {
        $A.get('e.force:refreshView').fire();
    },
    
    onHasAccountChange: function (component, event, helper) {
        /*
        component.set('v.truthy',false);
        component.set('v.truthy',true);          
        var pref = component.get("v.strCommunicationPref");
        if (pref==='Email'){
            component.set("v.emailrequired",true);
            component.set("v.phonerequired",false);
        }
        else {
            component.set("v.phonerequired",true);
            component.set("v.emailrequired",false);
        }
*/        
        
        
    }, //onHasAccountChange

    
    onChange: function (component, event, helper) {
   
        var allValid = component.get("v.strPerjuryAck");
      
        if (allValid ) {
            component.set("v.disabled",false);
        }
        else component.set("v.disabled",true);
       
        
        
    },   
    redirectToHome : function(component,event,helper){
        var checkUser=sessionStorage.getItem('guestUser');   
       var sacRecId=sessionStorage.getItem('salesforce_id');
          
       console.log('is guest user >>>>>>'+checkUser);
       console.log('sacRecId >>>>>>'+sacRecId);   
          
       if(checkUser=='false' && sacRecId!='undefined' && sacRecId!=null && sacRecId!=='')
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
           //window.history.back(); 
           window.location.href='https://poc.acura.americanhondafinance.com';
       }  
    },
    
    handlePrevious : function(component, event, helper) {
     // When an option is selected, navigate to the next screen
      var response = event.getSource().getLocalId();
      component.set("v.value", response);
      var navigate = component.get("v.navigateFlow");
      navigate("BACK");
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
    
    handleContinue : function(component, event, helper) {
     // When an option is selected, navigate to the next screen
      var response = event.getSource().getLocalId();
      component.set("v.value", response);
      var navigate = component.get("v.navigateFlow");
      navigate("NEXT");
   },
    handlePrevious : function(component, event, helper) {
     // When an option is selected, navigate to the next screen
      var response = event.getSource().getLocalId();
      component.set("v.value", response);
      var navigate = component.get("v.navigateFlow");
      navigate("BACK");
   },
    
   contactUs : function(component, event, helper) {
        var href = $A.get("$Label.c.AHFC_Contact_Us_URL");
        window.open(href,'_top');
	}, 

})