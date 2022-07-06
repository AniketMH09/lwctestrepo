/**************************************************************************
Author      :  Sajila Kadayaprath
Description :  Test class for create_Payment_Source
*****************************************************************************/

@isTest
public class create_Payment_Source_Test{
    private static TestMethod void testCreatePaymentWithErrorCase(){
    
        Finance_Account__c finacc = new Finance_Account__c();
        finacc.Finance_Account_Number__c='1111';
        finacc.Customer_Name__c='TestCustomerName';
        insert finacc;
    
        Payment_Source__c paysourcerecord = new Payment_Source__c();
        //paysourcerecord.Bank_Name__c='TestCitiBank';
        //paysourcerecord.Payment_Source_Nickname__c='TestABC';
        paysourcerecord.Bank_Account_Type__c='TestSaving';
        paysourcerecord.Preferred_Payment_Source__c=true;
        //paysourcerecord.Bank_Account_Number__c='Test1234567';
        //paysourcerecord.Finance_Account_Number__c = finacc.Id;
        paysourcerecord.Status__c='Active';
    
        ChargentBase__Gateway__c g=new ChargentBase__Gateway__c();
        insert g;
        Id gId=g.Id;
        
        Test.startTest();
        //create_Payment_Source cps=new create_Payment_Source();
    
        create_Payment_Source.create(paysourcerecord,gId);
        Test.stopTest();
      
    }
    
    private static TestMethod void testCreatePaymentWithoutErrorCase(){
    
        Finance_Account__c finacc = new Finance_Account__c();
        finacc.Finance_Account_Number__c='1111';
        finacc.Customer_Name__c='TestCustomerName';
        insert finacc;
    
        Payment_Source__c paysourcerecord = new Payment_Source__c();
        paysourcerecord.Bank_Name__c='TestCitiBank';
        paysourcerecord.Payment_Source_Nickname__c='TestABC';
        paysourcerecord.Bank_Account_Type__c='TestSaving';
        paysourcerecord.Preferred_Payment_Source__c=true;
        paysourcerecord.Bank_Account_Number__c='Test1234567';
        paysourcerecord.Finance_Account_Number__c = finacc.Id;
        paysourcerecord.Bank_Routing_Number__c ='123456';
        paysourcerecord.Billing_Street__c ='TestStreet';
        paysourcerecord.Billing_City__c ='TestCity';
        paysourcerecord.Billing_State__c ='TestState';
        paysourcerecord.Billing_Zip__c ='123478';
        paysourcerecord.Billing_Country__c ='TestCountry';
        paysourcerecord.Billing_Email__c ='test@testmail.com';
       // paysourcerecord.Billing_First_Name__c ='TestFName';
       // paysourcerecord.Billing_Last_Name__c ='TestLName';
        paysourcerecord.Currency__c ='Dollar';
        paysourcerecord.Status__c='Active';
    
        ChargentBase__Gateway__c g=new ChargentBase__Gateway__c();
        insert g;
        Id gId=g.Id;
    
        Test.startTest();
        //create_Payment_Source cps=new create_Payment_Source();
        
        create_Payment_Source.create(paysourcerecord,gId);
        Test.stopTest();
      
    }
}