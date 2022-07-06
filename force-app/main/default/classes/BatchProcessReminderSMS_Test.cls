/**************************************************************************
Author      :  Sajila Kadayaprath
Description :  Test class for BatchProcessReminderSMS 
*****************************************************************************/

@isTest
public class BatchProcessReminderSMS_Test{
    public static String CRON_EXP = '0 0 0 15 3 ? 2022';
    private static TestMethod void testProcessReminder(){
        
        Account a=new Account();
        a.Name='testaccount';
        insert a;
        
        /*RecordType recordType = [ select Id, Name, DeveloperName from RecordType where SObjectType = 'Account' and IsPersonType = true limit 1 ];
        Account newAccount = new Account( Salutation='Mr.', FirstName='Joe', LastName='Schmoe', personemail='person@wmail.com',RecordTypeId = recordType.id);
        insert newAccount;*/
        
        Contact c=new Contact();
        c.LastName='test';
        c.AccountId=a.Id;
        c.Email='test@mail.com';
        insert c;
        
        Finance_Account__c finacc = new Finance_Account__c();
        finacc.Finance_Account_Number__c='2458';
        finacc.Next_Due_Date__c=System.Today()+2;
        finacc.Payment_Due_Date__c=System.Today()+1;
        finacc.Past_Amount_Due__c=2000;
        finacc.Payoff_Amount__c=1000;
        finacc.Total_Amount_Due__c=5000;
        finacc.Honda_Brand__c='AFS';
        //finacc.Customer__c=cfa.Id;
        insert finacc;
        
        Customer_Finance_Account__c cfa=new Customer_Finance_Account__c();
        cfa.Customer__c= a.Id;
        cfa.Finance_Account__c=finacc.Id;
        insert cfa;
        
        finacc.Customer__c=cfa.Id;
        update finacc;
        
        ChargentBase__Gateway__c cbg = new ChargentBase__Gateway__c();
        cbg.name = 'Cybersource';
        cbg.ChargentBase__Active__c = true;   
        insert cbg;
        
        ChargentOrders__ChargentOrder__c ch=new ChargentOrders__ChargentOrder__c ();
        ch.Finance_Account_Number__c=finacc.Id;
        ch.Payment_Type__c = 'R';
        ch.Next_Withdrawal_Date__c=System.Today()+10;
        ch.ChargentOrders__Charge_Amount__c=5000;
        //RecordType rt = [select Id from RecordType where Name ='Recurring Payment' and sObjectType = 'ChargentOrders__ChargentOrder__c']; 
        //ch.RecordTypeId=rt.Id;
        ch.ChargentOrders__Payment_Start_Date__c=System.Today();
        ch.Payment_Display_Status__c='Processing';
        //ch.Email_Account_Brand__c='HFS';
        //ch.ChargentOrders__Payment_Status__c='Recurring';
        //ch.ChargentOrders__Payment_Frequency__c='Once';
        //ch.Payment_Source_Nickname__c=payNickName;
        insert ch;
        
        Communication_Preferences__c cPref=new Communication_Preferences__c();
        cPref.Finance_Account_Number__c=finacc.Id;
        cPref.Payment_Confirmations_via_Email__c=true;
        cPref.Payment_Reminders_via_Text__c=true;
        cPref.Payment_Confirmations_via_Text__c=true;
        cPref.EasyPay_Communications_via_Text__c =true;
        cPref.Payment_Reminders_via_Email__c=true;
        cPref.Text_Number__c='(999) 999-9999' ;
        cPref.Days_Prior_Reminder__c ='1day';
        cPref.Unsubscribe_from_all__c=false;
        cPref.Customer__c=a.Id;
        cpref.Email_Address__c = 'testagent@gmail.com';
        insert cPref;
      /* Code not required due to new DSX Changes  
        NotificationTextMsgs__c  msgTemplate=new NotificationTextMsgs__c();
        msgTemplate.Name='PaymentDueHonda';
        msgTemplate.MsgTemplate__c='test';
        insert msgTemplate;
        
        NotificationTextMsgs__c  msgTemplate1=new NotificationTextMsgs__c();
        msgTemplate1.Name='PaymentDueAcura';
        msgTemplate1.MsgTemplate__c='test';
        insert msgTemplate1;
        */
        Test.startTest(); 
        BatchProcessReminderSMS p=new BatchProcessReminderSMS();
        Database.executeBatch(p); 
        String s=p.formatMobile('9995730145');
        Test.stopTest();
    }
        private static TestMethod void testProcessReminder1(){
        
        Account a=new Account();
        a.Name='testaccount';
        insert a;
        
        /*RecordType recordType = [ select Id, Name, DeveloperName from RecordType where SObjectType = 'Account' and IsPersonType = true limit 1 ];
        Account newAccount = new Account( Salutation='Mr.', FirstName='Joe', LastName='Schmoe', personemail='person@wmail.com',RecordTypeId = recordType.id);
        insert newAccount;*/
        
        Contact c=new Contact();
        c.LastName='test';
        c.AccountId=a.Id;
        c.Email='test@mail.com';
        insert c;
        
        Finance_Account__c finacc = new Finance_Account__c();
        finacc.Finance_Account_Number__c='2458';
        finacc.Next_Due_Date__c=System.Today()+2;
        finacc.Payment_Due_Date__c=System.Today()+1;
        finacc.Past_Amount_Due__c=2000;
        finacc.Payoff_Amount__c=1000;
        finacc.Total_Amount_Due__c=5000;
        finacc.Honda_Brand__c='HFS';
        //finacc.Customer__c=cfa.Id;
        insert finacc;
        
        Customer_Finance_Account__c cfa=new Customer_Finance_Account__c();
        cfa.Customer__c= a.Id;
        cfa.Finance_Account__c=finacc.Id;
        insert cfa;
        
        finacc.Customer__c=cfa.Id;
        update finacc;
        
        ChargentBase__Gateway__c cbg = new ChargentBase__Gateway__c();
        cbg.name = 'Cybersource';
        cbg.ChargentBase__Active__c = true;   
        insert cbg;
        
        ChargentOrders__ChargentOrder__c ch=new ChargentOrders__ChargentOrder__c ();
        ch.Finance_Account_Number__c=finacc.Id;
        ch.Payment_Type__c = 'R';
        ch.Next_Withdrawal_Date__c=System.Today()+10;
        ch.ChargentOrders__Charge_Amount__c=5000;
        //RecordType rt = [select Id from RecordType where Name ='Recurring Payment' and sObjectType = 'ChargentOrders__ChargentOrder__c']; 
        //ch.RecordTypeId=rt.Id;
        ch.ChargentOrders__Payment_Start_Date__c=System.Today();
        ch.Payment_Display_Status__c='Processing';
        //ch.Email_Account_Brand__c='HFS';
        //ch.ChargentOrders__Payment_Status__c='Recurring';
        //ch.ChargentOrders__Payment_Frequency__c='Once';
        //ch.Payment_Source_Nickname__c=payNickName;
        insert ch;
        
        Communication_Preferences__c cPref=new Communication_Preferences__c();
        cPref.Finance_Account_Number__c=finacc.Id;
        cPref.Payment_Confirmations_via_Email__c=true;
        cPref.Payment_Reminders_via_Text__c=true;
        cPref.Payment_Confirmations_via_Text__c=true;
        cPref.EasyPay_Communications_via_Text__c =true;
        cPref.Payment_Reminders_via_Email__c=true;
        cPref.Text_Number__c='(999) 999-9999' ;
        cPref.Days_Prior_Reminder__c ='1day';
        cPref.Unsubscribe_from_all__c=false;
        cPref.Customer__c=a.Id;
        cpref.Email_Address__c = 'testagent@gmail.com';
        insert cPref;
         String acc = cPref.Finance_Account_Number__c; 
        
       /* Due to new DSX changes this code not required  
        NotificationTextMsgs__c  msgTemplate=new NotificationTextMsgs__c();
        msgTemplate.Name='PaymentDueHonda';
        msgTemplate.MsgTemplate__c='test';
        insert msgTemplate;
        
        NotificationTextMsgs__c  msgTemplate1=new NotificationTextMsgs__c();
        msgTemplate1.Name='PaymentDueAcura';
        msgTemplate1.MsgTemplate__c='test';
        insert msgTemplate1;
        */
            
        Test.startTest(); 
        BatchProcessReminderSMS p=new BatchProcessReminderSMS();
        Database.executeBatch(p); 
        String s=p.formatMobile('9995730145');
        MC_Notification__c mcnRec=  p.insertMCNotificationForReminder(finacc.Id,1,acc.substring(acc.length()-4,acc.length()));
        insert mcnRec;
        System.assert(mcnRec.id!=null);
        Test.stopTest();
    }
}