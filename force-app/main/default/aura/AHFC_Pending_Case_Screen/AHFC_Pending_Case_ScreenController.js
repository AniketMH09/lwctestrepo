({
    doInit : function (component, event, helper){
       
       
    },
    
    redirectToHome : function(component,event,helper){
        $A.get("e.force:navigateToURL").setParams({ 
           "url": "/"
        }).fire();
    },
    
})