/* Apex Class Name   :    AHFC_UpdateNickNameHelper
* Description        :    This Class is used to update the nickname and return the finance record.
* Modification Log   :
* ---------------------------------------------------------------------------
* Developer                   Date                   Description
* ---------------------------------------------------------------------------
* Prabu Mohanasundaram               May 12 2021             Created
*********************************************************************************/

 /**
* @description: This method will update the nickname and return the finance record
* @author Prabu Mohanasundaram | May 12 2021
* @return finance records
* @param
**/
public without sharing class AHFC_UpdateNickNameHelper {    
    @AuraEnabled
    public static Finance_Account__c updateNickName(String FinanceId, String NickName){                        
        Finance_Account__c finAcc = [select id,Name,AHFC_Product_Nickname__c from Finance_Account__c where id = :FinanceId];
        finAcc.AHFC_Product_Nickname__c = NickName;        
        try {
            update finAcc;  
        } catch (Exception e) {
            return null; 
        }        
        return finAcc;
    }   
}