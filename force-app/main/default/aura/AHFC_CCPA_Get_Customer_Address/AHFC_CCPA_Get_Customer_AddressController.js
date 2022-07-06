({
    
    doInit : function (component) {
        
        
         window.scroll(0, 0);
        
        //create states dropdown
        var States = [
            { value: 'Alabama', label: 'Alabama' },
            { value: 'Alaska', label: 'Alaska' },
            { value: 'American Samoa', label: 'American Samoa' },
            { value: 'Arizona', label: 'Arizona' },
            { value: 'Arkansas', label: 'Arkansas' },
            { value: 'Armed Forces Americas', label: 'Armed Forces Americas' },
            { value: 'Armed Forces Europe', label: 'Armed Forces Europe' },
            { value: 'Armed Forces Pacific', label: 'Armed Forces Pacific' },
            { value: 'California', label: 'California' },
            { value: 'Colorado', label: 'Colorado' },
            { value: 'Connecticut', label: 'Connecticut' },
            { value: 'Delaware', label: 'Delaware' },
            { value: 'District of Columbia', label: 'District of Columbia' },
            { value: 'Federated Micronesia', label: 'Federated Micronesia' },
            { value: 'Florida', label: 'Florida' },
            { value: 'Georgia', label: 'Georgia' },
            { value: 'Guam', label: 'Guam' },
            { value: 'Hawaii', label: 'Hawaii' },
            { value: 'Idaho', label: 'Idaho' },
            { value: 'Illinois', label: 'Illinois' },
            { value: 'Indiana', label: 'Indiana' },
            { value: 'Iowa', label: 'Iowa' },
            { value: 'Kansas', label: 'Kansas' },
            { value: 'Kentucky', label: 'Kentucky' },
            { value: 'Louisiana', label: 'Louisiana' },
            { value: 'Maine', label: 'Maine' },
            { value: 'Marshall Islands', label: 'Marshall Islands' },
            { value: 'Maryland', label: 'Maryland' },
            { value: 'Massachusetts', label: 'Massachusetts' },
            { value: 'Michigan', label: 'Michigan' },
            { value: 'Minnesota', label: 'Minnesota' },
            { value: 'Mississippi', label: 'Mississippi' },
            { value: 'Missouri', label: 'Missouri' },
            { value: 'Montana', label: 'Montana' },
            { value: 'Nebraska', label: 'Nebraska' },
            { value: 'Nevada', label: 'Nevada' },
            { value: 'New Hampshire', label: 'New Hampshire' },
            { value: 'New Jersey', label: 'New Jersey' },
            { value: 'New Mexico', label: 'New Mexico' },
            { value: 'New York', label: 'New York' },
            { value: 'North Carolina', label: 'North Carolina' },
            { value: 'North Dakota', label: 'North Dakota' },
            { value: 'Northern Mariana Islands', label: 'Northern Mariana Islands' },
            { value: 'Ohio', label: 'Ohio' },
            { value: 'Oklahoma', label: 'Oklahoma' },
            { value: 'Oregon', label: 'Oregon' },
            { value: 'Palau', label: 'Palau' },
            { value: 'Pennsylvania', label: 'Pennsylvania' },
            { value: 'Puerto Rico', label: 'Puerto Rico' },
            { value: 'Rhode Island', label: 'Rhode Island' },
            { value: 'South Carolina', label: 'South Carolina' },
            { value: 'South Dakota', label: 'South Dakota' },
            { value: 'Tennessee', label: 'Tennessee' },
            { value: 'Texas', label: 'Texas' },
            { value: 'United States Minor Outlying Islands', label: 'United States Minor Outlying Islands' },
            { value: 'US Virgin Islands', label: 'US Virgin Islands' },
            { value: 'Utah', label: 'Utah' },
            { value: 'Vermont', label: 'Vermont' },
            { value: 'Virginia', label: 'Virginia' },
            { value: 'Washington', label: 'Washington' },
            { value: 'West Virginia', label: 'West Virginia' },
            { value: 'Wisconsin', label: 'Wisconsin' },
            { value: 'Wyoming', label: 'Wyoming' },
        ];
        component.set("v.lstStates", States);
       
    },
    
    // validate data onchange
    onChange: function (component, event, helper) {
            
            helper.validateZipCode(component, event);
            
            var city = component.get("v.strCity");
            var inputCmp = component.find("inputCmp2");
            
            if(city!=null && city!='' && city!='undefined')
            {
                var validCity=helper.validateStringValues(city);
            
                if(validCity) {
                   inputCmp.setCustomValidity("");
                   inputCmp.reportValidity(); 
                   component.set("v.validCity",true);
                }else{
                   inputCmp.setCustomValidity("Error: Enter Valid City.");
                   inputCmp.reportValidity();
                   component.set("v.validCity",false);
                }
            }else{
                inputCmp.setCustomValidity("");
                inputCmp.reportValidity();
                component.set("v.validCity",false);
            }
            
            var inputCmp1 = component.find("inputCmp1");
            var street = component.get("v.strStreet");
            
            if(street!=null && street!='' && street!='undefined')
            {
              inputCmp1.setCustomValidity("");
              inputCmp1.reportValidity();
            }
            
            var inputCmp3 = component.find("inputCmp3");
            var state = component.get("v.strState");
            
            if(state!=null && state!='' && state!='undefined')
            {
              inputCmp3.setCustomValidity("");
              inputCmp3.reportValidity();
            }
            
            
        
    },
    
  // navigate to dashboard if user is logged in otherwise navigate to pre login
    redirectToHome : function(component,event){
       var checkUser=sessionStorage.getItem('guestUser');   
       var sacRecId=sessionStorage.getItem('salesforce_id');
          
       if(checkUser=='false' ) //&& sacRecId!='undefined' && sacRecId!=null && sacRecId!==''
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
    
    // to close popup set isOpen flage to false
    closeModel: function(component) {
      component.set("v.isOpen", false);
    },
    
   // to open popup set isOpen flage to true         
    openModel : function(component) {
      component.set("v.isOpen", true);
      const scrollOptions = {
            left: 4,
            top: 2,
            behavior: "smooth"
        };
        window.scrollTo(scrollOptions);      
    },
    
    // validate data and navigate to next screen
    handleContinue : function(component, event,helper) {
            
      var strStreet=component.get("v.strStreet");
      var strCity=component.get("v.strCity");
      var strState=component.get("v.strState");
      var strPostalCode=component.get("v.strPostalCode");  
      
            var inputCmp1 = component.find("inputCmp1");
            
            if(strStreet==null || strStreet=='' || strStreet=='undefined')
            {
              inputCmp1.setCustomValidity("Error: Enter Current Address.");
              inputCmp1.reportValidity();
              component.set("v.validAddress",false); 
            }else{
              component.set("v.validAddress",true); 
            }
            
            var inputCmp2 = component.find("inputCmp2");
            
            if(strCity==null || strCity=='' || strCity=='undefined')
            {
               inputCmp2.setCustomValidity("Error: Enter Current City.");
               inputCmp2.reportValidity();
               component.set("v.validCity",false);
            }else{
            
               var validCity=helper.validateStringValues(strCity);
            
                if(validCity) {
                   inputCmp2.setCustomValidity("");
                   inputCmp2.reportValidity(); 
                   component.set("v.validCity",true);
                }else{
                   inputCmp2.setCustomValidity("Error: Enter Valid City.");
                   inputCmp2.reportValidity();
                   component.set("v.validCity",false);
                }
            
            }

            var inputCmp3 = component.find("inputCmp3");            
            if(strState==null || strState=='' || strState=='undefined')
            {
              inputCmp3.setCustomValidity("Error: Enter Current State.");
              inputCmp3.reportValidity();
              component.set("v.validState",false);
            }else{
              component.set("v.validState",true);
            }
            
            var inputCmp4 = component.find("inputCmp4");
            if(strPostalCode==null || strPostalCode=='' || strPostalCode=='undefined')
            {
              inputCmp4.setCustomValidity("Error: Zip Code must be in 99999 or 99999-9999 format.");
              inputCmp4.reportValidity();
              component.set("v.validZip",false);
            }else{
               helper.validateZipCode(component, event);
            }
            
            if(component.get("v.validCity") && component.get("v.validZip")
               && component.get("v.validAddress") && component.get("v.validState"))
            {
              var response = event.getSource().getLocalId();
              component.set("v.value", response);
              var navigate = component.get("v.navigateFlow");
              navigate("NEXT");
            }
     
   },
    
    // navigate to previous flow screen
    handlePrevious : function(component, event) {
      var response = event.getSource().getLocalId();
      component.set("v.value", response);
      var navigate = component.get("v.navigateFlow");
      navigate("BACK");
   },
  

})