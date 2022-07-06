({
    // @VM 10/17, T-736268 : Server call to get custom setting value for no. of days to be enable
    doInit : function (component, event, helper) {
        
        //debug stmt
        //component.set("v.captchaokay",true);
        
        window.scroll(0, 0);
        
        var url = window.location.href;
        console.log(url);
        
        // Adding custom label for domain [3/01/2019]
        var hondaDomain = $A.get("$Label.c.HONDA_DOMAIN");
        var acuraDomain = $A.get("$Label.c.ACURA_DOMAIN");
        
        
        var vfOrigin = '';
        var vflink = '';
        if(url.includes(hondaDomain))
        {
            component.set("v.communityName",'hondahelp');
            vfOrigin = $A.get('$Label.c.CCPA_VF_COMMUNITY_URL_honda');
            vflink = vfOrigin +   '/apex/CCPA_Honda_captcha';
            component.set("v.strvflink", vflink);
        }
        else //if(url.includes(acuraDomain))
        {   
            component.set("v.communityName",'acurahelp');
            vfOrigin = $A.get('$Label.c.CCPA_VF_COMMUNITY_URL_acura');
            vflink = vfOrigin +   '/apex/CCPA_Acura_captcha';
            console.log(vflink);
            component.set("v.strvflink", vflink);
        }
        
        /*Captcha Code */
        //let vfOrigin = $A.get('$Label.c.CCPA_VF_COMMUNITY_URL');
        
        var pathArray = vfOrigin.split( '/' );
var protocol = pathArray[0];
var host = pathArray[2];
var vfdomain = protocol + '//' + host;
        window.addEventListener('message', function (event) {
            if (event.origin !== vfdomain) {
                return;
            }
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
                // passing captcha is handled here. event.data.response - is a key of captcha
                component.set("v.captchaokay",true);
            }
        }, false);
        // End Captcha Code 
        
        //update message based on request type
       // component.set("v.strRequestType",$A.get('$Label.c.CCPA_WHAT_INFO'));
        
        if (component.get("v.strRequestType") === $A.get('$Label.c.CCPA_DO_NOT_SELL')){
            component.set("v.strMessage1",$A.get('$Label.c.CCPA_DNS_MSG_1'));
        }
        else if (component.get("v.strRequestType") === $A.get('$Label.c.CCPA_WHAT_INFO')){
            component.set("v.strMessage1",$A.get('$Label.c.CCPA_WHAT_INFO_MSG_1'));
            component.set("v.inforequest", true);
        }
            else if (component.get("v.strRequestType") === $A.get('$Label.c.CCPA_DELETE_INFO')){
                component.set("v.strMessage1",$A.get('$Label.c.CCPA_DELETE_INFO_MSG_1'));
            }
        //end update message
        //
        //info category options
        var infocategory =  [
            {'label': $A.get('$Label.c.CCPA_INFO_CATEGORY_MSG1'), 'value':$A.get('$Label.c.CCPA_INFO_CATEGORY_MSG1') },
            {'label': $A.get('$Label.c.CCPA_INFO_CATEGORY_MSG2'), 'value': $A.get('$Label.c.CCPA_INFO_CATEGORY_MSG2')}
        ];
        component.set("v.infocategory", infocategory);
        //end info category
    },
    
    onChange: function (component, event, helper) {
        console.log("On Change function");
        console.log( component.get("v.captchaokay"));
        
        
        var allValid = component.find('field').reduce(function (validSoFar, inputCmp) {
            // inputCmp.reportValidity();
            return validSoFar && inputCmp.checkValidity();
        }, true);
        
        
        if (allValid && component.get("v.captchaokay")) {
            component.set("v.disabled",false);
        }
        else {
            component.set("v.disabled",true);
        }
        
        
    }, //end of on change
    
    onPrefChange: function (component, event, helper) {
        
        component.set('v.truthy',false);
        component.set('v.truthy',true);          
        var pref = component.get("v.strCommunicationPref");
        if (pref==='Email'){
            component.set("v.emailrequired",true);
            component.set("v.phonerequired",false);
        }
        else {
            component.set("v.phonerequired",true);
            component.set("v.emailrequired",false);
        }
        
       var trackpref = component.get("v.trackpref");
       if (trackpref) component.set("v.trackpref",false)
       else component.set("v.trackpref",true);
        
        
        
    }, //end of on pref change
    
    
    redirectToHome : function(component,event,helper){
        //@KP Nov/08 - T-747962 Cancellation return to MyAccount Page
        var url = window.location.href;
        // Adding custom label for domain [3/01/2019]
        var hondaDomain = $A.get("$Label.c.HONDA_DOMAIN");
        if(url.includes(hondaDomain)){
            url = $A.get("$Label.c.AHFC_Honda_URL");
        } else{
            url = $A.get("$Label.c.AHFC_Acura_URL");
        }
        window.open(url,'_top');
    },
    changeinfocategory: function(component, event, helper) {
    var infocategory = component.get("v.strinfocategory");
        if (infocategory ===$A.get('$Label.c.CCPA_INFO_CATEGORY_MSG2')){
            component.set("v.perjuryackreqd",true);
        }    
    },
    
    closeModel: function(component, event, helper) {
        // for Hide/Close Model,set the "isOpen" attribute to "Fasle"  
        component.set("v.isOpen", false);
    },
    
    openModel : function(component, event, helper) {
        // for Display Model,set the "isOpen" attribute to "true"
        component.set("v.isOpen", true);
    },
    
    handleContinue : function(component, event, helper) {
        // When an option is selected, navigate to the next screen
        var response = event.getSource().getLocalId();
        component.set("v.value", response);
        var navigate = component.get("v.navigateFlow");
        navigate("NEXT");
    },
    
    contactUs : function(component, event, helper) {
        var href = $A.get("$Label.c.AHFC_Contact_Us_URL");
        window.open(href,'_top');
    }, 
    
})