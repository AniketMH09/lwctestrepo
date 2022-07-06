({
    doInit : function (component) {
        
        window.scroll(0, 0);
        
        var hasAcc=component.get('v.hasaccount');
        var strssn=component.get('v.strssn');
        var faAcc=component.get('v.strFaAccount');
        var strVin=component.get('v.strVin');
        
        if(hasAcc!=null && hasAcc!='' && hasAcc!='undefined')
        {
            component.set('v.disabled',false);
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
    
    // validate finance account number
    onChangeFinanceAcc: function (component,event, helper) {
        var faAccount=(component.get("v.strFaAccount")===undefined || component.get("v.strFaAccount")==='')?null:component.get("v.strFaAccount");
        var vinNo=(component.get("v.strVin")===undefined || component.get("v.strVin")==='')?null:component.get("v.strVin");
        var serialNo=(component.get("v.strSerialNo")===undefined || component.get("v.strSerialNo")==='')?null:component.get("v.strSerialNo");
        var contractNo=(component.get("v.strContractNo")===undefined || component.get("v.strContractNo")==='')?null:component.get("v.strContractNo");
        var hasaccount=component.get("v.hasaccount");
        
        var inputCmp = component.find('faAcc');
        if(faAccount!==null)
        {
            helper.validateFinanceAccountNumber(component,event);
        }else{
            component.set("v.validAccNo",true);
            inputCmp.setCustomValidity("");
            inputCmp.reportValidity();
            
        }
        
        if(component.get("v.validAccNo")===true  && component.get("v.validVIN")===true)
        {
            component.set('v.disabled',false);  
        }else{
            component.set('v.disabled',true);
        }
        
        if(faAccount===null && vinNo===null && serialNo ===null && contractNo===null)
         {
          component.set('v.disabled',true);  
        }else if((faAccount==null && component.get("v.validAccNo")===true) && (vinNo===null && component.get("v.validVIN")===true)) {
                if(hasaccount==='Yes' && serialNo!==null || contractNo!==null)
                {
                   component.set('v.disabled',false); 
                }else{
                   component.set('v.disabled',true); 
                }
                
            }
        
        
    },
    // validate finance SSN or Tax Id
    onChangeStrTaxId: function(component,event,helper){
        helper.validateTaxId(component,event); 
    },
    // validate VIN number
    onVinNoChange : function(component,event,helper){
        var faAccount=(component.get("v.strFaAccount")===undefined || component.get("v.strFaAccount")==='')?null:component.get("v.strFaAccount");
        var vinNo=(component.get("v.strVin")===undefined || component.get("v.strVin")==='')?null:component.get("v.strVin");
        var serialNo=(component.get("v.strSerialNo")===undefined || component.get("v.strSerialNo")==='')?null:component.get("v.strSerialNo");
        var contractNo=(component.get("v.strContractNo")===undefined || component.get("v.strContractNo")==='')?null:component.get("v.strContractNo");
        
        var hasaccount=component.get("v.hasaccount");
        
        var inputCmp = component.find('vin');
        
           if(vinNo!==null)
            {
                helper.validateVinNumber(component,event);
            }else{
                component.set("v.validVIN",true);
                inputCmp.setCustomValidity("");
                inputCmp.reportValidity();
            }
            
            if(component.get("v.validVIN")===true  && component.get("v.validAccNo")===true)
            {
                component.set('v.disabled',false);  
            }else{
                component.set('v.disabled',true);
            }    
        
            if(hasaccount==='Yes' && faAccount===null && vinNo===null && serialNo ===null && contractNo===null)
            {
               component.set('v.disabled',true);  
            }else if((faAccount==null && component.get("v.validAccNo")===true) && (vinNo===null && component.get("v.validVIN")===true)) {
                if( hasaccount==='Yes' && serialNo!==null || contractNo!==null)
                {
                   component.set('v.disabled',false); 
                }else{
                   component.set('v.disabled',true); 
                }
                
            }
        
    },
    
    onValueChange: function (component,event) {
        var faAccount=(component.get("v.strFaAccount")===undefined || component.get("v.strFaAccount")==='')?null:component.get("v.strFaAccount");
        var vinNo=(component.get("v.strVin")===undefined || component.get("v.strVin")==='')?null:component.get("v.strVin");
        var serialNo=(component.get("v.strSerialNo")===undefined || component.get("v.strSerialNo")==='')?null:component.get("v.strSerialNo");
        var contractNo=(component.get("v.strContractNo")===undefined || component.get("v.strContractNo")==='')?null:component.get("v.strContractNo");
        var hasaccount=component.get("v.hasaccount");
        
            if(hasaccount==='Yes' && faAccount==null && vinNo==null && serialNo ===null && contractNo===null)
            {
               component.set('v.disabled',true);  
            }else{
                
                if(component.get("v.validVIN")===true  && component.get("v.validAccNo")===true)
                {
                 component.set('v.disabled',false);    
                }else{
                   component.set('v.disabled',true); 
                }
                
            }
        
    },
    
    // set flage validDob true if validity is true
    validateDateOfBith: function(component)
    {
        
        var inputCmp=component.find('dob');
        
        if(inputCmp.checkValidity()==false)
        {
            component.set("v.validDob", false); 
        }else{
            component.set("v.validDob", true);  
        }
    },
    
    onSelectRadioBtn: function(component){
        var hasAccount=component.get("v.hasaccount");
        if(hasAccount==='Yes')
        {
           component.set('v.disabled',true); 
        }else{
            component.set('v.disabled',false);
        }
    } ,
    
    //navigate to dashboard if user is logged in otherwise navigate to pre login page
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
    
    // to open popup set isOpen flag to false
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
    
    //validate data and navigate to next flow screen
    handleContinue : function(component, event, helper) {
        
        var faAccount=component.get("v.strFaAccount");
        var strVin=component.get("v.strVin");
        var hasAcc=component.get('v.hasaccount'); 
        var ssnTaxId=component.get('v.strssn'); 
        
        if(ssnTaxId!=null && ssnTaxId!='' && ssnTaxId!='undefined')
        {
            helper.validateTaxId(component);
            
        }else{
            component.set("v.validTaxId",true);
        } 
        
        var validDob=component.get('v.validDob'); 
        var validTaxId=component.get("v.validTaxId");
        var validVin=component.get("v.validVIN");
        var validAccNo=component.get("v.validAccNo");
        
        if(validTaxId===true && validDob===true && component.get("v.disabled")===false)
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