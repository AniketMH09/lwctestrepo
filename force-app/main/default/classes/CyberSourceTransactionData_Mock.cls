/*

A Webservice Mock Test class for CyberSourceTransactionData
*/
@isTest
global class CyberSourceTransactionData_Mock implements WebServiceMock{

global void doInvoke(Object stub, 
                     Object request, 
                     Map<String, Object> response, 
                     String endpoint, 
                     String soapAction,
                     String requestName,
                     String responseNS,
                     String responseName,
                     String responseType) 
     {
                     
          if(request instanceof CyberSourceTransactionData.BillTo){
             CyberSourceTransactionData.BillTo  responseElement=new CyberSourceTransactionData.BillTo();
                        responseElement.firstName = 'John';
                        responseElement.lastName ='David' ;
                        responseElement.street1 = 'Teststreet1';
                        responseElement.city  = 'Testcity';
                        responseElement.state  = 'Teststate';
                        responseElement.postalCode = 'Testpincode';
                        responseElement.country = 'Testcountry';
                        responseElement.phoneNumber = '1234567';
                        responseElement.email = 'JDTestUser@accenture.com';

                       response.put('response_x', responseElement); 
         }
         else if(request instanceof CyberSourceTransactionData.Check){
          CyberSourceTransactionData.Check responseElement=new CyberSourceTransactionData.Check();
                       responseElement.accountNumber = '12345';
                       responseElement.accountType ='Savings';
                       responseElement.bankTransitNumber = '021000089';
                      response.put('response_x', responseElement);
         }
         else if(request instanceof CyberSourceTransactionData.PaySubscriptionCreateReply){
          CyberSourceTransactionData.PaySubscriptionCreateReply responseElement=new CyberSourceTransactionData.PaySubscriptionCreateReply();
                      responseElement.reasonCode = 100;
                      responseElement.subscriptionID = '332134ccscsc354341';
                      response.put('response_x', responseElement);
         }
         else if(request instanceof CyberSourceTransactionData.PaySubscriptionCreateService){
          CyberSourceTransactionData.PaySubscriptionCreateService responseElement=new CyberSourceTransactionData.PaySubscriptionCreateService();
                      responseElement.paymentRequestID = '2315';
                      responseElement.paymentRequestToken = '65465aas';
                      responseElement.disableAutoAuth = 'true';
                      responseElement.run = 'true';
                      response.put('response_x', responseElement);
         }
         else if(request instanceof CyberSourceTransactionData.PurchaseTotals){
           CyberSourceTransactionData.PaySubscriptionCreateService responseElement=new CyberSourceTransactionData.PaySubscriptionCreateService();
                      response.put('response_x', responseElement);
         }
         else if(request instanceof CyberSourceTransactionData.RecurringSubscriptionInfo){
          CyberSourceTransactionData.RecurringSubscriptionInfo responseElement=new CyberSourceTransactionData.RecurringSubscriptionInfo();
                      responseElement.frequency = 'regular';
                      response.put('response_x', responseElement);
         }
         else if(request instanceof CyberSourceTransactionData.ReplyMessage){
          CyberSourceTransactionData.RecurringSubscriptionInfo responseElement=new CyberSourceTransactionData.RecurringSubscriptionInfo();
                      response.put('response_x', responseElement);
         }
         else if(request instanceof CyberSourceTransactionData.RequestMessage){
          CyberSourceTransactionData.RequestMessage responseElement=new CyberSourceTransactionData.RequestMessage();
                      response.put('response_x', responseElement);
         }
         else if(request instanceof CyberSourceTransactionData.Security){
          CyberSourceTransactionData.Security responseElement=new CyberSourceTransactionData.Security();
                      response.put('response_x', responseElement);
         }
         else if(request instanceof CyberSourceTransactionData.Subscription){
          CyberSourceTransactionData.Subscription responseElement=new CyberSourceTransactionData.Subscription();
                      response.put('response_x', responseElement);
         }
         else if(request instanceof CyberSourceTransactionData.UsernameToken){
          CyberSourceTransactionData.UsernameToken responseElement=new CyberSourceTransactionData.UsernameToken();
                      response.put('response_x', responseElement);
         }
         else if(request instanceof CyberSourceTransactionData.portXML){
           CyberSourceTransactionData.portXML responseElement=new CyberSourceTransactionData.portXML();
                      response.put('response_x', responseElement);
         }
                     
    } // End of doInvoke Method
}