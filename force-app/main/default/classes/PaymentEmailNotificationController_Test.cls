/*@ Author : Hari Charan Nethi.  
*/
@isTest
public class PaymentEmailNotificationController_Test{
    static testMethod void paymentEmailNotificationController_TestMethod(){
        
        RecordType recordType = [ select Id, Name, DeveloperName from RecordType where SObjectType = 'Account' and IsPersonType = true limit 1 ];
        Account newAccount = new Account( Salutation='Mr.', FirstName='Joe', LastName='Schmoe',Personemail='testhnda@testorg.com', Customer_Number__c='1234', RecordTypeId = recordType.id);
        insert newAccount;
        
        Finance_Account__c finacc1 = new Finance_Account__c();
        finacc1.Finance_Account_Number__c='1111';
        finacc1.Honda_Brand__c = 'HFS';
        finacc1.Customer_Name__c='Testing Account';
        insert finacc1; 
        
        System.assertNotEquals(Null, finacc1.id);
        
        /* Account a=new Account();
            a.Name='Test';
            insert a; */
        
        Customer_Finance_Account__c cfa=new Customer_Finance_Account__c();
        cfa.Customer__c= newAccount.Id;
        cfa.Finance_Account__c=finacc1.Id;
        insert cfa;
        
        finacc1.Customer__c=cfa.Id;
        update finacc1;
        
        Communication_Preferences__c cPref1 = new Communication_Preferences__c();
        cPref1.Finance_Account_Number__c=finacc1.id;
        cPref1.Customer__c=newAccount.Id;
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
        coco1.Payment_Display_Status__c = 'Reversed';
        coco1.ChargentOrders__Payment_Start_Date__c = system.today();
        coco1.ChargentOrders__Charge_Amount__c = 200.00;
        coco1.Payment_Channel__c = 'W';
        coco1.ChargentOrders__Payment_Method__c = 'Credit Card';
        coco1.ChargentOrders__Payment_Frequency__c = 'Once';
        coco1.ChargentOrders__Payment_Status__c = 'Recurring';
        coco1.ChargentOrders__Payment_End_Date__c = system.today().addDays(20);
        coco1.ChargentOrders__Payment_Stop__c = 'Date' ;
        coco1.Payment_Type__c = 'H';
        
        //coco1.recordtypeId = Schema.SobjectType.ChargentOrders__ChargentOrder__c.getRecordTypeInfosByName().get('Recurring Payment').getRecordTypeId();
        
        insert coco1;
                           
        String operation;    
        //PaymentEmailNotificationController penc = new PaymentEmailNotificationController();
        //PaymentEmailNotificationController.sendPymtReminderEmailConfirmation(coco1, 'SRM');
        //PaymentEmailNotificationController.sendBankAccEmailConfirmation(psor1,'NEW');
        //PaymentEmailNotificationController.sendReversalEmailNotification(cqbqi1);
        PaymentEmailNotificationController.sendCommPrefConfirmation(cPref1,'NEW');
        try{
            //PaymentEmailNotificationController.sendPymtEmailConfirmation(coco1, 'SRM');
        }
        catch(Exception e){}
        
        coco1.ChargentOrders__Payment_Frequency__c = 'Once';
        coco1.ChargentOrders__Payment_Status__c = 'Recurring';
        coco1.Payment_Type__c = 'P';
        
        update coco1;
        
        PaymentEmailNotificationController penc1 = new PaymentEmailNotificationController();
        try{
            //PaymentEmailNotificationController.sendPymtReminderEmailConfirmation(coco1, 'SRM');
        }
        catch(Exception e){}
        
        try{
            //PaymentEmailNotificationController.sendPymtEmailConfirmation(coco1, 'SRM');
        }catch(Exception e){}
        coco1.ChargentOrders__Payment_Frequency__c = 'Monthly';
        coco1.ChargentOrders__Payment_Status__c = 'Recurring';
        coco1.Payment_Type__c = 'P';
        
        update coco1;
        
        PaymentEmailNotificationController penc2 = new PaymentEmailNotificationController();
        try{
            //PaymentEmailNotificationController.sendPymtEmailConfirmation(coco1, 'SRM');
        }catch(Exception e){}
        try{
            //PaymentEmailNotificationController.sendPymtReminderEmailConfirmation(coco1, 'SRM');
        }catch(Exception e){}
        try{
           //PaymentEmailNotificationController.sendReversalEmailNotification(cqbqi1);  
        }catch(Exception e){} 
    }
    
