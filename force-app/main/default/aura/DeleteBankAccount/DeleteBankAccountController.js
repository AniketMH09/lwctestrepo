({
    doInit : function(component, event, helper) {
        debugger;
        var id = component.get("v.recordId");
        var msg ='Are you sure you want to cancel this bank account?';
        if (!confirm(msg)) {            
            //return false;
            $A.get("e.force:closeQuickAction").fire();
        } else {
            helper.deleteBankAccount(component, event, helper);
        }
        
        
    },
    deleteBankAccount:function(component, event, helper){
        var action = component.get("c.deleteBankAcc");
        console.log("recordId--- ",component.get("v.recordId"));
        action.setParams({ recordId : component.get("v.recordId") });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS"){
                var result=response.getReturnValue();
                console.log(result);
                if(result){
                    alert(result);
                }
                else{
                    
                }
                /*if(result=== 'Deleted'){
                 * 
                    alert("Bank account has already been deleted.");
                }else if(result === 'Active'){
                    alert("Bank account associated with pending payments cannot be deleted."); 
                }else{
                    alert('Updating...');
                }*/
            }
        });
        $A.enqueueAction(action);
    }
    
})