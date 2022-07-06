({
    doInit : function(component, event, helper) {
		 /*RSS:48973 Changes Made by Gufran 1/28/2020*/
        /*Line Added 15,16,17,35,45  Line Removed or Commented 34,44*/
        var d=new Date();
        var n= d.getFullYear();
        var footer= '\u00A9'+n+" "+ $A.get("$Label.c.AHFC_Footer"); 
    	var action = component.get('c.getFooterLinks'); 
        // method name i.e. getFooterLinks should be same as defined in apex class
        action.setCallback(this, function(a){
            var state = a.getState(); // get the response state
            if(state == 'SUCCESS') {
                console.log(a.getReturnValue());
                if(a.getReturnValue() != null){
                     var hondaDomain = a.getReturnValue().HONDA_DOMAIN;
        			var acuraDomain = a.getReturnValue().ACURA_DOMAIN;
                    var newfooter = a.getReturnValue().AHFC_New_Footer;
                    console.log("newfooter:" + newfooter);
                    if (newfooter === 'Y'){
                        component.set("v.DisplayNew", true);
                    }
                    else {
                        component.set("v.DisplayNew", false);
                    }
                    var url = window.location.href;
                    if(url.includes(hondaDomain)){
                        component.set("v.communityName",'hondahelp');
                        component.set("v.aboutUsURL",a.getReturnValue().AHFC_About_Us_URL_Honda);
                        component.set("v.contactUsURL",a.getReturnValue().AHFC_Contact_Us_URL_Honda);
                        component.set("v.dnsURL",a.getReturnValue().AHFC_DNS_URL_Honda);
                        component.set("v.privacyURL",a.getReturnValue().AHFC_Privacy_Policy_URL_Honda);
                        component.set("v.legalTermsURL",a.getReturnValue().AHFC_Terms_And_Conditions_URL_Honda);
                        //component.set("v.FooterNotes",a.getReturnValue().AHFC_Footer);
                        component.set("v.CookiePolicyURL",$A.get('$Label.c.AHFC_Honda_COOKIE_POLICY'))
						component.set("v.FooterNotes",footer);
                    }
                    else if(url.includes(acuraDomain)){
                         component.set("v.communityName",'acurahelp');
                        component.set("v.aboutUsURL",a.getReturnValue().AHFC_About_Us_URL_Acura);
                        component.set("v.contactUsURL",a.getReturnValue().AHFC_Contact_Us_URL_Acura);
                         component.set("v.dnsURL",a.getReturnValue().AHFC_DNS_URL_Acura);
                        component.set("v.privacyURL",a.getReturnValue().AHFC_Privacy_Policy_URL_Acura);
                        component.set("v.legalTermsURL",a.getReturnValue().AHFC_Terms_And_Conditions_URL_Acura);
                        component.set("v.FooterNotes",a.getReturnValue().AHFC_Footer);
                        component.set("v.CookiePolicyURL",$A.get('$Label.c.AHFC_Acura_COOKIE_POLICY'))
                        //console.log("v.FooterNotes",a.getReturnValue().AHFC_Footer);
						component.set("v.FooterNotes",footer);
                    }
                }
            }
        });
        $A.enqueueAction(action);
    }
})