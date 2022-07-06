/* Apex Class Name       :    AHFC_UpdateAddressIntegrationMock
* Description        :    Mock class for AHFC_RemoveBillToAddrIntegration - used in AHFC_RemoveAndUpdateAddressHandler
* Modification Log   :
* ---------------------------------------------------------------------------
* Developer                          Date                   Description
* ---------------------------------------------------------------------------
* Prabu Mohanasundaram               25 JUNE 2021               Created
*********************************************************************************/
@isTest
global class AHFC_UpdateAddressIntegrationMock implements HttpCalloutMock {
    /**
     * @author Prabu JUN 25 2021
     * @description Mock Class for testing AHFC_UpdateAddressIntegration
     * @param Http request as parameter
     * @return returns the response
	**/
    global HTTPResponse respond(HTTPRequest request) {
        // Create a fake response
        HttpResponse response = new HttpResponse();
        String updateAddress = AHFC_GlobalConstans.UPDATEADDRESS;
        AHFC_Integration_Setting__mdt objSetting =[SELECT ID, DeveloperName,Endpoint_URL__c,Method__c,HeaderValue__c,Path__c,Request_Timeout__c,
                                                   ServiceName__c,Retry__c,Environment__c FROM AHFC_Integration_Setting__mdt WHERE DeveloperName =:updateAddress limit 1];
        Map<String,String> mapHeaderKeyToValue = AHFC_IntegrationLogUtil.getHeaderValue(objSetting.HeaderValue__c);
        for(String key : mapHeaderKeyToValue.keySet()){
            if(String.isNotBlank(request.getHeader(key))){
                request.setHeader(key,mapHeaderKeyToValue.get(key));
            }
        }
        response.setStatusCode(200);
        return response; 
    }
}