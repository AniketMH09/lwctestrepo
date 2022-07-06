/* Apex Class Name       :    AHFC_TransactionIntegrationMock
* Description        	 :    Mock Callout Class for AHFC_TransactionIntegrationHandler
* Modification Log   	 :
* ---------------------------------------------------------------------------
* Developer                   Date                   Description
* ---------------------------------------------------------------------------
* Aniket Pharakate               30 May 2021              Created
*********************************************************************************/
@isTest
global class AHFC_TransactionIntegrationMock implements HttpCalloutMock {
     /*Written By Aniket P | 20 may'2021
      * @Method Name : respond
      * @description:  Implement this interface method 
      */
   
    global HTTPResponse respond(HTTPRequest request) {
        // Create a fake response
        HttpResponse response = new HttpResponse();
        AHFC_Integration_Setting__mdt objSetting =[select ID, DeveloperName,Endpoint_URL__c,Method__c,HeaderValue__c,Path__c,Request_Timeout__c,
                                                   ServiceName__c,Retry__c,Environment__c from AHFC_Integration_Setting__mdt where DeveloperName = 'TRANSACTIONHISTORY' limit 1];
        Map<String,String> mapHeaderKeyToValue = AHFC_IntegrationLogUtil.getHeaderValue(objSetting.HeaderValue__c);
        for(String key : mapHeaderKeyToValue.keySet()){
            request.setHeader(key,mapHeaderKeyToValue.get(key));
        }
        String json = '{'+ 
            '  \"entries\": ['+
            '    '+
            '    {'+
            '      \"date\": \"2020-08-10T00:00:00\",'+
            '      \"description\": \"Payment Received - Thank You!\",'+
            '      \"amount\": 600,'+
            '      \"subEntries\": ['+
            '        {'+
            '          \"description\": \"Interest\",'+
            '          \"amount\": 114.52'+
            '        },'+
            '        {'+
            '          \"description\": \"Principal\",'+
            '          \"amount\": 485.48'+
            '        }'+
            '      ]'+
            '    }'+
            '  ]'+
            '}';
        response.setBody(json);
        response.setStatusCode(200);
        return response; 
    }
}