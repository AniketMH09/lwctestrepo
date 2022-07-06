/* Apex Class Name       :    AHFC_PayOffInfoIntegrationUtil
* Description        :    This Class is used to get pay off info
* Modification Log   :
* ---------------------------------------------------------------------------
* Developer                   Date                   Description
* ---------------------------------------------------------------------------
* Prabu Mohanasundaram               26th JUNE 2021               Created
*********************************************************************************/
public class AHFC_PayOffInfoIntegrationUtil {
    
    //Initializations
    AHFC_IntegrationLogUtil IntegrationLogService = new AHFC_IntegrationLogUtil();
    List<string> integrationLogs = new List<string>();
    string strRecordId 		 = AHFC_GlobalConstans.INTUTIL_RECID;
    String strClassName 		 = AHFC_GlobalConstans.PAYOFF_INT_CLSNAME;
    String strMethodName		 = AHFC_GlobalConstans.PAYOFF_INT_MTHDNAME;
    String strWebServiceName	 = AHFC_GlobalConstans.PAYOFF_INT_WEBSERVICENAME;
    String strObjectName 		 = AHFC_GlobalConstans.INTUTIL_OBJNAME; 
    String strNamedCredential  = System.Label.AHFC_Named_Credential;
    
    
    public string makePayOffCallout(Map<String,String> mapHeaderKeyToValue, AHFC_Integration_Setting__mdt objSetting){
        HttpRequest  objRequest   = new HttpRequest();
        HttpResponse objResponse = new HttpResponse();
        string strResponsebody;
        Integer intTimeOut = (objSetting.Request_Timeout__c == NULL) ? Integer.valueOf(AHFC_GlobalConstans.DEFAULTTIMEOUT) : 
        Integer.valueOf(objSetting.Request_Timeout__c);
        strNamedCredential += objSetting.Environment__c;//Getting the named credential information from the mdt record
        try{
            String strMessageId = AHFC_IntegrationLogUtil.getUniqueMessageId();
            objRequest = prepareTransactionHistoryRequest(objSetting.Method__c,intTimeOut,objSetting.Endpoint_URL__c,mapHeaderKeyToValue);
            System.debug('objRequest---->'+objRequest);
            //initialize util service 
            AHFC_IntegrationLogUtil objIntUtil = new AHFC_IntegrationLogUtil(strRecordId,strClassName, strMethodName, strWebServiceName, strObjectName, strMessageId);
            Integer intRetryCount = (Integer)objSetting.Retry__c;
            List<String> lstSuccessStatuses =objSetting.Success_Status_Codes__c?.split(AHFC_GlobalConstans.SEMICOLON);
            System.debug('lstSuccessStatuses->'+lstSuccessStatuses);
            System.debug('Request Sent --> '+objRequest);
            objResponse=objIntUtil.handleRetryMechanism(objRequest,lstSuccessStatuses,intRetryCount);
            System.debug('Response --> '+objResponse);
            System.debug(lstSuccessStatuses+' <-> '+objResponse.getStatusCode());
            if(lstSuccessStatuses.contains(string.valueof(objResponse.getStatusCode()))){
                strResponsebody = objResponse.getBody();
            }
            
        }
        Catch(Exception e){
            String exdetails = e.getCause()+' ; '+e.getLineNumber() + ' ; '+e.getMessage()+' ; '+e.getStackTraceString();
           //AHFC_ExceptionUtil.logException('Get PayOff Info', 'AHFC_PayOffInfoIntegrationUtil.makePayOffCallout', 'null', 'null', exdetails);
          UtilityClass.logException(e,'AHFC_PayOffInfoIntegrationUtil.makePayOffCallout', e.getMessage(),strRecordId, e.getStackTraceString().left(32000));  
           
            
        }
        return strResponsebody;
    }
    
    
    /*
* @Method Name : prepareTransactionHistoryRequest
* @description:  Creates a HTTPRequest instance, sets the headers, endpoint and methods as per the current point
*/
    public HTTPRequest prepareTransactionHistoryRequest(String strMethodName,Integer intTimeOut,String strEndPoint,Map<String,String> mapHeaderKeyToValue){
        HttpRequest request = new HttpRequest() ;
        request.setEndpoint(strNamedCredential+strEndPoint);
        for(String key : mapHeaderKeyToValue.keySet()){
            request.setHeader(key,mapHeaderKeyToValue.get(key));
        }
        request.setMethod(strMethodName);
        request.setTimeOut(intTimeOut);
        System.debug('Request Prepared --> '+request);
        return request;
    }
}