(   {
    
    doInit : function(component, event, helper) {
    let width = component.get("v.intWidth");
    let widthattr = "width:" + width + "%";
    component.set("v.strWidth",widthattr);
    var action = component.get("c.isContributor");
    
    action.setCallback(this, function(response){
        var state = response.getState();
        if (state === "SUCCESS") {
            component.set("v.isContributor", response.getReturnValue());
        }
    });
    $A.enqueueAction(action);
    

     
    },
 
     openEmail : function(component, event, helper) {
         var url = 'mailto:' + component.get("v.strEmail") //+ '?subject=' + component.get("v.strSubject");
         window.location.href = url;
     },
 })