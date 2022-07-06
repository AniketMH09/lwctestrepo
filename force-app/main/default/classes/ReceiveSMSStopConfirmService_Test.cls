/*************************************************
Author      :  Sajila Kadayaprath
Description :  Test class for ReceiveSMSStopConfirmService
*************************************************/

@isTest
public class ReceiveSMSStopConfirmService_Test{
    private static TestMethod void stopConfirmServiceTest(){
       
       Finance_Account__c finacc1 = new Finance_Account__c();
       finacc1.Finance_Account_Number__c='1111';
       finacc1.Honda_Brand__c = 'AFS';
       finacc1.FI_Stop_Reinstate_Recurring_Payment__c = 'S';
       insert finacc1;
       
       Account a =new Account();
       a.Name='Test';
       insert a;
       
       Communication_Preferences__c cPref=new Communication_Preferences__c();
       cPref.Finance_Account_Number__c=finacc1.id;
       cPref.Customer__c=a.Id;
       cPref.Payment_Confirmations_via_Email__c=true;
       cPref.Payment_Reminders_via_Text__c=false;
       cPref.Email_Address__c= 'testhonda@testorg.com';
       cPref.EasyPay_Communications_via_Email__c= true;
       cPref.Text_Number__c = '9999999999' ;
       cPref.Payment_Confirmations_via_Text__c = true;
       cpref.Payment_Reminders_via_Text__c = true;  
       cPref.EasyPay_Communications_via_Text__c = true;
       cPref.Statements_Letters__c = 'eDelivery';
       insert cPref;
       
       ReceiveSMSStopConfirmService.RequestWrapper rq=new ReceiveSMSStopConfirmService.RequestWrapper();
       rq.phoneNumber='9999999999';
       String JsonMsg=JSON.serialize(rq);
       
       Test.startTest();
       
       RestRequest req = new RestRequest(); 
       RestResponse res = new RestResponse();
       
       req.requestURI = '/services/apexrest/ReceiveSMSStopConfirmService/';  
       req.httpMethod = 'POST';
       req.requestBody = Blob.valueof(JsonMsg);
       RestContext.request = req;
       RestContext.response= res;
       
       ReceiveSMSStopConfirmService.ResponseWrapper rs=new ReceiveSMSStopConfirmService.ResponseWrapper();
       rs=ReceiveSMSStopConfirmService.Customerlogic(rq);
       
       Test.stopTest();       
    }
    private static TestMethod void stopConfirmServiceTest1(){
               
       ReceiveSMSStopConfirmService.RequestWrapper rq=new ReceiveSMSStopConfirmService.RequestWrapper();
       rq.phoneNumber='15854612362';
       String JsonMsg=JSON.serialize(rq);
       
       Test.startTest();
       
       RestRequest req = new RestRequest(); 
       RestResponse res = new RestResponse();
       
       req.requestURI = '/services/apexrest/ReceiveSMSStopConfirmService/';  
       req.httpMethod = 'POST';
       req.requestBody = Blob.valueof(JsonMsg);
       RestContext.request = req;
       RestContext.response= res;
       
       ReceiveSMSStopConfirmService.ResponseWrapper rs=new ReceiveSMSStopConfirmService.ResponseWrapper();
       rs=ReceiveSMSStopConfirmService.Customerlogic(rq);
       
       Test.stopTest();       
    }
    private static TestMethod void stopConfirmServiceTest2(){
               
       ReceiveSMSStopConfirmService.RequestWrapper rq=new ReceiveSMSStopConfirmService.RequestWrapper();
       rq.phoneNumber='235854612362';
       String JsonMsg=JSON.serialize(rq);
       
       Test.startTest();
       
       RestRequest req = new RestRequest(); 
       RestResponse res = new RestResponse();
       
       req.requestURI = '/services/apexrest/ReceiveSMSStopConfirmService/';  
       req.httpMethod = 'POST';
       req.requestBody = Blob.valueof(JsonMsg);
       RestContext.request = req;
       RestContext.response= res;
       
       ReceiveSMSStopConfirmService.ResponseWrapper rs=new ReceiveSMSStopConfirmService.ResponseWrapper();
       rs=ReceiveSMSStopConfirmService.Customerlogic(rq);
       
       Test.stopTest();       
    }
 }