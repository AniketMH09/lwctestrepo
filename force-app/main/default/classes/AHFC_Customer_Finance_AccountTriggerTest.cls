@isTest
public class AHFC_Customer_Finance_AccountTriggerTest {

    @isTest static void AHFC_Customer_Finance_Account_Insert_Test()
    {
        Finance_Account__c finacc = new Finance_Account__c(Finance_Account_Number__c='123455678',Account_Type__c='Retail');
        insert finacc;
        Id finAccId = finacc.Id;
        Customer_Finance_Account__c custFinacc = new Customer_Finance_Account__c(Finance_Account__c=finAccId);
      
         Test.startTest();
         Database.SaveResult str = database.insert(custFinacc);
         System.assertEquals(True, str.isSuccess());
        Test.stopTest();
        
        
        
    }
}