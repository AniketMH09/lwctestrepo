({
	initCal : function (component, event, helper){
           var action = component.get("c.getNext25Days");
           var firstDay =0;
           action.setParams({financeAccNumber:component.get("v.FANumber")});
           action.setCallback(this, function(response){
             console.log(JSON.stringify(response));
             if(component.isValid() && response !== null && response.getState() == 'SUCCESS'){
                 var finalEligibleDay = response.getReturnValue().eligibleDay;
                 var dueDate = JSON.stringify(response.getReturnValue().grtOfnextDuePaidToDate);
                 console.log('finalEligibleDay:'+JSON.stringify(finalEligibleDay));
                 console.log('dueDate:'+dueDate);
                 component.set("v.finalEligibleDay",finalEligibleDay);
                 firstDay = parseInt(dueDate.substring(dueDate.lastIndexOf("-")+1));
                 console.log('firstDay:'+firstDay);
                 console.log('typeof:'+typeof firstDay);
                 console.log('typeof:'+typeof finalEligibleDay);
                 var options = new Array();
                 options.push({value: "", label:"select a date..."});
                 for(let i=1 ; i<=31 ; i++){
                     var option = {};  
                     
                     option.value = i;
                     
                     if(i == 1|| i == 21 || i == 31){
                         option.label = i + 'st of the month';
                     }else if(i == 2  || i == 22) {
                         option.label = i + 'nd of the month';
                     }else if(i == 3 || i == 23){
                         option.label = i + 'rd of the month';  
                     }else {
                         option.label = i + 'th of the month';
                     }
                     
                     if(firstDay < finalEligibleDay){
                         if(!(i > firstDay && i <= finalEligibleDay)){
                             option.disabled = true;
                         }
                     }
                     else if( firstDay > finalEligibleDay ){
                         if( i <= firstDay && i > finalEligibleDay){
                         option.disabled = true;
                       }
                     }
                     if(i == 29 || i == 30 || i == 31){
                         option.disabled = true;
                     }
                     if((finalEligibleDay == 29 || finalEligibleDay == 30 || finalEligibleDay ==31) && i == 1) {
                         option.disabled = false;
                     }
                     if(option.disabled != true){
                         options.push(option);
                     }
                 }
                 component.set("v.calendarDateList",options);
             }
        
          });
        $A.enqueueAction(action);
    }
})