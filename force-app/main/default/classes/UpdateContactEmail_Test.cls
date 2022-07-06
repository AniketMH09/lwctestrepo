/********************************************************
Author      :  Sajila Kadayaprath
Description :  Test class for UpdateContactEmail 
*********************************************************/
@isTest
public class UpdateContactEmail_Test{
    private static TestMethod void testUpdateContactEmail(){
   
    Finance_Account__c finacc = new Finance_Account__c();
    finacc.Finance_Account_Number__c='1000001';
    finacc.Honda_Brand__c='AFS';
    insert finacc;
    
    RecordType recordType = [ select Id, Name, DeveloperName from RecordType where SObjectType = 'Account' and IsPersonType = true limit 1 ];
    Account newAccount = new Account( Salutation='Mr.', FirstName='Joe', LastName='Schmoe', RecordTypeId = recordType.id );
    insert newAccount;
    
    Customer_Finance_Account__c cfa=new Customer_Finance_Account__c();
    cfa.Customer__c= newAccount.Id;
    cfa.Finance_Account__c=finacc.Id;
    insert cfa;
    
    finacc.Customer__c=cfa.Id;
    update finacc;
    
    Communication_Preferences__c cPref=new Communication_Preferences__c();
    cPref.Finance_Account_Number__c=finacc.Id;
    cPref.Payment_Confirmations_via_Email__c=true;
    cPref.Payment_Reminders_via_Text__c=true;
    cPref.Customer__c=newAccount.Id;
    cPref.Payment_Confirmations_via_Text__c=true;
    cPref.EasyPay_Communications_via_Text__c =true;    
    cPref.Email_Address__c ='test@123.com';
    cPref.Text_Number__c='9992223334';
    //New DSX Parameters added
    cPref.Account_Status_Updates_via_Email__c =true; 
    cPref.Account_Status_Updates_via_Text__c =true;
    insert cPref;
    
    Test.startTest();
    cPref.IsEmailBounced__c=true;
    cPref.Email_Address__c='test@321.com';
    cPref.Text_Number__c='9992223331';
    update cPref;
    Test.stopTest();   
    }
}