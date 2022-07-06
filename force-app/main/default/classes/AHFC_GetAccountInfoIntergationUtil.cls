/* 
* Apex Class Name   :   AHFC_GetAccountInfoIntergationUtil
* @description      :	US 5947 - Get Account info will return the flags which will be utilised to manipulate the finance account
* Modification Log  :
* ---------------------------------------------------------------------------
* Developer                   Date                   Description
* ---------------------------------------------------------------------------
* Akash Solanki               25th JUNE 2021               Created
*********************************************************************************/
/**
* @description AHFC_GetAccountInfoIntergationUtil 
*/
public without sharing class AHFC_GetAccountInfoIntergationUtil {
    
    String strNamedCredential = System.Label.AHFC_Named_Credential;
/**
* @description makeGetAccountInfoCallout
* @param  mapHeaderKeyToValue 
* @param  objSetting
* @return strResponsebody String
**/
    public string makeGetAccountInfoCallout(Map<String,String> mapHeaderKeyToValue, AHFC_Integration_Setting__mdt objSetting){
        HttpRequest  objRequest   = new HttpRequest();
        HttpResponse objResponse = new HttpResponse();
        string strResponsebody = 'FAILED';
        
        Integer intTimeOut = (objSetting.Request_Timeout__c == NULL) ? Integer.valueOf('12000') : Integer.valueOf(objSetting.Request_Timeout__c);
        strNamedCredential += objSetting.Environment__c;//Getting the named credential information from the mdt record
        try{
            objRequest = prepareTransactionHistoryRequest(objSetting.Method__c,intTimeOut,objSetting.Endpoint_URL__c,mapHeaderKeyToValue);
            AHFC_IntegrationLogUtil objIntUtil = new AHFC_IntegrationLogUtil();
            Integer intRetryCount = (Integer)objSetting.Retry__c;
            List<String> lstSuccessStatuses =objSetting.Success_Status_Codes__c?.split(';');
            objResponse=objIntUtil.handleRetryMechanism(objRequest,lstSuccessStatuses,intRetryCount);
            if(lstSuccessStatuses.contains(string.valueof(objResponse.getStatusCode()))){
                strResponsebody = objResponse.getBody();
            }
        }
        catch(Exception e){
            String exdetails = e.getCause()+' ; '+e.getLineNumber() + ' ; '+e.getMessage()+' ; '+e.getStackTraceString();
            ErrorLog__c errlog = new ErrorLog__c();
            errlog.ExceptionErrorMessage__c= e.getMessage();
            insert errlog;
            throw new AuraHandledException(exdetails); 
        }
        return strResponsebody;
    }

/**
* @description prepareTransactionHistoryRequest
* @param  strMethodName 
* @param  intTimeOut
* @param  strEndPoint
* @param  mapHeaderKeyToValue
* @return request HTTPRequest
**/
    public HTTPRequest prepareTransactionHistoryRequest(String strMethodName,Integer intTimeOut,String strEndPoint,Map<String,String> mapHeaderKeyToValue){
        HttpRequest request = new HttpRequest() ;
        request.setEndpoint('callout:AHFC_GetAccountInfo');
        for(String key : mapHeaderKeyToValue.keySet()){
            request.setHeader(key,mapHeaderKeyToValue.get(key));
        }
        request.setMethod(strMethodName);
        request.setTimeOut(intTimeOut);
        return request;
    }
}