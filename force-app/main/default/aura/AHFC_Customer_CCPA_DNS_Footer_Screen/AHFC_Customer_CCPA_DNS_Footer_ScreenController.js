({
    
    // at the time intitalization fetch values from custom label to display messages on screen
    doInit : function (component,helper){
        window.scroll(0, 0);
        //var a = component.get('c.handleMainContentEvent');
        //$A.enqueueAction(a);
        
       if (component.get("v.strRequestType") === $A.get('$Label.c.CCPA_DO_NOT_SELL')){
            component.set("v.strMessage",$A.get('$Label.c.CCPA_DNS_1ST_SCREEN'));
        }
        else if (component.get("v.strRequestType") === $A.get('$Label.c.CCPA_WHAT_INFO')){
            component.set("v.strMessage",$A.get('$Label.c.CCPA_INFO_1ST_SCREEN'));
        }
        else if (component.get("v.strRequestType") === $A.get('$Label.c.CCPA_DELETE_INFO')){
            component.set("v.strMessage",$A.get('$Label.c.CCPA_DELETE_1ST_SCREEN'));
        }  
        
        
   },

  
       
   handleMainContentEvent : function (component, event) {
    console.log('in handleMainContentEvent.. ');
    component.find("mainContentChannel").publish();
    if (event != null) {
        const message = event.getParam('messageBody');
        const source = event.getParam('source');

       // component.set("v.receivedMessage", 'Message: ' + message + '. Sent From: ' + source);
    }
},

  /* handleMainContentEvent: function(component,event){ 
       console.log('in handleMainContentEvent.. ');
    var continueId = component.find('cont3');
    var pageRef = this.pageReference;
    var payload = {
      recordId: continueId
    };

    component.find("mainContentChannel").publish(payload);

          /*  const message = event.getParam('messageBody');
            const source = event.getParam('source');
            component.set("v.receivedMessage", 'Message: ' + message + '. Sent From: ' + source);

        var continueId = component.find('cont3');
        component.fire(pageRef, 'MainContent', continueId);*/
   // },

   // navigate to dashboard if user is looged in or navigate to prelogin page  
    redirectToHome : function(component,event){
       
       var checkUser=sessionStorage.getItem('guestUser');   
       var sacRecId=sessionStorage.getItem('salesforce_id');
       
          
       if(checkUser=='false')
       {
           
            event.preventDefault();
           
            sessionStorage.setItem('reloaded','false');
            var navService = component.find( "navService" );
            var pageReference = {
                type: "comm__namedPage",
                attributes: {
                    pageName: "dashboard"
                }
            };
            navService.navigate(pageReference);   
       } else{
           var communityUrl = window.location.href;
           var baseURL = communityUrl.substring(0, communityUrl.indexOf("/s"));
           window.location.href=baseURL;
       }   
       
      
          
    },
    
    // to close a model,set the "isOpen" attribute to "true"
    closeModel: function(component) {
       
        component.set("v.isOpen", false);
    },
    
   // for Display Model,set the "isOpen" attribute to "true"
    openModel: function(component) {
        component.set("v.isOpen", true);
        
        const scrollOptions = {
            left: 4,
            top: 2,
            behavior: "smooth"
        };
        window.scrollTo(scrollOptions);
    },
    
    //navigate to next flow screen
    handleContinue : function(component, event) {
        var response = event.getSource().getLocalId();
        component.set("v.value", response);
        var navigate = component.get("v.navigateFlow");
        navigate("NEXT");
    },
    back : function(component, event) {
       	window.history.back();
    },
   
})