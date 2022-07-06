/*({
    doInit : function (component) {
        // Find the component whose aura:id is "DDCFlow"
        var flow = component.find("DDCFlow");
        var url = window.location.href;
        var recordId =url.substr(url.lastIndexOf('=') + 1).replace(/[^a-zA-Z0-9]/g, '');
        console.log('someParam ' + recordId);
        component.set('v.FAId', recordId); //311006440
        // In that component, start your flow. Reference the flow's Unique Name.
        var inputVariables = [
            {
                name : 'Finance_Account_Number',
                type : 'String',
                value :  component.get('v.FAId')
            }
        ];
        
        flow.startFlow("AHFC_Payment_Due_Date_Change_Request_Flow", inputVariables);
    },
})*/

({
        doInit : function (component) {
        var flow = component.find("DDCFlow");debugger;
        var action = component.get("c.getFinanceAccountNumber");
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            console.log('$$$' +response.getReturnValue());
            if (state === "SUCCESS") {
                component.set("v.FAId",response.getReturnValue());

                alert('$$$' +component.get("v.FAId"));
                 var inputVariables = [
            {
                name : 'Finance_Account_Number',
                type : 'String',
                value :  component.get("v.FAId")
            }
          ];
            flow.startFlow("AHFC_Payment_Due_Date_Change_Request_Flow", inputVariables);

            }
            
        });
        $A.enqueueAction(action);
        },

 })