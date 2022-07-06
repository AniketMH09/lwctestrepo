({
  
    
    doInit : function (component, event, helper){
        window.scroll(0, 0);
        
         var url = window.location.href;
         var msg = '';
         var strContactUsLink = '';
         var strPrivacyNoticeLink = '';
        
        // Adding custom label for domain [3/01/2019]
        var hondaDomain = $A.get("$Label.c.HONDA_DOMAIN");
        var acuraDomain = $A.get("$Label.c.ACURA_DOMAIN");
        // debug stmt
       // component.set("v.strRequestType",$A.get('$Label.c.CCPA_DO_NOT_SELL'));
        
         if(url.includes(hondaDomain))
        {    
            component.set("v.communityName",'hondahelp');
        }
        else if(url.includes(acuraDomain))
        { 
             component.set("v.communityName",'acurahelp');
        }
        
        //console.log('inside doinit');
        //component.set("v.strRequestType",$A.get('$Label.c.CCPA_DELETE_INFO'));
        if (component.get("v.strRequestType") === $A.get('$Label.c.CCPA_DO_NOT_SELL')){
            msg = $A.get('$Label.c.CCPA_DNS_1ST_SCREEN');
                //component.set("v.strMessage",$A.get('$Label.c.CCPA_DNS_1ST_SCREEN'));
        }
        else if (component.get("v.strRequestType") === $A.get('$Label.c.CCPA_WHAT_INFO')){
            //component.set("v.strMessage",$A.get('$Label.c.CCPA_INFO_1ST_SCREEN'));
            msg = $A.get('$Label.c.CCPA_INFO_1ST_SCREEN');
        }
        else if (component.get("v.strRequestType") === $A.get('$Label.c.CCPA_DELETE_INFO')){
            //component.set("v.strMessage",$A.get('$Label.c.CCPA_DELETE_1ST_SCREEN'));
            msg = $A.get('$Label.c.CCPA_DELETE_1ST_SCREEN');
        }
        
        
        
     //  <aura:attribute name = "strContactUsLink" type="string" default=""/>
   // <aura:attribute name = "strPrivacyNoticeLink" type="string" default=""/>
        
        if(url.includes(hondaDomain)){
            //component.set("v.strContactUsLink", $A.get("$Label.c.AHFC_Contact_Us_URL_Honda"));
            //component.set("v.strPrivacyNoticeLink", $A.get("$Label.c.AHFC_Privacy_URL_Honda"));
            strContactUsLink = $A.get("$Label.c.AHFC_Contact_Us_URL_Honda");
            strPrivacyNoticeLink = $A.get("$Label.c.AHFC_Privacy_URL_Honda");
        }

        else {
            //component.set("v.strContactUsLink",$A.get("$Label.c.AHFC_Contact_Us_URL_Acura"));
            //component.set("v.strPrivacyNoticeLink", $A.get('$Label.c.AHFC_Privacy_URL_Acura'));
            strContactUsLink = $A.get("$Label.c.AHFC_Contact_Us_URL_Acura");
            strPrivacyNoticeLink = $A.get('$Label.c.AHFC_Privacy_URL_Acura');


        }
        
        msg = msg.replace('{!contactus}',strContactUsLink );
        msg = msg.replace('{!privacy}', strPrivacyNoticeLink);                  
        
        component.set("v.strMessage", msg);
   },
      redirectToHome : function(component,event,helper){
        
        var hondaDomain = $A.get("$Label.c.HONDA_DOMAIN");
        var acuraDomain = $A.get("$Label.c.ACURA_DOMAIN");
        
        var url = window.location.href;
        if(url.includes(hondaDomain)){
             url = $A.get("$Label.c.AHFC_Honda_URL");
        } else{
      	    url = $A.get("$Label.c.AHFC_Acura_URL");
        }
       
       window.open(url,'_top');
    },
    
    closeModel: function(component, event, helper) {
       
        component.set("v.isOpen", false);
    },
    openModel: function(component, event, helper) {
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
        var url = window.location.href;
        
        var hondaDomain = $A.get("$Label.c.HONDA_DOMAIN");
        
        if(url.includes(hondaDomain)){
            window.open($A.get("$Label.c.AHFC_Contact_Us_URL_Honda"),'_top')

        } else {
            window.open($A.get("$Label.c.AHFC_Contact_Us_URL_Acura"),'_top')
           
        }
	},
})