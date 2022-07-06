@isTest
public class PaymentCancelButton_Test{
    private static TestMethod void PaymentCancelTest(){

    Honda_Finance__c mc=new Honda_Finance__c();
    mc.CutOff_Time__c=System.Today();
    insert mc;
    
    Finance_Account__c finacc1 = new Finance_Account__c();
            finacc1.Finance_Account_Number__c='1112';
            finacc1.Honda_Brand__c = 'AFS';
            finacc1.Payoff_Amount__c = 200.00;
            finacc1.Fl_Suppress_All_Notifications__c =true;
                 
        insert finacc1; 

       RecordType recordType = [ select Id, Name, DeveloperName from RecordType where SObjectType = 'Account' and IsPersonType = true limit 1 ];
        Account a= new Account( Salutation='Mr.', FirstName='Joe', LastName='Schmoe', RecordTypeId = recordType.id );
        insert a;
        
        Customer_Finance_Account__c cfa = new Customer_Finance_Account__c();
        cfa.Finance_Account__c = finacc1.id;
        cfa.Customer__c = a.Id;
        cfa.OwnerId = userInfo.getUserId();
        insert cfa; 
        
        Communication_Preferences__c cPref2 = new Communication_Preferences__c();
        cPref2.Finance_Account_Number__c=finacc1.id;
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
        
        //Creating Payment_Source__c records
        Payment_Source__c psor2 = new Payment_Source__c();
            psor2.Finance_Account_Number__c = finacc1.id; 
            psor2.Bank_Name__c = 'ICICkI';
            psor2.Payment_Source_Nickname__c ='1112' ;
            psor2.Bank_Account_Number__c = '1230000004560002';
            psor2.Bank_Account_Type__c = 'K';
            psor2.Bank_Routing_Number__c = 'IKBL01538';
            psor2.Preferred_Payment_Source__c = true;
            PSOR2.Status__c = 'Active';
        
        insert psor2; 
        System.assertNotEquals(Null,psor2.id);
        
        ChargentBase__Gateway__c cbg = new ChargentBase__Gateway__c();
        cbg.name = 'Cybersource';
        cbg.ChargentBase__Active__c = true;   
        insert cbg;
        
        ChargentOrders__ChargentOrder__c coco1 = new ChargentOrders__ChargentOrder__c();
            coco1.Finance_Account_Number__c = finacc1.id;
            coco1.Payment_Source_Nickname__c = psor2.id;
            coco1.Payment_Display_Status__c = 'Pending';
            coco1.ChargentOrders__Payment_Start_Date__c = system.today();
            coco1.ChargentOrders__Charge_Amount__c = 120.00;
            coco1.ChargentOrders__Payment_Status__c = 'Stopped';
            coco1.ChargentOrders__Payment_Frequency__c = 'Once';
            coco1.Payment_Type__c = 'P';
            coco1.Next_Withdrawal_Date__c=System.Today();
            coco1.RecordTypeId = Schema.SobjectType.ChargentOrders__ChargentOrder__c.getRecordTypeInfosByName().get('Payoff Payment').getRecordTypeId();
            insert coco1;
            
        PaymentCancelButton pcb=new PaymentCancelButton();
        String s= PaymentCancelButton.init(coco1.Id);
    }
    private static TestMethod void PaymentCancelTest1(){

    Honda_Finance__c mc=new Honda_Finance__c();
    mc.CutOff_Time__c=System.Today();
    insert mc;
    
    Finance_Account__c finacc1 = new Finance_Account__c();
            finacc1.Finance_Account_Number__c='1112';
            finacc1.Honda_Brand__c = 'AFS';
            finacc1.Payoff_Amount__c = 200.00;
            finacc1.Fl_Suppress_All_Notifications__c =true;
                 
        insert finacc1; 

       RecordType recordType = [ select Id, Name, DeveloperName from RecordType where SObjectType = 'Account' and IsPersonType = true limit 1 ];
        Account a= new Account( Salutation='Mr.', FirstName='Joe', LastName='Schmoe', RecordTypeId = recordType.id );
        insert a;
        
        Customer_Finance_Account__c cfa = new Customer_Finance_Account__c();
        cfa.Finance_Account__c = finacc1.id;
        cfa.Customer__c = a.Id;
        cfa.OwnerId = userInfo.getUserId();
        insert cfa; 
        
        Communication_Preferences__c cPref2 = new Communication_Preferences__c();
        cPref2.Finance_Account_Number__c=finacc1.id;
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
        
        //Creating Payment_Source__c records
        Payment_Source__c psor2 = new Payment_Source__c();
            psor2.Finance_Account_Number__c = finacc1.id; 
            psor2.Bank_Name__c = 'ICICkI';
            psor2.Payment_Source_Nickname__c ='1112' ;
            psor2.Bank_Account_Number__c = '1230000004560002';
            psor2.Bank_Account_Type__c = 'K';
            psor2.Bank_Routing_Number__c = 'IKBL01538';
            psor2.Preferred_Payment_Source__c = true;
            PSOR2.Status__c = 'Active';
        
        insert psor2; 
        System.assertNotEquals(Null,psor2.id);
        
        ChargentBase__Gateway__c cbg = new ChargentBase__Gateway__c();
        cbg.name = 'Cybersource';
        cbg.ChargentBase__Active__c = true;   
        insert cbg;
        
        ChargentOrders__ChargentOrder__c coco1 = new ChargentOrders__ChargentOrder__c();
            coco1.Finance_Account_Number__c = finacc1.id;
            coco1.Payment_Source_Nickname__c = psor2.id;
            coco1.Payment_Display_Status__c = 'Pending';
            coco1.ChargentOrders__Payment_Start_Date__c = system.today();
            coco1.ChargentOrders__Charge_Amount__c = 120.00;
            coco1.ChargentOrders__Payment_Status__c = 'Stopped';
            coco1.ChargentOrders__Payment_Frequency__c = 'Once';
            coco1.Payment_Type__c = 'P';
            coco1.Next_Withdrawal_Date__c=System.Today();
            coco1.RecordTypeId = Schema.SobjectType.ChargentOrders__ChargentOrder__c.getRecordTypeInfosByName().get('Recurring Payment').getRecordTypeId();
            insert coco1;
            
        PaymentCancelButton pcb=new PaymentCancelButton();
        String s= PaymentCancelButton.init(coco1.Id);
     }
     private static TestMethod void PaymentCancelTest2(){

    Honda_Finance__c mc=new Honda_Finance__c();
    mc.CutOff_Time__c=System.Today();
    insert mc;
    
    Finance_Account__c finacc1 = new Finance_Account__c();
            finacc1.Finance_Account_Number__c='1112';
            finacc1.Honda_Brand__c = 'AFS';
            finacc1.Payoff_Amount__c = 200.00;
            finacc1.Fl_Suppress_All_Notifications__c =true;
                 
        insert finacc1; 

       RecordType recordType = [ select Id, Name, DeveloperName from RecordType where SObjectType = 'Account' and IsPersonType = true limit 1 ];
        Account a= new Account( Salutation='Mr.', FirstName='Joe', LastName='Schmoe', RecordTypeId = recordType.id );
        insert a;
        
        Customer_Finance_Account__c cfa = new Customer_Finance_Account__c();
        cfa.Finance_Account__c = finacc1.id;
        cfa.Customer__c = a.Id;
        cfa.OwnerId = userInfo.getUserId();
        insert cfa; 
        
        Communication_Preferences__c cPref2 = new Communication_Preferences__c();
        cPref2.Finance_Account_Number__c=finacc1.id;
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
        
        //Creating Payment_Source__c records
        Payment_Source__c psor2 = new Payment_Source__c();
            psor2.Finance_Account_Number__c = finacc1.id; 
            psor2.Bank_Name__c = 'ICICkI';
            psor2.Payment_Source_Nickname__c ='1112' ;
            psor2.Bank_Account_Number__c = '1230000004560002';
            psor2.Bank_Account_Type__c = 'K';
            psor2.Bank_Routing_Number__c = 'IKBL01538';
            psor2.Preferred_Payment_Source__c = true;
            PSOR2.Status__c = 'Active';
        
        insert psor2; 
        System.assertNotEquals(Null,psor2.id);
        
        ChargentBase__Gateway__c cbg = new ChargentBase__Gateway__c();
        cbg.name = 'Cybersource';
        cbg.ChargentBase__Active__c = true;   
        insert cbg;
        
        ChargentOrders__ChargentOrder__c coco1 = new ChargentOrders__ChargentOrder__c();
            coco1.Finance_Account_Number__c = finacc1.id;
            coco1.Payment_Source_Nickname__c = psor2.id;
            coco1.Payment_Display_Status__c = 'Cancelled';
            coco1.ChargentOrders__Payment_Start_Date__c = system.today();
            coco1.ChargentOrders__Charge_Amount__c = 120.00;
            coco1.ChargentOrders__Payment_Status__c = 'Stopped';
            coco1.ChargentOrders__Payment_Frequency__c = 'Once';
            coco1.Payment_Type__c = 'P';
            coco1.Next_Withdrawal_Date__c=System.Today();
            coco1.RecordTypeId = Schema.SobjectType.ChargentOrders__ChargentOrder__c.getRecordTypeInfosByName().get('Recurring Payment').getRecordTypeId();
            insert coco1;
            
        PaymentCancelButton pcb=new PaymentCancelButton();
        String s= PaymentCancelButton.init(coco1.Id);
        }
    private static TestMethod void PaymentCancelTest3(){

    Honda_Finance__c mc=new Honda_Finance__c();
    mc.CutOff_Time__c=System.Today();
    insert mc;
    
    Finance_Account__c finacc1 = new Finance_Account__c();
            finacc1.Finance_Account_Number__c='1112';
            finacc1.Honda_Brand__c = 'AFS';
            finacc1.Payoff_Amount__c = 200.00;
            finacc1.Fl_Suppress_All_Notifications__c =true;
                 
        insert finacc1; 

       RecordType recordType = [ select Id, Name, DeveloperName from RecordType where SObjectType = 'Account' and IsPersonType = true limit 1 ];
        Account a= new Account( Salutation='Mr.', FirstName='Joe', LastName='Schmoe', RecordTypeId = recordType.id );
        insert a;
        
        Customer_Finance_Account__c cfa = new Customer_Finance_Account__c();
        cfa.Finance_Account__c = finacc1.id;
        cfa.Customer__c = a.Id;
        cfa.OwnerId = userInfo.getUserId();
        insert cfa; 
        
        Communication_Preferences__c cPref2 = new Communication_Preferences__c();
        cPref2.Finance_Account_Number__c=finacc1.id;
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
        
        //Creating Payment_Source__c records
        Payment_Source__c psor2 = new Payment_Source__c();
            psor2.Finance_Account_Number__c = finacc1.id; 
            psor2.Bank_Name__c = 'ICICkI';
            psor2.Payment_Source_Nickname__c ='1112' ;
            psor2.Bank_Account_Number__c = '1230000004560002';
            psor2.Bank_Account_Type__c = 'K';
            psor2.Bank_Routing_Number__c = 'IKBL01538';
            psor2.Preferred_Payment_Source__c = true;
            PSOR2.Status__c = 'Active';
        
        insert psor2; 
        System.assertNotEquals(Null,psor2.id);
        
        ChargentBase__Gateway__c cbg = new ChargentBase__Gateway__c();
        cbg.name = 'Cybersource';
        cbg.ChargentBase__Active__c = true;   
        insert cbg;
        
        ChargentOrders__ChargentOrder__c coco1 = new ChargentOrders__ChargentOrder__c();
            coco1.Finance_Account_Number__c = finacc1.id;
            coco1.Payment_Source_Nickname__c = psor2.id;
            coco1.Payment_Display_Status__c = 'Cancelled';
            coco1.ChargentOrders__Payment_Start_Date__c = system.today();
            coco1.ChargentOrders__Charge_Amount__c = 120.00;
            coco1.ChargentOrders__Payment_Status__c = 'Stopped';
            coco1.ChargentOrders__Payment_Frequency__c = 'Once';
            coco1.Payment_Type__c = 'P';
            coco1.Next_Withdrawal_Date__c=System.Today();
            coco1.RecordTypeId = Schema.SobjectType.ChargentOrders__ChargentOrder__c.getRecordTypeInfosByName().get('Payoff Payment').getRecordTypeId();
            insert coco1;
            
        PaymentCancelButton pcb=new PaymentCancelButton();
        String s= PaymentCancelButton.init(coco1.Id);
        }
}