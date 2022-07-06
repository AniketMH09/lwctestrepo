/* 
* Apex Class Name   :   AHFC_PromiseMadeServiceHandler
* @description      :	US 9020 - API development for promise made webservice which will be used in already made a payment.
* Modification Log  :
* ---------------------------------------------------------------------------
* Developer                   Date                   Description
* ---------------------------------------------------------------------------
* Akash Solanki               28th JULY 2021          Created for US 9020
*********************************************************************************/
/**
* @description AHFC_PromiseMadeServiceHandler 
*/
public without sharing class AHFC_PromiseMadeServiceHandler {
    public static Map<String,AHFC_Integration_Setting__mdt> mapIntSettings = AHFC_IntegrationLogUtil.getAllIntegrationSettings();
    public static final String PROMISEMADE = 'PUTPROMISEMADE';
    
    /**
* @description generateJSONContent
* @param  lookupId
* @param  confirmNumber
* @param  promiseAmount
* @param  promiseMadeType
* @return JSONReq  This is the request body which will be send to the web service call
**/
    @AuraEnabled
    public static String generateJSONContent(String lookupId, String confirmNumber, decimal promiseAmount, String promiseMadeType) {
        
        String jsonReq = '{'; 
        jsonReq+='"lookupID":"'+lookupId+'",';
        jsonReq+='"confirmNumber":"'+confirmNumber+'",';
        jsonReq+='"promiseAmount":'+promiseAmount+',';
        jsonReq+='"promiseMadeType":"'+promiseMadeType+'"';
        jsonReq += '}'; 
        
        return jsonReq;
    }

    /**
* @description getHttpRequest
* @param  lookupId
* @param  confirmNumber
* @param  promiseAmount
* @param  promiseMadeType
* @return request This is the final request object which will be send to Promise Made Web Service
**/
    public static HttpRequest getHttpRequest(String lookupId, String confirmNumber, decimal promiseAmount,String promiseMadeType){
        
        AHFC_Integration_Setting__mdt objSetting=mapIntSettings.get(PROMISEMADE);
        Map<String,String> mapHeaderKeyToValue = AHFC_IntegrationLogUtil.getHeaderValue(objSetting.HeaderValue__c); // calling this AHFC_IntegrationLogUtil class to deserialize the json response stored for headers and body in PROMISEMADE record of AHFC_Integration_Setting__mdt custom metadata.       
        String uniqueMessageId = AHFC_IntegrationLogUtil.getUniqueMessageId(); // get unique honda header message id from getUniqueMessageId method in AHFC_IntegrationLogUtil class. 
        String requestBody = generateJSONContent(lookupId,confirmNumber,promiseAmount,promiseMadeType);        
        HttpRequest request = new HttpRequest();
        request.setEndpoint('callout:AHFC_PromiseMadeService'); // Named credential - AHFC_PromiseMadeService
        request.setTimeout(Integer.valueOf(objSetting.Request_Timeout__c)); 
        request.setMethod('PUT');
        if(mapHeaderKeyToValue.containsKey('hondaHeaderType.messageId')){
            mapHeaderKeyToValue.put('hondaHeaderType.messageId',uniqueMessageId);
        }
        if(mapHeaderKeyToValue.containsKey('hondaHeaderType.collectedTimestamp')){
            mapHeaderKeyToValue.put('hondaHeaderType.collectedTimestamp',datetime.now().format('yyyy-MM-dd\'T\'HH:mm:ss.SSS\'Z\''));
        }
        for(String key : mapHeaderKeyToValue.keySet()){
            request.setHeader(key,mapHeaderKeyToValue.get(key)); // Header values coming from PROMISEMADE record of AHFC_Integration_Setting__mdt custom metadata.
        }
        request.setBody(requestBody);
        
        return request;
    }
    /**
* @description putPromisMade - This is the main method which will perform the callout and return the response
* @param  lookupId
* @param  confirmNumber
* @param  promiseAmount
* @param  promiseMadeType
* @return finalResponse  Final Parsed response - if record created in external system it will respond with 200 else error.
**/
    @AuraEnabled
    public static String putPromisMade(String lookupId, String confirmNumber, decimal promiseAmount,String promiseMadeType){
        String responseBody;
        Integer statusCode;
        String status='';
        String finalResponse = '';        
        try{
            HttpRequest request= getHttpRequest(lookupId,confirmNumber,promiseAmount,promiseMadeType);
            HttpResponse response = new Http().send(request);
            responseBody = response.getbody();
            statusCode	= response.getStatusCode();
            status = response.getStatus();
            if(statusCode== 200){
                finalResponse = 'SUCCESS';
            }else{
                finalResponse = 'FAILED';
            }
        }catch(Exception e){
            finalResponse = 'Error: '+ e.getMessage();
            ErrorLog__c errlog = new ErrorLog__c();
            errlog.ExceptionErrorMessage__c= finalResponse; //Insert the catch block exception into the error log object.
            insert errlog;
        }
        return finalResponse;
    }
}