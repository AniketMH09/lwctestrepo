({
	doInit : function(component, event, helper) {
     
     var redId= component.get("v.recordId");
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
             component.set("v.TopicName",'End of Lease');
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