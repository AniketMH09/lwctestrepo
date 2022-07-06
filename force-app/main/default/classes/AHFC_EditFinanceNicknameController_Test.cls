/*=====================================================================
* Name: AHFC_EditFinanceNicknameController_Test .apex
* Description: Unit Test class for AHFC_EditFinanceNicknameController
* Created Date: 14th May 2021
* Created By: Abhijit kurapati
*  ===================================================================== */

@isTest
public class AHFC_EditFinanceNicknameController_Test {
static testMethod void AHFC_EditFinanceNicknameController_Test1() {
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
        insert finacc;
        AHFC_EditFinanceNicknameController.updateFinanceNickName(String.valueOf(finacc.id),'test');
        Test.stopTest();
        System.assertEquals(finacc.AHFC_Product_Nickname__c,'test');
        
    
    
}
}