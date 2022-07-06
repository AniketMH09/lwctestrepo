@isTest
public class AHFC_payOffCalendarController_Test {
    
    static Finance_Account__c finacc;
    static Finance_Account__c finacc2;
    
    static testMethod void AHFC_PayoffCalendar_Test() {
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
        insert finacc;
        String recID=finacc.Id;
        AHFC_PayoffCalendarController.financeAccountDetails fad1  = AHFC_PayoffCalendarController.fetchFinanceAccountDetails(recID);
        
        finacc2 = new Finance_Account__c();
        
        finacc2.Finance_Account_Number__c='2541345659';
        finacc2.Honda_Brand__c='AFS';
        finacc2.Fl_Recurring_Payment_Eligible_Agent__c=true;
        finacc2.Region_Code__c='BKC';
        finacc2.Account_Type__c='Balloon';
        finacc2.Fl_Refinanced__c=true;
        finacc2.Payment_Due_Date__c=System.Today();
        finacc2.Fl_Suppress_All_Notifications__c = false;
        finacc2.AHFC_Product_Nickname__c ='test';
        finacc2.Fl_DDC_Eligibility__c=true;
        finacc2.FL_LE_Eligibility__c=true;
        finacc2.AHFC_Total_days_past_due__c=25;
        finacc2.AHFC_Web_Payoff_Calendar__c='N';
        insert finacc2;
        String recID2=finacc2.Id;
        AHFC_PayoffCalendarController.financeAccountDetails fad2 = AHFC_PayoffCalendarController.fetchFinanceAccountDetails(recID2);
        
        finacc2.Honda_Brand__c = 'HFS';
        finacc2.AHFC_Web_Payoff_Calendar__c = 'A';
        finacc2.Account_Type__c = 'Lease';
        update finacc2;
        AHFC_PayoffCalendarController.financeAccountDetails fad3  = AHFC_PayoffCalendarController.fetchFinanceAccountDetails(recID2);
        
        system.assertEquals(fad1.isAcura, true, 'error in data validation');
        system.assertEquals(fad1.isAccHappyPath, true, 'error in data validation');
        system.assertEquals(fad2.isAcura, true, 'error in data validation');
        system.assertEquals(fad3.isHonda, true, 'error in data validation');
        system.assertEquals(fad2.isAcc500, true, 'error in data validation');
        system.assertEquals(fad3.isAccClosed, true, 'error in data validation');
        system.assertEquals(fad3.isPurchase, true, 'error in data validation');
            
        Test.stopTest();        
            
    }

}