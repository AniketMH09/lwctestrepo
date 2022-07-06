({

    doInit : function (component, event, helper){
        //debug

         window.scroll(0, 0);
         console.log(component.get("v.strCaseNumber"));
         console.log(component.get("v.strstate"));
         console.log(component.get("v.strRequestType"));
        
        
        var url = window.location.href;
        var state =  component.get("v.strstate");
        console.log(state);
        
        var msg = "";
        
        console.log("SCRA message :");
                
        msg = $A.get('$Label.c.AHFC_SCRA_Submission_Msg') ;
        msg = msg.replace('{!case}', component.get("v.strCaseNumber"));
        component.set("v.strMessage", msg);
   	    console.log(msg);
            
    },
    
    /*redirectToHomeWindow : function(component,event,helper){
        var checkUser=sessionStorage.getItem('guestUser');   
       var sacRecId=sessionStorage.getItem('salesforce_id');
          
       console.log('is guest user >>>>>>'+checkUser);
       console.log('sacRecId >>>>>>'+sacRecId);   
          
       if(checkUser=='false' && sacRecId!='undefined' && sacRecId!=null && sacRecId!=='')
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
          // window.history.back(); 
          window.location.href='https://scrawebpro-hondafinance.cs15.force.com/hondahelp/s/';
       }  
	},*/
    
    redirectToHomeWindow : function(component,event,helper){
        //@KP Nov/08 - T-747962 Cancellation return to MyAccount Page
        var url = window.location.href;
        // Adding custom label for domain [3/01/2019]
        var hondaDomain = $A.get("$Label.c.HONDA_DOMAIN");
        if(url.includes(hondaDomain)){
            console.log('New Custom Label');
            url = $A.get("$Label.c.SCRA_F_A_Q_Knowledge_Article_URL");
        } else{
            url = $A.get("$Label.c.SCRA_F_A_Q_Knowledge_Article_URL");
        } 
        window.open(url,'_top');
    },
    
    
    contactUs : function(component, event, helper) {
        
	},
    
    

})