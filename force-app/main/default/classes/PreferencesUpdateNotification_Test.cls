/*
Author      :  Sajila Kadayaprath
Description :  Test class for PreferencesUpdateNotification Trigger
*/
@isTest
public class PreferencesUpdateNotification_Test{
    private static TestMethod void testPreferencesUpdate(){
    
    Finance_Account__c finacc = new Finance_Account__c();
    finacc.Finance_Account_Number__c='1000001';
    finacc.Honda_Brand__c='AFS';
    insert finacc;
    
    Communication_Preferences__c cPref=new Communication_Preferences__c();
    cPref.Finance_Account_Number__c=finacc.Id;
    cPref.Payment_Confirmations_via_Email__c=true;
    cPref.Payment_Reminders_via_Text__c=true;
    cPref.Payment_Confirmations_via_Text__c=true;
    cPref.EasyPay_Communications_via_Text__c =true;
    cPref.EasyPay_Communications_via_Email__c=true;
    cPref.Payment_Reminders_via_Email__c=true;
	cPref.Account_Status_Updates_via_Email__c=true;
	cPref.Account_Status_Updates_via_Text__c=true;
    cPref.Days_Prior_Reminder__c='txt';
    cPref.Text_Number__c='9992223334';
    cPref.Is_Comm_Pref_Set__c=false;
    insert cPref;
    
    NotificationTextMsgs__c msgTemplate=new NotificationTextMsgs__c();
    msgTemplate.Name='WelcomToNotificationHonda';
    msgTemplate.MsgTemplate__c='testtemplate';
    insert msgTemplate;
    
    NotificationTextMsgs__c msgTemplate1=new NotificationTextMsgs__c();
    msgTemplate1.Name='WelcomToNotificationAcura';
    msgTemplate1.MsgTemplate__c='testtemplate';
    insert msgTemplate1;
    
    NotificationTextMsgs__c msgTemplate2=new NotificationTextMsgs__c();
    msgTemplate2.Name='UpdatedCommPrefHonda';
    msgTemplate2.MsgTemplate__c='testtemplate';
    insert msgTemplate2;
    
    NotificationTextMsgs__c msgTemplate3=new NotificationTextMsgs__c();
    msgTemplate3.Name='UpdatedCommPrefAcura';
    msgTemplate3.MsgTemplate__c='testtemplate';
    insert msgTemplate3;
    
    NotificationTextMsgs__c msgTemplate4=new NotificationTextMsgs__c();
    msgTemplate4.Name='OptOutNotificationHonda';
    msgTemplate4.MsgTemplate__c='testtemplate';
    insert msgTemplate4;
    
    NotificationTextMsgs__c msgTemplate5=new NotificationTextMsgs__c();
    msgTemplate5.Name='OptOutNotificationAcura';
    msgTemplate5.MsgTemplate__c='testtemplate';
    insert msgTemplate5;
    
    Test.startTest();
    
    cPref.Is_Comm_Pref_Set__c=true;
    cPref.Text_Number__c='9895265478';
    update cPref;
    cPref.Payment_Reminders_via_Text__c=false;
    update cPref;
    cPref.Payment_Reminders_via_Email__c=false;
    update cPref;
    cPref.Days_Prior_Reminder__c='test';
    update cPref;
    cPref.Payment_Confirmations_via_Text__c=false;
    update cPref;
    cPref.Payment_Confirmations_via_Email__c=false;
    update cPref;
    cPref.EasyPay_Communications_via_Email__c=false;
    update cPref;
    cPref.EasyPay_Communications_via_Text__c=false;
    update cPref;
	cPref.Account_Status_Updates_via_Email__c=false;
	update cPref; 
	cPref.Account_Status_Updates_via_Text__c=false;
	update cPref; 
    cPref.Paperless_Statements_Letters__c=false;
    update cPref;
    
    finacc.Honda_Brand__c='HFS';
    update finacc;
    
    cPref.Text_Number__c='9895265418';
    update cPref;
    
    Test.stopTest();
        
    }
    private static TestMethod void testPreferencesUpdate1(){
    
    Finance_Account__c finacc = new Finance_Account__c();
    finacc.Finance_Account_Number__c='1000001';
    finacc.Honda_Brand__c='HFS';
    insert finacc;
    
    Communication_Preferences__c cPref=new Communication_Preferences__c();
    cPref.Finance_Account_Number__c=finacc.Id;
    cPref.Payment_Confirmations_via_Email__c=true;
    cPref.Payment_Reminders_via_Text__c=true;
    cPref.Payment_Confirmations_via_Text__c=true;
    cPref.EasyPay_Communications_via_Text__c =true;
    cPref.EasyPay_Communications_via_Email__c=true;
	cPref.Account_Status_Updates_via_Email__c=true;
	cpref.Account_Status_Updates_via_Text__c=true;
    cPref.Payment_Reminders_via_Email__c=true;
    cPref.Days_Prior_Reminder__c='txt';
    cPref.Text_Number__c='9992223334';
    cPref.Is_Comm_Pref_Set__c=false;
    insert cPref;
    
    NotificationTextMsgs__c msgTemplate=new NotificationTextMsgs__c();
    msgTemplate.Name='WelcomToNotificationHonda';
    msgTemplate.MsgTemplate__c='testtemplate';
    insert msgTemplate;
    
    NotificationTextMsgs__c msgTemplate1=new NotificationTextMsgs__c();
    msgTemplate1.Name='WelcomToNotificationAcura';
    msgTemplate1.MsgTemplate__c='testtemplate';
    insert msgTemplate1;
    
    NotificationTextMsgs__c msgTemplate2=new NotificationTextMsgs__c();
    msgTemplate2.Name='UpdatedCommPrefHonda';
    msgTemplate2.MsgTemplate__c='testtemplate';
    insert msgTemplate2;
    
    NotificationTextMsgs__c msgTemplate3=new NotificationTextMsgs__c();
    msgTemplate3.Name='UpdatedCommPrefAcura';
    msgTemplate3.MsgTemplate__c='testtemplate';
    insert msgTemplate3;
    
    NotificationTextMsgs__c msgTemplate4=new NotificationTextMsgs__c();
    msgTemplate4.Name='OptOutNotificationHonda';
    msgTemplate4.MsgTemplate__c='testtemplate';
    insert msgTemplate4;
    
    NotificationTextMsgs__c msgTemplate5=new NotificationTextMsgs__c();
    msgTemplate5.Name='OptOutNotificationAcura';
    msgTemplate5.MsgTemplate__c='testtemplate';
    insert msgTemplate5;
    
    Test.startTest();
    
    cPref.Is_Comm_Pref_Set__c=true;
    cPref.Text_Number__c='9895265478';
    update cPref;
    cPref.Payment_Reminders_via_Text__c=false;
    update cPref;
    cPref.Payment_Reminders_via_Email__c=false;
    update cPref;
    cPref.Days_Prior_Reminder__c='test';
    update cPref;
    cPref.Payment_Confirmations_via_Text__c=false;
    update cPref;
    cPref.Payment_Confirmations_via_Email__c=false;
    update cPref;
    cPref.EasyPay_Communications_via_Email__c=false;
    update cPref;
    cPref.EasyPay_Communications_via_Text__c=false;
    update cPref;
	cPref.Account_Status_Updates_via_Email__c=false;
	update cPref;
	cPref.Account_Status_Updates_via_Text__c=false;
	update cPref;
    cPref.Paperless_Statements_Letters__c=false;
    update cPref;
    cPref.Text_Number__c='9895265418';
    update cPref;
    
    Test.stopTest();
        
    }
}