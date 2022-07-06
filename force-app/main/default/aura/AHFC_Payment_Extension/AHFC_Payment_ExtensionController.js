({
    
    doInit : function (component, event, helper) {
         window.scroll(0, 0);
        
        var url = window.location.href;
        
         // Adding custom label for domain [3/01/2019]
        var hondaDomain = $A.get("$Label.c.HONDA_DOMAIN");
        var acuraDomain = $A.get("$Label.c.ACURA_DOMAIN");
        
        if(url.includes(hondaDomain))
        {
            component.set("v.communityName",'hondahelp');
        }
        else if(url.includes(acuraDomain))
        {   
             component.set("v.communityName",'acurahelp');
        }
        var PaymentAmountDecimal='';
        var n= parseFloat(component.get("v.nextPaymentAmount"));
        PaymentAmountDecimal=n.toFixed(2).toString();
        component.set('v.nextPaymentAmountDecimal', PaymentAmountDecimal);
        
       if(component.get("v.selRequestedMonths") != undefined && component.get("v.selRequestedMonths") != ''){
           component.set('v.disabled', false);
       }
       if(component.get('v.dueDate') != undefined && component.get('v.dueDate') != ''){
             var dueDate = $A.localizationService.formatDate(component.get("v.dueDate"), "MM/dd/YYYY");
             component.set('v.dueDatemdy',dueDate);
       }else{
           component.set('v.dueDatemdy','');
       }
       if(component.get('v.currentMaturityDate') != undefined && component.get('v.currentMaturityDate') != ''){
             var curMaturityDate = $A.localizationService.formatDate(component.get("v.currentMaturityDate"), "MM/dd/YYYY");
             component.set('v.maturityDate',curMaturityDate);
       }else{
           component.set('v.maturityDate','');
       }
       
       var numOfMths = $A.get("$Label.c.AHFC_PE_Mnths");
       var options = [];
       options.push({ value: "", label: "Select Term" });
        for (var i=0;i< numOfMths;i++){
            
            options.push({ value: (i+1).toString(), label: [i+1] + ' month' });
        }
        console.log(options);
       
         component.set("v.options", options);
    },
    
    //T-749443 | onChangeDate method
    onChangeDate: function (component, event, helper) {
       var extensionRate = '';
       if(component.get("v.selRequestedMonths") != undefined && component.get("v.selRequestedMonths") != ''){
        	
            if(component.get("v.extensionTaxRate") != undefined && component.get("v.extensionTaxRate") != '' && component.get("v.nextPaymentAmount") != undefined && component.get("v.nextPaymentAmount") != ''){
                var n = (parseInt(component.get("v.selRequestedMonths")) * parseFloat(component.get("v.extensionTaxRate")) * parseFloat(component.get("v.nextPaymentAmount")))/100;
                extensionRate = n.toFixed(2).toString();
            }
            component.set('v.estimatedLETax',extensionRate);
            
           
            if(component.get("v.currentMaturityDate") != undefined){
               console.log('&&&&&&&'+component.get("v.currentMaturityDate"));
               var n =  parseInt(component.get("v.selRequestedMonths"));
               var currentMd = component.get("v.currentMaturityDate");
                console.log('before calling method');
                var action = component.get("c.getNextMaturityDate");
                
                action.setParams({"currentMdate":component.get("v.currentMaturityDate"), "months":n});
                action.setCallback(this,function(response){
                    console.log('inside setCallback');
                    if(component.isValid() && response !== null && response.getState() == 'SUCCESS'){
                       
                        var objResponse = response.getReturnValue();
                        console.log('objResponse:'+objResponse);
                        var nxtMaturityDate = $A.localizationService.formatDateTimeUTC(objResponse, "MM/dd/YYYY");
                        component.set('v.nextMaturityDate',nxtMaturityDate);
                        if(component.get("v.dueDate") != undefined){
               console.log('&&&&&&&'+component.get("v.dueDate"));
               var n =  parseInt(component.get("v.selRequestedMonths"));
               var currentMd = component.get("v.dueDate");
                console.log('before calling method');
                var action = component.get("c.getNextDueDate");
                
                action.setParams({"currentMdate":component.get("v.dueDate"), "months":n});
                action.setCallback(this,function(response){
                    console.log('inside setCallback');
                    if(component.isValid() && response !== null && response.getState() == 'SUCCESS'){
                       
                        var objResponse = response.getReturnValue();
                        console.log('objResponse:'+objResponse);
                        var nxtDueDate = $A.localizationService.formatDateTimeUTC(objResponse, "MM/dd/YYYY");
                        component.set('v.nextDueDate',nxtDueDate);
                        component.set('v.disabled', false);
                        
                    }
                });
                
                $A.enqueueAction(action); 
            }
                    }
                });
                
                $A.enqueueAction(action); 
            }
           
           
       }else{
            component.set('v.disabled', true);
            component.set('v.estimatedLETax',extensionRate);
       } 
        //alert('v.estimatedLETax '+ extensionRate);
       //var newDate = new Date(curMD.substring(curMD.lastIndexOf("/")+1)+'-'+curMD.substring(0,curMD.indexOf("/"))+'-'+curMD.substring(curMD.indexOf("/")+1,curMD.lastIndexOf("/")));         
    },
    
    redirectToHome : function(component,event,helper){
        //@KP Nov/08 - T-747962 Cancellation return to MyAccount Page
       	 var url = window.location.href;
        // Adding custom label for domain [3/01/2019]
        var hondaDomain = $A.get("$Label.c.HONDA_DOMAIN");
        if(url.includes(hondaDomain)){
             url = $A.get("$Label.c.AHFC_Return_to_My_Account");
        } else{
      	    url = $A.get("$Label.c.AHFC_Return_To_My_Account_Acura");
        }
         window.open(url,'_top');
    },
    
    closeModel: function(component, event, helper) {
      // for Hide/Close Model,set the "isOpen" attribute to "Fasle"  
      component.set("v.isOpen", false);
    },
    
    openModel : function(component, event, helper) {
      // for Display Model,set the "isOpen" attribute to "true"
      component.set("v.isOpen", true);
    },
    
    handleContinue : function(component, event, helper) {
     // When an option is selected, navigate to the next screen
      var response = event.getSource().getLocalId();
      component.set("v.value", response);
      var navigate = component.get("v.navigateFlow");
      navigate("NEXT");
   },
    
   contactUs : function(component, event, helper) {
        var href = $A.get("$Label.c.AHFC_Contact_Us_URL");
        window.open(href,'_top');
	}, 
})