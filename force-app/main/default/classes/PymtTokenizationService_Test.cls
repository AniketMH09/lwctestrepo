/**************************************************************************
Author      :  Veeraraj Govinda
Description :  Test class for PymtTokenizationService
*****************************************************************************/

@isTest
public class PymtTokenizationService_Test{

////////////////////////////////////////////////////////Test Method1///////////////////////////////////////////////////////////////////////////

private static TestMethod void PTSMethod1(){
        Test.setMock(WebServiceMock.class , new CyberSourceTransactionData_Mock()); 
         Finance_Account__c finacc = new Finance_Account__c();
        finacc.Finance_Account_Number__c='000000129760';
        finacc.Past_Amount_Due__c= 2000;
        finacc.Customer_Name__c = 'Test Customer';
        Insert finacc;
      
        Payment_Source__c paysource = new Payment_Source__c();
        paysource.Finance_Account_Number__c = finacc.id;
        paysource.Bank_Account_Type__c='Savings';
        paysource.Status__c='Active';
        paysource.Bank_Name__c='TestCitiBank';
        paysource.Payment_Source_Nickname__c='TestABC';
        paysource.Preferred_Payment_Source__c=true;
        paysource.Bank_Account_Number__c='Test1234567';
        paysource.Bank_Routing_Number__c ='123456';
        paysource.Billing_Street__c ='TestStreet';
        paysource.Billing_City__c ='TestCity';
        paysource.Billing_State__c ='TestState';
        paysource.Billing_Zip__c ='123478';
        paysource.Billing_Country__c ='TestCountry';
        paysource.Billing_Email__c ='test@testmail.com';
        paysource.Billing_First_Name__c ='TestFName';
        paysource.Billing_Last_Name__c ='TestLName';
        paysource.Currency__c ='Dollar';
        paysource.CyBs_Customer_Id__c = finacc.Finance_Account_Number__c;
        
        Test.startTest();
        
       PymtTokenizationService.PTSResult result = PymtTokenizationService.createPS(paysource);
       PymtTokenizationService.Name namestr = PymtTokenizationService.SplitFullNAME ('veeraraj govinda');
       String str = PymtTokenizationService.TokenizationRequest(paysource);

        Test.stopTest();
      
    }

////////////////////////////////////////////////////Test Method2///////////////////////////////////////////////////////////////////////////////


private static TestMethod void PTSMethod2(){
        Test.setMock(WebServiceMock.class , new CyberSourceTransactionData_Mock()); 
         Finance_Account__c finacc = new Finance_Account__c();
        finacc.Finance_Account_Number__c= '00000132545699';
        finacc.Past_Amount_Due__c= 2000;
        finacc.Customer_Name__c = Null;
        Insert finacc;
        
        Communication_Preferences__c cPref=new Communication_Preferences__c();
        cPref.Finance_Account_Number__c=finacc.Id;
        //cPref.Customer__c=a.Id;
        cPref.Payment_Confirmations_via_Text__c = true;
        cPref.Payment_Reminders_via_Text__c=true;
        cPref.EasyPay_Communications_via_Text__c = true;
        cPref.Text_Number__c='9992223334';
        insert cPref;
      
        Payment_Source__c paysource = new Payment_Source__c();
        paysource.Finance_Account_Number__c = finacc.id;
        paysource.Bank_Account_Type__c='Checking';
        paysource.Status__c='Active';
        paysource.Bank_Name__c='TestCitiBank';
        paysource.Payment_Source_Nickname__c='TestABC';
        paysource.Preferred_Payment_Source__c=true;
        paysource.Bank_Account_Number__c='Test1234567';
        paysource.Bank_Routing_Number__c ='123456';
        paysource.Billing_Street__c ='TestStreet';
        paysource.Billing_City__c ='TestCity';
        paysource.Billing_State__c ='TestState';
        paysource.Billing_Zip__c ='123478';
        paysource.Billing_Country__c ='TestCountry';
        paysource.Billing_Email__c ='test@testmail.com';
        paysource.Billing_First_Name__c ='TestFName';
        paysource.Billing_Last_Name__c ='TestLName';
        paysource.Currency__c ='Dollar';
        paysource.CyBs_Customer_Id__c = Null;
        
        system.debug('Method2 values===>' + paysource);
        Insert paysource;
        
        Test.startTest();
        //Invoking PymtTokenizationService class
       PymtTokenizationService.PTSResult result = PymtTokenizationService.createPS(paysource);
       PymtTokenizationService.Name namestr = PymtTokenizationService.SplitFullNAME ('');
       PymtTokenizationService.Name namestr2 = PymtTokenizationService.SplitFullNAME ('john');
       String str = PymtTokenizationService.TokenizationRequest(paysource);

        Test.stopTest();

    }
    
//////////////////////////////////////////////////////Test Method3/////////////////////////////////////////////////////////////////////////////    
private static TestMethod void PTSMethod3(){

PymtTokenizationService.PTSResult wrap = new PymtTokenizationService.PTSResult('pid','token');
Payment_Source__c paysource = new Payment_Source__c();
PymtTokenizationService.PTSResult result = PymtTokenizationService.createPS(paysource);


}
    
