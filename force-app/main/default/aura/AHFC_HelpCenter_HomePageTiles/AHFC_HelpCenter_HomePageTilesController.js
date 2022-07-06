({
    doInit : function(component, event, helper) {
    
        //var redId= component.get("v.recordId");
        var url = window.location.href;
        // Adding custom label for domain [2/27/2019]
        var hondaDomain = $A.get("$Label.c.HONDA_DOMAIN");
        var acuraDomain = $A.get("$Label.c.ACURA_DOMAIN");
        var env = $A.get("$Label.c.Environment");
        
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
        
        //tagging code added by Aniket
        //
         var digitalData = {
        "Metadata.version_dl": '2021.12',
        "Metadata.property_name": "American Honda Finance",
        "Event_Metadata.action_type": "",
        "Event_Metadata.action_label": "",
        "Event_Metadata.action_category": "",
        "Model.model_brand": "",
        "Page.content_publish_date": "12/15/2021",
        "Page.Page_page_friendly_url": '',
        "Page.full_url": window.location.href,
        "Page.page_name": "Help Center",
        "Page.site_section": "",
        "Page.sub_section": "",
        "Page.sub_section2": "",
        "Page.sub_section3": "",
        "Page.brand_name": "",
        "Page.referrer_type": "",
        "Page.referrer_url": '',
        "Page.environment": env
    };

    
    window.dataLayer = digitalData;
    _satellite.track('PageLoadReady');
        
        
        
        
    }
	
})