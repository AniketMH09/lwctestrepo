/* Apex Class Name       :    AHFC_DemographicsIntegrationUtil
    * Description        :    This Class is used to handle all integration updates related to Demographics Integration
    * Modification Log   :
    * ---------------------------------------------------------------------------
    * Developer                   Date                   Description
    * ---------------------------------------------------------------------------
    * Kanagaraj			         25 MAY 2021               Created
*********************************************************************************/
public without sharing class AHFC_DemographicsIntegrationUtil {

    //Initializations
    String strRecordId            = AHFC_GlobalConstans.INTUTIL_RECID; 
    String strClassName          = AHFC_GlobalConstans.DEMOGRAPHIC_INT_CLSNAME;
    String strMethodName        = AHFC_GlobalConstans.DEMOGRAPHIC_INT_MTHDNAME;
    String strWebServiceName     = AHFC_GlobalConstans.DEMOGRAPHIC_INT_WEBSERVICENAME;
    String strObjectName        = AHFC_GlobalConstans.INTUTIL_OBJNAME;
    String strUpdateMtdName          = AHFC_GlobalConstans.DEMOGRAPHIC_INT_UPDATE_MTDNAME;
    String strUpdateWebserviceName   = AHFC_GlobalConstans.DEMOGRAPHIC_INT_UPDATE_WEBSERVICENAME;
    String strNamedCredential         = System.Label.AHFC_Named_Credential;
    public static Datetime datTNow = System.now();

    //Written By Kanagaraj | 25 MAY 2021
    /*
     * Description : This method makes external callout to Get the Demographics 
     * @return List reference : Returns String
    */
    public String makeGetDemographicsCallout(String strLookUpID, AHFC_Integration_Setting__mdt objSetting){
        List<String> lstSuccessStatuses = objSetting.Success_Status_Codes__c == NULL? new List<String>() : objSetting.Success_Status_Codes__c.split(AHFC_GlobalConstans.SEMICOLON);
        Integer intTimeOut = (objSetting.Request_Timeout__c == NULL) ? Integer.valueOf(AHFC_GlobalConstans.DEFAULTTIMEOUT) : Integer.valueOf(objSetting.Request_Timeout__c);
        strNamedCredential += objSetting.Environment__c; //Getting the named credential information from the mdt record
        try{
            String strMessageId = AHFC_IntegrationLogUtil.getUniqueMessageId();
            
            //initialize util service 
            AHFC_IntegrationLogUtil objIntUtil = new AHFC_IntegrationLogUtil(strLookUpID,strClassName, strMethodName,strWebServiceName, strObjectName, strMessageId);
            //get header information into a map
            Map<String,String> mapHeaderKeyToValue = AHFC_IntegrationLogUtil.getHeaderValue(objSetting.HeaderValue__c);
            if(mapHeaderKeyToValue!=null && !mapHeaderKeyToValue.isEmpty() && String.isNotBlank(strMessageId)){
                if(mapHeaderKeyToValue.containsKey(AHFC_GlobalConstans.HTTP_HEADER_MSGID)){
                    mapHeaderKeyToValue.put(AHFC_GlobalConstans.HTTP_HEADER_MSGID, strMessageId);
                }
                if(mapHeaderKeyToValue.containsKey(AHFC_GlobalConstans.HTTP_HEADER_COLTIME)){
                    mapHeaderKeyToValue.put(AHFC_GlobalConstans.HTTP_HEADER_COLTIME, String.valueOf(datTNow));
                }
                if(mapHeaderKeyToValue.containsKey(AHFC_GlobalConstans.HTTP_HEADER_LOOKUPID)){
                    mapHeaderKeyToValue.put(AHFC_GlobalConstans.HTTP_HEADER_LOOKUPID, String.valueOf(strLookUpID));
                }
            }
            //prepare request
            HttpRequest objRequest = prepareRequest(null,objSetting.Method__c,intTimeOut,objSetting.Endpoint_URL__c,mapHeaderKeyToValue);
            Integer intRetryCount = (Integer)objSetting.Retry__c;
            HttpResponse objResponse = objIntUtil.handleRetryMechanism(objRequest,lstSuccessStatuses,intRetryCount);
            system.debug('objResponse>>>>>'+objResponse);
            return objResponse.getBody();
        }
        catch(Exception e) {
            String exdetails = e.getCause()+' ; '+e.getLineNumber() + ' ; '+e.getMessage()+' ; '+e.getStackTraceString();   
        }
        return null;
        }

    //Written By Kanagaraj | 25 MAY 2021
    /*
     * Description : This method makes external callout to handle update Demographics 
     * @return List reference : Returns void
    */
    public responseDemographyWrapper handleUpdateOtherDemographics(String strLookUpID, String strRequestBody, AHFC_Integration_Setting__mdt objSetting){
        HttpResponse objResponse ;
        responseDemographyWrapper responseWrapp = new responseDemographyWrapper();
        List<String> lstSuccessStatuses = objSetting.Success_Status_Codes__c == NULL? new List<String>() : objSetting.Success_Status_Codes__c.split(AHFC_GlobalConstans.SEMICOLON);
        Integer intTimeOut = (objSetting.Request_Timeout__c == NULL) ? Integer.valueOf(AHFC_GlobalConstans.DEFAULTTIMEOUT) : Integer.valueOf(objSetting.Request_Timeout__c);
        strNamedCredential += objSetting.Environment__c;//Getting the named credential information from the mdt record
        try{
            //get header information into a map
            Map<String,String> mapHeaderKeyToValue = AHFC_IntegrationLogUtil.getHeaderValue(objSetting.HeaderValue__c);
            String strMessageId = AHFC_IntegrationLogUtil.getUniqueMessageId();
            //initialize util service 
            AHFC_IntegrationLogUtil objIntUtil = new AHFC_IntegrationLogUtil(strLookUpID,strClassName, strUpdateMtdName, strUpdateWebserviceName, strObjectName, strMessageId);
            if(mapHeaderKeyToValue!=null && !mapHeaderKeyToValue.isEmpty() && String.isNotBlank(strMessageId)){
                if(mapHeaderKeyToValue.containsKey(AHFC_GlobalConstans.HTTP_HEADER_MSGID)){
                    mapHeaderKeyToValue.put(AHFC_GlobalConstans.HTTP_HEADER_MSGID, strMessageId);
                }
                if(mapHeaderKeyToValue.containsKey(AHFC_GlobalConstans.HTTP_HEADER_COLTIME)){
                    mapHeaderKeyToValue.put(AHFC_GlobalConstans.HTTP_HEADER_COLTIME, String.valueOf(datTNow));
                }
            }
            //prepare request
            HttpRequest  objRequest = prepareRequest(strRequestBody,objSetting.Method__c,intTimeOut,objSetting.Endpoint_URL__c,mapHeaderKeyToValue);
            Integer intRetryCount = (Integer)objSetting.Retry__c;
            objResponse = objIntUtil.handleRetryMechanism(objRequest,lstSuccessStatuses,intRetryCount);
            system.debug('response>>>>'+objResponse);
        } catch(Exception e){
            String exdetails = e.getCause()+' ; '+e.getLineNumber() + ' ; '+e.getMessage()+' ; '+e.getStackTraceString();
        }
        
        if(objResponse<> null && lstSuccessStatuses.contains(String.valueOf(objResponse.getStatusCode()))){
            responseWrapp.isSuccess = true;
            responseWrapp.isResponseCode = String.valueOf(objResponse.getStatusCode());
        }else{
            responseWrapp.isSuccess = false;
        }
            return responseWrapp;
    }
    
    //Written By Kanagaraj | 25 MAY 2021
    /*
    * @Method Name : prepareRequest
    * @description:  Creates a HTTPRequest instance, sets the headers, endpoint and methods as per the current point
    */
      public HTTPRequest prepareRequest(String strRequestBody, String strMethodName,Integer intTimeOut,String strEndPoint,Map<String,String> mapHeaderKeyToValue){
        HttpRequest request = new HttpRequest() ;
        request.setEndpoint(strNamedCredential+strEndPoint);
        for(String key : mapHeaderKeyToValue.keySet()){
        	request.setHeader(key,mapHeaderKeyToValue.get(key));
        }
        if(String.isNotBlank(strRequestBody)){
            request.setbody(strRequestBody);
        }
        request.setMethod(strMethodName);
        request.setTimeOut(intTimeOut);
        return request;
    }
    
    public class responseDemographyWrapper{
        @AuraEnabled
        public boolean isSuccess = false;
        @AuraEnabled
        public String isResponseCode = '';
    }
}