    private static TestMethod void PTSMethod4() {
        Test.setMock(WebServiceMock.class , new CyberSourceTransactionData_Mock()); 
         Finance_Account__c finacc = new Finance_Account__c();
        finacc.Finance_Account_Number__c='00000012434560';
        finacc.Past_Amount_Due__c= 2000;
        finacc.Customer_Name__c = 'Test Customer';
        Insert finacc;
      
        Payment_Source__c paysource = new Payment_Source__c();
        paysource.Finance_Account_Number__c = finacc.id;
        paysource.Bank_Account_Type__c='Savings';
        paysource.Status__c='Active';
        paysource.Bank_Name__c='TestCitiBank';
        paysource.Payment_Source_Nickname__c='TestABC';
        paysource.Preferred_Payment_Source__c=true;
        paysource.Bank_Account_Number__c='Test1234567';
        paysource.Bank_Routing_Number__c ='123456';
        paysource.Billing_Street__c ='TestStreet';
        paysource.Billing_City__c ='TestCity';
        paysource.Billing_State__c ='TestState';
        paysource.Billing_Zip__c ='123478';
        paysource.Billing_Country__c ='TestCountry';
        paysource.Billing_Email__c ='test@testmail.com';
        paysource.Billing_First_Name__c ='TestFName';
        paysource.Billing_Last_Name__c ='TestLName';
        paysource.Currency__c ='Dollar';
        paysource.CyBs_Customer_Id__c = finacc.Finance_Account_Number__c;
        
        CyberSourceTransactionData.ReplyMessage response = new CyberSourceTransactionData.ReplyMessage();
        CyberSourceTransactionData.PaySubscriptionCreateReply subReply = new CyberSourceTransactionData.PaySubscriptionCreateReply();
        subReply.subscriptionID = '123456789';
        response.decision = 'ACCEPT';
        response.reasonCode = 100;
        response.PaySubscriptionCreateReply = subReply;
        
        Test.startTest();
        
       PymtTokenizationService.validateResponse(response, paysource);

        Test.stopTest();
    }
    
    private static TestMethod void PTSMethod5() {
        Test.setMock(WebServiceMock.class , new CyberSourceTransactionData_Mock()); 
         Finance_Account__c finacc = new Finance_Account__c();
        finacc.Finance_Account_Number__c='00000012345600';
        finacc.Past_Amount_Due__c= 2000;
        finacc.Customer_Name__c = 'Test Customer';
        Insert finacc;
      
        Payment_Source__c paysource = new Payment_Source__c();
        paysource.Finance_Account_Number__c = finacc.id;
        paysource.Bank_Account_Type__c='Savings';
        paysource.Status__c='Active';
        paysource.Bank_Name__c='TestCitiBank';
        paysource.Payment_Source_Nickname__c='TestABC';
        paysource.Preferred_Payment_Source__c=true;
        paysource.Bank_Account_Number__c='Test1234567';
        paysource.Bank_Routing_Number__c ='123456';
        paysource.Billing_Street__c ='TestStreet';
        paysource.Billing_City__c ='TestCity';
        paysource.Billing_State__c ='TestState';
        paysource.Billing_Zip__c ='123478';
        paysource.Billing_Country__c ='TestCountry';
        paysource.Billing_Email__c ='test@testmail.com';
        paysource.Billing_First_Name__c ='TestFName';
        paysource.Billing_Last_Name__c ='TestLName';
        paysource.Currency__c ='Dollar';
        paysource.CyBs_Customer_Id__c = finacc.Finance_Account_Number__c;
        
        CyberSourceTransactionData.ReplyMessage response = new CyberSourceTransactionData.ReplyMessage();
        CyberSourceTransactionData.PaySubscriptionCreateReply subReply = new CyberSourceTransactionData.PaySubscriptionCreateReply();
        response.decision = 'REJECT';
        subReply.reasonCode = 102;
        response.reasonCode = 102;
        response.invalidField = new List<String> {'c:bankTransitNumber'};
        response.PaySubscriptionCreateReply = subReply;
        
        Test.startTest();
        
       PymtTokenizationService.validateResponse(response, paysource);

        Test.stopTest();
    }


}