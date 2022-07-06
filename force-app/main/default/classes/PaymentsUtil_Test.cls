@isTest
public class PaymentsUtil_Test{
    private static TestMethod void fetchBankAccSelecOptions(){

    Finance_Account__c finacc1 = new Finance_Account__c();
            finacc1.Finance_Account_Number__c='1112';
            finacc1.Honda_Brand__c = 'AFS';
            finacc1.Payoff_Amount__c = 200.00;
                 
        insert finacc1; 
        //ApexPages.CurrentPage().getParameters().put('finnumber','1112');
        System.assertNotEquals(Null, finacc1.id);
    Finance_Account__c finacc2 = new Finance_Account__c();
            finacc2.Finance_Account_Number__c='123242';
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
        
        //Creating Payment_Source__c records
        Payment_Source__c psor1 = new Payment_Source__c();
            psor1.Finance_Account_Number__c = finacc2.id; 
            psor1.Bank_Name__c = 'ICICkI';
            psor1.Payment_Source_Nickname__c ='1112' ;
            psor1.Bank_Account_Number__c = '1230000004560002';
            psor1.Bank_Account_Type__c = 'K';
            psor1.Bank_Routing_Number__c = 'IKBL01538';
            psor1.Status__c = 'Active';
            //psor1.Preferred_Payment_Source__c = true;
        
        insert psor1; 
        System.assertNotEquals(Null,psor1.id);
        
         Payment_Source__c psor3 = new Payment_Source__c();
            psor3.Finance_Account_Number__c = finacc2.id; 
            psor3.Bank_Name__c = 'ICICkI';
            psor3.Payment_Source_Nickname__c ='1112' ;
            psor3.Bank_Account_Number__c = '1230000004560002';
            psor3.Bank_Account_Type__c = 'K';
            psor3.Bank_Routing_Number__c = 'IKBL01538';
            psor3.Status__c = 'Active';
            
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
        
        List<Payment_Source__c> psorList = new List<Payment_Source__c>();
        psorList.add(psor2);
        psorList.add(psor1);
        
        Map<Id,Payment_Source__c> psorMap = new Map<Id,Payment_Source__c>(psorList);
        PaymentsUtils pu=new PaymentsUtils();
        PaymentsUtils.GetBankToken(psor3);
        String s=psor1.Id;
        PaymentsUtils.fetchBankAccSelecOptions(finacc2.Finance_Account_Number__c,'EDIT',s);
        PaymentsUtils.fetchBankAccs(finacc2.Id);
        PaymentsUtils.CheckPaymentCounts(finacc1.Id);
        PaymentsUtils.fetchBankAccSelecOptions(finacc2.Finance_Account_Number__c,'NEW',s);
       
       coco1.Payment_Display_Status__c ='Posted';
       update coco1;
       
       PaymentsUtils.CheckPaymentCounts(finacc1.Id);
}
}