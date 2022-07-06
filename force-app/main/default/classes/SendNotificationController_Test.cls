/**************************************************************************
Author      :  Sajila Kadayaprath
Description :  Test class for SendNotificationController
*****************************************************************************/
@isTest
public class SendNotificationController_Test{
    
    private static testMethod void sendNotification_Testmethod(){
    
        RecordType recordType = [ select Id, Name, DeveloperName from RecordType where SObjectType = 'Account' and IsPersonType = true limit 1 ];
        Account a= new Account( Salutation='Mr.', FirstName='Joe', LastName='Schmoe', RecordTypeId = recordType.id );
        insert a;
        
        Contact con = new Contact();
        con.LastName = 'Honda Contact';
        //con.AccountId = a.Id;
        con.OwnerId = userInfo.getUserId();
        insert con;
        
        ChargentBase__Gateway__c cbg = new ChargentBase__Gateway__c();
        cbg.name = 'Cybersource';
        cbg.ChargentBase__Active__c = true;   
        insert cbg;
         
        Finance_Account__c finacc2 = new Finance_Account__c();
        finacc2.Finance_Account_Number__c='1112';
        finacc2.Honda_Brand__c = 'AFS';
        finacc2.Payoff_Amount__c = 200.00;
        //finacc2.Customer__c = cfa.id;
        finacc2.OwnerId = userInfo.getUserId();
        finacc2.Next_Due_Date__c = system.today();
        finacc2.Payment_Due_Date__c  = system.today();
        finacc2.Paid_to_Date__c  = system.today();
        finacc2.Total_Amount_Due__c = 200.00;
        finacc2.Payoff_Amount__c=1000;
              
        insert finacc2; 
        ApexPages.CurrentPage().getParameters().put('finnumber','1112');
        System.assertNotEquals(Null, finacc2.id);
        
        Customer_Finance_Account__c cfa = new Customer_Finance_Account__c();
        cfa.Finance_Account__c = finacc2.id;
        cfa.Customer__c = a.Id;
        cfa.OwnerId = userInfo.getUserId();
        insert cfa; 
        
        Communication_Preferences__c cPref2 = new Communication_Preferences__c();
        cPref2.Finance_Account_Number__c=finacc2.id;
        cPref2.Customer__c=a.Id;
        cPref2.Payment_Confirmations_via_Email__c=true;
        cPref2.Payment_Reminders_via_Text__c=true;
        cPref2.Email_Address__c= 'testhonda@testorg.com';
        cPref2.EasyPay_Communications_via_Email__c= true;
        cPref2.Payment_Reminders_via_Email__c = true;
        cPref2.Text_Number__c = '(999) 999-9999' ;
        cPref2.Unsubscribe_from_all__c = false;
        //cpref2.Unsubscribe_from_all__c = true;
        cpref2.Payment_Reminders_via_Email__c = false;
        cpref2.Days_Prior_Reminder__c = '15';
        cpref2.Paperless_Statements_Letters__c = true;
        cPref2.Payment_Confirmations_via_Text__c = true; 
        cPref2.EasyPay_Communications_via_Text__c = true;
        cPref2.Statements_Letters__c = 'eDelivery';
        cPref2.IsEmailBounced__c=true;
        cPref2.Email_BounceBack_Count__c=1;
        cPref2.Is_SMS_Bounced_Back__c=true;
        cPref2.SMS_Bounce_Back_Count__c=1;
        cpref2.Is_Comm_Pref_Set__c = true;
        
        insert cPref2;
        
        //Creating Payment_Source__c records
        Payment_Source__c psor2 = new Payment_Source__c();
        psor2.Finance_Account_Number__c = finacc2.id; 
        psor2.Bank_Name__c = 'ICICkI';
        psor2.Payment_Source_Nickname__c ='1112' ;
        psor2.Bank_Account_Number__c = '1230000004560002';
        psor2.Bank_Account_Type__c = 'K';
        psor2.Bank_Routing_Number__c = 'IKBL01538';
        psor2.Status__c = 'Active';
        insert psor2; 
        System.assertNotEquals(Null,psor2.id);
        
        List<Payment_Source__c> psorList = new List<Payment_Source__c>();
        psorList.add(psor2);  
             
         //Creating List of ChargentOrders__ChargentOrder__c records
        ChargentOrders__ChargentOrder__c coco1 = new ChargentOrders__ChargentOrder__c();
        coco1.Finance_Account_Number__c = finacc2.id;
        coco1.Payment_Source_Nickname__c = psor2.id;
        coco1.Payment_Display_Status__c = 'Reversed';
        coco1.ChargentOrders__Payment_Start_Date__c = system.today();
        coco1.ChargentOrders__Charge_Amount__c = 120.00;
        coco1.ChargentOrders__Payment_Status__c = 'Recurring';
        coco1.ChargentOrders__Payment_Frequency__c = 'Once';
        coco1.Payment_Display_Status__c='Pending';
        coco1.Payment_Type__c = 'P';
        coco1.Next_Withdrawal_Date__c = system.today();
        coco1.Last_Extraction_Date__c = system.today();
        coco1.RecordTypeId = Schema.SobjectType.ChargentOrders__ChargentOrder__c.getRecordTypeInfosByName().get('Standard One-Time Payment').getRecordTypeId();
        insert coco1;
  
        //Instantiating the rest context
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
    
        // pass the req and resp objects to the method     
        req.requestURI = '/services/apexrest/SendNotification/'+finacc2.Finance_Account_Number__c;  
        req.httpMethod = 'POST';
        
        RestContext.request = req;
        RestContext.response= res;

         SendNotificationController snc = new SendNotificationController();
        SendNotificationController.Result sncr = new SendNotificationController.Result();
        SendNotificationController.EasyPay sncep = new SendNotificationController.EasyPay();
        SendNotificationController.OneTimePayment sncotp = new SendNotificationController.OneTimePayment();
        SendNotificationController.PendingPayments snrpp = new SendNotificationController.PendingPayments();
        SendNotificationController.Response snrr = new SendNotificationController.Response();
        try{
        SendNotificationController.PendingPayments resp =SendNotificationController.doPost();}
        catch(Exception e){}
    }
    private static testMethod void sendNotification_Testmethod1(){
    
        RecordType recordType = [ select Id, Name, DeveloperName from RecordType where SObjectType = 'Account' and IsPersonType = true limit 1 ];
        Account a= new Account( Salutation='Mr.', FirstName='Joe', LastName='Schmoe', RecordTypeId = recordType.id );
        insert a;
        
        Contact con = new Contact();
        con.LastName = 'Honda Contact';
        //con.AccountId = a.Id;
        con.OwnerId = userInfo.getUserId();
        insert con;
        
        ChargentBase__Gateway__c cbg = new ChargentBase__Gateway__c();
        cbg.name = 'Cybersource';
        cbg.ChargentBase__Active__c = true;   
        insert cbg;
         
        Finance_Account__c finacc2 = new Finance_Account__c();
        finacc2.Finance_Account_Number__c='1112';
        finacc2.Honda_Brand__c = 'AFS';
        finacc2.Payoff_Amount__c = 200.00;
        //finacc2.Customer__c = cfa.id;
        finacc2.OwnerId = userInfo.getUserId();
        finacc2.Next_Due_Date__c = system.today();
        finacc2.Payment_Due_Date__c  = system.today();
        finacc2.Paid_to_Date__c  = system.today();
        finacc2.Total_Amount_Due__c = 200.00;
        finacc2.Payoff_Amount__c=1000;
              
        insert finacc2; 
        ApexPages.CurrentPage().getParameters().put('finnumber','1112');
        System.assertNotEquals(Null, finacc2.id);
        
        Customer_Finance_Account__c cfa = new Customer_Finance_Account__c();
        cfa.Finance_Account__c = finacc2.id;
        cfa.Customer__c = a.Id;
        cfa.OwnerId = userInfo.getUserId();
        insert cfa; 
        
        Communication_Preferences__c cPref2 = new Communication_Preferences__c();
        cPref2.Finance_Account_Number__c=finacc2.id;
        cPref2.Customer__c=a.Id;
        cPref2.Payment_Confirmations_via_Email__c=true;
        cPref2.Payment_Reminders_via_Text__c=true;
        cPref2.Email_Address__c= 'testhonda@testorg.com';
        cPref2.EasyPay_Communications_via_Email__c= true;
        cPref2.Payment_Reminders_via_Email__c = true;
        cPref2.Text_Number__c = '(999) 999-9999' ;
        cPref2.Unsubscribe_from_all__c = false;
        //cpref2.Unsubscribe_from_all__c = true;
        cpref2.Payment_Reminders_via_Email__c = false;
        cpref2.Days_Prior_Reminder__c = '15';
        cpref2.Paperless_Statements_Letters__c = true;
        cPref2.Payment_Confirmations_via_Text__c = true; 
        cPref2.EasyPay_Communications_via_Text__c = true;
        cPref2.Statements_Letters__c = 'eDelivery';
        cPref2.IsEmailBounced__c=true;
        cPref2.Email_BounceBack_Count__c=1;
        cPref2.Is_SMS_Bounced_Back__c=true;
        cPref2.SMS_Bounce_Back_Count__c=1;
        
        insert cPref2;
        
        //Creating Payment_Source__c records
        Payment_Source__c psor2 = new Payment_Source__c();
        psor2.Finance_Account_Number__c = finacc2.id; 
        psor2.Bank_Name__c = 'ICICkI';
        psor2.Payment_Source_Nickname__c ='1112' ;
        psor2.Bank_Account_Number__c = '1230000004560002';
        psor2.Bank_Account_Type__c = 'K';
        psor2.Bank_Routing_Number__c = 'IKBL01538';
        psor2.Status__c = 'Active';
        insert psor2; 
        System.assertNotEquals(Null,psor2.id);
        
        List<Payment_Source__c> psorList = new List<Payment_Source__c>();
        psorList.add(psor2);  
             
         //Creating List of ChargentOrders__ChargentOrder__c records
        ChargentOrders__ChargentOrder__c coco1 = new ChargentOrders__ChargentOrder__c();
        coco1.Finance_Account_Number__c = finacc2.id;
        coco1.Payment_Source_Nickname__c = psor2.id;
        coco1.Payment_Display_Status__c = 'Reversed';
        coco1.ChargentOrders__Payment_Start_Date__c = system.today();
        coco1.ChargentOrders__Charge_Amount__c = 120.00;
        coco1.ChargentOrders__Payment_Status__c = 'Recurring';
        coco1.ChargentOrders__Payment_Frequency__c = 'Once';
        coco1.Payment_Display_Status__c='Pending';
        coco1.Payment_Type__c = 'P';
        coco1.Next_Withdrawal_Date__c = system.today();
        coco1.Last_Extraction_Date__c = system.today();
        coco1.RecordTypeId = Schema.SobjectType.ChargentOrders__ChargentOrder__c.getRecordTypeInfosByName().get('Recurring Payment').getRecordTypeId();
        System.debug('coco1 FA' + coco1.Finance_Account_Number__c);
        System.debug('coco1 PS' + coco1.Payment_Source_Nickname__c);
        insert coco1;
  
        //Instantiating the rest context
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
    
        // pass the req and resp objects to the method     
        req.requestURI = '/services/apexrest/SendNotification/'+finacc2.Finance_Account_Number__c;  
        req.httpMethod = 'POST';
        
        RestContext.request = req;
        RestContext.response= res;

         SendNotificationController snc = new SendNotificationController();
        SendNotificationController.Result sncr = new SendNotificationController.Result();
        SendNotificationController.EasyPay sncep = new SendNotificationController.EasyPay();
        SendNotificationController.OneTimePayment sncotp = new SendNotificationController.OneTimePayment();
        SendNotificationController.PendingPayments snrpp = new SendNotificationController.PendingPayments();
        SendNotificationController.Response snrr = new SendNotificationController.Response();
        try{
        SendNotificationController.PendingPayments resp =SendNotificationController.doPost();}
        catch(Exception e){}
    }private static testMethod void sendNotification_Testmethod2(){

        Finance_Account__c finacc2 = new Finance_Account__c();
        finacc2.Finance_Account_Number__c='1112';
        finacc2.Honda_Brand__c = 'AFS';
        finacc2.Payoff_Amount__c = 200.00;
        //finacc2.Customer__c = cfa.id;
        finacc2.OwnerId = userInfo.getUserId();
        finacc2.Next_Due_Date__c = system.today();
        finacc2.Payment_Due_Date__c  = system.today();
        finacc2.Paid_to_Date__c  = system.today();
        finacc2.Total_Amount_Due__c = 200.00;
        finacc2.Payoff_Amount__c=1000;
              
        insert finacc2; 
        ApexPages.CurrentPage().getParameters().put('finnumber','1112');
        System.assertNotEquals(Null, finacc2.id);
        
        //Instantiating the rest context
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
    
        // pass the req and resp objects to the method     
        req.requestURI = '/services/apexrest/SendNotification/';  
        req.httpMethod = 'POST';
        
        RestContext.request = req;
        RestContext.response= res;

         SendNotificationController snc = new SendNotificationController();
        SendNotificationController.Result sncr = new SendNotificationController.Result();
        SendNotificationController.EasyPay sncep = new SendNotificationController.EasyPay();
        SendNotificationController.OneTimePayment sncotp = new SendNotificationController.OneTimePayment();
        SendNotificationController.PendingPayments snrpp = new SendNotificationController.PendingPayments();
        SendNotificationController.Response snrr = new SendNotificationController.Response();
        try{
        SendNotificationController.PendingPayments resp =SendNotificationController.doPost();}
        catch(Exception e){}
    }
    
