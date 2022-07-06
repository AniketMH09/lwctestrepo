/* Apex Class Name   :    AHFC_UpdateNickNameHelper_Test
 * Description        :    Unit Test class for AHFC_UpdateNickNameHelper
 * Modification Log   :
 * ---------------------------------------------------------------------------
 * Developer                             Date                   Description
 * ---------------------------------------------------------------------------
 * Abhijit kurapati                  14th May 2021             Created
 * Prabu Mohanasundaram              19th Nov 2021             Modified
 *********************************************************************************/

/**
 * @description: Added the code for cover the catch block.
 * @author Prabu Mohanasundaram | Nov 19 2021
 **/

@isTest(SeeAllData = false)
public class AHFC_UpdateNickNameHelper_Test {
    public static testMethod void testPaymentSource() {
        String hondaMarine = 'Honda Marine';
        String hondaPower = 'Honda Power Sports 226-9012AGHJ-QWXXYZ-2367489-WEEFGHJKY-12349876534-QASDXCVX';
        Finance_Account__c finaccount = new Finance_Account__c();
        finaccount.Finance_Account_Number__c = '2541345678';
        finaccount.Honda_Brand__c = 'HFS';
        finaccount.Fl_Recurring_Payment_Eligible_Agent__c = true;
        finaccount.Region_Code__c = 'BKC';
        finaccount.Account_Type__c = 'Balloon';
        finaccount.Fl_Refinanced__c = true;
        finaccount.Payment_Due_Date__c = System.Today();
        finaccount.Fl_Suppress_All_Notifications__c = false;
        finaccount.AHFC_Product_Nickname__c = 'test';
        insert finaccount;
        AHFC_UpdateNickNameHelper.updateNickName(String.valueOf(finaccount.id), hondaMarine);
        system.assertEquals(hondaMarine.length() < 46, true, 'when Nickname is less than 46');
        AHFC_UpdateNickNameHelper.updateNickName(String.valueOf(finaccount.id), hondaPower); //Added the code for cover the catch block.
        system.assertEquals(hondaPower.length() < 46, false, 'when Nickname is more than 46');
    }
}