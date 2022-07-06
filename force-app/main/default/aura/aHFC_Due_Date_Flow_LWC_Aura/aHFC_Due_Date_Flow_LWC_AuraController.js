({
    handleEvent : function(component, event, helper) {
        var flow = component.find("flowData");  
        var result = event.getParam('resultData');
        var secondParam = event.getParam('secondParam');        
        var resultParse = JSON.parse(result);
        var secondParse = JSON.parse(secondParam);        
        var action = component.get("c.getFinanceAccountNumber");
        action.setParams({fNumber : resultParse.FinanceAccNo});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.FAId",response.getReturnValue());
                var faid=response.getReturnValue();
                var inputVariables = [
                    {
                        name : 'Finance_Account_Number', 
                        type : 'String',
                        value : faid
                    }                    
                ];
                if(resultParse.DueDateChange && secondParse.ddcFlowFlag)
                {
                    flow.startFlow("AHFC_DDC_Request_Flow",inputVariables);
                }
                else if(resultParse.LeaseExtension && secondParse.leflowFlag)
                {
                    flow.startFlow("AHFC_Customer_Lease_Extension_V1",inputVariables);
                }                
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