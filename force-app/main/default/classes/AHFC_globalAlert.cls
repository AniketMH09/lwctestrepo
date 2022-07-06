/* Apex Class Name       :    AHFC_globalAlert
* @Description        :    This Class is used to push Global Alert Messages
* Modification Log   :
* ---------------------------------------------------------------------------
* Developer                   Date                   Description
* ---------------------------------------------------------------------------
* 						      Created
* Narain                      23/08/2021                Modified for 2320
*********************************************************************************/

public  class AHFC_globalAlert {
    @AuraEnabled
    public static List<Global_Alert__c> globalAlertMessage(){
        List<Global_Alert__c> alertMessage ;
       
            alertMessage = [SELECT Alert_Message__c,Valid_Upto__c,Name,CreatedDate,Is_Active__c	from Global_Alert__c where Valid_Upto__c >= today AND Is_Active__c =true];
          
        
        return alertMessage;
    }
    
}