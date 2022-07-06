({
    doInit : function(component, event, helper) {
     //alert('JavaScript');
     var redId= component.get("v.recordId");
        var url = window.location.href;
        
        

        var action = component.get("c.getDownloadStatus");
        action.setParams({
            faqId : component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.checked",response.getReturnValue());

            }
            else if (state === "INCOMPLETE") {
                // do something
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                 errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });

        $A.enqueueAction(action);

    },
    goToArticleDownload:function(component,event,helper){
        console.log('Enter Here');
        debugger;
        var evt = $A.get("e.force:navigateToComponent");
        console.log('evt'+evt);
        evt.setParams({
            componentDef: "c:AHFC_ArticleDownload",
            //componentAttributes :{ //your attribute}
        });
       
    evt.fire();
    }
	
})