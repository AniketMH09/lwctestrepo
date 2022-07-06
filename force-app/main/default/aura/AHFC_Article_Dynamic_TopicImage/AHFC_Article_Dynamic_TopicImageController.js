({
	doInit : function(component, event, helper) {
     
     var redId= component.get("v.recordId");
        
        var comName = window.location.href;
        
        // Adding custom label for domain [2/27/2019]
        var hondaDomain = $A.get("$Label.c.HONDA_DOMAIN");
        var acuraDomain = $A.get("$Label.c.ACURA_DOMAIN");
       
         
         if(comName.includes(hondaDomain))
        {
            component.set("v.communityName",'hondahelp');
            console.log('==honda=='+hondaDomain);
        }
        else if(comName.includes(acuraDomain))
        {
             component.set("v.communityName",'acurahelp');
             console.log('==honda=='+acuraDomain);
        }
        
        var url = window.location.href;
       
        if(url.includes('payments'))
        {
            component.set("v.TopicName",'Payments');
        }
        else if(url.includes('account-management'))
        {
             component.set("v.TopicName",'Account Management');
        }
        else if(url.includes('financing'))
        {
             component.set("v.TopicName",'Financing');
        }
        else if(url.includes('leasing'))
        {
             component.set("v.TopicName",'Leasing');
        }
        else if(url.includes('end-of-lease'))
        {
             component.set("v.TopicName",'End Of Lease');
        }
        else if(url.includes('statements'))
        {
             component.set("v.TopicName",'Statements');
        }
        else if(url.includes('service-contracts'))
        {
             component.set("v.TopicName",'Service Contracts');
        }
        else if(url.includes('credit-preapproval'))
        {
             component.set("v.TopicName",'Credit Pre-Approval');
        }
    }
})