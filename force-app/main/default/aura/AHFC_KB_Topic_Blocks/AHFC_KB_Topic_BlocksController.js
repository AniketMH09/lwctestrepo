({
    doInit : function(component, event, helper) {
    
        //var redId= component.get("v.recordId");
        var url = window.location.href;
        // Adding custom label for domain [2/27/2019]
        var hondaDomain = $A.get("$Label.c.HONDA_DOMAIN");
        var acuraDomain = $A.get("$Label.c.ACURA_DOMAIN");
        
        if(url.includes(hondaDomain))
        {
          
            component.set("v.communityName",'hondahelp');
        }
        else if(url.includes(acuraDomain))
        {
            
             component.set("v.communityName",'acurahelp');
        }
        else{
            component.set("v.communityName",'ahfchelpcenter');
        }
        
        
        
    }
	
})