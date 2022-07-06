({
    
    doInit : function (component) {
        
        
        var comPref=component.get('v.strCommunicationPref');
        
        if(comPref!==null && comPref!=='' && comPref!==undefined)
        {
            component.set('v.trackComPref',true);
            
            if(comPref==='Email')
            {
                component.set('v.emailrequired',true);
            }
        }
        
        
        /*Captcha Code Implementation */
        
        
        window.addEventListener('message', function (event) {
            
            if (event.data.captchaVisible) {
                let captchEl = document.getElementById('vfFrame');
                if(event.data.captchaVisible === 'visible'){
                    captchEl.classList.add('reCaptchaBig');
                    captchEl.classList.remove('reCaptchaSmall');
                } else {
                    captchEl.classList.remove('reCaptchaBig');
                    captchEl.classList.add('reCaptchaSmall');
                }
            }
            
            if (event.data.action === 'unlock') {
                component.set("v.captchaokay",true);
            }
            
            if (event.data.action === 'expired') {
                component.set("v.captchaokay",false);
            }
            
        }, false);
        
        /*End Captch code*/
        
        
        if (component.get("v.strRequestType") === $A.get('$Label.c.CCPA_DO_NOT_SELL')){
            component.set("v.strMessage1",$A.get('$Label.c.CCPA_DNS_MSG_1'));
        }
        else if (component.get("v.strRequestType") === $A.get('$Label.c.CCPA_WHAT_INFO')){
            component.set("v.strMessage1",$A.get('$Label.c.CCPA_WHAT_INFO_MSG_1'));
            component.set("v.inforequest", true);
        }else if (component.get("v.strRequestType") === $A.get('$Label.c.CCPA_DELETE_INFO')){
            component.set("v.strMessage1",$A.get('$Label.c.CCPA_DELETE_INFO_MSG_1'));
        }
        
        var infocategory =  [
            {'label': $A.get('$Label.c.CCPA_INFO_CATEGORY_MSG1'), 'value':$A.get('$Label.c.CCPA_INFO_CATEGORY_MSG1') },
            {'label': $A.get('$Label.c.CCPA_INFO_CATEGORY_MSG2'), 'value': $A.get('$Label.c.CCPA_INFO_CATEGORY_MSG2')}
        ];
        
        component.set("v.infocategory", infocategory); 
        
    },
    
    // this function called when captchaokay value change to enable or disable button
    checkCapchaStatus : function(component)
    {
        
        if(component.get("v.captchaokay") && component.get('v.trackComPref'))
        {
            component.set("v.disabled",false);
        }else{
            component.set("v.disabled",true);
        }
    },
    
    // validate Email Id 
    validateEmail: function (component,event ,helper){
        helper.validateEmailId(component, event );
    }, 
    
    // validate phone
    validatePhone : function(component, event,helper)
    {
        helper.validatePhoneNumber(component, event); 
    },
    
    onChangeComPref: function(component)
    {
        var comPref= component.get("v.strCommunicationPref");
        var inputCmp = component.find('email');
        
        component.set('v.trackComPref',true);
        if(comPref==='Email')
        {
            component.set("v.emailrequired",true);
        }else{
            component.set("v.emailrequired",false);
            inputCmp.setCustomValidity("");
            inputCmp.reportValidity(); 
        
        }
        
        if(component.get("v.captchaokay"))
        {
            component.set("v.disabled",false); 
        }else{
            component.set("v.disabled",true);
        }
    },
    
    //navigate to dashboard if user is logged in otherwise navigate to prelogin page
    redirectToHome : function(component,event)
    {
        
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
    
    changeinfocategory: function(component) {
        var infocategory = component.get("v.strinfocategory");
        if (infocategory ===$A.get('$Label.c.CCPA_INFO_CATEGORY_MSG2')){
            component.set("v.perjuryackreqd",true);
        }    
    },
    
    // to close popup  set isOpen flage to false
    closeModel: function(component) {
        component.set("v.isOpen", false);
    },
    
    // to close popup  set isOpen flage to true
    openModel : function(component) {
        component.set("v.isOpen", true);
        const scrollOptions = {
            left: 4,
            top: 2,
            behavior: "smooth"
        };
        window.scrollTo(scrollOptions);
    },
    
    // navigate to next flow screen 
    handleContinue : function(component, event,helper){
        
        var validEmailId=false;
        if(component.get("v.emailrequired"))
        {
            validEmailId=helper.validateEmailId(component,event);
        }else{
            validEmailId=true;
        }
        
        var validPhone=helper.validatePhoneNumber(component,event); 
        
        var response = event.getSource().getLocalId(); 
        
        if(validEmailId && validPhone)
        {
            component.set("v.value", response);
            var navigate = component.get("v.navigateFlow");
            navigate("NEXT"); 
        }
    },
})