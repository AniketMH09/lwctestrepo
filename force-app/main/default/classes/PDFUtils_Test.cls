/*************************************************
Author      :  Sajila Kadayaprath
Description :  Test class for PDFUtils
*************************************************/

@isTest
public class PDFUtils_Test{
    private static TestMethod void pdfUtils(){
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
        cPref.Payment_Confirmations_via_Text__c=true;
        cPref.Payment_Reminders_via_Text__c=true;
        cPref.EasyPay_Communications_via_Email__c=true;
        cPref.EasyPay_Communications_via_Text__c=true;
        cPref.Text_Number__c='9992223334';
        insert cPref;
           
        String s=PDFUtils.SetSummaryMessage('Online','Processed',System.Today().format(),cPref);
        String e=PDFUtils.SetEasyPaySummaryMessage('Processed',System.Today().format(),cPref);
        
        cPref.Payment_Confirmations_via_Email__c=false;
        cPref.Payment_Confirmations_via_Text__c=true;
        cPref.EasyPay_Communications_via_Email__c=false;
        cPref.EasyPay_Communications_via_Text__c=true;
        update cPref;
        String s1=PDFUtils.SetSummaryMessage('Online','Processed',System.Today().format(),cPref);
        String e1=PDFUtils.SetEasyPaySummaryMessage('Processed',System.Today().format(),cPref);
        
        cPref.Payment_Confirmations_via_Email__c=true;
        cPref.Payment_Confirmations_via_Text__c=false;
        cPref.EasyPay_Communications_via_Email__c=true;
        cPref.EasyPay_Communications_via_Text__c=false;
        update cPref;
        String s2=PDFUtils.SetSummaryMessage('Online','Processed',System.Today().format(),cPref);
        String e2=PDFUtils.SetEasyPaySummaryMessage('Processed',System.Today().format(),cPref);
        
        cPref.Payment_Confirmations_via_Email__c=false;
        cPref.Payment_Confirmations_via_Text__c=false;
        cPref.EasyPay_Communications_via_Email__c=false;
        cPref.EasyPay_Communications_via_Text__c=false;
        update cPref;
        String s3=PDFUtils.SetSummaryMessage('Online','Processed',System.Today().format(),cPref);
        String e3=PDFUtils.SetEasyPaySummaryMessage('Processed',System.Today().format(),cPref);  
        
        String n=PDFUtils.FmtDate(System.Today());
        String n1=PDFUtils.FmtDate(null);
    }
 }