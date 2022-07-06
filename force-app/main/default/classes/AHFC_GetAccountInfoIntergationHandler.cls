/* 
* Apex Class Name   :   AHFC_GetAccountInfoIntergationHandler
* @description      :	US 5947 - Get Account info will return the flags which will be utilised to manipulate the finance account
* Modification Log  :
* ---------------------------------------------------------------------------
* Developer                   Date                   Description
* ---------------------------------------------------------------------------
* Akash Solanki               25th JUNE 2021               Created
* Akash Solanki				  09 July 2021				   Modified - accomodated message id logic for request header
*********************************************************************************/
/**
* @description AHFC_GetAccountInfoIntergationHandler 
*/
public without sharing class AHFC_GetAccountInfoIntergationHandler {
    
    public static Map<String,AHFC_Integration_Setting__mdt> mapIntSettings = AHFC_IntegrationLogUtil.getAllIntegrationSettings();
    public static final String GETACCOUNTINFO = 'GETGETACCOUNTINFO'; // This is a custom metadata record for get account info integration.
    public static Datetime datTNow = System.now();
    
/**
* @description handleGetAccountInfo will call the getaccountinfo webservice to the get the account flags.
* @param  strFinanceAccount Finance Account Number
* @return strresponsebody  response String
**/
    @AuraEnabled 
    public static string handleGetAccountInfo(string strFinanceAccount){
        string strresponsebody;
        AHFC_GetAccountInfoIntergationUtil objIntHandler = new AHFC_GetAccountInfoIntergationUtil();
        AHFC_Integration_Setting__mdt objSetting=mapIntSettings.get(GETACCOUNTINFO);
        String uniqueMessageId = AHFC_IntegrationLogUtil.getUniqueMessageId();
        
        Map<String,String> mapHeaderKeyToValue = AHFC_IntegrationLogUtil.getHeaderValue(objSetting.HeaderValue__c);
        if(mapHeaderKeyToValue!=null && !mapHeaderKeyToValue.isEmpty()){
            if(mapHeaderKeyToValue.containsKey('lookupID') &&
               strFinanceAccount!=null){
                   mapHeaderKeyToValue.put('lookupID',strFinanceAccount);
               }
            if(mapHeaderKeyToValue.containsKey('hondaHeaderType.messageId') &&
               uniqueMessageId!=null){
                   mapHeaderKeyToValue.put('hondaHeaderType.messageId',uniqueMessageId);
               }
        }
        if(!mapHeaderKeyToValue.isEmpty() && objSetting!=null ){
            strresponsebody=objIntHandler.makeGetAccountInfoCallout(mapHeaderKeyToValue,objSetting);
        }
        return strresponsebody;
    }
}