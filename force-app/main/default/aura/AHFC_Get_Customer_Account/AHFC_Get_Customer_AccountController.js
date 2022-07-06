({
    doInit : function (component, event, helper) {
         window.scroll(0, 0);
        
         var hasAcc=component.get('v.hasaccount');
         var strssn=component.get('v.strssn');
         var faAcc=component.get('v.strFaAccount');
         var strVin=component.get('v.strVin');
         
         if(hasAcc!=null && hasAcc!='' && hasAcc!='undefined')
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
         }
        
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
            console.log('length of string >>>> '+accNolength);
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
    
    onVinNoChange : function(component,event,helper){
       
       var inputCmp = component.find('vin');
       var regex = /[A-Za-z0-9]{17}/; 
       var vinNo=component.get("v.strVin");
       
       if(vinNo!=null && vinNo!='' && vinNo!='undefined')
       {
           if(!vinNo.match(regex)) {
                inputCmp.setCustomValidity("VIN should be Should be 17 characters");
                component.set("v.validVIN",false);
           }else{
               inputCmp.setCustomValidity("");
                component.set("v.validVIN",true); 
           }
       }else{
           inputCmp.setCustomValidity("");
       }
       
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
     
      var faAccount=component.get("v.strFaAccount");
      var strVin=component.get("v.strVin");
      
      var hasAcc=component.get('v.hasaccount');  
      
        
     // if(hasAcc=='Yes')
      //{
          var inputCmp = component.find('faAcc');
          
          if(faAccount!=null && faAccount!='' && faAccount!='undefined')
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
          
          if(strVin!=null && strVin!='' && strVin!='undefined')
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
          }
   //   }
      
        var ssnTaxId=component.get("v.strssn");
        
       if(ssnTaxId!=null && ssnTaxId!='' && ssnTaxId!='undefined')
       {
           var inputCmp = component.find('ssn');
           var regex = /^[0-9]/; 
           
           var ssnTaxIdLength=ssnTaxId.length;
            
            if(!ssnTaxId.match(regex)) {
                inputCmp.setCustomValidity("Enter valid value");
                component.set("v.validTaxId",false);
                inputCmp.reportValidity();
            }else if(ssnTaxIdLength<4){
                inputCmp.setCustomValidity("Your entry is too short");
                
                component.set("v.validTaxId",false);
                inputCmp.reportValidity();
            }else{
                //inputCmp.setCustomValidity("");
                component.set("v.validTaxId",true);
            }
            
       }else{
           component.set("v.validTaxId",true);
       } 
        
        var validTaxId=component.get("v.validTaxId");
        var validVin=component.get("v.validVIN");
        var validAccNo=component.get("v.validAccNo");
        
        if(validTaxId && validVin && validAccNo)
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