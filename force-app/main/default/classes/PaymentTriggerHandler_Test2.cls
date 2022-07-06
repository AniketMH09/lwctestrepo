@isTest
public class PaymentTriggerHandler_Test2 {

private static String lastMethodCalled;
private static PaymentTriggerHandler_Test2.TestHandler pHandler;
    
  static {
    pHandler = new PaymentTriggerHandler_Test2.TestHandler();
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
        
        BaseTriggerHandler.isUserSession= true;
         
         Test.stopTest();

}


////////////////////////////////////////////////////////////// TEST SETUP ENDS///////////////////////////////////////////////////////////////////////

/******************************************* Start Of TestHandler extending BaseTriggerHandler  ***********************************************************************************/
  
  private class TestHandler extends BaseTriggerHandler  {

    

    public override void  beforeUpdate() {
      PaymentTriggerHandler_Test2.lastMethodCalled = 'beforeUpdate';
      BaseTriggerHandler.isUserSession= true;
      string hname = '123';
      BaseTriggerHandler.bypass(hname);
      BaseTriggerHandler.clearAllBypasses();
      BaseTriggerHandler.isBypassed(hname);
    }


    public override void afterUpdate() {
      PaymentTriggerHandler_Test2.lastMethodCalled = 'afterUpdate';
      string hname = '123';
      BaseTriggerHandler.bypass(hname);
      BaseTriggerHandler.clearAllBypasses();
    
BaseTriggerHandler.isBypassed(hname);
    }


}

/*********************************************End of TestHandler extending BaseTriggerHandler *******************************************************************************/

 private static void afterUpdateMode() {
    pHandler.setTriggerContext('after update', true);
        string hname = '123';
    BaseTriggerHandler.bypass(hname);
    BaseTriggerHandler.clearAllBypasses();
    BaseTriggerHandler.isUserSession= true;
    
BaseTriggerHandler.isBypassed(hname);
  }



    
////////////////////////////////////////////// Test Method 13 started /////////////////////////////////////////////////////////     
@isTest
  static void testAfterUpdate() {
      Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
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
          //   afterInsertMode();
            pHandler.setTriggerContext('after insert', true);
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
        
     //   afterInsertMode();
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

}