@isTest
public class PaymentReinstateButton_Test{

private static TestMethod void PRB_Init(){
    Finance_Account__c finacc1 = new Finance_Account__c();
            finacc1.Finance_Account_Number__c='1112';
            finacc1.Honda_Brand__c = 'AFS';
            finacc1.Payoff_Amount__c = 200.00;
            finacc1.Fl_Suppress_All_Notifications__c =true;
                 
        insert finacc1; 
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
            //coco1.RecordTypeId = Schema.SobjectType.ChargentOrders__ChargentOrder__c.getRecordTypeInfosByName().get('Payoff Payment').getRecordTypeId();
            coco1.RecordTypeId = Schema.SobjectType.ChargentOrders__ChargentOrder__c.getRecordTypeInfosByName().get('Recurring Payment').getRecordTypeId();
            insert coco1;

Test.startTest();
//PaymentReinstateButton prb = new PaymentReinstateButton();
String s = PaymentReinstateButton.init(coco1.Id);
Test.stopTest();
}

private static TestMethod void PRB_Init2(){
    Finance_Account__c finacc1 = new Finance_Account__c();
            finacc1.Finance_Account_Number__c='1112';
            finacc1.Honda_Brand__c = 'AFS';
            finacc1.Payoff_Amount__c = 200.00;
            finacc1.Fl_Suppress_All_Notifications__c =true;
                 
        insert finacc1; 
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

        ChargentOrders__ChargentOrder__c coco1 = new ChargentOrders__ChargentOrder__c();
            coco1.Finance_Account_Number__c = finacc1.id;
            coco1.Payment_Source_Nickname__c = psor2.id;
            coco1.Payment_Display_Status__c = 'Cleared to GL';
            coco1.ChargentOrders__Payment_Start_Date__c = system.today();
            coco1.ChargentOrders__Charge_Amount__c = 120.00;
            coco1.ChargentOrders__Payment_Status__c = 'Stopped';
            coco1.ChargentOrders__Payment_Frequency__c = 'Once';
            coco1.Payment_Type__c = 'P';
            coco1.Next_Withdrawal_Date__c=System.Today();
            coco1.ChargentOrders__Charge_Date__c = '31';
            coco1.RecordTypeId = Schema.SobjectType.ChargentOrders__ChargentOrder__c.getRecordTypeInfosByName().get('Recurring Payment').getRecordTypeId();
            insert coco1;

Test.startTest();
//PaymentReinstateButton prb = new PaymentReinstateButton();
    try{
String s = PaymentReinstateButton.init(coco1.Id);
    }Catch(Exception e){}
Test.stopTest();
}

}