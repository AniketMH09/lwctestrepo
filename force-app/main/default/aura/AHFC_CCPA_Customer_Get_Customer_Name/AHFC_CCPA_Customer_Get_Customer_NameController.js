({
    doInit : function (component) {
        
        window.scroll(0,0);
        
        var firstName = component.get("v.validFirstName");
        
        if(firstName!=null && firstName!='' && firstName!='undefined')
        {
            component.set("v.validFirstName",true);
        }
        
        var lastName = component.get("v.validLastName");
        
        if(lastName!=null && lastName!='' && lastName!='undefined')
        {
            component.set("v.validLastName",true);
        }
        
    },
    
    // on  input value chage validate data and show error message
    onChange: function (component, event, helper) {
        
        var inputCmp = component.find("inputCmp1");
        var firstName = component.get("v.strFirstName");
        
        var validFirstName=false;
        
        if(firstName!=null && firstName!='' && firstName!='undefined')
        {
            validFirstName=helper.validateName(firstName);
            if(validFirstName==false)
            {
                inputCmp.setCustomValidity("Error: Enter Valid First Name.");
                inputCmp.reportValidity();
            }else{
                inputCmp.setCustomValidity("");
                inputCmp.reportValidity();
            }
        }else{
            inputCmp.setCustomValidity("");
            inputCmp.reportValidity();
        }
        
        var inputCmp2 = component.find("inputCmp2");
        var lastName  = component.get("v.strLastName");
        
        var validLastName=false;
        
        if(lastName!=null && lastName!='' && lastName!='undefined')
        {
            validLastName=helper.validateName(lastName);
            if(validLastName==false)
            {
                inputCmp2.setCustomValidity("Error: Enter Valid Last Name.");
                inputCmp2.reportValidity();
            }else{
                inputCmp2.setCustomValidity("");
                inputCmp2.reportValidity();
            }
        }else{
            inputCmp2.setCustomValidity("");
            inputCmp2.reportValidity();
        }
        
        
        var inputCmp3 = component.find("inputCmp3");
        var middleName = component.get("v.strMiddleName");
        
        var validMiddleName=false;
        
        if(middleName!=null && middleName!='' && middleName!='undefined')
        {
            validMiddleName=helper.validateName(middleName);
            if(validMiddleName==false)
            {
                inputCmp3.setCustomValidity("Error: Enter Valid Middle Name.");
                inputCmp3.reportValidity();
                component.set("v.validMiddleName",false);
            }else{
                inputCmp3.setCustomValidity("");
                inputCmp3.reportValidity();
                component.set("v.validMiddleName",true);
            }
        }else{
            inputCmp3.setCustomValidity("");
            inputCmp3.reportValidity();
            component.set("v.validMiddleName",true);
        }
        
        var inputCmp4 = component.find("inputCmp4");
        var suffix = component.get("v.strSuffix");
        
        var validSuffix=false;
        
        if(suffix!=null && suffix!='' && suffix!='undefined')
        {
            validSuffix=helper.validateName(suffix);
            if(validSuffix==false)
            {
                inputCmp4.setCustomValidity("Error: Enter Valid Suffix.");
                inputCmp4.reportValidity();
                component.set("v.validSuffix",false);
            }else{
                inputCmp4.setCustomValidity("");
                inputCmp4.reportValidity();
                component.set("v.validSuffix",true);
            }
        }else{
            inputCmp4.setCustomValidity("");
            inputCmp4.reportValidity();
            component.set("v.validSuffix",true);
        }
        
        
    }, 
    
    
    // navigate to dashboard if user is logged in otherwise pre login page
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
    
    // to close popup set isOpen flag to false
    closeModel: function(component) {
        component.set("v.isOpen", false);
    },
    
    // to close popup set isOpen flag to true
    openModel : function(component) {
        component.set("v.isOpen", true);
        const scrollOptions = {
            left: 4,
            top: 2,
            behavior: "smooth"
        };
        window.scrollTo(scrollOptions);
    },
    
    //navigate to previous flow screen
    handlePrevious : function(component, event) {
        var response = event.getSource().getLocalId();
        component.set("v.value", response);
        var navigate = component.get("v.navigateFlow");
        navigate("BACK");
    },
    
    //validate data first and then navigate to next flow screen  
    handleContinue : function(component, event, helper) {
        
        var strFirstName=component.get('v.strFirstName');
        var strLastName=component.get('v.strLastName');
        
        var  validFirstName=false;
        var  validLastName=false;
        
        var inputCmp = component.find("inputCmp1");
        
        if(strFirstName==null || strFirstName=='' || strFirstName=='undefined')
        {   inputCmp.setCustomValidity("Error: Enter First Name.");
         inputCmp.reportValidity();
        }else{
            
            validFirstName=helper.validateName(strFirstName);
            
            if(validFirstName)
            {
                validFirstName=true;
            }else{
                inputCmp.setCustomValidity("Error: Enter Valid First Name.");
            }
            
        }
        
        var inputCmp2 = component.find("inputCmp2");
        
        if(strLastName==null || strLastName=='' || strLastName=='undefined')
        {
            inputCmp2.setCustomValidity("Error: Enter Last Name.");
            inputCmp2.reportValidity();   
        }else{
            
            validLastName=helper.validateName(strLastName);
            
            if(validLastName)
            {
                component.set("v.validLastName",true);
                validLastName=true;
            }else{
                inputCmp2.setCustomValidity("Error: Enter Valid Last Name.");
                component.set("v.validLastName",false);
            }
            
        }
        
        
        var validMiddleName=component.get("v.validMiddleName");
        var validSuffix=component.get("v.validSuffix");
        
        if(validFirstName && validLastName
           && validMiddleName && validSuffix)
        {
            var response = event.getSource().getLocalId();
            component.set("v.value", response);
            var navigate = component.get("v.navigateFlow");
            navigate("NEXT");
            
        }
        
    },
    
    
    
})