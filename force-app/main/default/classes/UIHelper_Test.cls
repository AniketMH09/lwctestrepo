/*
Test Class for UIHelper

*/
@isTest
public class UIHelper_Test{

/********************************** Method1: canUpdateEPStatus_POS ******************************************************/   
 
   private static TestMethod void canUpdateEPStatus_POS()
   {
   ApexPages.StandardController controller;
    UIHelper  UIH = new UIHelper (controller);
    String displayStatus;
    Date nextWithdrawalDt= date.newinstance(2016,10,08); 
    displayStatus = 'Pending';

    test.startTest();
    String str = UIHelper.canUpdateEPStatus(displayStatus,nextWithdrawalDt);
    test.stopTest();
  }
 
/********************************** Method2: canUpdateEPStatus_NEG ******************************************************/    
 
  private static TestMethod void canUpdateEPStatus_NEG()
   {
   ApexPages.StandardController controller;
    UIHelper  UIH = new UIHelper (controller);
    String displayStatus;
    Date nextWithdrawalDt= date.newinstance(2016,12,08); 
    displayStatus = 'Pending';

    test.startTest();
    String str = UIHelper.canUpdateEPStatus(displayStatus,nextWithdrawalDt);
    test.stopTest();
  }
  
/********************************** Method3: isEPCancelledAfterCutoff ******************************************************/  
   private static TestMethod void method2isEPCancelledAfterCutoff()
   {
      
         ApexPages.StandardController controller;
         UIHelper  UIH = new UIHelper (controller);
         test.startTest();
         UIH.isEPCancelledAfterCutoff();
         test.stopTest();

  }
    
       
    private static TestMethod void method4isEPCancelledAfterCutoff()
   {
         ApexPages.StandardController controller;
         UIHelper  UIH = new UIHelper (controller);
         UIH.NWDStr = String.ValueOf(Date.Today());
         UIH.epDisplayStatus = 'Pending';
         Honda_Finance__c hfc = Honda_Finance__c.getOrgDefaults();
         hfc.CutOff_Time__c = System.Now();
         upsert hfc Honda_Finance__c.Id;

         test.startTest();
         UIH.isEPCancelledAfterCutoff();
         test.stopTest();

  } 
    
    
 
  }