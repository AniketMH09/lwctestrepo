@isTest
public class NEWCommunicationPreferenceAgent_Test{
    private static TestMethod void newCommnPrefTest(){

    Finance_Account__c finacc1 = new Finance_Account__c();
            finacc1.Finance_Account_Number__c='1112';
            finacc1.Honda_Brand__c = 'AFS';
            finacc1.Payoff_Amount__c = 200.00;
                 
        insert finacc1; 
        //ApexPages.CurrentPage().getParameters().put('finnumber','1112');
        System.assertNotEquals(Null, finacc1.id);
    Finance_Account__c finacc2 = new Finance_Account__c();
            finacc2.Finance_Account_Number__c='135319';
            finacc2.Honda_Brand__c = 'AFS';
            finacc2.Payoff_Amount__c = 200.00;
                 
        insert finacc2; 
        ApexPages.CurrentPage().getParameters().put('finnumber','1112');
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
        cPref2.Statements_Letters__c = 'Paper';
        
        insert cPref2;
        
        //Creating Payment_Source__c records
        Payment_Source__c psor2 = new Payment_Source__c();
            psor2.Finance_Account_Number__c = finacc2.id; 
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
        cbg.Name = 'Cybersource';
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
            coco1.RecordTypeId = Schema.SobjectType.ChargentOrders__ChargentOrder__c.getRecordTypeInfosByName().get('Payoff Payment').getRecordTypeId();
            insert coco1;
        
       PageReference pageRef = Page.NewCommunicationPref;
       Test.setCurrentPage(pageRef);
       ApexPages.StandardController sc = new ApexPages.standardController(cPref2);
       NEWCommunicationPreferenceInlineAgent n=new NEWCommunicationPreferenceInlineAgent(sc);
       List<Communication_Preferences__history > cList=n.gethistory();
       Pagereference p=n.updateEdeliveryPreference();
       Pagereference p1=n.updateReadOnly();
    }
        private static TestMethod void newCommnPrefTest1(){

    Finance_Account__c finacc1 = new Finance_Account__c();
            finacc1.Finance_Account_Number__c='1837';
            finacc1.Honda_Brand__c = 'AFS';
            finacc1.Payoff_Amount__c = 200.00;
                 
        insert finacc1; 
        //ApexPages.CurrentPage().getParameters().put('finnumber','1112');
        System.assertNotEquals(Null, finacc1.id);
    Finance_Account__c finacc2 = new Finance_Account__c();
            finacc2.Finance_Account_Number__c='13245';
            finacc2.Honda_Brand__c = 'AFS';
            finacc2.Payoff_Amount__c = 200.00;
                 
        insert finacc2; 
        ApexPages.CurrentPage().getParameters().put('finnumber','1112');
        System.assertNotEquals(Null, finacc2.id);
        
        Account a=new Account();
        a.Name='Test';
        insert a;
        
        Communication_Preferences__c cPref2 = new Communication_Preferences__c();
        cPref2.Finance_Account_Number__c=finacc2.id;
        cPref2.Customer__c=a.Id;
        cPref2.Payment_Confirmations_via_Email__c=true;
        cPref2.Payment_Reminders_via_Text__c=true;
        //cPref2.Email_Address__c= '';
        cPref2.Email_Address__c= 'testhonda@testorg.com';
        cPref2.EasyPay_Communications_via_Email__c= true;
        cPref2.Text_Number__c = '9999999999' ;
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
            psor2.Finance_Account_Number__c = finacc2.id; 
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
        cbg.Name = 'Cybersource';
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
            coco1.RecordTypeId = Schema.SobjectType.ChargentOrders__ChargentOrder__c.getRecordTypeInfosByName().get('Payoff Payment').getRecordTypeId();
            insert coco1;
        
       PageReference pageRef = Page.NewCommunicationPref;
       Test.setCurrentPage(pageRef);
       ApexPages.StandardController sc = new ApexPages.standardController(cPref2);
       NEWCommunicationPreferenceInlineAgent n=new NEWCommunicationPreferenceInlineAgent(sc);
       List<Communication_Preferences__history > cList=n.gethistory();
       Pagereference p=n.updateEdeliveryPreference();
       Pagereference p1=n.updateReadOnly();
    }
        private static TestMethod void newCommnPrefTest2(){

    Finance_Account__c finacc1 = new Finance_Account__c();
            finacc1.Finance_Account_Number__c='1973773';
            finacc1.Honda_Brand__c = 'AFS';
            finacc1.Payoff_Amount__c = 200.00;
                 
        insert finacc1; 
        //ApexPages.CurrentPage().getParameters().put('finnumber','1112');
        System.assertNotEquals(Null, finacc1.id);
    Finance_Account__c finacc2 = new Finance_Account__c();
            finacc2.Finance_Account_Number__c='133245';
            finacc2.Honda_Brand__c = 'AFS';
            finacc2.Payoff_Amount__c = 200.00;
                 
        insert finacc2; 
        ApexPages.CurrentPage().getParameters().put('finnumber','1112');
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
        
        //Creating Payment_Source__c records
        Payment_Source__c psor2 = new Payment_Source__c();
            psor2.Finance_Account_Number__c = finacc2.id; 
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
        cbg.Name = 'Cybersource';
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
            coco1.RecordTypeId = Schema.SobjectType.ChargentOrders__ChargentOrder__c.getRecordTypeInfosByName().get('Payoff Payment').getRecordTypeId();
            insert coco1;
        
       PageReference pageRef = Page.NewCommunicationPref;
       Test.setCurrentPage(pageRef);
       ApexPages.StandardController sc = new ApexPages.standardController(cPref2);
       NEWCommunicationPreferenceInlineAgent n=new NEWCommunicationPreferenceInlineAgent(sc);
       List<Communication_Preferences__history > cList=n.gethistory();
       Pagereference p=n.updateEdeliveryPreference();
       Pagereference p1=n.updateReadOnly();
    }
}