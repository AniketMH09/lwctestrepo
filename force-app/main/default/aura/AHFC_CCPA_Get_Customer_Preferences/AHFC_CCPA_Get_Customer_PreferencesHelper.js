({
	// validate email id
    validateEmailId: function(component,event)
    {
        var inputCmp = component.find('email');
        var validEmail=false;
        var email=component.get("v.strEmail");
        var regex = /^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+$/;
        
        console.log(' email >>>> '+email);
        
        if(email!=null && email!='undefined' && email!='')
        {
            if(email.match(regex))
            {
                inputCmp.setCustomValidity("");
                inputCmp.reportValidity();
                validEmail=true;
            }else{
                inputCmp.setCustomValidity("Error: Enter a Valid Email Address.");
                inputCmp.reportValidity();
            }
        }else{
            if(component.get("v.emailrequired"))
            {
                inputCmp.setCustomValidity("Error: Enter an Email Address.");
            }else{
                inputCmp.setCustomValidity("");
            }
             inputCmp.reportValidity();
            
        }
        
        
        return validEmail;
    },
    
    // validate phone number
    validatePhoneNumber : function(component,event)
    {
        var inputCmp = component.find('phone');
        var validPhone=false;
        var phone=component.get("v.strPhoneNumber");
        var regex = /^[0-9]{10}/;
        
        if(phone!=null && phone!='undefined' && phone!='')
        {
            if(phone.match(regex))
            {
                inputCmp.setCustomValidity("");
                inputCmp.reportValidity();
                validPhone=true;
            }else{
                inputCmp.setCustomValidity("Error: Enter a 10 digits Mobile Number.");
                inputCmp.reportValidity();
            }
        }else{
            inputCmp.setCustomValidity("");
            inputCmp.reportValidity();
            validPhone=true;
        }
        
        return validPhone;
    }
  
})