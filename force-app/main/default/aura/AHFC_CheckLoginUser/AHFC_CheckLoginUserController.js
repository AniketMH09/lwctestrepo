({
        doInit : function (component) {
        
        var action = component.get("c.checkLoginUser");
        action.setCallback(this, function(response) {
            var state = response.getState();
            console.log(state);
            //console.log(response.getReturnValue());
            if (state === "SUCCESS") {
                var loginUrl = response.getReturnValue();
                //window.location.href = 'https://appiriodev-hondafinance.cs23.force.com/acurahelp/s';
                window.location.href = loginUrl;
                /*var urlEvent = $A.get("e.force:navigateToURL");
                urlEvent.setParams({
                  "url": loginUrl
                });
                urlEvent.fire();*/
                //console.log('location '+window.location.href);
                //if(userProfile == 'Customer') {
                	//window.location.href = 'https://appiriodev-hondafinance.cs23.force.com/acurahelp/login';    
                //} else {
                    //window.location.href = 'https://appiriodev-hondafinance.cs23.force.com/acurahelp/s';    
                //}
            //component.set("v.usrProfile",response.getReturnValue());                    
            }
            
        });
        $A.enqueueAction(action);
        },

 })