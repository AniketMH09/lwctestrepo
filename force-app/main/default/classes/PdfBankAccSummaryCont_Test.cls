/*************************************************
Author      :  Sajila Kadayaprath
Description :  Test class for PdfBankAccSummaryCont 
*************************************************/

@isTest
public class PdfBankAccSummaryCont_Test{
    private static TestMethod void pdfBankAccSummary(){
        Finance_Account__c finacc = new Finance_Account__c();
        finacc.Finance_Account_Number__c='2541';
        finacc.Honda_Brand__c='HFS';
        finacc.Name ='2541';
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
        
        PageReference pageRef = Page.PdfBankAccSummary;
        Test.setCurrentPage(pageRef);
        ApexPages.CurrentPage().getparameters().put('BankAccId',paysourcerecord.Id);
        //ApexPages.StandardController sc = new ApexPages.standardController(paysourcerecord);
        PdfBankAccSummaryCont p=new PdfBankAccSummaryCont();
    }
}