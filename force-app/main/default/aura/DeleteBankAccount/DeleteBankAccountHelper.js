({
	deleteBankAccount : function(component, event, helper){
		var action = component.get("c.deleteBankAcc");
        console.log("recordId--- ",component.get("v.recordId"));
        action.setParams({ recordId : component.get("v.recordId") });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS"){
                var result=response.getReturnValue();
                console.log(result);
                if(result){
                    if(result.includes('succesfully')){
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            title : 'Success',
                            message: result,
                            duration:' 5000',
                            key: 'info_alt',
                            type: 'success',
                            mode: 'pester'
                        });
        				toastEvent.fire();
                        
                        // Close the action panel
                        $A.get("e.force:closeQuickAction").fire();
                        $A.get('e.force:refreshView').fire();

                    }else{
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            title : 'Error',
                            message: result,
                            duration:' 5000',
                            key: 'info_alt',
                            type: 'error',
                            mode: 'sticky'
                        });
                        toastEvent.fire();
                        
                        // Close the action panel
                        $A.get("e.force:closeQuickAction").fire();                        
                        $A.get('e.force:refreshView').fire();

                    }
                }
                else{
                    var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            title : 'Error',
                            message: 'Some problem has occured',
                            duration:' 5000',
                            key: 'info_alt',
                            type: 'error',
                            mode: 'sticky'
                        });
                        toastEvent.fire();
                    
                    	// Close the action panel
                        $A.get("e.force:closeQuickAction").fire();
                        $A.get('e.force:refreshView').fire();

                }
                
            }
        });
        $A.enqueueAction(action);
	}
})