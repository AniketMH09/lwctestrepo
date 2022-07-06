/**************************************************************************
Author      :  Sajila Kadayaprath
Description :  Test class for recurringStatusUpdate 
*****************************************************************************/

@isTest
public class recurringStatusUpdate_Test{
    private static TestMethod void testRecurringStatus(){
    
        Finance_Account__c finacc = new Finance_Account__c();
        finacc.Finance_Account_Number__c='1111';
        finacc.Past_Amount_Due__c=2000;
        finacc.Payoff_Amount__c=1000;
        insert finacc;
        
        Id accId=CreateObjectTest.createpersonAccount();
        Id cId=CreateObjectTest.createCommunicationPreferences(finacc.Id,accId);
        Id payId=CreateObjectTest.createPaymentSource(finacc.Id);
        String payNickName=(String)payId;
        
        ChargentBase__Gateway__c cbg = new ChargentBase__Gateway__c();
        cbg.Name = 'Cybersource';
        insert cbg;
        
        ChargentOrders__ChargentOrder__c ch=new ChargentOrders__ChargentOrder__c ();
        ch.Finance_Account_Number__c=finacc.Id;
        ch.Payment_Type__c = 'O';
        ch.ChargentOrders__Charge_Amount__c=5000;
        //RecordType rt = [select Id from RecordType where Name ='Recurring Payment' and sObjectType = 'ChargentOrders__ChargentOrder__c']; 
        ch.RecordTypeId=Schema.SobjectType.ChargentOrders__ChargentOrder__c.getRecordTypeInfosByName().get('Recurring Payment').getRecordTypeId();
        ch.ChargentOrders__Payment_Start_Date__c=System.Today()+2;
        ch.Payment_Display_Status__c='Stopped';
        ch.ChargentOrders__Payment_Status__c='Recurring';
        ch.ChargentOrders__Payment_Frequency__c='Once';
        ch.Payment_Source_Nickname__c=payNickName;
        
        TriggerRun.firstRun=true;
        
        insert ch;
        
        TriggerRun.firstRun=true;
        
        ch.Payment_Display_Status__c='Pending';
        update ch;
        
        TriggerRun.firstRun=true;
        
        ch.RecordTypeId=Schema.SobjectType.ChargentOrders__ChargentOrder__c.getRecordTypeInfosByName().get('Payoff Payment').getRecordTypeId();
        ch.Payment_Display_Status__c='Stopped';
        update ch;
        
        TriggerRun.firstRun=true;
        
        ch.Payment_Display_Status__c='Pending';
        update ch;
    }
}