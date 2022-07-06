({
        doInit : function (component) {
        
        var action = component.get("c.checkLoginUser");
            console.log('currentUrl:-==='+window.location.href);
        action.setCallback(this, function(response) {
            console.log('response==='+response);
            var state = response.getState();  
            console.log(state+'===');
            console.log('==return value=='+response.getReturnValue());
            if (state === "SUCCESS") {
                var loginUrl = response.getReturnValue();
         //This condition will be satisfied only if currentRequestURL contains HONDA_DOMAIN or ACURA_DOMAIN
                if(loginUrl != ''){
                     window.location.href = loginUrl;
                }
               
            }
            
        });
        $A.enqueueAction(action);
        },

 })