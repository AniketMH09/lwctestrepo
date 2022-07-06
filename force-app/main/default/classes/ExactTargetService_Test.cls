@isTest
public class ExactTargetService_Test{
    static testMethod void ExactTargetService_TestMethod(){
    	list<String> mobilenos = new list<String>{'1236547890','1239874560','3216547890'};
    
     	Finance_Account__c finacc2 = new Finance_Account__c();
        finacc2.Finance_Account_Number__c='1112';
        finacc2.Honda_Brand__c = 'AFS';
        finacc2.Payoff_Amount__c = 200.00;
                 
        insert finacc2; 
        //ApexPages.CurrentPage().getParameters().put('finnumber','1112');
        System.assertNotEquals(Null, finacc2.id);
        
        Account a=new Account();
        a.Name='Test';
        insert a;
        
        Communication_Preferences__c cPref2 = new Communication_Preferences__c();
        cPref2.Finance_Account_Number__c=finacc2.id;
        cPref2.Customer__c=a.Id;
        cPref2.Payment_Confirmations_via_Email__c=true;
        cPref2.Payment_Reminders_via_Text__c=true;
        cPref2.Email_Address__c= 'testhonda@testorg.com';
        cPref2.EasyPay_Communications_via_Email__c= true;
        cPref2.Text_Number__c = '(999) 999-9999' ;
        //cpref2.Unsubscribe_from_all__c = true;
        cpref2.Payment_Reminders_via_Email__c = false;
        cpref2.Days_Prior_Reminder__c = '15';
        cpref2.Paperless_Statements_Letters__c = true;
        cPref2.Payment_Confirmations_via_Text__c = true; 
        cPref2.EasyPay_Communications_via_Text__c = true;
        cPref2.Statements_Letters__c = 'eDelivery';
        
        insert cPref2;
        
        SingleRequestMock fakeResponse = new SingleRequestMock(200,'Complete','[{"Name": "sForceTest1"}]',null);
        SingleRequestMock smsfakeResponse = new SingleRequestMock(202,'Complete','[{"Name": "sForceTest1","message": "Not Authorized","tokenId":"erferferf"}]',null);
        SingleRequestMock smsfakeResponse2 = new SingleRequestMock(401,'Complete','[{"Name": "sForceTest1","message": "Not Authorized","tokenId":"erferferf"}]',null);
        ExactTargetServiceMock exacttarget = new ExactTargetServiceMock(200,4000,'Your communication preferences have been updated for HFS account ending 1234. View changes at hondafinancialservices.com. Text HELP for help and STOP to cancel.');
        ExactTargetServiceMock exacttargeterror = new ExactTargetServiceMock(200,4503,'Not Authorized');
       // ExactTargetServiceMock exacttargetundelivered = new ExactTargetServiceMock(200,4503,'');
       // ExactTargetServiceMock smsSending = new ExactTargetServiceMock(202,4503);
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, fakeResponse);
    
        ExactTargetService ets = new ExactTargetService();
        ExactTargetService.creds etsc = new ExactTargetService.creds();
        ExactTargetService.sendmessage etssm = new ExactTargetService.sendmessage();
       
        ExactTargetService.getCustomsetting();
        try{
            String s=ExactTargetService.getAuthCode();
        }catch(Exception e){}
        //ExactTargetService.sendSMS(mobilenos, true, '1234', '1323', true, 'Please Enter your Name', cPref2.Id);
        Test.setMock(HttpCalloutMock.class, smsfakeResponse);
           // Test.setMock(HttpCalloutMock.class,exacttargeterror);
        ExactTargetService.sendSMS(mobilenos, true, true, 'Please Enter your Name', cPref2.Id);
        ExactTargetService.sendSMSBatch(mobilenos, true, true, 'Please Enter your Name', cPref2.Id);
        
        try{
        String p=ExactTargetService.jsonprocessing('1234','1234'); 
         Test.setMock(HttpCalloutMock.class,exacttarget);
        String p1=ets.checkDeliveryStatus('Test','Test');
         Test.setMock(HttpCalloutMock.class,exacttargeterror);
        String p2=ets.checkDeliveryStatus('Test','Test');
          
        Test.setMock(HttpCalloutMock.class, smsfakeResponse2);
        ExactTargetService.sendSMSBatch(mobilenos, true, true, 'Please Enter your Name', cPref2.Id);
        ExactTargetService.sendSMS(mobilenos, true, true, 'Please Enter your Name', cPref2.Id);
        }catch(Exception e){}
            ExactTargetService.setCustomSetting('123') ;
        Test.stopTest();
    }
   static testMethod void ExactTargetService_TestMethod2(){
       ExactTargetService EtsNotAut = new ExactTargetService();
       Test.startTest();
       try{
           ExactTargetServiceMock exacttargeterror = new ExactTargetServiceMock(401,null,'Not Authorized');
           Test.setMock(HttpCalloutMock.class,exacttargeterror);
           String p2=EtsNotAut.checkDeliveryStatus('Test','Test');
           SingleRequestMock smsfakeResponse = new SingleRequestMock(401,'Not Authorized','[{"message": "Not Authorized"}]',null);
           Test.setMock(HttpCalloutMock.class, smsfakeResponse);
           String p3=EtsNotAut.checkDeliveryStatus('Test','Test');
           ExactTargetServiceMock exacttarget = new ExactTargetServiceMock(200,4000,'Your communication preferences have been updated for HFS account ending 1234. View changes at hondafinancialservices.com. Text HELP for help and STOP to cancel.');
           Test.setMock(HttpCalloutMock.class, exacttarget);
           String p4=EtsNotAut.checkDeliveryStatus('Test','Test');
       }catch(Exception e){}
       Test.stopTest();
   }
    static testMethod void ExactTargetService_TestMethod3(){
        try{
           ExactTargetService ets = new ExactTargetService();
           ExactTargetServiceMock exacttargeterror = new ExactTargetServiceMock(401,4503,'Not Authorized');
           String p4=ets.checkDeliveryStatus('Test','Test');
       }catch(Exception e){}
    }
}