    private static testMethod void sendNotification_Testmethod4(){
    
        RecordType recordType = [ select Id, Name, DeveloperName from RecordType where SObjectType = 'Account' and IsPersonType = true limit 1 ];
        Account a= new Account( Salutation='Mr.', FirstName='Joe', LastName='Schmoe', RecordTypeId = recordType.id );
        insert a;
        
        Contact con = new Contact();
        con.LastName = 'Honda Contact';
        //con.AccountId = a.Id;
        con.OwnerId = userInfo.getUserId();
        insert con;
        
        ChargentBase__Gateway__c cbg = new ChargentBase__Gateway__c();
        cbg.name = 'Cybersource';
        cbg.ChargentBase__Active__c = true;   
        insert cbg;
         
        Finance_Account__c finacc2 = new Finance_Account__c();
        finacc2.Finance_Account_Number__c='1112';
        finacc2.Honda_Brand__c = 'AFS';
        finacc2.Payoff_Amount__c = 200.00;
        //finacc2.Customer__c = cfa.id;
        finacc2.OwnerId = userInfo.getUserId();
        finacc2.Next_Due_Date__c = system.today();
        finacc2.Payment_Due_Date__c  = system.today();
        finacc2.Paid_to_Date__c  = system.today();
        finacc2.Total_Amount_Due__c = 200.00;
        finacc2.Payoff_Amount__c=1000;
              
        insert finacc2; 
        ApexPages.CurrentPage().getParameters().put('finnumber','1112');
        System.assertNotEquals(Null, finacc2.id);
        
        Customer_Finance_Account__c cfa = new Customer_Finance_Account__c();
        cfa.Finance_Account__c = finacc2.id;
        cfa.Customer__c = a.Id;
        cfa.OwnerId = userInfo.getUserId();
        insert cfa; 
        
        Communication_Preferences__c cPref2 = new Communication_Preferences__c();
        cPref2.Finance_Account_Number__c=finacc2.id;
        cPref2.Customer__c=a.Id;
        cPref2.Payment_Confirmations_via_Email__c=true;
        cPref2.Payment_Reminders_via_Text__c=true;
        cPref2.Email_Address__c= 'testhonda@testorg.com';
        cPref2.EasyPay_Communications_via_Email__c= true;
        cPref2.Payment_Reminders_via_Email__c = true;
        cPref2.Text_Number__c = '(999) 999-9999' ;
        cPref2.Unsubscribe_from_all__c = false;
        //cpref2.Unsubscribe_from_all__c = true;
        cpref2.Payment_Reminders_via_Email__c = false;
        cpref2.Days_Prior_Reminder__c = '15';
        cpref2.Paperless_Statements_Letters__c = true;
        cPref2.Payment_Confirmations_via_Text__c = true; 
        cPref2.EasyPay_Communications_via_Text__c = true;
        cPref2.Statements_Letters__c = 'eDelivery';
        cPref2.IsEmailBounced__c=true;
        cPref2.Email_BounceBack_Count__c=4;
        cPref2.Is_SMS_Bounced_Back__c=true;
        cPref2.SMS_Bounce_Back_Count__c=4;
        
        insert cPref2;
        
        //Creating Payment_Source__c records
        Payment_Source__c psor2 = new Payment_Source__c();
        psor2.Finance_Account_Number__c = finacc2.id; 
        psor2.Bank_Name__c = 'ICICkI';
        psor2.Payment_Source_Nickname__c ='1112' ;
        psor2.Bank_Account_Number__c = '1230000004560002';
        psor2.Bank_Account_Type__c = 'K';
        psor2.Bank_Routing_Number__c = 'IKBL01538';
        psor2.Status__c = 'Active';
        insert psor2; 
        System.assertNotEquals(Null,psor2.id);
        
        List<Payment_Source__c> psorList = new List<Payment_Source__c>();
        psorList.add(psor2);  
             
         //Creating List of ChargentOrders__ChargentOrder__c records
        ChargentOrders__ChargentOrder__c coco1 = new ChargentOrders__ChargentOrder__c();
        coco1.Finance_Account_Number__c = finacc2.id;
        coco1.Payment_Source_Nickname__c = psor2.id;
        coco1.Payment_Display_Status__c = 'Reversed';
        coco1.ChargentOrders__Payment_Start_Date__c = system.today();
        coco1.ChargentOrders__Charge_Amount__c = 120.00;
        coco1.ChargentOrders__Payment_Status__c = 'Recurring';
        coco1.ChargentOrders__Payment_Frequency__c = 'Once';
        coco1.Payment_Display_Status__c='Pending';
        coco1.Payment_Type__c = 'P';
        coco1.Next_Withdrawal_Date__c = system.today();
        coco1.Last_Extraction_Date__c = system.today();
        coco1.RecordTypeId = Schema.SobjectType.ChargentOrders__ChargentOrder__c.getRecordTypeInfosByName().get('Standard One-Time Payment').getRecordTypeId();
        insert coco1;
  
        //Instantiating the rest context
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
    
        // pass the req and resp objects to the method     
        req.requestURI = '/services/apexrest/SendNotification/'+finacc2.Finance_Account_Number__c;  
        req.httpMethod = 'POST';
        
        RestContext.request = req;
        RestContext.response= res;

         SendNotificationController snc = new SendNotificationController();
        SendNotificationController.Result sncr = new SendNotificationController.Result();
        SendNotificationController.EasyPay sncep = new SendNotificationController.EasyPay();
        SendNotificationController.OneTimePayment sncotp = new SendNotificationController.OneTimePayment();
        SendNotificationController.PendingPayments snrpp = new SendNotificationController.PendingPayments();
        SendNotificationController.Response snrr = new SendNotificationController.Response();
        try{
        SendNotificationController.PendingPayments resp =SendNotificationController.doPost();}
        catch(Exception e){}
    }
    