    static testMethod void paymentEmailNotificationController_TestMethod1(){
        
        RecordType recordType = [ select Id, Name, DeveloperName from RecordType where SObjectType = 'Account' and IsPersonType = true limit 1 ];
        Account newAccount = new Account( Salutation='Mr.', FirstName='Joe', LastName='Schmoe',Personemail='testhnda@testorg.com', Customer_Number__c='1234', RecordTypeId = recordType.id);
        insert newAccount;
        
        Finance_Account__c finacc2 = new Finance_Account__c();
        finacc2.Finance_Account_Number__c='1112';
        finacc2.Honda_Brand__c = 'AFS';
        finacc2.Customer_Name__c='Testing Account';
        insert finacc2; 
        
        System.assertNotEquals(Null, finacc2.id);
        
        /* Account a=new Account();
            a.Name='Test';
            insert a;*/
        
        Customer_Finance_Account__c cfa=new Customer_Finance_Account__c();
        cfa.Customer__c= newAccount.Id;
        cfa.Finance_Account__c=finacc2.Id;
        insert cfa;
        
        finacc2.Customer__c=cfa.Id;
        update finacc2;
        
        Communication_Preferences__c cPref2 = new Communication_Preferences__c();
        cPref2.Finance_Account_Number__c=finacc2.id;
        cPref2.Customer__c=newAccount.Id;
        cPref2.Payment_Confirmations_via_Email__c=true;
        cPref2.Payment_Reminders_via_Text__c=true;
        cPref2.Email_Address__c= 'testhonda@testorg.com';
        cPref2.EasyPay_Communications_via_Email__c= true;
        cPref2.Text_Number__c = '(999) 999-9999' ;
        //cpref2.Unsubscribe_from_all__c = true;
        cpref2.Payment_Reminders_via_Email__c = true;
        cpref2.Days_Prior_Reminder__c = '15';
        cpref2.Paperless_Statements_Letters__c = true;
        cPref2.Payment_Confirmations_via_Text__c = true; 
        cPref2.EasyPay_Communications_via_Text__c = true;
        cPref2.Payment_Profile_Updates_via_Email__c= true;
        cPref2.Statements_Letters__c = 'eDelivery';
        // cPref2.Email_Account_Brand__c='AFS';
        
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
        coco2.Payment_Display_Status__c = 'Reversed';
        coco2.ChargentOrders__Payment_Start_Date__c = system.today();
        coco2.ChargentOrders__Charge_Amount__c = 120.00;
        coco2.ChargentOrders__Payment_Status__c = 'Recurring';
        coco2.ChargentOrders__Payment_Frequency__c = 'Once';
        coco2.Payment_Type__c = 'P';
        insert coco2;
        
        PaymentEmailNotificationController penc = new PaymentEmailNotificationController();
        //PaymentEmailNotificationController.sendPymtReminderEmailConfirmation(coco2, 'SRM');     
        try{ 
            PaymentEmailNotificationController.sendCommPrefConfirmationforUnsubscribe(cPref2,'Operation');
        }catch(Exception e){}
        
    }
    
