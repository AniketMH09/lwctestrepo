/*************************************************
Author      :  Sajila Kadayaprath
Description :  Test class for PDFEasypaySummaryCont
*************************************************/

@isTest
public class PDFEasypaySummaryCont_Test{
    private static TestMethod void pdfEasyPay(){
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
        ch.ChargentOrders__Charge_Date__c = '29';
        ch.RecordTypeId=Schema.SobjectType.ChargentOrders__ChargentOrder__c.getRecordTypeInfosByName().get('Recurring Payment').getRecordTypeId();
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
        
        PageReference pageRef = Page.PDFEasypaySummary;
        Test.setCurrentPage(pageRef);
        ApexPages.CurrentPage().getparameters().put('RPID',ch.Id);
        ApexPages.CurrentPage().getparameters().put('finnumber',finacc.Finance_Account_Number__c);
        ApexPages.CurrentPage().getparameters().put('WithdrawDate',System.Today().format());
        //ApexPages.StandardController sc = new ApexPages.standardController(paysourcerecord);
        PDFEasypaySummaryCont p=new PDFEasypaySummaryCont();
        Decimal d=p.TotalPaymentAmount;
        //p.FinRecordId=finacc.Id;
    }
    private static TestMethod void pdfEasyPay1(){
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
        ch.RecordTypeId=Schema.SobjectType.ChargentOrders__ChargentOrder__c.getRecordTypeInfosByName().get('Recurring Payment').getRecordTypeId();
        ch.ChargentOrders__Charge_Date__c = '29';
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
        
        PageReference pageRef = Page.PDFEasypaySummary;
        Test.setCurrentPage(pageRef);
        ApexPages.CurrentPage().getparameters().put('RPID','1111');
        ApexPages.CurrentPage().getparameters().put('finnumber',finacc.Finance_Account_Number__c);
        ApexPages.CurrentPage().getparameters().put('WithdrawDate',System.Today().format());
        //ApexPages.StandardController sc = new ApexPages.standardController(paysourcerecord);
        PDFEasypaySummaryCont p=new PDFEasypaySummaryCont();
        //p.FinRecordId=finacc.Id;
    }
    private static TestMethod void pdfEasyPay2(){
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
   
        Payment_Source__c paysourcerecord = new Payment_Source__c();
        paysourcerecord.Bank_Name__c='TestCitiBank';
        paysourcerecord.Payment_Source_Nickname__c='TestABC';
        paysourcerecord.Bank_Account_Type__c='TestSaving';
        paysourcerecord.Preferred_Payment_Source__c=true;
        paysourcerecord.Bank_Account_Number__c='Test1234567';
        paysourcerecord.Finance_Account_Number__c = finacc.Id;
        paysourcerecord.Status__c='Active';
        insert paysourcerecord;
        
        PageReference pageRef = Page.PDFEasypaySummary;
        Test.setCurrentPage(pageRef);
        ApexPages.CurrentPage().getparameters().put('RPID',null);
        ApexPages.CurrentPage().getparameters().put('finnumber',finacc.Finance_Account_Number__c);
        ApexPages.CurrentPage().getparameters().put('WithdrawDate',System.Today().format());
        ApexPages.CurrentPage().getparameters().put('RPID','111');

        //ApexPages.StandardController sc = new ApexPages.standardController(paysourcerecord);
        PDFEasypaySummaryCont p=new PDFEasypaySummaryCont();
        //p.FinRecordId=finacc.Id;
    }
}