/************************************************************************************************
* @Name         AHFC_ContractViewIntegrationMock 
* @Author       Satish Lokinindi
* @Date         26/06/2021
* @description  Mock Callout Class for AHFC_ContractViewIntegrationHandler
*************************************************************************************************
* MODIFICATION LOG
* Version          Developer          Date               Description
*-------------------------------------------------------------------------------------------------
*  1.0             Satish Lokinindi  26/06/2021         Created                                                    
************************************************************************************************/
@isTest
global class AHFC_ContractViewIntegrationMock implements HttpCalloutMock {
    /***************************************************************************************************
    * @description  : Creates a mock response for a Mock Callout
    * param        : request: HTTPRequest
    * return       : HTTPResponse
    ***************************************************************************************************/
    global HTTPResponse respond(HTTPRequest request) {
        // Create a fake response
        HttpResponse response = new HttpResponse();
        AHFC_Integration_Setting__mdt objSetting =[select ID, DeveloperName,Endpoint_URL__c,Method__c,HeaderValue__c,Path__c,Request_Timeout__c,
                                                   ServiceName__c,Retry__c,Environment__c from AHFC_Integration_Setting__mdt where DeveloperName = 'TRANSACTIONHISTORY' limit 1];
        Map<String,String> mapHeaderKeyToValue = AHFC_IntegrationLogUtil.getHeaderValue(objSetting.HeaderValue__c);
        for(String key : mapHeaderKeyToValue.keySet()){
            request.setHeader(key,mapHeaderKeyToValue.get(key));
        }
        String json = '{\"hidden\":0,\"total\":1,\"items\":[{\"file\":{\"id\":19663,\"name\":\"400039611_Contract.pdf\",\"added\":\"2016-05-19T00:39:08.593Z\",\"addedBy\":null,\"size\":236557,\"doctype\":null,\"index\":[{\"typeId\":1,\"type\":1,\"name\":\"AccountNumber\",\"value\":\"400039611\",\"order\":20},{\"typeId\":2,\"type\":1,\"name\":\"CustomerName\",\"value\":\"ELIZABETHTAVARES\",\"order\":22},{\"typeId\":3,\"type\":10,\"name\":\"DocumentType\",\"value\":\"Contract\",\"order\":24},{\"typeId\":4,\"type\":1,\"name\":\"Source\",\"value\":\"Originations\",\"order\":26},{\"typeId\":5,\"type\":1,\"name\":\"DCN\",\"value\":\"V1087555\",\"order\":28},{\"typeId\":6,\"type\":1,\"name\":\"OriginatingRegion\",\"value\":\"2\",\"order\":30},{\"typeId\":9,\"type\":1,\"name\":\"Confidential\",\"value\":\"No\",\"order\":99}],\"renderStatus\":1,\"parentId\":103,\"sourceType\":\"IM\",\"version\":null},\"perm\":{\"file\":1,\"folder\":1,\"index\":1,\"viewer\":5,\"import\":0,\"special\":0,\"custom\":73},\"matches\":[{\"field\":16,\"context\":null}],\"location\":\"POP Files/POPNonConfidential/000007\"}]}';
		
        response.setBody(json);
        response.setStatusCode(200);
        
        return response; 
    }
}