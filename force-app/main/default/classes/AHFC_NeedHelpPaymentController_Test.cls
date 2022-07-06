/* Apex Class Name       :    AHFC_NeedHelpPaymentController_Test
* Description        :    Test Class for AHFC_NeedHelpPaymentController_Test
* Modification Log   :
* ---------------------------------------------------------------------------
* Developer                   Date                   Description
* ---------------------------------------------------------------------------
* Prabu Mohanasundaram               6th JUNE 2021              Created
*********************************************************************************/

@isTest
public class AHFC_NeedHelpPaymentController_Test {
    static testMethod void AHFC_NeedHelp_Test() {
     Test.startTest();
     Finance_Account__c finacc = new Finance_Account__c();
        finacc.Finance_Account_Number__c='2541345678';
        finacc.Honda_Brand__c='HFS';
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
        insert finacc;
        AHFC_NeedHelpPaymentController.NeedHelpWrapper wrapper = new AHFC_NeedHelpPaymentController.NeedHelpWrapper();
        wrapper = AHFC_NeedHelpPaymentController.eligibiltyFlagRetrieve(String.valueOf(finacc.id));
        System.assertEquals(wrapper.FinanceAccNo, finacc.Finance_Account_Number__c,'Finance Account number');
        Test.stopTest();
}
    static testMethod void AHFC_NeedHelp_Test2() {
     Test.startTest();
     Finance_Account__c finacc = new Finance_Account__c();
        finacc.Finance_Account_Number__c='25413456798';
        finacc.Honda_Brand__c='HFSS';
        finacc.Fl_Recurring_Payment_Eligible_Agent__c=true;
        finacc.Region_Code__c='BKCW';
        finacc.Account_Type__c='Balloons';
        finacc.Fl_Refinanced__c=true;
        finacc.Payment_Due_Date__c=System.Today();
        finacc.Fl_Suppress_All_Notifications__c = false;
        finacc.AHFC_Product_Nickname__c ='test22';
        finacc.Fl_DDC_Eligibility__c=true;
        finacc.FL_LE_Eligibility__c=true;
        finacc.AHFC_Total_days_past_due__c=100;
        insert finacc;
        AHFC_NeedHelpPaymentController.NeedHelpWrapper wrapper = new AHFC_NeedHelpPaymentController.NeedHelpWrapper();
        wrapper = AHFC_NeedHelpPaymentController.eligibiltyFlagRetrieve(String.valueOf(finacc.id));
        System.assertEquals(wrapper.FinanceAccNo, finacc.Finance_Account_Number__c,'Finance Account number');
        Test.stopTest();
}
}