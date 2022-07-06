/*****************************************************
Author : Sajila Kadayaprath
Description : Test class for BatchUpdateCommunicationpreference Batch class
*****************************************************/

@isTest
private class BatchUpdateCommunicationpreference_Test {
    static testmethod void test() {
       /*RecordType recordType = [ select Id, Name, DeveloperName from RecordType where SObjectType = 'Account' and IsPersonType = true limit 1 ];
       Account newAccount = new Account( Salutation='Mr.', FirstName='Joe', LastName='Schmoe', RecordTypeId = recordType.id );
       insert newAccount;*/

       Account a=new Account();
       a.Name='test';
       insert a;
       
       Contact c=new Contact();
       c.AccountId=a.Id;
       c.LastName='tname';
       insert c;
       
       Finance_Account__c finacc = new Finance_Account__c();
       finacc.Finance_Account_Number__c='1000001';
       finacc.Honda_Brand__c='AFS';
       insert finacc;
       
       Customer_Finance_Account__c cfa= new Customer_Finance_Account__c();
       cfa.Customer__c=a.Id;
       cfa.Finance_Account__c =finacc.Id;
       insert cfa;
       
       Communication_Preferences__c cPref=new Communication_Preferences__c();
       cPref.Finance_Account_Number__c=finacc.Id;
       cPref.Payment_Confirmations_via_Email__c=true;
       cPref.Payment_Reminders_via_Text__c=true;
       cPref.Customer__c=a.Id;
       cPref.Payment_Confirmations_via_Text__c=true;
       cPref.EasyPay_Communications_via_Text__c =true;
       cPref.Email_Address__c ='test@123.com';
       cPref.Text_Number__c='(999) 999-9999';
       insert cPref;
       
       Test.startTest();
       
       BatchUpdateCommunicationpreference cp = new BatchUpdateCommunicationpreference();
       Database.executeBatch(cp);
       
       Test.stopTest();
    }
}