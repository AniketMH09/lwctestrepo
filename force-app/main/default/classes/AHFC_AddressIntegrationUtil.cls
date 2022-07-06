/* Apex Class Name       :    AHFC_AddressIntegrationUtil
    * @Description        :    This Class is used to handle all integration updates related to Account addresses
    * Modification Log   :
    * ---------------------------------------------------------------------------
    * Developer                   Date                   Description
    * ---------------------------------------------------------------------------
    Prabu Mohanasundaram       15-JUNE-2021              Created
    Prabu Mohanasundaram	   11 NOV  2021				Modified the makeRemoveBillToAddrCallout
    													method for getting the response of StatusCode
*********************************************************************************/
public without sharing class AHFC_AddressIntegrationUtil{
    //Initializations
    String strClassName = 'AHFC_AddressIntegrationUtil';
    String strNamedCredential= 'callout:';
    public static Datetime datTNow = System.now();

    
    /*
     * @author Prabu JUN 25 2021
     * @Description : This method makes external callout to handle remove bill to address 
     * @return List reference : Returns void
     * @param : takes string Id as Params and AHFC_Integration_Setting__mdt metadata
    */
    public removeBillToResponseWrapper makeRemoveBillToAddrCallout(String strLookUpID, AHFC_Integration_Setting__mdt objSetting){
        removeBillToResponseWrapper billToResponse = new removeBillToResponseWrapper();
        Integer intTimeOut = (objSetting.Request_Timeout__c == NULL) ? Integer.valueOf(AHFC_GlobalConstans.DEFAULTTIMEOUT) : 
                              Integer.valueOf(objSetting.Request_Timeout__c);
            strNamedCredential += objSetting.Environment__c;//Getting the named credential information from the mdt record
            try{
                String strMessageId = AHFC_IntegrationLogUtil.getUniqueMessageId();
                //initialize util service 
                AHFC_IntegrationLogUtil objIntUtil = new AHFC_IntegrationLogUtil('Record Id',strClassName, 'makeRemoveBillToAddrCallout', 'Remove Bill To Address', 'UI-real-time', strMessageId);
                //get header information into a map
                Map<String,String> mapHeaderKeyToValue = AHFC_IntegrationLogUtil.getHeaderValue(objSetting.HeaderValue__c);
                if(mapHeaderKeyToValue!=null && !mapHeaderKeyToValue.isEmpty() && String.isNotBlank(strMessageId)){
                    if(mapHeaderKeyToValue.containsKey('hondaHeaderType.messageId')){
                        mapHeaderKeyToValue.put('hondaHeaderType.messageId', strMessageId);
                    }
                    if(mapHeaderKeyToValue.containsKey('collectedTimeStamp')){
                        mapHeaderKeyToValue.put('collectedTimeStamp', String.valueOf(datTNow));
                    }
                    if(mapHeaderKeyToValue.containsKey('lookupID')){
                        mapHeaderKeyToValue.put('lookupID', String.valueOf(strLookUpID));
                    }
                }
                //prepare request
                HttpRequest objRequest = prepareRequest(null,objSetting.Method__c,intTimeOut,objSetting.Endpoint_URL__c,mapHeaderKeyToValue);
                Integer intRetryCount = (Integer)objSetting.Retry__c;
                List<String> lstSuccessStatuses = new List<String>();
                lstSuccessStatuses = objSetting.Success_Status_Codes__c?.split(AHFC_GlobalConstans.SEMICOLON);
                HttpResponse objResponse = objIntUtil.handleRetryMechanism(objRequest,lstSuccessStatuses,intRetryCount);
                if(objResponse != null)
                {                    
                   billToResponse.status = String.valueOf(objResponse.getStatus());
                   billToResponse.statusCode = String.valueOf(objResponse.getStatusCode());
                }
            }
            catch(Exception e){
                String exdetails = e.getCause()+' ; '+e.getLineNumber() + ' ; '+e.getMessage()+' ; '+e.getStackTraceString();
                UtilityClass.logException(e,'AHFC_AddressIntegrationUtil',exdetails,strLookUpID,'ERROR While calling makeUpdateAddressCallout');
            }
        return billToResponse;
        }

    
    /*
     * @author Prabu JUN 25 2021
     * @Description : This method makes external callout to handle update address 
     * @return List reference : Returns Boolean
     * @param : takes Json Body as Params and AHFC_Integration_Setting__mdt metadata
    */
    public responseAddressWrapper makeUpdateAddressCallout(String strRequestBody, AHFC_Integration_Setting__mdt objSetting){
        Boolean isSuccess = false;
        responseAddressWrapper addressResponse = new responseAddressWrapper();
        Integer intTimeOut = (objSetting.Request_Timeout__c == NULL) ? Integer.valueOf(AHFC_GlobalConstans.DEFAULTTIMEOUT) : Integer.valueOf(objSetting.Request_Timeout__c);
            strNamedCredential += objSetting.Environment__c;//Getting the named credential information from the mdt record
            try{
                //get header information into a map
                Map<String,String> mapHeaderKeyToValue = AHFC_IntegrationLogUtil.getHeaderValue(objSetting.HeaderValue__c);
                String strMessageId = AHFC_IntegrationLogUtil.getUniqueMessageId();
                //initialize util service 
                AHFC_IntegrationLogUtil objIntUtil = new AHFC_IntegrationLogUtil('Record Id',strClassName, 'makeUpdateAddressCallout', 'Update Address', 'UI-real-time', strMessageId);
                if(mapHeaderKeyToValue!=null && !mapHeaderKeyToValue.isEmpty() && String.isNotBlank(strMessageId)){
                    if(mapHeaderKeyToValue.containsKey('hondaHeaderType.messageId')){
                        mapHeaderKeyToValue.put('hondaHeaderType.messageId', strMessageId);
                    }
                    if(mapHeaderKeyToValue.containsKey('collectedTimeStamp')){
                        mapHeaderKeyToValue.put('collectedTimeStamp', String.valueOf(datTNow));
                    }
                }
                
                //prepare request
                system.debug('strRequestBody>>>>>'+strRequestBody);
                HttpRequest  objRequest = prepareRequest(strRequestBody,objSetting.Method__c,intTimeOut,objSetting.Endpoint_URL__c,mapHeaderKeyToValue);
                Integer intRetryCount = (Integer)objSetting.Retry__c;
                List<String> lstSuccessStatuses = objSetting.Success_Status_Codes__c?.split(AHFC_GlobalConstans.SEMICOLON);
                List<String> lstUnsuccessStatues = system.Label.AHFC_Update_Address_Failur_Status_Code.split(',');
                HttpResponse objResponse = objIntUtil.handleRetryMechanism(objRequest,lstSuccessStatuses,intRetryCount);
                system.debug('addressupdateResponse>>>>'+objResponse);
                if(objResponse<> null && lstSuccessStatuses.contains(String.valueOf(objResponse.getStatusCode()))){
                    addressResponse.isSuccess = true; 
                    addressResponse.isResponseCode = String.valueOf(objResponse.getStatusCode());
                }else if(objResponse<> null && lstUnsuccessStatues.contains(String.valueOf(objResponse.getStatusCode()))){
					string responseBody = objResponse.getbody();
                    addressResponse = (responseAddressWrapper) System.JSON.deserialize(responseBody, responseAddressWrapper.class);
                    addressResponse.isSuccess = false;
                    addressResponse.isResponseCode = String.valueOf(objResponse.getStatusCode());
				}
            }
            catch(Exception e){
                String exdetails = e.getCause()+' ; '+e.getLineNumber() + ' ; '+e.getMessage()+' ; '+e.getStackTraceString();
                
             	UtilityClass.logException(e,'AHFC_AddressIntegrationUtil',exdetails,'','ERROR While calling makeUpdateAddressCallout');
            }
            return addressResponse;
        }
    
    /*
    * @author Prabu JUN 25 2021
    * @Method Name : prepareRequest
    * @description:  Creates a HTTPRequest instance, sets the headers, endpoint and methods as per the current point
    * @param : takes stirng - request Body  ,defines method name,call timeout time, endpoint header key valu as map
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
    
    public class responseAddressWrapper{
        @AuraEnabled
        public boolean isSuccess = false;
        @AuraEnabled
        public String isResponseCode = AHFC_GlobalConstans.EMPTY;
        @AuraEnabled
        public String[] counties = null;
    }
    
    public class removeBillToResponseWrapper{
        @AuraEnabled
        public String status{get;set;}
        @AuraEnabled
        public String statusCode{get;set;}
    }

}