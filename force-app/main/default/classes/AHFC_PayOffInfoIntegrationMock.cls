/* Apex Class Name       :    AHFC_PayOffInfoIntegrationMock
* Description        	 :    Mock Callout Class for AHFC_PayOffInfoIntegrationHandler
* Modification Log   	 :
* ---------------------------------------------------------------------------
* Developer                   Date                   Description
* ---------------------------------------------------------------------------
* Prabu Mohanasundaram               5th JUNE 2021               Created
*********************************************************************************/
@isTest
global class AHFC_PayOffInfoIntegrationMock implements HttpCalloutMock{
    // Implement this interface method
    global HTTPResponse respond(HTTPRequest request) {
        // Create a fake response
        HttpResponse response = new HttpResponse();
        AHFC_Integration_Setting__mdt objSetting =[select ID, DeveloperName,Endpoint_URL__c,Method__c,HeaderValue__c,Path__c,Request_Timeout__c,
                                                   ServiceName__c,Retry__c,Environment__c from AHFC_Integration_Setting__mdt where DeveloperName = 'PAYOFFINFO' limit 1];
        Map<String,String> mapHeaderKeyToValue = AHFC_IntegrationLogUtil.getHeaderValue(objSetting.HeaderValue__c);
        for(String key : mapHeaderKeyToValue.keySet()){
            request.setHeader(key,mapHeaderKeyToValue.get(key));
        }
        response.setBody('{"payoffAmount": 29458.78, "goodThruDate": "2021-03-09T00:00:00",  "payoffPerDiem": 0}');
        response.setStatusCode(200);
        System.assertEquals(200,response.getStatusCode());
        return response; 
    }
}