@isTest
public class AHFC_singleStatementController_Test {
    
    static Finance_Account__c finacc;
    
    static testMethod void AHFC_singleStatement_Test() {
        Test.startTest();
        finacc = new Finance_Account__c();
        
        finacc.Finance_Account_Number__c='2541345676';
        finacc.Honda_Brand__c='AFS';
        finacc.Fl_Recurring_Payment_Eligible_Agent__c=true;
        finacc.Region_Code__c='BKC';
        finacc.Account_Type__c='Balloon';
        finacc.Fl_Refinanced__c=true;
        finacc.Payment_Due_Date__c=System.Today();
        finacc.Fl_Suppress_All_Notifications__c = false;
        finacc.AHFC_Product_Nickname__c ='test';
        finacc.Fl_DDC_Eligibility__c=true;
        finacc.FL_LE_Eligibility__c=true;
        finacc.AHFC_Total_days_past_due__c=25;
        finacc.AHFC_Web_Payoff_Calendar__c='y';
        finacc.Account_Type__c= 'Lease';
        insert finacc;
        
        Communication_Preferences__c comPref = new Communication_Preferences__c();
        comPref.Email_Address__c = '123@123.com';
        comPref.Statements_Letters__c = 'eDelivery';
        comPref.Finance_Account_Number__c = finacc.Id;
        insert comPref;
        
        aHFC_singleStatementController.singleStatementDetails ex = new   aHFC_singleStatementController.singleStatementDetails();
        ex=aHFC_singleStatementController.fetchFinanceAccountDetails(finacc.Id);
        System.assertEquals(ex.isAcura,true);
        System.assertEquals(ex.isLeaseAccount,true);
        Test.stopTest();       
    }
}