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
            component.set("v.errmsg",$A.get('$Label.c.CCPA_Honda_Err_Msg'));
        }
        else if(url.includes(acuraDomain))
        { 
             component.set("v.errmsg",$A.get('$Label.c.CCPA_Acura_Err_Msg'));
        }
        
        
   },
})