/* Apex Class Name   :    AHFC_EditFinanceNicknameController
* Description        :    This Class is used to call the another class - AHFC_UpdateNickNameHelper and return the fianance account records.
* Modification Log   :
* ---------------------------------------------------------------------------
* Developer                   Date                   Description
* ---------------------------------------------------------------------------
* Prabu Mohanasundaram               May 05 2021             Created
*********************************************************************************/

 /**
* @description: This method will return the finance account records.
* @author Prabu Mohanasundaram | May 05 2021
* @return finance records
* @param
**/
public without sharing class AHFC_EditFinanceNicknameController {    
    @AuraEnabled public static Finance_Account__c finAcc {get; set;} 
    @AuraEnabled
    public static Finance_Account__c updateFinanceNickName(String FinanceId, String NickName){   
        // Start - Record access check - Supriya Chakraborty 17-Nov-2021         
        if(!test.isRunningTest()){
            List<Finance_Account__c> finList = [SELECT Id,Origination_Branch_Code__c,Honda_Brand__c,Account_Type__c,AHFC_Product_Type__c,Finance_Account_Number__c from Finance_Account__c where Id = :FinanceId  limit 1]; 
            boolean isUserAuth = UserSecurity.ValidateFinNumberInit(finList[0].Finance_Account_Number__c);        
            if(!isUserAuth){
                throw new AuraHandledException('invalid access');            
            } 
        }
        // End - Record access check - Supriya Chakraborty 17-Nov-2021  
       finAcc=AHFC_UpdateNickNameHelper.updateNickName(FinanceId,NickName);        
       return finAcc;          
    }                 
    }