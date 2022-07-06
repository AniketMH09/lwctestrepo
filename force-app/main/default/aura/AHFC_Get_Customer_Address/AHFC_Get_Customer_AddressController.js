({
    
    doInit : function (component, event, helper) {
        
        
         window.scroll(0, 0);
        
        var url = window.location.href;
        
        
        //create states dropdown
        var States = [
            //{ value: '--None--', label: '--None--' },
          //  { value: '', label: '' },
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
        //end create states dropdown
       
    },
    
    onChange: function (component, event, helper) {
            console.log(component.get("v.strState"));
          /*  var allValid = component.find('inputCmp4').reduce(function (validSoFar, inputCmp) {
            // inputCmp.reportValidity();
            return validSoFar && inputCmp.checkValidity();
            }, true);*/
            
            var zipCmp = component.find('inputCmp4');
            
            var postalRegex = /^[0-9]{5}(?:-[0-9]{4})?$/;
            
            var postalCode=component.get("v.strPostalCode")
            
            if(postalCode!=null && postalCode!='' && postalCode!='undefined')
            {
              
                 if(!postalCode.match(postalRegex)) {
                   //set the custom error message
                    zipCmp.setCustomValidity("Current Zip must be in 99999 or 99999-9999 format.");
                    component.set("v.validZip",false);
                    }else{
                   //reset the error message
                    zipCmp.setCustomValidity("");
                    component.set("v.validZip",true);
                }
            
            }else{
                 zipCmp.setCustomValidity("");
            }
            
            
            var regex = /[A-Za-z, ]+$/;
            
            var inputCmp = component.find("inputCmp2");
            var city = component.get("v.strCity");
            
            if(city!=null && city!='' && city!='undefined')
            {
                if(!city.match(regex)) {
                   inputCmp.setCustomValidity("Enter valid value");
                   component.set("v.validCity",false);
                }else{
                   inputCmp.setCustomValidity("");
                   component.set("v.validCity",true);
                }
            }else{
                inputCmp.setCustomValidity("");
            }
            
            var inputCmp1 = component.find("inputCmp1");
            var street = component.get("v.strStreet");
            
            if(street!=null && street!='' && street!='undefined')
            {
              inputCmp1.setCustomValidity("");
            }
            
            var inputCmp3 = component.find("inputCmp3");
            var street = component.get("v.strState");
            
            if(street!=null && street!='' && street!='undefined')
            {
              inputCmp3.setCustomValidity("");
            }
            
            
        
    }, //end of on change
    
  
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
          // window.history.back(); 
          window.location.href='https://poc.acura.americanhondafinance.com';
       }
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
            
      var strStreet=component.get("v.strStreet");
      var strCity=component.get("v.strCity");
      var strState=component.get("v.strState");
      var strPostalCode=component.get("v.strPostalCode");  
      
      var regex = /[A-Za-z, ]+$/; 
      var postalRegex = /^[0-9]{5}(?:-[0-9]{4})?$/;      
            
            if(strStreet==null || strStreet=='' || strStreet=='undefined')
            {
              var inputCmp = component.find("inputCmp1");
              var value = inputCmp.get("v.value");
              inputCmp.setCustomValidity("Complete this field");
              inputCmp.reportValidity();
              component.set("v.validAddress",false); 
            }else{
              component.set("v.validAddress",true); 
            }
            
            if(strCity==null || strCity=='' || strCity=='undefined')
            {
              var inputCmp = component.find("inputCmp2");
              var value = inputCmp.get("v.value");
              inputCmp.setCustomValidity("Complete this field");
              inputCmp.reportValidity();
              component.set("v.validCity",false);
            }else{
               if(!strCity.match(regex))
               {
                inputCmp.setCustomValidity("Enter valid value");
                component.set("v.validCity",false);
               }else{
                component.set("v.validCity",true);
               }
            }
            
            if(strState==null || strState=='' || strState=='undefined')
            {
              var inputCmp = component.find("inputCmp3");
              var value = inputCmp.get("v.value");
              inputCmp.setCustomValidity("Complete this field");
              inputCmp.reportValidity();
              component.set("v.validState",false);
            }else{
              component.set("v.validState",true);
            }
            
            if(strPostalCode==null || strPostalCode=='' || strPostalCode=='undefined')
            {
              var inputCmp = component.find("inputCmp4");
              var value = inputCmp.get("v.value");
              inputCmp.setCustomValidity("Complete this field");
              inputCmp.reportValidity();
              component.set("v.validZip",false);
            }else{
              if(!strPostalCode.match(postalRegex))
              {
                 var inputCmp = component.find("inputCmp4");
                 var value = inputCmp.get("v.value");
                 
                inputCmp.setCustomValidity("Current Zip must be in 99999 or 99999-9999 format.");
                component.set("v.validZip",false);
            
              }else{
                component.set("v.validZip",true);
              }
              
            }
            
            var valCity=component.get("v.validCity");
            var valPostalCode=component.get("v.validZip");
            var valAddress=component.get("v.validAddress");
            var valState=component.get("v.validState");
            
            if(valCity && valPostalCode && valAddress && valState)
            {
              // When an option is selected, navigate to the next screen
              var response = event.getSource().getLocalId();
              component.set("v.value", response);
              var navigate = component.get("v.navigateFlow");
              navigate("NEXT");
            }
     
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