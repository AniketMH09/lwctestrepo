({
  
     handleEvent : function (component,event) {
         var filterssss = event.getParam('resultData');
        alert(filterssss);
         var flow = component.find("flowData");         
         var inputVariables = [
               {
                  name : 'Finance_Account_Number',
                  type : 'Text',
                  value: "00000449905794"
               },
             {
                  name : 'LE_Eligibility_True',
                  type : 'Boolean',
                  value: True
               },
            ];         
         flow.startFlow("AHFC_Lease_Extension_Flow",inputVariables);
         

    }
    

})