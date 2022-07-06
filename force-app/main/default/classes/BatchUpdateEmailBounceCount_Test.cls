/*****************************************************
Author : Sajila Kadayaprath
Description : Test class for BatchUpdateEmailBounceCount Batch class
*****************************************************/

@isTest
private class BatchUpdateEmailBounceCount_Test{
    static testmethod void test() {
       
       /*RecordType recordType = [ select Id, Name, DeveloperName from RecordType where SObjectType = 'Account' and IsPersonType = true limit 1 ];
       Account newAccount = new Account( Salutation='Mr.', FirstName='Joe', LastName='Schmoe', RecordTypeId = recordType.id);
       insert newAccount;*/
       
       Account a=new Account();
       a.Name='Test';
       insert a;
       
       Contact c=new Contact();
       c.LastName='TestName';
       c.AccountId=a.Id;
       c.Email='test@123.com';
       insert c;

       c.EmailBouncedDate=System.Today();
       update c;

       Finance_Account__c finacc = new Finance_Account__c();
       finacc.Finance_Account_Number__c='1111';
       finacc.Honda_Brand__c='AFS';
       //finacc.Customer__c=cfa.Id;
       insert finacc;
    
       Communication_Preferences__c cPref=new Communication_Preferences__c();
       cPref.Finance_Account_Number__c=finacc.Id;
       cPref.Payment_Confirmations_via_Email__c=true;
       cPref.Payment_Reminders_via_Text__c=true;
       cPref.Payment_Confirmations_via_Text__c=true;
       cPref.EasyPay_Communications_via_Text__c =true;
       cPref.Text_Number__c='9992223334';
       cPref.Email_Address__c='test@123.com';
       cPref.Email_BounceBack_Count__c=null; 
       cPref.EmailBouncedDate__c=null;
       cPref.Customer__c=a.Id;
       insert cPref;
       
       ChargentBase__Gateway__c cbg = new ChargentBase__Gateway__c();
        cbg.Name = 'Cybersource';
       insert cbg;
       
       ChargentOrders__ChargentOrder__c ch=new ChargentOrders__ChargentOrder__c ();
        ch.Finance_Account_Number__c=finacc.Id;
        ch.Payment_Type__c = 'O';
        ch.ChargentOrders__Charge_Amount__c=5000;
        //RecordType rt = [select Id from RecordType where Name ='Standard One-Time Payment' and sObjectType = 'ChargentOrders__ChargentOrder__c']; 
        ch.RecordTypeId=Schema.SobjectType.ChargentOrders__ChargentOrder__c.getRecordTypeInfosByName().get('Recurring Payment').getRecordTypeId();
        ch.Payment_Display_Status__c='Processing';
        ch.ChargentOrders__Payment_Status__c='Recurring';
        ch.ChargentOrders__Payment_Frequency__c='Once';  
        ch.ChargentOrders__Payment_Start_Date__c=System.today();
        insert ch;
       
       Test.startTest();
       BatchUpdateEmailBounceCount bc = new BatchUpdateEmailBounceCount();
       Database.executeBatch(bc);
       Test.stopTest();
    }
}