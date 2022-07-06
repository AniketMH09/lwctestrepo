/*Apex Class Name   :   AHFC_CorrespondenceHandler
* Description       :   This is class used in Correspondence Page 
* Created By        :   Aniket Pharakate
* Created on        :   7/6/2021
*********************************************************************************/
public without sharing class AHFC_CorrespondenceHandler {
    
    
    /**
    * @description: This method will return the Custom metadata types
    * @author Aniket Pharakate | 7/6/2021
    * @return AHFC_Correspondence_code__mdt
    * @param
    **/
    @AuraEnabled(cacheable=true)
    public static List<AHFC_Correspondence_code__mdt> nameSearch(){
        List<AHFC_Correspondence_code__mdt> nameList = [SELECT Id,Code__c,Description__c from AHFC_Correspondence_code__mdt];
        return nameList;
    }
    
    /**
    * @description: This method will return Communication Refer record
    * @author Aniket Pharakate | 7/6/2021
    * @return Communication_Preferences__c
    * @param
    **/
    @AuraEnabled
    public static List<Communication_Preferences__c> commRefeSearch(string finid){
        List<Communication_Preferences__c> nameList = [SELECT Id,Email_Address__c from Communication_Preferences__c where Paperless_Statements_Letters__c = true and Finance_Account_Number__c = :finid ORDER BY CreatedDate ASC limit 1];
        return nameList;
    }
    
    
}