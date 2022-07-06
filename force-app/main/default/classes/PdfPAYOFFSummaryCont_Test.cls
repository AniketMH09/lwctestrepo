/*************************************************
Author      :  Sajila Kadayaprath
Description :  Test class for PdfPAYOFFSummaryCont
*************************************************/

@isTest
public class PdfPAYOFFSummaryCont_Test{
    private static TestMethod void pdfPayOffSummary(){
        Finance_Account__c finacc = new Finance_Account__c();
        finacc.Finance_Account_Number__c='2541';
        finacc.Honda_Brand__c='HFS';
        insert finacc;
        
        Account a=new Account();
        a.Name='Test';
        insert a;
    
        Communication_Preferences__c cPref=new Communication_Preferences__c();
        cPref.Finance_Account_Number__c=finacc.Id;
        cPref.Customer__c=a.Id;
        cPref.Payment_Confirmations_via_Email__c=true;
        cPref.Payment_Reminders_via_Text__c=true;
        cPref.Text_Number__c='9992223334';
        insert cPref;
        
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
        ch.Payment_Display_Status__c='Pending';
        ch.RecordTypeId=Schema.SobjectType.ChargentOrders__ChargentOrder__c.getRecordTypeInfosByName().get('Payoff Payment').getRecordTypeId();
        insert ch;
        
        Payment_Source__c paysourcerecord = new Payment_Source__c();
        paysourcerecord.Bank_Name__c='TestCitiBank';
        paysourcerecord.Payment_Source_Nickname__c='TestABC';
        paysourcerecord.Bank_Account_Type__c='TestSaving';
        paysourcerecord.Preferred_Payment_Source__c=true;
        paysourcerecord.Bank_Account_Number__c='Test1234567';
        paysourcerecord.Finance_Account_Number__c = finacc.Id;
        paysourcerecord.Status__c='Active';
        insert paysourcerecord;
        
        PageReference pageRef = Page.PdfPAYOFFSummary;
        Test.setCurrentPage(pageRef);
        ApexPages.CurrentPage().getparameters().put('Payoffid',ch.Id);
        ApexPages.CurrentPage().getparameters().put('isHonda','true');
        ApexPages.CurrentPage().getparameters().put('finnumber',finacc.Finance_Account_Number__c);
        //ApexPages.StandardController sc = new ApexPages.standardController(paysourcerecord);
        PdfPAYOFFSummaryCont p=new PdfPAYOFFSummaryCont();
        //Decimal d=p.TotalPaymentAmount;
        //p.FinRecordId=finacc.Id;
    }
 }