({
    init : function (component) {
        // Find the component whose aura:id is "AHFC_Payment_Due_Date_Change_Request_Flow"
        var flow = component.find("AHFC_Payment_Due_Date_Change_Request_Flow");
        // In that component, start your flow. Reference the flow's Unique Name.
        flow.startFlow("myFlow");
    },
})