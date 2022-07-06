/*
Author      :  Sajila Kadayaprath
Description :  Test class for CommPrefEmailNotificationTrigger
*/

@isTest
public class CommPrefEmailNotificationTrigger_Test{
    private static TestMethod void testCommPrefEmail(){
     Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
        User u = new User(Alias = 'sandt', Email='stadarduser@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='stadarduser@testorg.com');
        insert u;

        system.runAs(u)
        {
    Account a =new Account();
    a.Name='Test';
    insert a;
    
    Finance_Account__c facc = new Finance_Account__c();
    facc.Finance_Account_Number__c='24251';
    facc.Honda_Brand__c='AFS';
    facc.Fl_Suppress_All_Notifications__c=true;
    insert facc;
    
    Customer_Finance_Account__c cfa= new Customer_Finance_Account__c();
    cfa.Customer__c=a.Id;
    cfa.Finance_Account__c =facc.Id;
    insert cfa;
    
    Communication_Preferences__c cp=new Communication_Preferences__c();
    cp.Finance_Account_Number__c=facc.Id;
    cp.Payment_Confirmations_via_Email__c=true;
    cp.Payment_Reminders_via_Text__c=true;
    cp.Payment_Confirmations_via_Text__c=true;
    cp.EasyPay_Communications_via_Text__c =true;
    cp.Account_Status_Updates_via_Email__c =true;
    cp.Account_Status_Updates_via_Text__c =true;        
    cp.Text_Number__c='(999) 999-9999' ;
    cp.Is_Comm_Pref_Set__c=false;
    cp.Unsubscribe_from_all__c=false;
    cp.Email_Address__c='test@gmail.com';
    insert cp;
    
    //cp.Text_Number__c='9992222415';
    cp.Unsubscribe_from_all__c=false;
    cp.Is_Comm_Pref_Set__c=true;
    cp.Email_Address__c='test@ymail.com';
    update cp;

    facc.Fl_Suppress_All_Notifications__c=false;
    update facc;
    
    cp.Unsubscribe_from_all__c=true;
    cp.Is_Comm_Pref_Set__c=true;
    cp.Email_Address__c='test@gmail.com';
    update cp;
    
    cp.Unsubscribe_from_all__c=false;
    cp.Is_Comm_Pref_Set__c=true;
    cp.Email_Address__c='test@ymail.com';
    update cp;
    }
    }
}