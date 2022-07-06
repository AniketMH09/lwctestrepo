/**************************************************************************
Author      :  Sajila Kadayaprath
Description :  Test class for BatchProcessReminderEmail 
*****************************************************************************/

@isTest
public class BatchProcessReminderEmail_Test{
    public static String CRON_EXP = '0 0 0 15 3 ? 2022';
    private static TestMethod void testProcessReminder(){
        Test.startTest();
        
        Account a=new Account();
        a.Name='testaccount';
        a.customer_number__c='123456789012';
        insert a;
        
        Contact c=new Contact();
        c.LastName='test';
        c.AccountId=a.Id;
        c.Email='test@gmail.com';
        insert c;
        
        Finance_Account__c finacc = new Finance_Account__c();
        finacc.Finance_Account_Number__c='123456789012';
        finacc.Next_Due_Date__c=System.Today()+2;
        finacc.Payment_Due_Date__c=System.Today()+1;
        finacc.Past_Amount_Due__c=2000;
        finacc.Payoff_Amount__c=1000;
        finacc.Total_Amount_Due__c=5000;
        finacc.Honda_Brand__c='AFS';
        finacc.Customer_Name__c='Testing Account';
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
        ch.ChargentOrders__Billing_Email__c = a.PersonEmail;
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
       
        BatchProcessReminderEmail b= new BatchProcessReminderEmail();
        Database.executeBatch(b);

        Test.stopTest();
    }
 }