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
        
       
        
        if (state==='California') {
        	if (component.get("v.strRequestType") === $A.get('$Label.c.CCPA_DO_NOT_SELL'))
        	{
                console.log("in ca");
                
                msg = $A.get('$Label.c.AHFC_CCPA_CA_Submission_Msg_DNS') ;
                msg = msg.replace('{!case}', component.get("v.strCaseNumber"));
                component.set("v.strMessage", msg);
   			}
            else if (component.get("v.strRequestType") === $A.get('$Label.c.CCPA_DELETE_INFO'))
        	{
                console.log("in ca");
                msg = $A.get('$Label.c.AHFC_CCPA_CA_Submission_Msg_DMI') ;
                msg = msg.replace('{!case}', component.get("v.strCaseNumber"));
                component.set("v.strMessage", msg);
   			}
   			else if (component.get("v.strRequestType") === $A.get('$Label.c.CCPA_WHAT_INFO'))
        	{
                console.log("in ca");
                msg = $A.get('$Label.c.AHFC_CCPA_CA_Submission_Msg_WI') ;
                msg = msg.replace('{!case}', component.get("v.strCaseNumber"));
                component.set("v.strMessage", msg);
   			}
            else
          	{
                console.log("in ca");
                msg = $A.get('$Label.c.AHFC_CCPA_CA_Submission_Msg') ;
                msg = msg.replace('{!case}', component.get("v.strCaseNumber"));
                component.set("v.strMessage", msg);
          	}
        }
        else {
            if (component.get("v.strRequestType") === $A.get('$Label.c.CCPA_DO_NOT_SELL'))
        	{
                console.log("non ca");
                msg = $A.get('$Label.c.AHFC_CCPA_Non_CA_Submission_Msg_DNS') ;
                msg = msg.replace('{!case}', component.get("v.strCaseNumber"));
                component.set("v.strMessage", msg);
   			}
            else if (component.get("v.strRequestType") === $A.get('$Label.c.CCPA_DELETE_INFO'))
        	{
                console.log("non ca");
                msg = $A.get('$Label.c.AHFC_CCPA_Non_CA_Submission_Msg_DMI') ;
                msg = msg.replace('{!case}', component.get("v.strCaseNumber"));
                component.set("v.strMessage", msg);
   			}
   			else if (component.get("v.strRequestType") === $A.get('$Label.c.CCPA_WHAT_INFO'))
        	{
                console.log("non ca");
                msg = $A.get('$Label.c.AHFC_CCPA_Non_CA_Submission_Msg_WI') ;
                msg = msg.replace('{!case}', component.get("v.strCaseNumber"));
                component.set("v.strMessage", msg);
   			}
            else
            {
                console.log("non ca");
                msg = $A.get('$Label.c.AHFC_CCPA_Non_CA_Submission_Msg');
                msg = msg.replace('{!case}', component.get("v.strCaseNumber"));
                component.set("v.strMessage", msg);
            }
        }
            
    },
    
    redirectToHomeWindow : function(component,event,helper){
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
          window.location.href='https://poc.acura.americanhondafinance.com';
       }  
	},
    
    contactUs : function(component, event, helper) {
        
	},
    
    

})