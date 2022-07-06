({
    // load custom labels during initialization
    doInit : function (component){
        
         window.scroll(0, 0);
         var msg = '';
         var msg_part1='';
         var msg_part2='';
        
        
        if (component.get("v.strRequestType") === $A.get('$Label.c.CCPA_DO_NOT_SELL')){
            msg_part1 = $A.get('$Label.c.CCPA_Customer_DNS_Msg_Part1');
            msg_part2 = $A.get('$Label.c.CCPA_Customer_DNS_Msg_Part2');   
           
           component.set("v.ccpa_msg1",msg_part1);
           component.set("v.ccpa_msg2",msg_part2); 
           component.set("v.doNotSell",true);
            
        }
        
        else if (component.get("v.strRequestType") === $A.get('$Label.c.CCPA_WHAT_INFO')){
            msg = $A.get('$Label.c.AHFC_CCPA_INFO_1ST_SCREEN');
            
            msg_part1 = $A.get('$Label.c.AHFC_CCPA_INFO_1ST_SCREEN');
           
            component.set("v.ccpa_msg1",msg_part1);
           
            component.set("v.whatInfo",true);
           
            
        }
        
        else if (component.get("v.strRequestType") === $A.get('$Label.c.CCPA_DELETE_INFO')){
            //component.set("v.strMessage",$A.get('$Label.c.CCPA_DELETE_1ST_SCREEN'));
            msg = $A.get('$Label.c.CCPA_DELETE_1ST_SCREEN');
            msg_part1 = $A.get('$Label.c.CCPA_Customer_DI_Msg_Part1');
           
           component.set("v.ccpa_msg1",msg_part1);
            
           component.set("v.delteInfo",true);
        }
        
        component.set("v.strMessage", msg);
   },
    
  // navigate to dashboard if user is logged in otherwise navigate to pre login page  
   redirectToHome : function(component,event){
      var checkUser=sessionStorage.getItem('guestUser');   
      var sacRecId=sessionStorage.getItem('salesforce_id');
     
          
       if(checkUser=='false') // && sacRecId!='undefined' && sacRecId!=null && sacRecId!==''
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
    
    // to close modal popup set flag isOpen to false
    closeModel: function(component) {
        component.set("v.isOpen", false);
    },
    
    // to open modal popup set flag isOpen to true
    openModel: function(component) {
        component.set("v.isOpen", true);
        const scrollOptions = {
            left: 4,
            top: 2,
            behavior: "smooth"
        };
        window.scrollTo(scrollOptions);
        
    },
    
    // navigate to next flow screem
    handleContinue : function(component, event) {
        var response = event.getSource().getLocalId();
        component.set("v.value", response);
        var navigate = component.get("v.navigateFlow");
        navigate("NEXT");
    },
   
    // navigate to previous flow screen
    handlePrevious : function(component, event) {
            var response = event.getSource().getLocalId();
            component.set("v.value", response);
            var navigate = component.get("v.navigateFlow");
            navigate("BACK");
    },
    
    // navigate to contact us pre or post login page 
     contactUs : function(component, event) {
         var checkUser=sessionStorage.getItem('guestUser');  
         if(checkUser=='false')
         {
             event.preventDefault();
                var navService = component.find( "navService" );
                var pageReference = {
                    type: "comm__namedPage",
                    attributes: {
                        pageName: "contact-us-post-login"
                    }
                };
                navService.navigate(pageReference);
         }else{
               event.preventDefault();
                var navService = component.find( "navService" );
                var pageReference = {
                    type: "comm__namedPage",
                    attributes: {
                        pageName: "contact-us-pre-login"
                    }
                };
                navService.navigate(pageReference);
         }
	},
    
    navigateToPrivacyPolicy : function(component, event)
    {
        var pdfUrl=$A.get('$Resource.HFS_Privacy_Notice');
        window.open(pdfUrl,'_blank');
    }
   
})