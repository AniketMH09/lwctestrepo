({
    doInit : function (component) {
        
        // Find the component whose aura:id is "LeaseFlow"
        var flow = component.find("LeaseFlow");
        
        var url = window.location.href;
        //var recordId =url.substr(url.lastIndexOf('=') + 1).replace(/[^a-zA-Z0-9]/g, '');
        var recordId =url.substr(url.indexOf('=') + 1);
        console.log('someParam ' + recordId);
        component.set('v.FAid', recordId);
        var action = component.get("c.getFinanceAccountNumber");
        action.setParams({FNumber : recordId});

        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.FAid",response.getReturnValue());
                console.log('Returned Finance AccountNumber... ' + response.getReturnValue());
                 var inputVariables = [
            {
                name : 'Finance_Account_Number',
                type : 'String',
                value :  component.get("v.FAid")
            }
        ];
        
        flow.startFlow("AHFC_Lease_Extension_Flow", inputVariables);

                
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
})