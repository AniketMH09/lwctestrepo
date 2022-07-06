/* Apex Class Name       :    AHFC_FinanceAccountTriggerHandler
* (c) LTI
*  @description         :    Handler of Finance Account Trigger
*  Modification Log   :
* ---------------------------------------------------------------------------
*  Developer                   Date                   Description
* --------------------------------------------------------------------------- 
*  Supriya Chakraborty         10 Jul 2021               Created
*/

public with sharing class AHFC_FinanceAccountTriggerHandler {
    public static void onBeforeInsert(List<Finance_Account__c> newList) {
        AHFC_FinanceAccountTriggerHelper.populateNickName(newList);
    }
}