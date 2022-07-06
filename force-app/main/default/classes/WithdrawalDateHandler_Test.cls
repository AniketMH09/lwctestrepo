/***************************************************
Author      :  Sajila Kadayaprath
Description :  Test class for WithdrawalDateHandler
***************************************************/

@isTest
public class WithdrawalDateHandler_Test{
    private static TestMethod void testWithdrawalDateHandler(){
    
    List<ChargentOrders__ChargentOrder__c> cList=new List<ChargentOrders__ChargentOrder__c>();
    Map<Id,ChargentOrders__ChargentOrder__c> cMap=new Map<Id,ChargentOrders__ChargentOrder__c>();
    
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
    ch.ChargentOrders__Payment_Start_Date__c =System.today();
    ch.Next_Withdrawal_Date__c =System.Today()+10;
    ch.RecordTypeId=Schema.SobjectType.ChargentOrders__ChargentOrder__c.getRecordTypeInfosByName().get('Recurring Payment').getRecordTypeId();
    Test.startTest();
    //Recurring -Once-Insert
    insert ch;
    
    cList.add(ch);
    cMap.put(ch.Id,ch);
    
    WithdrawalDateHandler w=new WithdrawalDateHandler();
    WithdrawalDateHandler.onAfterInsert(cList);
    
    ch.Next_Withdrawal_Date__c =System.Today()+15;
    update ch;
    
    try{
     integer a=5/0;
    }
    catch(Exception e){
        WithdrawalDateHandler.onAfterUpdate(cList,cMap);
        WithdrawalDateHandler.errorLogMethod(e);
    }
    Test.stopTest();       
    }
 }