    private static testMethod void sendNotification_Testmethod5(){
    
        RecordType recordType = [ select Id, Name, DeveloperName from RecordType where SObjectType = 'Account' and IsPersonType = true limit 1 ];
        Account a= new Account( Salutation='Mr.', FirstName='Joe', LastName='Schmoe', RecordTypeId = recordType.id );
        insert a;
        
        Contact con = new Contact();
        con.LastName = 'Honda Contact';
        //con.AccountId = a.Id;
        con.OwnerId = userInfo.getUserId();
        insert con;
        
        ChargentBase__Gateway__c cbg = new ChargentBase__Gateway__c();
        cbg.name = 'Cybersource';
        cbg.ChargentBase__Active__c = true;   
        insert cbg;
         
        Finance_Account__c finacc2 = new Finance_Account__c();
        finacc2.Finance_Account_Number__c='1112';
        finacc2.Honda_Brand__c = 'AFS';
        finacc2.Payoff_Amount__c = 200.00;
        //finacc2.Customer__c = cfa.id;
        finacc2.OwnerId = userInfo.getUserId();
        finacc2.Next_Due_Date__c = system.today();
        finacc2.Payment_Due_Date__c  = system.today();
        finacc2.Paid_to_Date__c  = system.today();
        finacc2.Total_Amount_Due__c = 200.00;
        finacc2.Payoff_Amount__c=1000;
              
        insert finacc2; 
        ApexPages.CurrentPage().getParameters().put('finnumber','1112');
        System.assertNotEquals(Null, finacc2.id);
        
        Customer_Finance_Account__c cfa = new Customer_Finance_Account__c();
        cfa.Finance_Account__c = finacc2.id;
        cfa.Customer__c = a.Id;
        cfa.OwnerId = userInfo.getUserId();
        insert cfa; 
        
        Communication_Preferences__c cPref2 = new Communication_Preferences__c();
        cPref2.Finance_Account_Number__c=finacc2.id;
        cPref2.Customer__c=a.Id;
        cPref2.Payment_Confirmations_via_Email__c=true;
        cPref2.Payment_Reminders_via_Text__c=true;
        cPref2.Email_Address__c= 'testhonda@testorg.com';
        cPref2.EasyPay_Communications_via_Email__c= true;
        cPref2.Payment_Reminders_via_Email__c = true;
        cPref2.Text_Number__c = '(999) 999-9999' ;
        cPref2.Unsubscribe_from_all__c = false;
        //cpref2.Unsubscribe_from_all__c = true;
        cpref2.Payment_Reminders_via_Email__c = false;
        cpref2.Days_Prior_Reminder__c = '15';
        cpref2.Paperless_Statements_Letters__c = true;
        cPref2.Payment_Confirmations_via_Text__c = true; 
        cPref2.EasyPay_Communications_via_Text__c = true;
        cPref2.Statements_Letters__c = 'eDelivery';
        cPref2.IsEmailBounced__c=true;
        cPref2.Email_BounceBack_Count__c=4;
        cPref2.Is_SMS_Bounced_Back__c=true;
        cPref2.SMS_Bounce_Back_Count__c=0;
        
        insert cPref2;
        
        //Creating Payment_Source__c records
        Payment_Source__c psor2 = new Payment_Source__c();
        psor2.Finance_Account_Number__c = finacc2.id; 
        psor2.Bank_Name__c = 'ICICkI';
        psor2.Payment_Source_Nickname__c ='1112' ;
        psor2.Bank_Account_Number__c = '1230000004560002';
        psor2.Bank_Account_Type__c = 'K';
        psor2.Bank_Routing_Number__c = 'IKBL01538';
        psor2.Status__c = 'Active';
        insert psor2; 
        System.assertNotEquals(Null,psor2.id);
        
        List<Payment_Source__c> psorList = new List<Payment_Source__c>();
        psorList.add(psor2);  
             
         //Creating List of ChargentOrders__ChargentOrder__c records
        ChargentOrders__ChargentOrder__c coco1 = new ChargentOrders__ChargentOrder__c();
        coco1.Finance_Account_Number__c = finacc2.id;
        coco1.Payment_Source_Nickname__c = psor2.id;
        coco1.Payment_Display_Status__c = 'Reversed';
        coco1.ChargentOrders__Payment_Start_Date__c = system.today();
        coco1.ChargentOrders__Charge_Amount__c = 120.00;
        coco1.ChargentOrders__Payment_Status__c = 'Recurring';
        coco1.ChargentOrders__Payment_Frequency__c = 'Once';
        coco1.Payment_Display_Status__c='Pending';
        coco1.Payment_Type__c = 'P';
        coco1.Next_Withdrawal_Date__c = system.today();
        coco1.Last_Extraction_Date__c = system.today();
        coco1.RecordTypeId = Schema.SobjectType.ChargentOrders__ChargentOrder__c.getRecordTypeInfosByName().get('Standard One-Time Payment').getRecordTypeId();
        insert coco1;
  
        //Instantiating the rest context
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
    
        // pass the req and resp objects to the method     
        req.requestURI = '/services/apexrest/SendNotification/'+finacc2.Finance_Account_Number__c;  
        req.httpMethod = 'POST';
        
        RestContext.request = req;
        RestContext.response= res;

         SendNotificationController snc = new SendNotificationController();
        SendNotificationController.Result sncr = new SendNotificationController.Result();
        SendNotificationController.EasyPay sncep = new SendNotificationController.EasyPay();
        SendNotificationController.OneTimePayment sncotp = new SendNotificationController.OneTimePayment();
        SendNotificationController.PendingPayments snrpp = new SendNotificationController.PendingPayments();
        SendNotificationController.Response snrr = new SendNotificationController.Response();
        try{
        SendNotificationController.PendingPayments resp =SendNotificationController.doPost();}
        catch(Exception e){}
    }
    
     private static testMethod void sendNotification_Testmethod6(){
         String lastWithdrawDate = '' ;
         String Dt = system.today().format();
         SendNotificationController.setStringToDateFormat(dt);
     }
}