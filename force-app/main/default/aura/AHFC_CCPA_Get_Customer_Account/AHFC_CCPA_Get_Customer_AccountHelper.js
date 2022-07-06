({
	// validate finance account number
    validateFinanceAccountNumber: function(component,event)
    {
        var inputCmp = component.find('faAcc');
        var regex = /^[0-9]+$/; 
        var faAccount=component.get("v.strFaAccount");
        var accNolength=faAccount.length;
            
            if(!faAccount.match(regex)) {
                inputCmp.setCustomValidity("Error: Account Number Should be 8 or 9 digits.");
                inputCmp.reportValidity();
                component.set("v.validAccNo",false);
                component.set('v.disabled',true);
            }else if(accNolength<8){
                inputCmp.setCustomValidity("Error: Account Number Should be 8 or 9 digits.");
                inputCmp.reportValidity();
                component.set("v.validAccNo",false);
                component.set('v.disabled',true);
            }else{
                inputCmp.setCustomValidity("");
                inputCmp.reportValidity();
                component.set("v.validAccNo",true);
                component.set('v.disabled',false);
            }
        
    },
    // validate finance SSN or Tax Id
    validateTaxId: function(component,event)
    {
       var inputCmp = component.find('ssn');
       var regex = /^[0-9]/; 
       var ssnTaxId=component.get("v.strssn");
       
        if(ssnTaxId!==null && ssnTaxId!=='' && ssnTaxId!=='undefined')
        {
            var ssnTaxIdLength=ssnTaxId.length;
            
            if(!ssnTaxId.match(regex)) {
                inputCmp.setCustomValidity("Error: SSN/Tax ID should be 4 digits.");
                inputCmp.reportValidity();
                component.set("v.validTaxId",false);
            }else if(ssnTaxIdLength<4){
                inputCmp.setCustomValidity("Error: SSN/Tax ID should be 4 digits.");
                inputCmp.reportValidity();
                component.set("v.validTaxId",false);
            }else{
                inputCmp.setCustomValidity("");
                inputCmp.reportValidity();
                component.set("v.validTaxId",true);
            }
            
        }else{
            
            inputCmp.setCustomValidity("");
            inputCmp.reportValidity();
        }
    },
    
    // validate VIN number
    validateVinNumber :function(component,event)
    {
       var inputCmp = component.find('vin');
       var regex = /[A-Za-z0-9]{17}/; 
       var vinNo=component.get("v.strVin");
      
        if(!vinNo.match(regex)) {
               inputCmp.setCustomValidity("Error: VIN should be 17 characters.");
               inputCmp.reportValidity();
               component.set("v.validVIN",false);
               component.set('v.disabled',true);
           }else{
               inputCmp.setCustomValidity("");
               inputCmp.reportValidity();
               component.set("v.validVIN",true); 
               component.set('v.disabled',false);
           }
       
    } ,
    
 
})