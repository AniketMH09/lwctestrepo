/**************************************************************************
Author      :  Sajila Kadayaprath
Description :  Test class for RecordTypeSelection 
*****************************************************************************/

@isTest
public class RecordTypeSelection_Test{
    private static TestMethod void recordTypeSelectioncase1(){
    
        Finance_Account__c finacc = new Finance_Account__c();
        finacc.Finance_Account_Number__c='1111';
        finacc.Past_Amount_Due__c=2000;
        insert finacc;
    
        ChargentBase__Gateway__c cbg = new ChargentBase__Gateway__c();
        cbg.Name = 'Cybersource';
        insert cbg;
        
        ChargentOrders__ChargentOrder__c ch=new ChargentOrders__ChargentOrder__c ();
        ch.Finance_Account_Number__c=finacc.Id;
        ch.Payment_Type__c = 'O';
        ch.ChargentOrders__Charge_Amount__c=5000;
        //RecordType rt = [select Id from RecordType where Name ='Standard One-Time Payment' and sObjectType = 'ChargentOrders__ChargentOrder__c']; 
        ch.RecordTypeId=Schema.SobjectType.ChargentOrders__ChargentOrder__c.getRecordTypeInfosByName().get('Standard One-Time Payment').getRecordTypeId();
        ch.Payment_Display_Status__c='Processing';
        ch.ChargentOrders__Payment_Start_Date__c=System.Today();
        insert ch;
    
        PageReference pageRef = Page.RecordTypeSelectionPage;
        Test.setCurrentPage(pageRef);
        ApexPages.CurrentPage().getparameters().put('finnumber', finacc.Finance_Account_Number__c);
    
        ApexPages.StandardController sc = new ApexPages.standardController(finacc);
        RecordTypeSelection rts=new RecordTypeSelection (sc);
        pagereference p=rts.init();
        Pagereference cancel=rts.CancelAction();
        rts.Selected='One_Time_Payment';
        Pagereference cont=rts.ContinueAction();
        rts.Selected='Payoff_Payment';
        Pagereference cont1=rts.ContinueAction();
        rts.Selected='Principal_One_Time_Payment';
        Pagereference cont2=rts.ContinueAction();
        rts.Selected='Recurring_Payment';
        Pagereference cont3=rts.ContinueAction();  
    }
    private static TestMethod void recordTypeSelectioncase2(){

        Finance_Account__c finacc = new Finance_Account__c();
        finacc.Finance_Account_Number__c='1112';
        finacc.Past_Amount_Due__c=2000;
        insert finacc;
        
        ChargentBase__Gateway__c cbg = new ChargentBase__Gateway__c();
        cbg.Name = 'Cybersource';
        insert cbg;
        
        ChargentOrders__ChargentOrder__c ch=new ChargentOrders__ChargentOrder__c ();
        ch.Finance_Account_Number__c=finacc.Id;
        ch.Payment_Type__c = 'O';
        ch.ChargentOrders__Charge_Amount__c=5000;
        //RecordType rt = [select Id from RecordType where Name ='Standard One-Time Payment' and sObjectType = 'ChargentOrders__ChargentOrder__c']; 
        ch.RecordTypeId=Schema.SobjectType.ChargentOrders__ChargentOrder__c.getRecordTypeInfosByName().get('Standard One-Time Payment').getRecordTypeId();
        ch.Payment_Display_Status__c='Processing';
        ch.ChargentOrders__Payment_Start_Date__c=System.Today();
        insert ch;
        
        PageReference pageRef = Page.RecordTypeSelectionPage;
        Test.setCurrentPage(pageRef);
        ApexPages.CurrentPage().getparameters().put('finnumber', finacc.Finance_Account_Number__c);
    
        ApexPages.StandardController sc = new ApexPages.standardController(finacc);
        RecordTypeSelection rts=new RecordTypeSelection (sc);
        
        rts.Selected='Recurring_Payment';
        pagereference p=rts.init();
        Pagereference cont3=rts.ContinueAction();
    }
     private static TestMethod void recordTypeSelectioncase3(){

        Finance_Account__c finacc = new Finance_Account__c();
        finacc.Finance_Account_Number__c='1112';
        finacc.Past_Amount_Due__c=2000;
        insert finacc;

        PageReference pageRef = Page.RecordTypeSelectionPage;
        Test.setCurrentPage(pageRef);
        ApexPages.CurrentPage().getparameters().put('finnumber', finacc.Finance_Account_Number__c);
    
        ApexPages.StandardController sc = new ApexPages.standardController(finacc);
        RecordTypeSelection rts=new RecordTypeSelection (sc);
        
        rts.Selected='Recurring_Payment';
        pagereference p=rts.init();
        Pagereference cont3=rts.ContinueAction();
    }
}