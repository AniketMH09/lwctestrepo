/**************************************************************************
Author      :  Sajila Kadayaprath
Description :  Test class for VFC05_PayOffPayment
*****************************************************************************/

@isTest
public class VFC05_PayOffPayment_Test{
    private static TestMethod void testPayOffPay(){
    
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
    
        PageReference pageRef = Page.VFP11_PayoffPaymentPage;
        Test.setCurrentPage(pageRef);
        //ApexPages.CurrentPage().getparameters().put('finnumber', finacc.Finance_Account_Number__c);
        ApexPages.CurrentPage().getparameters().put('id', ch.Id);
    
        ApexPages.StandardController sc = new ApexPages.standardController(ch);
        VFC05_PayOffPayment pop=new VFC05_PayOffPayment(sc);
        pop.EditFunction();
        pageReference  p=pop.PageRedirect();
        pageReference  p1=pop.DeleteFuntion();
        
    }
}