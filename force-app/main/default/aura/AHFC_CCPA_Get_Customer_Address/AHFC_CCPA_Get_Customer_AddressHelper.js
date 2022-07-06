({
    // validate zip code
	validateZipCode : function(component, event) {
        
         var postalRegex = /^[0-9]{5}(?:-[0-9]{4})?$/;
         var postalCode=component.get("v.strPostalCode")
         var zipCmp = component.find('inputCmp4');
        
         if(postalCode!=null && postalCode!='' && postalCode!='undefined')
            {
              
                 if(!postalCode.match(postalRegex)) {
                     zipCmp.setCustomValidity("Error: Zip Code must be in 99999 or 99999-9999 format.");
                     component.set("v.validZip",false);
                     zipCmp.reportValidity();
                    }else{
                    zipCmp.setCustomValidity("");
                    component.set("v.validZip",true);
                    zipCmp.reportValidity();
                }
            
            }else{
                 zipCmp.setCustomValidity("");
                zipCmp.reportValidity();
            }
	},
 
    // validate input string values
    validateStringValues : function(data)
    {
        var regex = /[A-Za-z, ]+$/;
        var validData=false;
        if(data.match(regex))
        {
           validData=true; 
        }
        
        return validData;
    }
})