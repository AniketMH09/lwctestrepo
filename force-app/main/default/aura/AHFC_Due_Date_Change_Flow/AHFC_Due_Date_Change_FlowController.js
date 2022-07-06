({
        doInit : function (component) {
        var flow = component.find("DDCFlow");
         var url = window.location.href;
         var queryString = url.substring(url.indexOf("?")+1);
            var obj = {};
            if (queryString) {
                // split our query string into its component parts
                var arr = queryString.split('&');
                console.log(arr);
                for (var i = 0; i < arr.length; i++) {
                  var aTemp = arr[i];
                  var paramName = aTemp.substring(0,aTemp.indexOf("="));
                  var paramValue = aTemp.substring(aTemp.indexOf("=")+1);
                  paramName = paramName.toLowerCase();
                  obj[paramName] = paramValue;
                }
          }
        console.log(obj.finnumber);
        var flow = component.find("DDCFlow");
        //get record ID
        var recordId =obj.finnumber;
        console.log('Account Number = ' + recordId);
        //var recordId = recordId.replace(/^0+/, '');
        component.set('v.FAid', recordId); 
        var action = component.get("c.getFinanceAccountNumber");

        action.setParams({FNumber : recordId});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log('returnValue'+response.getReturnValue());
                component.set("v.FAid",response.getReturnValue());
                console.log('realNumber:-::: '+component.get("v.FAid"));
                 var inputVariables = [
            {
                name : 'Finance_Account_Number',
                type : 'String',
                value :  component.get("v.FAid")
            }
          ];
            flow.startFlow("AHFC_Payment_Due_Date_Change_Request_Flow", inputVariables);

            }
            
        });
        $A.enqueueAction(action);
        },

 })