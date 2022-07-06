/********************************************************************************************************************************

Author      :  Shubham Malik
Description :  Test class for PaymentTriggerHandler, BaseTriggerHandler, SMSDeliveryService & ManagePaymentService

*********************************************************************************************************************************/
@isTest
public class PaymentTriggerHandler_Test {

 
    private static String lastMethodCalled;
    
    private static PaymentTriggerHandler_Test.TestHandler pHandler;
    
  static {
    pHandler = new PaymentTriggerHandler_Test.TestHandler();
    // override its internal trigger detection
    pHandler.isTriggerExecuting = true;
     }
////////////////////////////////////////////////////////////// TEST SETUP START///////////////////////////////////////////////////////////////////////    
    
    @testSetup static void dataformethods(){
        
        Test.startTest();
        Finance_Account__c finacc = new Finance_Account__c();
        finacc.Finance_Account_Number__c='2541345678';
        finacc.Honda_Brand__c='HFS';
        finacc.Fl_Recurring_Payment_Eligible_Agent__c=true;
        finacc.Region_Code__c='BKC';
        finacc.Account_Type__c='Balloon';
        finacc.Fl_Refinanced__c=true;
        finacc.Payment_Due_Date__c=System.Today();
        finacc.Fl_Suppress_All_Notifications__c = false;
        insert finacc;
    
        Account a=new Account();
        a.Name='Test';
        insert a;
    
        Communication_Preferences__c cPref=new Communication_Preferences__c();
        cPref.Finance_Account_Number__c=finacc.Id;
        cPref.Customer__c=a.Id;
        cPref.Payment_Confirmations_via_Text__c = true;
        cPref.Payment_Reminders_via_Text__c=true;
        cPref.EasyPay_Communications_via_Text__c = true;
        cPref.Text_Number__c='9992223334';
        insert cPref;
        
        ChargentBase__Gateway__c cbg = new ChargentBase__Gateway__c();
        cbg.Name = 'Cybersource';
        insert cbg;
    
        Payment_Source__c paysourcerecord = new Payment_Source__c();
        paysourcerecord.Bank_Name__c='TestCitiBank';
        paysourcerecord.Payment_Source_Nickname__c='TestABC';
        paysourcerecord.Bank_Account_Type__c='TestSaving';
        paysourcerecord.Preferred_Payment_Source__c=true;
        paysourcerecord.Bank_Account_Number__c='Test1234567';
        paysourcerecord.Finance_Account_Number__c = finacc.Id;
        paysourcerecord.Status__c='Active';
        insert paysourcerecord;    
        
        NotificationTextMsgs__c msgTemplate=new NotificationTextMsgs__c();
        msgTemplate.Name='ScheduledPaymentAcura';
        msgTemplate.MsgTemplate__c='testtemplate';
        insert msgTemplate;
        
        NotificationTextMsgs__c msgTemplate1=new NotificationTextMsgs__c();
        msgTemplate1.Name='ModifiedPaymentAcura';
        msgTemplate1.MsgTemplate__c='testtemplate';
        insert msgTemplate1;
        
        NotificationTextMsgs__c msgTemplate2=new NotificationTextMsgs__c();
        msgTemplate2.Name='CancelledOTPHonda';
        msgTemplate2.MsgTemplate__c='testtemplate';
        insert msgTemplate2;
        
        NotificationTextMsgs__c msgTemplate3=new NotificationTextMsgs__c();
        msgTemplate3.Name='CreatedEasyPayHonda';
        msgTemplate3.MsgTemplate__c='testtemplate';
        insert msgTemplate3;
        
        NotificationTextMsgs__c msgTemplate4=new NotificationTextMsgs__c();
        msgTemplate4.Name='CancelledEasyPayHonda';
        msgTemplate4.MsgTemplate__c='testtemplate';
        insert msgTemplate4;
         
         Test.stopTest();

}


    
////////////////////////////////////////////////////////////// TEST SETUP ENDS///////////////////////////////////////////////////////////////////////    

