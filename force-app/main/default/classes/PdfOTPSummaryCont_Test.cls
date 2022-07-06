/*************************************************
Author      :  Sajila Kadayaprath
Description :  Test class for PdfOTPSummaryCont
*************************************************/

@isTest
public class PdfOTPSummaryCont_Test{
    private static TestMethod void pdfOTPSummary(){
        Finance_Account__c finacc = new Finance_Account__c();
        finacc.Finance_Account_Number__c='2541';
        finacc.Honda_Brand__c='HFS';
        finacc.Name = '2541';
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
        
        ChargentOrders__ChargentOrder__c cn= [select Confirmation_Number__c from ChargentOrders__ChargentOrder__c where id = : ch.id];
        
        System.AssertNotEquals(null,cn.Confirmation_Number__c);
        
        PageReference pageRef = Page.PdfOTPSummary;
        Test.setCurrentPage(pageRef);
        ApexPages.CurrentPage().getparameters().put('OTPid','testId');
        ApexPages.CurrentPage().getparameters().put('isHonda','true');
        ApexPages.CurrentPage().getparameters().put('StdOTPNumber',cn.Confirmation_Number__c);
        ApexPages.CurrentPage().getparameters().put('PrincipalNumber',cn.Confirmation_Number__c);
        ApexPages.CurrentPage().getparameters().put('finnumber','1111');
        //ApexPages.CurrentPage().getparameters().put('FinRecordId',finacc.Id);
        //ApexPages.StandardController sc = new ApexPages.standardController(paysourcerecord);
        PdfOTPSummaryCont p=new PdfOTPSummaryCont();
      
        //p.FinRecordId=finacc.Id;
    }
    private static TestMethod void pdfOTPSummary1(){
        Finance_Account__c finacc = new Finance_Account__c();
        finacc.Finance_Account_Number__c='2541';
        finacc.Honda_Brand__c='HFS';
        finacc.Name = '2541';
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
        
        ChargentOrders__ChargentOrder__c cn= [select Confirmation_Number__c from ChargentOrders__ChargentOrder__c where id = : ch.id];
        
        System.AssertNotEquals(null,cn.Confirmation_Number__c);
        
        PageReference pageRef = Page.PdfOTPSummary;
        Test.setCurrentPage(pageRef);
        ApexPages.CurrentPage().getparameters().put('OTPid','testId');
        ApexPages.CurrentPage().getparameters().put('isHonda','true');
        ApexPages.CurrentPage().getparameters().put('StdOTPNumber','2345');
        ApexPages.CurrentPage().getparameters().put('finnumber','1111');
        ApexPages.CurrentPage().getparameters().put('PrincipalNumber',cn.Confirmation_Number__c);
        //ApexPages.CurrentPage().getparameters().put('FinRecordId',finacc.Id);
        //ApexPages.StandardController sc = new ApexPages.standardController(paysourcerecord);
        PdfOTPSummaryCont p=new PdfOTPSummaryCont();
      
        //p.FinRecordId=finacc.Id;
    }
}