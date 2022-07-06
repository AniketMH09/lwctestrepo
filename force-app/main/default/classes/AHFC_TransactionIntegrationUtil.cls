/* Apex Class Name       :    AHFC_TransactionIntegrationUtil
    * Description        :    This Class is used to get all transaction history details related to Service Account
    * Modification Log   :
    * ---------------------------------------------------------------------------
    * Developer                   Date                   Description
    * ---------------------------------------------------------------------------
    * Aniket P              24 May 2021               Created
    */
public class AHFC_TransactionIntegrationUtil {
   
    String strNamedCredential		= System.Label.AHFC_Named_Credential;
    /*Written By Aniket P | 20 may'2021
      * @Method Name : makeTransactionhistoryCallout
      * @description:  TO make callout
      */
    public string makeTransactionhistoryCallout(Map<String,String> mapHeaderKeyToValue, AHFC_Integration_Setting__mdt objSetting){
        HttpRequest  objRequest   = new HttpRequest();
        HttpResponse objResponse = new HttpResponse();
        string strResponsebody = 'FAILED';
        
        Integer intTimeOut = (objSetting.Request_Timeout__c == NULL) ? 
            Integer.valueOf('12000') : 
           Integer.valueOf(objSetting.Request_Timeout__c);
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
            throw new AuraHandledException(exdetails); 
        }
        return strResponsebody;
    }
    
    /*Written By Aniket P | 24 may'2021
     *
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
        return request;
    }
}