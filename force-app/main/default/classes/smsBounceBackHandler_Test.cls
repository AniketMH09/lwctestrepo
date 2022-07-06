/*****************************************************
Author : Sajila Kadayaprath
Description : Test class for smsBounceBackHandler Batch class
*****************************************************/

@isTest
private class smsBounceBackHandler_Test{
    static testmethod void test() {
       RecordType recordType = [ select Id, Name, DeveloperName from RecordType where SObjectType = 'Account' and IsPersonType = true limit 1 ];
       Account newAccount = new Account( Salutation='Mr.', FirstName='Joe', LastName='Schmoe', RecordTypeId = recordType.id );
       insert newAccount;
       
       Finance_Account__c finacc = new Finance_Account__c();
       finacc.Finance_Account_Number__c='1000001';
       finacc.Honda_Brand__c='AFS';
       insert finacc;
       
       Customer_Finance_Account__c c= new Customer_Finance_Account__c();
       c.Customer__c=newAccount.Id;
       c.Finance_Account__c =finacc.Id;
       
       Communication_Preferences__c cPref=new Communication_Preferences__c();
       cPref.Finance_Account_Number__c=finacc.Id;
       cPref.Payment_Confirmations_via_Email__c=true;
       cPref.Payment_Reminders_via_Text__c=true;
       cPref.Customer__c=newAccount.Id;
       cPref.Payment_Confirmations_via_Text__c=true;
       cPref.EasyPay_Communications_via_Text__c =true;
       cPref.Email_Address__c ='test@123.com';
       cPref.Need_To_Check_Delivery__c=true;
       cPref.last_sms_token__c='rand';
       cPref.Text_Number__c='9992223334';
       insert cPref;
       
       Test.startTest();
       smsBounceBackHandler cp = new smsBounceBackHandler();
       cp.trackingResponse='DELIVERED TO Air2Web, Successfully Sent';
       Database.executeBatch(cp);
       Test.stopTest();
    }
        static testmethod void test1() {
       RecordType recordType = [ select Id, Name, DeveloperName from RecordType where SObjectType = 'Account' and IsPersonType = true limit 1 ];
       Account newAccount = new Account( Salutation='Mr.', FirstName='Joe', LastName='Schmoe', RecordTypeId = recordType.id );
       insert newAccount;
       
       Finance_Account__c finacc = new Finance_Account__c();
       finacc.Finance_Account_Number__c='1000001';
       finacc.Honda_Brand__c='AFS';
       insert finacc;
       
       Customer_Finance_Account__c c= new Customer_Finance_Account__c();
       c.Customer__c=newAccount.Id;
       c.Finance_Account__c =finacc.Id;
       
       Communication_Preferences__c cPref=new Communication_Preferences__c();
       cPref.Finance_Account_Number__c=finacc.Id;
       cPref.Payment_Confirmations_via_Email__c=true;
       cPref.Payment_Reminders_via_Text__c=true;
       cPref.Customer__c=newAccount.Id;
       cPref.Payment_Confirmations_via_Text__c=true;
       cPref.EasyPay_Communications_via_Text__c =true;
       cPref.Email_Address__c ='test@123.com';
       cPref.Need_To_Check_Delivery__c=true;
       cPref.last_sms_token__c='rand';
       cPref.Text_Number__c='9992223334';
       insert cPref;
       
       Test.startTest();
       try{
       smsBounceBackHandler cp = new smsBounceBackHandler();
       cp.trackingResponse='DELIVERED, Successfully Sent';
       Database.executeBatch(cp);
       }
       catch(Exception e){}
       Test.stopTest();
    }
}