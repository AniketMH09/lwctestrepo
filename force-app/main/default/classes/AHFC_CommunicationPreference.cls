/* Apex Class Name   :    AHFC_CommunicationPreference
* Description        :    class used by aHFC_communicationPrefernce lwc component to fetch default values required for the components
* Modification Log   :
* ---------------------------------------------------------------------------
* Developer                   Date                   Description
* ---------------------------------------------------------------------------
* Vishnu            		JUL 28 2021             	Created
*********************************************************************************/
public without sharing class AHFC_CommunicationPreference {
    
    /**
* @author Vishnu JUL 28 2021 
* @description method to fetch value from database and assign to wrapper variable and return as value
* @param recID:Finance_Account__c recId to retrive Finance_Account__c account record and Communication Preferance values
* @return object reference : wrapper class recDetailWrapper
*/
    @AuraEnabled
    public static recDetailWrapper commPrefDetail(string finid){
        SYSTEM.DEBUG(finid);
        Communication_Preferences__c commprefObj;         
        list<Finance_Account__c> finObj = new list<Finance_Account__c>();        
        finObj = [select id,name,Finance_Account_Number__c,AHFC_Product_Nickname__c,AHFC_Web_Manage_Comm_Pref__c,AHFC_Web_Account_Locked__c  from Finance_Account__c where id=:finid];
        system.debug('finObj=='+finObj);  
        boolean isUserAuth;
        if(finObj.size() > 0)
        {
            isUserAuth = UserSecurity.ValidateFinNumberInit(finObj[0].Finance_Account_Number__c);
            System.debug('isUserAuth==' + isUserAuth);
            if(!isUserAuth){ 
                system.debug('invalid access');
                throw new AuraHandledException('invalid access');            
            } 
            
            try{
                
                commprefObj = [SELECT Id,Email_Address__c, EmailBouncedDate__c, Finance_Account_Number__r.Message_Ack_Date__c,Finance_Account_Number__r.AHFC_Web_Manage_Comm_Pref__c,Paperless_Statements_Letters__c,Unsubscribe_from_all__c,Payment_Reminders_via_Email__c,Payment_Reminders_via_Text__c,
                               Account_Status_Updates_via_Email__c,Account_Status_Updates_via_Text__c,Days_Prior_Reminder__c,
                               Text_Number__c,Payment_Confirmations_via_Email__c, Payment_Profile_Updates_via_Email__c, Payment_Confirmations_via_Text__c,
                               Statements_Letters__c,EasyPay_Communications_via_Email__c,Email_BounceBack_Count__c,Payment_Profile_Updates_via_Text__c,SMS_Bounce_Back_Count__c,Is_SMS_Bounced_Back__c,IsEmailBounced__c,Marketing_Communications_Via_Email__c,EasyPay_Communications_via_Text__c
                               from Communication_Preferences__c where
                               Finance_Account_Number__c = :finid ORDER BY CreatedDate ASC limit 1];
                SYSTEM.DEBUG('commprefObj==' + commprefObj);
                recDetailWrapper recDetails = new recDetailWrapper(commprefObj,finObj[0],AHFC_GlobalConstans.SUCCESS);
                SYSTEM.DEBUG('recDetails==' + recDetails);
                return recDetails;
            }catch(exception ex){
                recDetailWrapper recDetails = new recDetailWrapper(commprefObj,finObj[0],ex.getMessage()); 
                return recDetails;
            }
        }
        return null;
        
        
    }
    /**
* @author Vishnu JUL 28 2021 
* @description method to Update communication Preferance
* @param recID:JSON string with Communication_Preferences__c object model
* @return object reference : communication Pref Updated Record
*/
    @AuraEnabled 
    public static recDetailWrapper saveCommPref(string recDetails ,string finNumber, string oldRecDetails){
        Communication_Preferences__c commPref = (Communication_Preferences__c)JSON.deserialize(recDetails, Communication_Preferences__c.class);
        Communication_Preferences__c oldCommPref = (Communication_Preferences__c)JSON.deserialize(oldRecDetails, Communication_Preferences__c.class);
        commPref.Statements_Letters__c = AHFC_GlobalConstans.Paper;
        try {
            Boolean successFlag = false;
            system.debug(commPref.Email_Address__c);
            system.debug(oldCommPref.Email_Address__c);
            if((commPref.Email_Address__c != oldCommPref.Email_Address__c) || (commPref.Paperless_Statements_Letters__c != oldCommPref.Paperless_Statements_Letters__c)){ 
                UpdateEDeliveryPreferenceService edeliveryService = new UpdateEDeliveryPreferenceService();
                successFlag = edeliveryService.updateEDeliveryPreference(commPref.Paperless_Statements_Letters__c, commPref.Email_Address__c, finNumber);
                successFlag = true;
                system.debug('successFlag'+successFlag);
            }else{
                system.debug('successFlag'+successFlag);
                successFlag = true; 
            }
            If(successFlag){
                if(commPref.Paperless_Statements_Letters__c){
                    commPref.Statements_Letters__c = AHFC_GlobalConstans.EnrollEDillevery;
                }
                update commPref;
                recDetailWrapper recDetailsOnSave = new recDetailWrapper(commPref,null,AHFC_GlobalConstans.SUCCESS);
                return recDetailsOnSave;
                
            }else{
                recDetailWrapper recDetailsOnSave = new recDetailWrapper(commPref,null,'Error');
                return recDetailsOnSave;    
            }
            
        }Catch  (Exception e) {
            UtilityClass.logErrorResp('CommunicationPreferenceExtension', e.getmessage(), finNumber , finNumber, e.getStackTraceString() +'\n' +e.getLineNumber() );
            recDetailWrapper recDetailsOnSave = new recDetailWrapper(commPref,null,e.getmessage()); 
            return recDetailsOnSave;
        } 
        
    }
    
    /**
* @author Vishnu JUL 28 2021 
* @description wrapper class used to send default details for AHFC_CommunicationPreference
* @param recID:JSON string with Communication_Preferences__c object model
* @return object reference : communication Pref Updated Record
*/ 
    public class recDetailWrapper{
        @AuraEnabled public Communication_Preferences__c commPrefDetails;
        @AuraEnabled public Finance_Account__c financeDetails ;
        @AuraEnabled public string errorMessage ;
        public  recDetailWrapper(Communication_Preferences__c commPref,Finance_Account__c fenanceRec,string errMsg){
            errorMessage = errMsg;  
            commPrefDetails = commPref;  
            financeDetails = fenanceRec;
            
        }
    }
    
}