    static testMethod void paymentEmailNotificationController_TestMethod2(){
        
        RecordType recordType = [ select Id, Name, DeveloperName from RecordType where SObjectType = 'Account' and IsPersonType = true limit 1 ];
        Account newAccount = new Account( Salutation='Mr.', FirstName='Joe', LastName='Schmoe',Personemail='testhnda@testorg.com', Customer_Number__c='1234',  RecordTypeId = recordType.id);
        insert newAccount;
        
        Finance_Account__c finacc1 = new Finance_Account__c();
        finacc1.Finance_Account_Number__c='1111';
        finacc1.Honda_Brand__c = 'HFS';
        finacc1.Customer_Name__c='Testing Account';
        insert finacc1; 
        
        System.assertNotEquals(Null, finacc1.id);
        
        /* Account a=new Account();
            a.Name='Test';
            insert a; */
        
        Customer_Finance_Account__c cfa=new Customer_Finance_Account__c();
        cfa.Customer__c= newAccount.Id;
        cfa.Finance_Account__c=finacc1.Id;
        insert cfa;
        
        finacc1.Customer__c=cfa.Id;
        update finacc1;
        
        Communication_Preferences__c cPref1 = new Communication_Preferences__c();
        cPref1.Finance_Account_Number__c=finacc1.id;
        cPref1.Customer__c=newAccount.Id;
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
        cPref1.Statements_Letters__c = 'eDelivery';
        cPref1.Payment_Profile_Updates_via_Email__c= true;

        insert cPref1;
        
        Payment_Source__c psor1 = new Payment_Source__c();
        psor1.Finance_Account_Number__c = finacc1.id; 
        psor1.Bank_Name__c = 'Citibank';
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
        coco1.Payment_Display_Status__c = 'Reversed';
        coco1.ChargentOrders__Payment_Start_Date__c = system.today();
        coco1.ChargentOrders__Charge_Amount__c = 200.00;
        coco1.Payment_Channel__c = 'W';
        coco1.ChargentOrders__Payment_Method__c = 'Credit Card';
        coco1.ChargentOrders__Payment_Frequency__c = 'Once';
        coco1.ChargentOrders__Payment_Status__c = 'Recurring';
        coco1.ChargentOrders__Payment_End_Date__c = system.today().addDays(20);
        coco1.ChargentOrders__Payment_Stop__c = 'Date' ;
        coco1.Payment_Type__c = 'R';
        
        
        //coco1.recordtypeId = Schema.SobjectType.ChargentOrders__ChargentOrder__c.getRecordTypeInfosByName().get('Recurring Payment').getRecordTypeId();
        
        insert coco1;
        
        Contact c = [select id from contact limit 1];
        EmailTemplate eTemplate = [select id from EmailTemplate limit 1];
        
        
        String operation;    
        //PaymentEmailNotificationController penc = new PaymentEmailNotificationController();
        //PaymentEmailNotificationController.sendPymtReminderEmailConfirmation(coco1, 'SRM');
        //PaymentEmailNotificationController.sendBankAccEmailConfirmation(psor1,'NEW');
        //PaymentEmailNotificationController.sendReversalEmailNotification(cqbqi1);
        PaymentEmailNotificationController.sendCommPrefConfirmation(cPref1,'NEW');
        try{
            //PaymentEmailNotificationController.sendPymtEmailConfirmation(coco1, 'SRM');
            PaymentEmailNotificationController.doSendEmail(c.id,coco1.id,eTemplate.id,'AFS');
        }
        catch(Exception e){}
        
        coco1.ChargentOrders__Payment_Frequency__c = 'Once';
        coco1.ChargentOrders__Payment_Status__c = 'Recurring';
        coco1.Payment_Type__c = 'P';
        
        update coco1;
        
        PaymentEmailNotificationController penc1 = new PaymentEmailNotificationController();
        try{
            //PaymentEmailNotificationController.sendPymtReminderEmailConfirmation(coco1, 'SRM');
        }
        catch(Exception e){}
        
        try{
            //PaymentEmailNotificationController.sendPymtEmailConfirmation(coco1, 'SRM');
        }catch(Exception e){}
        coco1.ChargentOrders__Payment_Frequency__c = 'Monthly';
        coco1.ChargentOrders__Payment_Status__c = 'Recurring';
        coco1.Payment_Type__c = 'P';
        
        update coco1;
        
        PaymentEmailNotificationController penc2 = new PaymentEmailNotificationController();
        try{
            //PaymentEmailNotificationController.sendPymtEmailConfirmation(coco1, 'SRM');
        }catch(Exception e){}
        try{
            //PaymentEmailNotificationController.sendPymtReminderEmailConfirmation(coco1, 'SRM');
        }catch(Exception e){}
        try{
            //PaymentEmailNotificationController.sendReversalEmailNotification(cqbqi1);  
        }catch(Exception e){} 
    }
   
}