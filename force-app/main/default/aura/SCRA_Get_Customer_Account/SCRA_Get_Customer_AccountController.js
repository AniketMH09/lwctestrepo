({
    doInit : function (component, event, helper) {
         window.scroll(0, 0);
        
         //var hasAcc=component.get('v.hasaccount');
         var strssn=component.get('v.strssn');
         var faAcc=component.get('v.strFaAccount');
         var strVin=component.get('v.strVin');
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
        component.set("v.calledPrevious",false);
         /*if(hasAcc!=null && hasAcc!='' && hasAcc!='undefined')
         {
             component.set('v.hasaccount',hasAcc);
             component.set('v.disabled','false');
             component.set('v.trackAccOpt','false');
             
             if(hasAcc=='Yes')
             {
                component.set('v.hasHondaAccount',true); 
                component.set('v.accYes',true); 
             }else{
                component.set('v.hasHondaAccount',false); 
                component.set('v.accNo',true);  
             } 
         }else{
             component.set('v.hasaccount',"");
         }*/
        
         if(strssn!=null && strssn!='' && strssn!='undefined')
         {
             component.set('v.validTaxId',true);
         }
        
         if(faAcc!=null && faAcc!='' && faAcc!='undefined')
         {
             component.set('v.validAccNo',true);
         }
        
         
         if(strVin!=null && strVin!='' && strVin!='undefined')
         {
             component.set('v.validVIN',true);
         }
        
        
    },
    
    hasAccount: function (component, event, helper) {
        component.set('v.hasaccount','Yes');
        component.set('v.hasHondaAccount',true);
        component.set('v.disabled','false');
        
        
    },
    
    noAccount: function (component, event, helper) {
       component.set('v.hasaccount','No');
       component.set('v.hasHondaAccount',false); 
       component.set('v.disabled','false'); 
    },
    
    onChangeFinanceAcc: function (component, event, helper) {
       var inputCmp = component.find('faAcc');
       var regex = /^[0-9]/; 
       var faAccount=component.get("v.strFaAccount");
        
        if(faAccount!=null && faAccount!='' && faAccount!='undefined')
        {
            var accNolength=faAccount.length;
            //console.log('length of string >>>> '+accNolength);
            if(!faAccount.match(regex)) {
                inputCmp.setCustomValidity("Account Number Should be 8 or 9 digits");
                component.set("v.validAccNo",false);
            }else if(accNolength<8){
                inputCmp.setCustomValidity("Your entry is too short");
                
                component.set("v.validAccNo",false);
            }else{
                inputCmp.setCustomValidity("");
                component.set("v.validAccNo",true);
            }
        }else{
            inputCmp.setCustomValidity("");
        } 
    },
     
    onChangeStrTaxId: function(component,event,helper){
       
       var inputCmp = component.find('ssn');
       var regex = /^[0-9]/; 
       var ssnTaxId=component.get("v.strssn");
       
        if(ssnTaxId!=null && ssnTaxId!='' && ssnTaxId!='undefined')
        {
            var ssnTaxIdLength=ssnTaxId.length;
            
            if(!ssnTaxId.match(regex)) {
                inputCmp.setCustomValidity("Enter valid value");
                component.set("v.validTaxId",false);
            }else if(ssnTaxIdLength<4){
                inputCmp.setCustomValidity("Your entry is too short");
                
                component.set("v.validTaxId",false);
            }else{
                inputCmp.setCustomValidity("");
                component.set("v.validTaxId",true);
            }
            
        }else{
            inputCmp.setCustomValidity("");
        }
    },
    
    onChangeDOB : function(component,event,helper){
       
       var inputCmp = component.find('dobfield');
       var vinNo=component.get("v.strdob2");
       
       if(vinNo!=null && vinNo!='' && vinNo!='undefined')
       {
           
               inputCmp.setCustomValidity("");
                component.set("v.validDOB",true); 
           
       }else{
           inputCmp.setCustomValidity("");
       }
       
    },
             
              onChangeState : function(component,event,helper){
       
       var inputCmp = component.find('state');
       var state=component.get("v.strState");
       
       if(state!=null && state!='' && state!='undefined')
       {
            
               inputCmp.setCustomValidity("");
                component.set("v.validDOB",true); 
           
       }else{
           inputCmp.setCustomValidity("");
       }
       
    }, //Narain

    onChangeActiveDutyDate : function(component,event,helper){
       
        var inputCmp = component.find('activeddate');
        var activedutydate=component.get("v.activedutydate");

        var isvalidDOB = component.get("v.validDOB");
        var isvalivalidTaxId = component.get("v.validTaxId");
        
        if(activedutydate!=null && activedutydate!='' && activedutydate!='undefined')
        {
            
                inputCmp.setCustomValidity("");
                 component.set("v.validActiveDutyDate",true); 
                if(isvalidDOB && isvalivalidTaxId){
                    component.set('v.disabled','false'); 
                }
                
            
        }else{
            inputCmp.setCustomValidity("");
        }
        
     },
     onAdditionalInfoChange: function (component, event, helper) {
        
        
        	var inputCmp2 = component.find("additionalinfo");
            var strrequestoption = component.get("v.additionalInfoSelected");
            
            if(strrequestoption!=null && strrequestoption!='' && strrequestoption!='undefined')
            {
            	inputCmp2.setCustomValidity(""); 
            	component.set("v.validAdditionalInfo",true);
            }
        
        
    }, 
     
     
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
        
     const scrollOptions = {
            left: 4,
            top: 2,
            behavior: "smooth"
        };
        window.scrollTo(scrollOptions);     
    },
    
    handleContinue : function(component, event, helper) {
     
      var faAccount=component.get("v.strFaAccount");
      //var strVin=component.get("v.strVin");
      
      //var hasAcc=component.get('v.hasaccount');  
      
        
     // if(hasAcc=='Yes')
      //{
          /*var inputCmp = component.find('faAcc');
          
          if(faAccount!=null && faAccount!='' && faAccount!=undefined)
          {   
              var regex = /^[0-9]/; 
              var accNolength=faAccount.length;
            console.log('length of string >>>> '+accNolength);
            if(!faAccount.match(regex)) {
                inputCmp.setCustomValidity("Account Number Should be 8 or 9 digits");
                component.set("v.validAccNo",false);
                inputCmp.reportValidity();
            }else if(accNolength<8){
                inputCmp.setCustomValidity("Your entry is too short");
                
                component.set("v.validAccNo",false);
                inputCmp.reportValidity();
            }else{
               // inputCmp.setCustomValidity("");
                component.set("v.validAccNo",true);
            }
            
              
              
          }else if(hasAcc=='Yes'){
            component.set("v.validAccNo",false);  
            inputCmp.setCustomValidity("Complete this field");  
            inputCmp.reportValidity();  
          }else if(hasAcc=='No'){
             component.set("v.validAccNo",true);  
          }
          
          var inputCmp2 = component.find('vin');
          
          if(strVin!=null && strVin!='' && strVin!=undefined)
          {
              var regex = /[A-Za-z0-9]{17}/; 
              if(!strVin.match(regex)) {
                inputCmp2.setCustomValidity("VIN should be Should be 17 characters");
                component.set("v.validVIN",false);
                inputCmp2.reportValidity();  
           }else{
              // inputCmp2.setCustomValidity("");
                component.set("v.validVIN",true); 
           }
              
          }else if(hasAcc=='Yes'){
              component.set("v.validVIN",false); 
              inputCmp2.setCustomValidity("Complete this field");
              inputCmp2.reportValidity();
          }else if(hasAcc=='No'){
             component.set("v.validVIN",true);  
          }*/
   //   }
      
        var ssnTaxId=component.get("v.strssn");
        
       if(ssnTaxId === null || ssnTaxId === '' || ssnTaxId === undefined)
            {
            
            var inputCmp = component.find("ssn");
            var value = inputCmp.get("v.value");
            inputCmp.setCustomValidity("Error: SSN/Tax Id should be 4 digits.");
            inputCmp.reportValidity();
            component.set("v.validTaxId",false); 
            } else if(ssnTaxId!=null && ssnTaxId!='' && ssnTaxId!=undefined)
       {
           var inputCmp = component.find('ssn');
           var regex = /^[0-9]/; 
           
           var ssnTaxIdLength=ssnTaxId.length;
            
            if(!ssnTaxId.match(regex)) {
                inputCmp.setCustomValidity("Complete this field");
                component.set("v.validTaxId",false);
                inputCmp.reportValidity();
            }else if(ssnTaxIdLength<4){
                inputCmp.setCustomValidity("Error: SSN/Tax Id should be 4 digits.");
                
                component.set("v.validTaxId",false);
                inputCmp.reportValidity();
            }else{
                //inputCmp.setCustomValidity("");
                component.set("v.validTaxId",true);
            }
            
       }else{
           component.set("v.validTaxId",true);
       }
        
        var strdob2=component.get('v.strdob2');
        var activedutydate=component.get('v.activedutydate');
        var additionalInfo = component.get('v.additionalInfoSelected');
        var strState = component.get('v.strState');
         
        if(strdob2 === null || strdob2 === '' || strdob2 === undefined)
            {
            
            var inputCmp = component.find("dobfield");
            var value = inputCmp.get("v.value");
            inputCmp.setCustomValidity("Error: Your Date of Birth does not match the allowed format of Jan 1, 2022.");
            inputCmp.reportValidity();
            component.set("v.validDOB",false); 
            }else{
               component.set("v.validDOB",true); 
            }
        if(activedutydate === null || activedutydate === '' || activedutydate === undefined)
            {
            
            var inputCmp = component.find("activeddate");
            var value = inputCmp.get("v.value");
            inputCmp.setCustomValidity("Error: Your Date of Active Duty does not match the allowed format of Jan 1, 2022.");
            inputCmp.reportValidity();
            component.set("v.validdoad",false); 
            }else{
               component.set("v.validdoad",true); 
            }

        if(strState === null || strState === '' || strState === undefined)
            {
              var inputCmp = component.find("state");
              var value = inputCmp.get("v.value");
              inputCmp.setCustomValidity("Error: Select a state from the dropdown");
              inputCmp.reportValidity();
              component.set("v.validState",false);
 
            }else{
 
              component.set("v.validState",true);
             }

        if(additionalInfo === null || additionalInfo === '' || additionalInfo === undefined)
            {
            
            var inputCmp = component.find("additionalinfo");
            inputCmp.setCustomValidity("Error: Please make a selection");
            inputCmp.reportValidity();
            component.set("v.validAdditionalInfo",false); 
            }else{
               component.set("v.validAdditionalInfo",true); 
            }
          
        
        var validTaxId=component.get("v.validTaxId");
        var validDatob = component.get("v.validDOB");
        var validactive = component.get("v.validdoad");
        var validAdditionalInfo = component.get("v.validAdditionalInfo");
        var validState = component.get("v.validState");
        //var validVin=component.get("v.validVIN");
        //var validAccNo=component.get("v.validAccNo");
        
        if(validTaxId && validDatob && validactive && validAdditionalInfo && validState)
        {
            // When an option is selected, navigate to the next screen
              var response = event.getSource().getLocalId();
              component.set("v.value", response);
              var navigate = component.get("v.navigateFlow");
              navigate("NEXT");
        }
     
   },
    handlePrevious : function(component, event, helper) {
        try{
     // When an option is selected, navigate to the next screen
     component.set("v.calledPrevious",true);
      var response = event.getSource().getLocalId();
      component.set("v.value", response);
      var navigate = component.get("v.navigateFlow");
      
            /*
        var navigateEvent = $A.get("e.c:SCRA_Navigate_event");
        navigateEvent.setParams({ "action" : "Previous" });
        navigateEvent.fire();*/
        navigate("BACK");
        }catch(err){
            console.log(err);
        }
   },
    
   contactUs : function(component, event, helper) {
        var href = $A.get("$Label.c.AHFC_Contact_Us_URL");
        window.open(href,'_top');
	}, 

})