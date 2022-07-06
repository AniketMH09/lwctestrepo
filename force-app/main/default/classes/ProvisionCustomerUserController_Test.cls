/*******************************************************************************************************
    * @author   : Accenture
    * @date     :  10 Mar 2016
    * @modified : 14 Mar 2016 
    * @group    :  
    * @group-content : 
    * @description :TEST CLASS FOR ProvisionCustomerUserController.
    * RELATIONSHIP TO PROVISION THE USER ACCESS:  FINANCE ACCOUNT <-> CUSTOMER FINANCE ACCOUNT (JUNC OBJECT) <-> PERSON ACCOUNT - USER RECORD
    * CREATE AND PROVISION THE USER ACCESS - IF ANY ONE OR COMBINATION OF THE ABOVE RECORD IS MISSING 
********************************************************************************************************/

@isTest(seeAlldata = false)
public class ProvisionCustomerUserController_Test{
    
    private static TestMethod void testProvisionScenario1(){
        //CREATING TEST RECORDS
        Finance_Account__c finacc = new Finance_Account__c();
        finacc.Finance_Account_Number__c='1000001';
        finacc.Honda_Brand__c='AFS';
        insert finacc;
        
        //CALLING METHODS FROM THE ProvisionCustomerUserController
        Test.startTest();
            RestRequest req = new RestRequest(); 
            RestResponse res = new RestResponse();
            req.requestURI = URL.getSalesforceBaseUrl().toExternalForm()+'/services/apexrest/provisionCustomerUser';  
            req.httpMethod = 'POST';
            RestContext.request = req;
            RestContext.response= res;
            ProvisionCustomerUserController.RequestWrapper request1 = new ProvisionCustomerUserController.RequestWrapper();
            request1.userEmail = 'manoj@gmail.com';
            request1.userName = 'manoj123';
            request1.eCustomerId = '12345';
            request1.accountNumber = '1000001';
            
            ProvisionCustomerUserController.RequestWrapper request2 = new ProvisionCustomerUserController.RequestWrapper();
            request2.userEmail = 'manoj@gmail.com';
            request2.userName = 'manoj123';
            request2.eCustomerId = '454545';
            request2.accountNumber = '1000001';
            
            ProvisionCustomerUserController.ResponseWrapper ResponseIns1 = ProvisionCustomerUserController.Customerlogic(request1);
            ProvisionCustomerUserController.ResponseWrapper ResponseIns2 = ProvisionCustomerUserController.Customerlogic(request2);
            ProvisionCustomerUserController.tracePayload(request2);
        Test.stopTest();
    }
    
    


    
}