   // contexts tests
//////////////////////////////////////////////////////////////Method 1 ///////////////////////////////////////////////////////////////////////
  @isTest
  static void testBeforeInsert() {
  string hname = '123';
    beforeInsertMode();
    pHandler.run();
    BaseTriggerHandler.bypass(hname);
    BaseTriggerHandler.clearAllBypasses();
    System.assertEquals('beforeInsert', lastMethodCalled, 'last method should be beforeInsert');
    List<ChargentOrders__ChargentOrder__c> ch2List = new List<ChargentOrders__ChargentOrder__c>();
    Map<Id,ChargentOrders__ChargentOrder__c> myMap = new Map<Id,ChargentOrders__ChargentOrder__c>();
      
        BaseTriggerHandler.isBypassed(hname);
        Finance_Account__c fin= [select id,Finance_Account_Number__c from Finance_Account__c];
        ChargentOrders__ChargentOrder__c ch=new ChargentOrders__ChargentOrder__c();
        ch.Finance_Account_Number__c=fin.Id;
        ch.Payment_Type__c = 'O';
        ch.ChargentOrders__Charge_Amount__c=5000;
        ch.ChargentOrders__Payment_Status__c='Recurring';
        ch.ChargentOrders__Payment_Frequency__c = 'Once'; 
        ch.ChargentOrders__Payment_Start_Date__c =System.today();        
        ch.Deficiency_Account__c = true;
        ch.Payment_Display_Status__c = 'Stopped';
        ch.Extracted_Payment_Count__c = 200;
        ch.RecordTypeId=Schema.SobjectType.ChargentOrders__ChargentOrder__c.getRecordTypeInfosByName().get('Recurring Payment').getRecordTypeId();
        insert ch;
        
        ch.ChargentOrders__Payment_Status__c = 'Complete';
        ch.Payment_Display_Status__c = 'Cancelled';
        ch.Duplicate_Key_Tracker__c = ch.Finance_Account_Number__r.Finance_Account_Number__c + 'Recurring_Payment' + 'INACTIVE' + Datetime.now();
        ch2List.add(ch);
        System.assertEquals(1, ch2List.size());
        update ch2List;
        ManagePaymentService.incrementPymtCount(ch);
        // beforeInsertMode();
  }

  
  //////////////////////////////////////////////////////////////Method 2 ///////////////////////////////////////////////////////////////////////
  @isTest
  static void testBeforeUpdate() {
    beforeUpdateMode();
    pHandler.run();
    string hname = '123';
    BaseTriggerHandler.bypass(hname);
    BaseTriggerHandler.clearAllBypasses();
    
    BaseTriggerHandler.isBypassed(hname);
    System.assertEquals('beforeUpdate', lastMethodCalled, 'last method should be beforeUpdate');
  }
//////////////////////////////////////////////////////////////Method 3 ///////////////////////////////////////////////////////////////////////
  @isTest
  static void testAfterInsert() {
      Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
        User u = new User(Alias = 'sandt', Email='stadarduser@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='stadarduser13@testorg.com');
        insert u;
        
        system.runAs(u)
        {
      
    BaseTriggerHandler.isUserSession=false;
    string hname = '123';
    BaseTriggerHandler.bypass(hname);
    BaseTriggerHandler.clearAllBypasses();
    
      List<ChargentOrders__ChargentOrder__c> ch1List = new List<ChargentOrders__ChargentOrder__c>();
      List<ChargentOrders__ChargentOrder__c> ch2List = new List<ChargentOrders__ChargentOrder__c>();
      Map<Id,ChargentOrders__ChargentOrder__c> myMap = new Map<Id,ChargentOrders__ChargentOrder__c>();
      BaseTriggerHandler.isBypassed(hname);
      
        Finance_Account__c fin= [select id,Finance_Account_Number__c from Finance_Account__c];
        ChargentOrders__ChargentOrder__c ch=new ChargentOrders__ChargentOrder__c();
        ch.Finance_Account_Number__c=fin.Id;
        ch.Payment_Type__c = 'O';
        ch.ChargentOrders__Charge_Amount__c=5000;
        ch.ChargentOrders__Payment_Status__c='Recurring';
        ch.ChargentOrders__Payment_Frequency__c = 'Once';  
        ch.ChargentOrders__Payment_Start_Date__c =System.today();        
        ch.Deficiency_Account__c = true;
        ch.Extracted_Payment_Count__c = Null;
        ch.Payment_Display_Status__c = 'Stopped';
        ch.RecordTypeId=Schema.SobjectType.ChargentOrders__ChargentOrder__c.getRecordTypeInfosByName().get('Recurring Payment').getRecordTypeId();
        insert ch;
        
        afterInsertMode();
            
        pHandler.run();   
        System.assertEquals('afterInsert', lastMethodCalled, 'last method should be afterInsert');
        
        ChargentOrders__ChargentOrder__c ch1=new ChargentOrders__ChargentOrder__c();
        ch1.Finance_Account_Number__c=fin.Id;
        ch1.Payment_Type__c = 'O';
        ch1.ChargentOrders__Charge_Amount__c=5000;
        ch1.ChargentOrders__Payment_Status__c='Recurring';
        ch1.ChargentOrders__Payment_Frequency__c = 'Monthly';  
        ch1.ChargentOrders__Payment_Start_Date__c =System.today();        
        ch1.Deficiency_Account__c = true;
        ch1.RecordTypeId=Schema.SobjectType.ChargentOrders__ChargentOrder__c.getRecordTypeInfosByName().get('Recurring Payment').getRecordTypeId();
        insert ch1;
      
        ch1List.add(ch1);
        myMap.put(ch1.Id,ch1);
        afterInsertMode();
        pHandler.run(); 
        ManagePaymentService.incrementPymtCount(ch);
        SMSDeliveryService.sendPymtConfBySMS(ch1List,myMap);
        System.assertEquals('afterInsert', lastMethodCalled, 'last method should be afterInsert');

        }}
 

//////////////////////////////////////////////////////////////Method 4 /////////////////////////////////////////////////////////////////////// 
  @isTest
  static void testManagePaymentService1() {
      Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
        User u = new User(Alias = 'sandt', Email='stadarduser@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='stadarduser1@testorg.com');
        insert u;
        
        system.runAs(u)
        {
           
            Integer Dt = (System.Today()-1).day();
            String s = String.valueOf(dt);
            Finance_Account__c fin= [select id,Finance_Account_Number__c from Finance_Account__c];
            ChargentOrders__ChargentOrder__c ch=new ChargentOrders__ChargentOrder__c();
            ch.Finance_Account_Number__c=fin.Id;
            ch.Payment_Type__c = 'O';
            ch.ChargentOrders__Charge_Amount__c=5000;
            ch.ChargentOrders__Payment_Status__c='Recurring';
            ch.ChargentOrders__Payment_Frequency__c = 'Monthly';              
            ch.ChargentOrders__Payment_Start_Date__c =System.today();        
            ch.Deficiency_Account__c = true;
            ch.Payment_Display_Status__c = 'Pending';
            ch.ChargentOrders__Charge_Date__c =s;
            ch.RecordTypeId=Schema.SobjectType.ChargentOrders__ChargentOrder__c.getRecordTypeInfosByName().get('Recurring Payment').getRecordTypeId();
            insert ch;
            ManagePaymentService.updateNextWithdrawalDate(ch);
        }
  }


//////////////////////////////////////////////////////////////Method 5 ///////////////////////////////////////////////////////////////////////  
    @isTest
  static void testManagePaymentService2() {
      Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
        User u = new User(Alias = 'sandt', Email='stadarduser@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='stadarduser2@testorg.com');
        insert u;
        
        system.runAs(u)
        {
            Integer Dt = (System.Today()+1).day();
            String s = String.valueOf(dt);
            Finance_Account__c fin= [select id,Finance_Account_Number__c from Finance_Account__c];
            ChargentOrders__ChargentOrder__c ch=new ChargentOrders__ChargentOrder__c();
            ch.Finance_Account_Number__c=fin.Id;
            ch.Payment_Type__c = 'O';
            ch.ChargentOrders__Charge_Amount__c=5000;
            ch.ChargentOrders__Payment_Status__c='Recurring';
            ch.ChargentOrders__Payment_Frequency__c = 'Monthly';  
            ch.ChargentOrders__Payment_Start_Date__c =System.today();
            ch.ChargentOrders__Payment_End_Date__c = System.today();
            ch.Deficiency_Account__c = true;
            ch.Payment_Display_Status__c = 'Pending';
            ch.ChargentOrders__Charge_Date__c = s;
            ch.ChargentOrders__Payment_Stop__c = 'Date';
            //ch.ChargentOrders__Charge_Date__c = '31';
            ch.RecordTypeId=Schema.SobjectType.ChargentOrders__ChargentOrder__c.getRecordTypeInfosByName().get('Recurring Payment').getRecordTypeId();
            insert ch;
            fin.FA_Next_Withdrawal_Date__c = System.Today() + 1;
            ManagePaymentService.updateNextWithdrawalDate(ch);
        }
  }
  
  
//////////////////////////////////////////////////////////////Method 6 ///////////////////////////////////////////////////////////////////////  
      @isTest
  static void testManagePaymentService3() {
      Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
        User u = new User(Alias = 'sandt', Email='stadarduser@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='stadarduser3@testorg.com');
        insert u;
        
        system.runAs(u)
        {
            Integer Dt = (System.Today()+1).day();
            String s = String.valueOf(dt);
            Finance_Account__c fin= [select id,Finance_Account_Number__c from Finance_Account__c];
            ChargentOrders__ChargentOrder__c ch=new ChargentOrders__ChargentOrder__c();
            ch.Finance_Account_Number__c=fin.Id;
            ch.Payment_Type__c = 'O';
            ch.ChargentOrders__Charge_Amount__c=5000;
            ch.ChargentOrders__Payment_Status__c='Recurring';
            ch.ChargentOrders__Payment_Frequency__c = 'Monthly';  
            ch.ChargentOrders__Payment_Start_Date__c =System.today();
            ch.ChargentOrders__Payment_End_Date__c = System.today() +2;
            ch.Deficiency_Account__c = true;
            ch.Payment_Display_Status__c = 'Pending';
             ch.ChargentOrders__Charge_Date__c = s;
            ch.ChargentOrders__Payment_Stop__c = 'Date';
            //ch.Finance_Account_Number__r.Account_Type__c='Lease';
            //ch.ChargentOrders__Charge_Date__c = '31';
            ch.RecordTypeId=Schema.SobjectType.ChargentOrders__ChargentOrder__c.getRecordTypeInfosByName().get('Recurring Payment').getRecordTypeId();
            insert ch;
            fin.FA_Next_Withdrawal_Date__c = System.Today() + 1;
            ManagePaymentService.updateNextWithdrawalDate(ch);
        }
  }
  
//////////////////////////////////////////////////////////////Method 7 ///////////////////////////////////////////////////////////////////////  
     @isTest
  static void testManagePaymentService4() {
      Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
        User u = new User(Alias = 'sandt', Email='stadarduser@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='stadarduser4@testorg.com');
        insert u;
        
        system.runAs(u)
        {
            Integer Dt = (System.Today()+1).day();
            String s = String.valueOf(dt);
            Finance_Account__c fin= [select id,Finance_Account_Number__c from Finance_Account__c];
            ChargentOrders__ChargentOrder__c ch=new ChargentOrders__ChargentOrder__c();
            ch.Finance_Account_Number__c=fin.Id;
            ch.Payment_Type__c = 'O';
            ch.ChargentOrders__Charge_Amount__c=5000;
            ch.ChargentOrders__Payment_Status__c='Recurring';
            ch.ChargentOrders__Payment_Frequency__c = 'Monthly';  
            ch.ChargentOrders__Payment_Start_Date__c =System.today();
            ch.ChargentOrders__Payment_End_Date__c = System.today();
            ch.Deficiency_Account__c = true;
            ch.Payment_Display_Status__c = 'Pending';
             ch.ChargentOrders__Charge_Date__c = s;
            ch.ChargentOrders__Payment_Stop__c = 'Count';
            ch.Extracted_Payment_Count__c = 200;
            ch.ChargentOrders__Payment_Count__c = 300;
            ch.RecordTypeId=Schema.SobjectType.ChargentOrders__ChargentOrder__c.getRecordTypeInfosByName().get('Recurring Payment').getRecordTypeId();
            insert ch;
            fin.FA_Next_Withdrawal_Date__c = System.Today() + 1;
            ManagePaymentService.updateNextWithdrawalDate(ch);
        }
  }

//////////////////////////////////////////////////////////////Method 8 ///////////////////////////////////////////////////////////////////////  
     @isTest
  static void testManagePaymentService5() {
      Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
        User u = new User(Alias = 'sandt', Email='stadarduser@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='stadarduser5@testorg.com');
        insert u;
        
        system.runAs(u)
        {
            Integer Dt = (System.Today()+1).day();
            String s = String.valueOf(dt);
            Finance_Account__c fin= [select id,Finance_Account_Number__c from Finance_Account__c];
            ChargentOrders__ChargentOrder__c ch=new ChargentOrders__ChargentOrder__c();
            ch.Finance_Account_Number__c=fin.Id;
            ch.Payment_Type__c = 'O';
            ch.ChargentOrders__Charge_Amount__c=5000;
            ch.ChargentOrders__Payment_Status__c='Recurring';
            ch.ChargentOrders__Payment_Frequency__c = 'Monthly';  
            ch.ChargentOrders__Payment_Start_Date__c =System.today();
            ch.ChargentOrders__Payment_End_Date__c = System.today();
            ch.Deficiency_Account__c = true;
            ch.Payment_Display_Status__c = 'Pending';
            ch.ChargentOrders__Charge_Date__c = s;
            ch.ChargentOrders__Payment_Stop__c = 'Count';
            ch.Extracted_Payment_Count__c = 400;
            ch.ChargentOrders__Payment_Count__c = 300;
            ch.RecordTypeId=Schema.SobjectType.ChargentOrders__ChargentOrder__c.getRecordTypeInfosByName().get('Recurring Payment').getRecordTypeId();
            insert ch;
            fin.FA_Next_Withdrawal_Date__c = System.Today() + 1;
            ManagePaymentService.updateNextWithdrawalDate(ch);
        }
  }


//////////////////////////////////////////////////////////////Method 9 ///////////////////////////////////////////////////////////////////////  
     @isTest
  static void testManagePaymentService6() {
      Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
        User u = new User(Alias = 'sandt', Email='stadarduser@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='stadarduser6@testorg.com');
        insert u;
        
        system.runAs(u)
        {
            
            Integer numberOfDays = Date.daysInMonth(Date.Today().year(), Date.Today().month()) + 1;
            String s = String.valueOf(numberOfDays);
            Finance_Account__c fin= [select id,Finance_Account_Number__c from Finance_Account__c];
            ChargentOrders__ChargentOrder__c ch=new ChargentOrders__ChargentOrder__c();
            ch.Finance_Account_Number__c=fin.Id;
            ch.Payment_Type__c = 'O';
            ch.ChargentOrders__Charge_Amount__c=5000;
            ch.ChargentOrders__Payment_Status__c='Recurring';
            ch.ChargentOrders__Payment_Frequency__c = 'Monthly';  
            ch.ChargentOrders__Payment_Start_Date__c =System.today();
            ch.ChargentOrders__Payment_End_Date__c = System.today();
            ch.Deficiency_Account__c = true;
            ch.Payment_Display_Status__c = 'Pending';
            ch.ChargentOrders__Charge_Date__c = s;
            ch.ChargentOrders__Payment_Stop__c = 'Date';
            ch.RecordTypeId=Schema.SobjectType.ChargentOrders__ChargentOrder__c.getRecordTypeInfosByName().get('Recurring Payment').getRecordTypeId();
            insert ch;
            ManagePaymentService.updateNextWithdrawalDate(ch);
        }
  }
 
 
 //////////////////////////////////////////////////////////////Method 10 /////////////////////////////////////////////////////////////////////// 
    @isTest
  static void testManagePaymentService7() {
      Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User u = new User(Alias = 'sandt', Email='stadarduser@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='stadarduser6@testorg.com');
        insert u;
        
        system.runAs(u)
        {
            
           Map<Id,ChargentOrders__ChargentOrder__c> oldMap = new Map<Id,ChargentOrders__ChargentOrder__c>();
           Map<Id,ChargentOrders__ChargentOrder__c> myMap = new Map<Id,ChargentOrders__ChargentOrder__c>(); 
            Finance_Account__c fin= [select id,Finance_Account_Number__c from Finance_Account__c];
            ChargentOrders__ChargentOrder__c ch=new ChargentOrders__ChargentOrder__c();
            ch.Finance_Account_Number__c=fin.Id;
            ch.Payment_Type__c = 'O';
            ch.ChargentOrders__Charge_Amount__c=5000;
            ch.ChargentOrders__Payment_Status__c='Recurring';
            ch.ChargentOrders__Payment_Frequency__c = 'Monthly';  
            ch.ChargentOrders__Payment_Start_Date__c =System.today();
            ch.ChargentOrders__Payment_End_Date__c = System.today();
            ch.Deficiency_Account__c = true;
            ch.Payment_Display_Status__c = 'Pending';
            ch.RecordTypeId=Schema.SobjectType.ChargentOrders__ChargentOrder__c.getRecordTypeInfosByName().get('Recurring Payment').getRecordTypeId();
            insert ch;
            
            oldMap.put(ch.Id,ch);
            ChargentOrders__ChargentOrder__c ch1 = [Select id,Finance_Account_Number__c,ChargentOrders__Payment_Status__c from ChargentOrders__ChargentOrder__c];
            ch1.ChargentOrders__Payment_End_Date__c = System.today() +1;
            ch.RecordTypeId =Schema.SobjectType.ChargentOrders__ChargentOrder__c.getRecordTypeInfosByName().get('Payoff Payment').getRecordTypeId(); 
            update ch1;
            
            myMap.put(ch1.Id, ch1);
            ManagePaymentService.beforeUpdateRulesForUsers(myMap,oldMap);
        }
  }


//////////////////////////////////////////////////////////////Method 11 ///////////////////////////////////////////////////////////////////////  
    @isTest
  static void testManagePaymentService8() {
      Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User u = new User(Alias = 'sandt', Email='stadarduser@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='stadarduser7@testorg.com');
        insert u;
        
        system.runAs(u)
        {
            
           Map<Id,ChargentOrders__ChargentOrder__c> oldMap = new Map<Id,ChargentOrders__ChargentOrder__c>();
           Map<Id,ChargentOrders__ChargentOrder__c> myMap = new Map<Id,ChargentOrders__ChargentOrder__c>(); 
            Finance_Account__c fin= [select id,Finance_Account_Number__c from Finance_Account__c];
            ChargentOrders__ChargentOrder__c ch=new ChargentOrders__ChargentOrder__c();
            ch.Finance_Account_Number__c=fin.Id;
            ch.Payment_Type__c = 'O';
            ch.ChargentOrders__Charge_Amount__c=5000;
            ch.ChargentOrders__Payment_Status__c='Recurring';
            ch.ChargentOrders__Payment_Frequency__c = 'Monthly';  
            ch.ChargentOrders__Payment_Start_Date__c =System.today();
            ch.ChargentOrders__Payment_End_Date__c = System.today();
            ch.Deficiency_Account__c = true;
            ch.Payment_Display_Status__c = 'Pending';
            ch.RecordTypeId=Schema.SobjectType.ChargentOrders__ChargentOrder__c.getRecordTypeInfosByName().get('Payoff Payment').getRecordTypeId();
            insert ch;
            
            oldMap.put(ch.Id,ch);
            ChargentOrders__ChargentOrder__c ch1 = [Select id,Finance_Account_Number__c,ChargentOrders__Charge_Amount__c from ChargentOrders__ChargentOrder__c];
            ch1.ChargentOrders__Payment_End_Date__c = System.today() +1;
            ch1.ChargentOrders__Charge_Amount__c = 6000;
            ch1.RecordTypeId =Schema.SobjectType.ChargentOrders__ChargentOrder__c.getRecordTypeInfosByName().get('Recurring Payment').getRecordTypeId(); 
            update ch1;
            
            myMap.put(ch1.Id, ch1);
            ManagePaymentService.beforeUpdateRulesForUsers(myMap,oldMap);
        }
  }
    
    
//////////////////////////////////////////////////////////////Method 12 ///////////////////////////////////////////////////////////////////////

 @isTest
static void testbeforeInsertRules() {
      Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User u = new User(Alias = 'sandt', Email='stadarduser@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='stadarduser7@testorg.com');
        insert u;
        
        system.runAs(u)
        {

List <ChargentOrders__ChargentOrder__c> ch2List = new List <ChargentOrders__ChargentOrder__c>();
//List <ChargentOrders__ChargentOrder__c> ch3List = new List <ChargentOrders__ChargentOrder__c>();
 Finance_Account__c finacc2 = new Finance_Account__c();
 finacc2.Finance_Account_Number__c='1112';
 finacc2.Honda_Brand__c = 'AFS';
 finacc2.Customer_Name__c='Testing Account';
         insert finacc2; 
         
         
  Customer_Finance_Account__c cfa=new Customer_Finance_Account__c();
        cfa.Finance_Account__c=finacc2.Id;
        insert cfa;
        
   Communication_Preferences__c cPref=new Communication_Preferences__c();      
        cPref.Finance_Account_Number__c=finacc2.Id;           
        cPref.Payment_Confirmations_via_Text__c = true;     
        cPref.Payment_Reminders_via_Text__c=true;       
        cPref.EasyPay_Communications_via_Text__c = true;        
        cPref.Text_Number__c='9992223334';      
        insert cPref;
        
        Payment_Source__c pSor2 = new Payment_Source__c();
        pSor2.Finance_Account_Number__c = finacc2.id;
        psor2.Bank_Name__c = 'CITIBank';
        psor2.Payment_Source_Nickname__c ='1111' ;
        psor2.Bank_Account_Number__c = '1230000004560001';
        psor2.Bank_Account_Type__c = 's';
        psor2.Bank_Routing_Number__c = '021000089';
        psor2.Status__c = 'Active';
        insert pSor2;
        
        
        ChargentOrders__ChargentOrder__c coco2 = new ChargentOrders__ChargentOrder__c();
        coco2.Finance_Account_Number__c = finacc2.id;
        coco2.Payment_Source_Nickname__c = psor2.id;
        coco2.Payment_Display_Status__c = 'Stopped';
        coco2.ChargentOrders__Payment_Start_Date__c = system.today();
        coco2.ChargentOrders__Charge_Amount__c = 120.00;
        coco2.ChargentOrders__Payment_Status__c = 'Recurring';
        coco2.ChargentOrders__Payment_Frequency__c = 'Once';
        coco2.Payment_Type__c = 'P';
        coco2.Duplicate_Key_Tracker__c = '';
        coco2.RecordTypeId=Schema.SobjectType.ChargentOrders__ChargentOrder__c.getRecordTypeInfosByName().get('Recurring Payment').getRecordTypeId();
          
        insert coco2;
            
        /*ChargentOrders__ChargentOrder__c coco3 = new ChargentOrders__ChargentOrder__c();
        coco3.Finance_Account_Number__c = finacc2.id;
        coco3.Payment_Source_Nickname__c = psor2.id;
        coco3.Payment_Display_Status__c = 'Pending';
        coco3.ChargentOrders__Payment_Start_Date__c = system.today();
        coco3.ChargentOrders__Charge_Amount__c = 120.00;
        coco3.ChargentOrders__Payment_Status__c = 'Complete';
        coco3.ChargentOrders__Payment_Frequency__c = 'Once';
        coco3.Payment_Type__c = 'P';
        coco3.RecordTypeId=Schema.SobjectType.ChargentOrders__ChargentOrder__c.getRecordTypeInfosByName().get('Standard One-Time Payment').getRecordTypeId();
          
        insert coco3;*/
        
       ch2List.add(coco2);
        ManagePaymentService.beforeInsertRules(ch2List);
       //ch3List.add(coco3);          
      //ManagePaymentService.beforeInsertRules(ch3List);     
            
  
  }
  }
  
//////////////////////////////////////////////////////////////Method 13 ///////////////////////////////////////////////////////////////////////    
   @isTest
  static void testAfterUpdate() {
      Profile p = [SELECT Id FROM Profile WHERE Name='iConnect Support Team']; 
        User u = new User(Alias = 'sandt', Email='stadarduser@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='stadarduser9@testorg.com');
        insert u;
        
        system.runAs(u)
        {
     BaseTriggerHandler.isUserSession=false;
     string hname = '123';
     BaseTriggerHandler.bypass(hname);
     BaseTriggerHandler.clearAllBypasses(); 
     
     List<ChargentOrders__ChargentOrder__c> ch1List = new List<ChargentOrders__ChargentOrder__c>();
     Map<Id,ChargentOrders__ChargentOrder__c> myMap = new Map<Id,ChargentOrders__ChargentOrder__c>(); 
     BaseTriggerHandler.isBypassed(hname);
     Finance_Account__c fin= [select id,Finance_Account_Number__c from Finance_Account__c];
    
            ChargentOrders__ChargentOrder__c ch=new ChargentOrders__ChargentOrder__c();
            ch.Finance_Account_Number__c=fin.Id;
            ch.Payment_Type__c = 'O';
            ch.ChargentOrders__Charge_Amount__c=5000;
            ch.ChargentOrders__Payment_Status__c='Recurring';
            ch.ChargentOrders__Payment_Frequency__c = 'Once';  
            ch.ChargentOrders__Payment_Start_Date__c =System.today();        
            ch.Deficiency_Account__c = true;
            ch.Extracted_Payment_Count__c = Null;
            ch.Payment_Display_Status__c = 'Stopped';
            ch.RecordTypeId=Schema.SobjectType.ChargentOrders__ChargentOrder__c.getRecordTypeInfosByName().get('Recurring Payment').getRecordTypeId();
            insert ch;
            afterInsertMode();
            
            pHandler.run();        
            
        ChargentOrders__ChargentOrder__c ch1=new ChargentOrders__ChargentOrder__c();
        ch1.Finance_Account_Number__c=fin.Id;
        ch1.Payment_Type__c = 'O';
        ch1.ChargentOrders__Charge_Amount__c=5000;
        ch1.ChargentOrders__Payment_Status__c='Recurring';
        ch1.ChargentOrders__Payment_Frequency__c = 'Monthly';  
        ch1.ChargentOrders__Payment_Start_Date__c =System.today();        
        ch1.Deficiency_Account__c = true;
        ch1.RecordTypeId=Schema.SobjectType.ChargentOrders__ChargentOrder__c.getRecordTypeInfosByName().get('Recurring Payment').getRecordTypeId();
        insert ch1;
        
        ch1List.add(ch1);
        myMap.put(ch1.Id,ch1);      
        
        afterInsertMode();
        pHandler.run(); 
        ManagePaymentService.incrementPymtCount(ch);
        SMSDeliveryService.sendPymtConfBySMS(ch1List,myMap);

        
        ch.Deficiency_Account__c = false;
        ch.Payment_Display_Status__c = 'Cancelled';
        ch.ChargentOrders__Charge_Amount__c=5005;
        BaseTriggerHandler BTH = new BaseTriggerHandler();
        
        BaseTriggerHandler.isUserSession=true;
        update ch;
        ch1List.add(ch);
 
 
        
        afterUpdateMode();
        //BaseTriggerHandler.isUserSession=true;      
        pHandler.run();
        update ch1List;
        

        }    
  }
/******************************************* Start Of Test Modes ***********************************************************************************/  
  // modes for testing
  private static void beforeInsertMode() {
      Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
        User u = new User(Alias = 'sandt', Email='stadarduser@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='stadarduser100@testorg.com');
        insert u;
        
        system.runAs(u)
        {
    pHandler.setTriggerContext('before insert', true);
    string hname = '123';
    BaseTriggerHandler.bypass(hname);
    BaseTriggerHandler.clearAllBypasses();
    
    BaseTriggerHandler.isBypassed(hname);
        }}

  private static void beforeUpdateMode() {
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
        User u = new User(Alias = 'sandt', Email='stadarduser@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='stadarduser11@testorg.com');
        insert u;
        
        system.runAs(u)
        {
    pHandler.setTriggerContext('before update', true);
    string hname = '123';
    BaseTriggerHandler.bypass(hname);
    BaseTriggerHandler.clearAllBypasses();
    BaseTriggerHandler.isBypassed(hname);
        } 
    }

  private static void beforeDeleteMode() {
    pHandler.setTriggerContext('before delete', true);
    string hname = '123';
    BaseTriggerHandler.bypass(hname);
    BaseTriggerHandler.clearAllBypasses();
    
 BaseTriggerHandler.isBypassed(hname);
  }

  private static void afterInsertMode() {
    pHandler.setTriggerContext('after insert', true);
        string hname = '123';
    BaseTriggerHandler.bypass(hname);
    BaseTriggerHandler.clearAllBypasses();
    
BaseTriggerHandler.isBypassed(hname);
  }

  private static void afterUpdateMode() {
    pHandler.setTriggerContext('after update', true);
        string hname = '123';
    BaseTriggerHandler BT = new BaseTriggerHandler();
    BaseTriggerHandler.setUserContext();    
    BaseTriggerHandler.bypass(hname);
    BaseTriggerHandler.clearAllBypasses();
    
BaseTriggerHandler.isBypassed(hname);
  }

  private static void afterDeleteMode() {
      
    pHandler.setTriggerContext('after delete', true);
    string hname = '123';
    BaseTriggerHandler.bypass(hname);
    BaseTriggerHandler.clearAllBypasses();
    BaseTriggerHandler.isBypassed(hname);
        }

  private static void afterUndeleteMode() {
    pHandler.setTriggerContext('after undelete', true);
    string hname = '123';
    BaseTriggerHandler.bypass(hname);
    BaseTriggerHandler.clearAllBypasses();
    BaseTriggerHandler.isBypassed(hname);
  }
  
    // test implementation of the TriggerHandler
 /******************************************* End Of Test Modes ***********************************************************************************/
 
 
 /******************************************* Start Of TestHandler extending BaseTriggerHandler  ***********************************************************************************/
  
  private class TestHandler extends BaseTriggerHandler  {

    public override void beforeInsert() {
        
      PaymentTriggerHandler_Test.lastMethodCalled = 'beforeInsert';
      string hname = '123';
      BaseTriggerHandler.bypass(hname);
      BaseTriggerHandler.clearAllBypasses();
      BaseTriggerHandler.isBypassed(hname);
    }

    public override void  beforeUpdate() {
      PaymentTriggerHandler_Test.lastMethodCalled = 'beforeUpdate';
      BaseTriggerHandler.isUserSession=false;
      string hname = '123';
      BaseTriggerHandler.bypass(hname);
      BaseTriggerHandler.clearAllBypasses();
      BaseTriggerHandler.isBypassed(hname);
    }

    public override void beforeDelete() {
        
      PaymentTriggerHandler_Test.lastMethodCalled = 'beforeDelete';
      string hname = '123';
      BaseTriggerHandler.bypass(hname);
      BaseTriggerHandler.clearAllBypasses();
    
BaseTriggerHandler.isBypassed(hname);
    }

    public override void afterInsert() {
        
      PaymentTriggerHandler_Test.lastMethodCalled = 'afterInsert';
      string hname = '123';
      BaseTriggerHandler.bypass(hname);
      BaseTriggerHandler.clearAllBypasses();
    
BaseTriggerHandler.isBypassed(hname);
    }

    public override void afterUpdate() {
      PaymentTriggerHandler_Test.lastMethodCalled = 'afterUpdate';
      string hname = '123';
      BaseTriggerHandler.bypass(hname);
      BaseTriggerHandler.clearAllBypasses();
    
BaseTriggerHandler.isBypassed(hname);
    }

    public override void afterDelete() {
      PaymentTriggerHandler_Test.lastMethodCalled = 'afterDelete';
      string hname = '123';
      BaseTriggerHandler.bypass(hname);
      BaseTriggerHandler.clearAllBypasses();
    
BaseTriggerHandler.isBypassed(hname);
    }

    public override void afterUndelete() {
      PaymentTriggerHandler_Test.lastMethodCalled = 'afterUndelete';
      string hname = '123';
      BaseTriggerHandler.bypass(hname);
      BaseTriggerHandler.clearAllBypasses();
    
BaseTriggerHandler.isBypassed(hname);
    }
}

/*********************************************End of TestHandler extending BaseTriggerHandler *******************************************************************************/

//////////////////////////////////////////////////////////////Method 14 ///////////////////////////////////////////////////////////////////////    

    // Method to cover 'sendPymtForNotestamp' method in PaymentTriggerHandler class
    @isTest
  static void sendPymtForNotestampcheck() {
   List<ChargentOrders__ChargentOrder__c> lstneworders = new List<ChargentOrders__ChargentOrder__c>();
   Map<id,ChargentOrders__ChargentOrder__c> mapoldorders = new Map<id,ChargentOrders__ChargentOrder__c>();

   PaymentTriggerHandler PTM = new PaymentTriggerHandler();
    // PTM.sendPymtForNotestamp(lstneworders,mapoldorders );
  }
  
//////////////////////////////////////////////////////////////Method 15 ///////////////////////////////////////////////////////////////////////    
  
  @isTest
  static void testmethodnew() {
   
        Finance_Account__c finacc1 = new Finance_Account__c();
        finacc1.Finance_Account_Number__c='1111';
        finacc1.Honda_Brand__c = 'HFS';
        finacc1.Customer_Name__c='Testing Account';
        finacc1.Fl_Suppress_All_Notifications__c = False;
        insert finacc1; 
                  
        Communication_Preferences__c cPref2 = new Communication_Preferences__c();
        cPref2.Finance_Account_Number__c = finacc1.id;
        cPref2.Payment_Confirmations_via_Email__c=true;
        cPref2.Payment_Reminders_via_Text__c=true;
        cPref2.Email_Address__c= 'testhnda@testorg.com';
        cPref2.EasyPay_Communications_via_Email__c= true;
        cPref2.Text_Number__c = '(999) 999-9999' ;
        cpref2.Payment_Reminders_via_Email__c = true;
        cpref2.Days_Prior_Reminder__c = '15';
        cpref2.Paperless_Statements_Letters__c = true;
        cPref2.Payment_Confirmations_via_Text__c = true; 
        cPref2.EasyPay_Communications_via_Text__c = true;
        cPref2.Payment_Profile_Updates_via_Email__c= true;
        cPref2.Statements_Letters__c = 'eDelivery';
        insert cPref2;  
            
        Payment_Source__c pSor2 = new Payment_Source__c();
        pSor2.Finance_Account_Number__c = finacc1.id;
        psor2.Bank_Name__c = 'CITIBank';
        psor2.Payment_Source_Nickname__c ='1111' ;
        psor2.Bank_Account_Number__c = '1230000004560001';
        psor2.Bank_Account_Type__c = 's';
        psor2.Bank_Routing_Number__c = '021000089';
        psor2.Status__c = 'Active';
        insert pSor2;
      
        System.assertNotEquals(Null,psor2.id);
        ChargentOrders__ChargentOrder__c coco4 = new ChargentOrders__ChargentOrder__c();
        coco4.Finance_Account_Number__c = finacc1.id;
        coco4.Payment_Source_Nickname__c = psor2.id;
        coco4.Payment_Display_Status__c = 'Pending';
        coco4.ChargentOrders__Payment_Start_Date__c = system.today();
        coco4.ChargentOrders__Charge_Amount__c = 200.00;
        coco4.Payment_Channel__c = 'W';
        coco4.ChargentOrders__Payment_Method__c = 'Credit Card';
        coco4.ChargentOrders__Payment_Frequency__c = 'Once';
        coco4.ChargentOrders__Payment_Status__c = 'Recurring';
        coco4.ChargentOrders__Payment_End_Date__c = system.today().addDays(20);
        coco4.ChargentOrders__Payment_Stop__c = 'Date' ;
        coco4.Payment_Type__c = 'H';
        insert coco4;
        
        PaymentTriggerHandler obj = new PaymentTriggerHandler();
      //  obj.initCollection();     
  }
 
//////////////////////////////////////////////////////////////Method 16 ///////////////////////////////////////////////////////////////////////    
 
    static testMethod void paymentEmailNotificationController_TestMethod(){
    
    // Setup test data
    // This code runs as the system user
       
        List <ChargentOrders__ChargentOrder__c> coco1list = new List <ChargentOrders__ChargentOrder__c> ();      
        Map <Id, ChargentOrders__ChargentOrder__c> myMap = new Map <Id, ChargentOrders__ChargentOrder__c> ();
          
        RecordType recordType = [ select Id, Name, DeveloperName from RecordType where SObjectType = 'Account' and IsPersonType = true limit 1 ];
   
        Finance_Account__c finacc1 = new Finance_Account__c();
        finacc1.Finance_Account_Number__c='1111';
        finacc1.Honda_Brand__c = 'HFS';
        finacc1.Customer_Name__c='Testing Account';
        finacc1.Fl_Suppress_All_Notifications__c = False;
        insert finacc1; 
        
        
        System.assertNotEquals(Null, finacc1.id);
       
        Customer_Finance_Account__c cfa=new Customer_Finance_Account__c();
        cfa.Finance_Account__c=finacc1.Id;
        insert cfa;
        update cfa;
        
        finacc1.Customer__c=cfa.Id;
        update finacc1;
        
        Communication_Preferences__c cPref1 = new Communication_Preferences__c();
        cPref1.Finance_Account_Number__c=finacc1.id;
        cPref1.Payment_Confirmations_via_Email__c=true;
        cPref1.Payment_Reminders_via_Text__c=true;
        cPref1.Email_Address__c= 'testhnda@testorg.com';
        cPref1.EasyPay_Communications_via_Email__c= true;
        cPref1.Text_Number__c = '(999) 999-9999' ;
        cpref1.Payment_Reminders_via_Email__c = true;
        cpref1.Days_Prior_Reminder__c = '15';
        cpref1.Paperless_Statements_Letters__c = true;
        cPref1.Payment_Confirmations_via_Text__c = true; 
        cPref1.EasyPay_Communications_via_Text__c = true;
        cPref1.Payment_Profile_Updates_via_Email__c= true;
        cPref1.Statements_Letters__c = 'eDelivery';
        
        insert cPref1;
       
        Payment_Source__c psor1 = new Payment_Source__c();
        psor1.Finance_Account_Number__c = finacc1.id; 
        psor1.Bank_Name__c = 'CITIBank';
        psor1.Payment_Source_Nickname__c ='1111' ;
        psor1.Bank_Account_Number__c = '1230000004560001';
        psor1.Bank_Account_Type__c = 's';
        psor1.Bank_Routing_Number__c = '021000089';
        psor1.Status__c = 'Active';
        
        insert psor1; 
        System.assertNotEquals(Null,psor1.id);
        
        ChargentBase__Gateway__c cbg = new ChargentBase__Gateway__c();
        cbg.Name = 'Cybersource';
        insert cbg;
      
        //Creating List of ChargentOrders__ChargentOrder__c records
        ChargentOrders__ChargentOrder__c coco1 = new ChargentOrders__ChargentOrder__c();
        coco1.Finance_Account_Number__c = finacc1.id;
        coco1.Payment_Source_Nickname__c = psor1.id;
        coco1.Payment_Display_Status__c = 'Pending';
        coco1.ChargentOrders__Payment_Start_Date__c = system.today();
        coco1.ChargentOrders__Charge_Amount__c = 200.00;
        coco1.Payment_Channel__c = 'W';
        coco1.ChargentOrders__Payment_Method__c = 'Credit Card';
        coco1.ChargentOrders__Payment_Frequency__c = 'Once';
        coco1.ChargentOrders__Payment_Status__c = 'Recurring';
        coco1.ChargentOrders__Payment_End_Date__c = system.today().addDays(20);
        coco1.ChargentOrders__Payment_Stop__c = 'Date' ;
        coco1.Payment_Type__c = 'H';
       
        insert coco1;
       
        mymap.put(coco1.Id, coco1);
        coco1.ChargentOrders__Charge_Amount__c = 300.00 ;
        coco1.Payment_Display_Status__c ='Pending';
        update coco1;
            
        afterUpdateMode();      
        pHandler.run();      

        }
 //////////////////////////////////////////////////////////////Method 17 ///////////////////////////////////////////////////////////////////////          
 
  static testMethod void paymentEmailNotificationController_TestMethod1(){
    
    // Setup test data
    // This code runs as the system user
       
      Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
        User u = new User(Alias = 'sandt', Email='stadarduser@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='stadarduser12@testorg.com');
        insert u;
        
        system.runAs(u)
        {
        List <ChargentOrders__ChargentOrder__c> coco1list = new List <ChargentOrders__ChargentOrder__c> ();
        Map <Id, ChargentOrders__ChargentOrder__c> myMap = new Map <Id, ChargentOrders__ChargentOrder__c> ();
        RecordType recordType = [ select Id, Name, DeveloperName from RecordType where SObjectType = 'Account' and IsPersonType = true limit 1 ];

        Finance_Account__c finacc2 = new Finance_Account__c();
        finacc2.Finance_Account_Number__c='1112';
        finacc2.Honda_Brand__c = 'HFS';
        finacc2.Customer_Name__c='Testing Account';
        finacc2.Fl_Suppress_All_Notifications__c = False;
        insert finacc2; 
        update finacc2;
        
        System.assertNotEquals(Null, finacc2.id);
        
        Customer_Finance_Account__c cfa=new Customer_Finance_Account__c();
        cfa.Finance_Account__c=finacc2.Id;
        insert cfa;
        
        finacc2.Customer__c=cfa.Id;
        update finacc2;
        
        Communication_Preferences__c cPref2 = new Communication_Preferences__c();
        cPref2.Finance_Account_Number__c=finacc2.id;
        cPref2.Payment_Confirmations_via_Email__c=true;
        cPref2.Payment_Reminders_via_Text__c=true;
        cPref2.Email_Address__c= 'testhonda@testorg.com';
        cPref2.EasyPay_Communications_via_Email__c= true;
        cPref2.Text_Number__c = '(999) 999-9999' ;
        cpref2.Unsubscribe_from_all__c = true;
        cpref2.IsEmailBounced__c=true;
        cpref2.Payment_Reminders_via_Email__c = true;
        cpref2.Days_Prior_Reminder__c = '15';
        cpref2.Paperless_Statements_Letters__c = true;
        cPref2.Payment_Confirmations_via_Text__c = true; 
        cPref2.EasyPay_Communications_via_Text__c = true;
        cPref2.Payment_Profile_Updates_via_Email__c= true;
        cPref2.Statements_Letters__c = 'eDelivery';

        insert cPref2;
    
        //Creating Payment_Source__c records
        Payment_Source__c psor2 = new Payment_Source__c();
        psor2.Finance_Account_Number__c = finacc2.id; 
        psor2.Bank_Name__c = 'CITIBank';
        psor2.Payment_Source_Nickname__c ='1112' ;
        psor2.Bank_Account_Number__c = '1230000004560002';
        psor2.Bank_Account_Type__c = 'K';
        psor2.Bank_Routing_Number__c = '021000089';
        psor2.Status__c = 'Active';
        
        insert psor2; 
        System.assertNotEquals(Null,psor2.id);
        
        ChargentBase__Gateway__c cbg = new ChargentBase__Gateway__c();
        cbg.Name = 'Cybersource';
        insert cbg;
        
        //Creating List of ChargentOrders__ChargentOrder__c records
        ChargentOrders__ChargentOrder__c coco2 = new ChargentOrders__ChargentOrder__c();
        coco2.Finance_Account_Number__c = finacc2.id;
        coco2.Payment_Source_Nickname__c = psor2.id;
        coco2.Payment_Display_Status__c = 'Pending';
        coco2.ChargentOrders__Payment_Start_Date__c = system.today();
        coco2.ChargentOrders__Charge_Amount__c = 120.00;
        coco2.ChargentOrders__Payment_Status__c = 'Stopped';
        coco2.ChargentOrders__Payment_Frequency__c = 'Monthly';
        coco2.Payment_Type__c = 'O';
        insert coco2;
        
        myMap.put(coco2.Id, coco2);
        
        coco2.ChargentOrders__Payment_Frequency__c = 'Once';
        coco2.ChargentOrders__Charge_Amount__c = 150.00;
        update coco2;
            
        String operation; 
        coco1list.add(coco2);   
        
        try{ 
          System.debug('CCOCO1List' +coco1list);
          System.debug('MYMAP' +myMap);
           EmailDeliveryService.sendPymtEmailConfirmation(coco1list,myMap,'Update');
        }catch(Exception e){}
        
              
        }}
        
      
//////////////////////////////////////////////////////////////Method 18 ///////////////////////////////////////////////////////////////////////    
    
    static testMethod void paymentEmailNotificationController_TestMethod3(){
            try{
        // Setup test data
        // This code runs as the system user
       
        List <ChargentOrders__ChargentOrder__c> coco3list = new List <ChargentOrders__ChargentOrder__c> ();
        Map <Id, ChargentOrders__ChargentOrder__c> myMap = new Map <Id, ChargentOrders__ChargentOrder__c> ();
        RecordType recordType = [ select Id, Name, DeveloperName from RecordType where SObjectType = 'Account' and IsPersonType = true limit 1 ];

        Finance_Account__c finacc3 = new Finance_Account__c();
        finacc3.Finance_Account_Number__c='1112';
        finacc3.Honda_Brand__c = 'HFS';
        finacc3.Customer_Name__c='Testing Account';
        
        insert finacc3;

        System.assertNotEquals(Null, finacc3.id);
       
        Payment_Source__c psor3 = new Payment_Source__c();
        psor3.Finance_Account_Number__c = finacc3.id; 
        psor3.Bank_Name__c = 'CITIBank';
        psor3.Payment_Source_Nickname__c ='1112' ;
        psor3.Bank_Account_Number__c = '1230000004560002';
        psor3.Bank_Account_Type__c = 'K';
        psor3.Bank_Routing_Number__c = '021000089';
        psor3.Status__c = 'Active';
        
        insert psor3; 
        System.assertNotEquals(Null,psor3.id);
        
        ChargentOrders__ChargentOrder__c coco3 = new ChargentOrders__ChargentOrder__c();
        coco3.RecordTypeId=Schema.SobjectType.ChargentOrders__ChargentOrder__c.getRecordTypeInfosByName().get('Payoff Payment').getRecordTypeId();
        coco3.Finance_Account_Number__c = finacc3.id;
        coco3.Payment_Source_Nickname__c = psor3.id;
        coco3.Payment_Display_Status__c = 'Cancelled';
        coco3.ChargentOrders__Payment_Start_Date__c = system.today();
        coco3.ChargentOrders__Charge_Amount__c = 150.00;
        coco3.Monthly_Payment_Amount__c = 100;
        coco3.ChargentOrders__Charge_Date__c = '10';
        coco3.Extracted_Payment_Count__c = 2.0;
        coco3.ChargentOrders__Payment_Count__c = 2.0;
        coco3.ChargentOrders__Payment_Status__c = 'Stopped';
        coco3.ChargentOrders__Payment_Frequency__c = 'Monthly';
        coco3.Payment_Type__c = 'O';
      //  coco3.Communication_Preference__c=cPref3.id;
   
        insert coco3;
        
        
         
        update coco3;
         
        // mymap.put(coco3.Id, coco3);
        PaymentTriggerHandler obj = new PaymentTriggerHandler();
      Test.startTest();
      system.debug('===> finacc3 ' + finacc3 );
      system.debug('===> psor3' + psor3);
       system.debug('===> coco3' + coco3);
                //  obj.initCollection();  
 
      Test.stopTest();            
           
        }catch(Exception e){ 
          //system.debug("Enterd into Catch');
          }
    }
    
    
    //////////////////////////////////////////////////////////////Method 19 ///////////////////////////////////////////////////////////////////////    
    
    static testMethod void paymentEmailNotificationController_TestMethod2(){
    
    // Setup test data  
    // This code runs as the system user
        
        List <ChargentOrders__ChargentOrder__c> coco1list = new List <ChargentOrders__ChargentOrder__c> ();
        Map <Id, ChargentOrders__ChargentOrder__c> myMap = new Map <Id, ChargentOrders__ChargentOrder__c> ();
        RecordType recordType = [ select Id, Name, DeveloperName from RecordType where SObjectType = 'Account' and IsPersonType = true limit 1 ];
    //   Account newAccount = new Account( Salutation='Mr.', FirstName='Joe', LastName='Schmoe',Personemail='testhnda@testorg.com', Customer_Number__c='1234', RecordTypeId = recordType.id);
    //  insert newAccount;
        
        Finance_Account__c finacc2 = new Finance_Account__c();
        finacc2.Finance_Account_Number__c='1112';
        finacc2.Honda_Brand__c = 'AFS';
        finacc2.Customer_Name__c='Testing Account';
        insert finacc2; 
        update finacc2;
        
        System.assertNotEquals(Null, finacc2.id);
        
        Customer_Finance_Account__c cfa=new Customer_Finance_Account__c();
        cfa.Finance_Account__c=finacc2.Id;
        insert cfa;
        
        finacc2.Customer__c=cfa.Id;
        update finacc2;
        
        Communication_Preferences__c cPref2 = new Communication_Preferences__c();
        cPref2.Finance_Account_Number__c=finacc2.id;
        cPref2.Payment_Confirmations_via_Email__c=true;
        cPref2.Payment_Reminders_via_Text__c=true;
        cPref2.Email_Address__c= 'testhonda@testorg.com';
        cPref2.EasyPay_Communications_via_Email__c= true;
        cPref2.Text_Number__c = '(999) 999-9999' ;
        cpref2.Unsubscribe_from_all__c = true;
        cpref2.IsEmailBounced__c=true;
        cpref2.Payment_Reminders_via_Email__c = true;
        cpref2.Days_Prior_Reminder__c = '15';
        cpref2.Paperless_Statements_Letters__c = true;
        cPref2.Payment_Confirmations_via_Text__c = true; 
        cPref2.EasyPay_Communications_via_Text__c = true;
        cPref2.Payment_Profile_Updates_via_Email__c= true;
        cPref2.Statements_Letters__c = 'eDelivery';
        
        insert cPref2;
        update cPref2;
        
        //Creating Payment_Source__c records
        Payment_Source__c psor2 = new Payment_Source__c();
        psor2.Finance_Account_Number__c = finacc2.id; 
        psor2.Bank_Name__c = 'CITIBank';
        psor2.Payment_Source_Nickname__c ='1112' ;
        psor2.Bank_Account_Number__c = '1230000004560002';
        psor2.Bank_Account_Type__c = 'K';
        psor2.Bank_Routing_Number__c = '021000089';
        psor2.Status__c = 'Active';
        
        insert psor2; 
        System.assertNotEquals(Null,psor2.id);
        
        ChargentBase__Gateway__c cbg = new ChargentBase__Gateway__c();
        cbg.Name = 'Cybersource';
        insert cbg;
        
        //Creating List of ChargentOrders__ChargentOrder__c records
        ChargentOrders__ChargentOrder__c coco2 = new ChargentOrders__ChargentOrder__c();
        coco2.Finance_Account_Number__c = finacc2.id;
        coco2.Payment_Source_Nickname__c = psor2.id;
        coco2.Payment_Display_Status__c = 'Reversed';
        coco2.ChargentOrders__Payment_Start_Date__c = system.today();
        coco2.ChargentOrders__Charge_Amount__c = 120.00;
        coco2.ChargentOrders__Payment_Status__c = 'Recurring';
        coco2.ChargentOrders__Payment_Frequency__c = 'Once';
        coco2.Payment_Type__c = 'P';
        
        insert coco2;
        mymap.put(coco2.Id, coco2);
       BaseTriggerHandler BT = new BaseTriggerHandler(); 
        coco1list.add(coco2);    
        try{
            EmailDeliveryService.sendPymtEmailConfirmation(coco1list,myMap,'Update');
            BT.validateRun();
            
        }catch(Exception e){}
        
        coco2.Payment_Type__c = 'O';
        update coco2;
        
        coco1list.add(coco2);    
        try{
            EmailDeliveryService.sendPymtEmailConfirmation(coco1list,myMap,'Update');
            
        }catch(Exception e){}
    }
    
    
//////////////////////////////////////////////////////////////Method 20 ///////////////////////////////////////////////////////////////////////        
static TestMethod void TestBTcontextMethods(){

BaseTriggerHandler BT = new BaseTriggerHandler();
BT.beforeInsert();
BT.beforeUpdate();
BT.beforeDelete();
BT.afterInsert();
BT.afterUpdate();
BT.afterDelete();
BT.afterUndelete();
BaseTriggerHandler.clearBypass('handler');
}
    
    
}