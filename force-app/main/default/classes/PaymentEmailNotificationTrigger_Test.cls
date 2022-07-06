@isTest
public class PaymentEmailNotificationTrigger_Test
{
    private static testMethod void paymentEmail()
    {
        Finance_Account__c finacc = new Finance_Account__c();
        finacc.Finance_Account_Number__c='1000001';
        finacc.Honda_Brand__c='AFS';
        //finacc.Customer__c=cfa.Id;
        insert finacc;
        
        ChargentBase__Gateway__c cbg = new ChargentBase__Gateway__c();
        cbg.Name = 'Cybersource';
        insert cbg;
        
        ChargentOrders__ChargentOrder__c ch=new ChargentOrders__ChargentOrder__c();
        ch.Finance_Account_Number__c=finacc.Id;
        ch.Payment_Type__c = 'O';
        ch.ChargentOrders__Charge_Amount__c=5000;
        ch.ChargentOrders__Payment_Status__c='Recurring';
        ch.ChargentOrders__Payment_Frequency__c='Once';
        ch.Next_Withdrawal_Date__c=System.Today()+20;
        insert ch;
        
        ch.Payment_Display_Status__c ='Pending';
        update ch;
        
        ch.Payment_Display_Status__c ='Cancelled';
        update ch;
        
        ch.Payment_Display_Status__c ='Suspended';
        update ch; 
    }
}