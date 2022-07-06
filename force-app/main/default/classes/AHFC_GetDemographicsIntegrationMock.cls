/* Apex Class Name       :    AHFC_GetDemographicsIntegrationMock
* Description           :    Mock Callout Class for AHFC_DemographicsIntegration get call
* Modification Log      :
* ---------------------------------------------------------------------------
* Developer                   Date                   Description
* ---------------------------------------------------------------------------
* Kanagaraj		            28 Jun 2021              Created
*********************************************************************************/
@isTest
public class AHFC_GetDemographicsIntegrationMock implements HttpCalloutMock {

    /**
     * Simulates the Web Service response for the test class.
     *
     * @param objRequest    Simulated request.
     * @return HTTP Response.
     */
    public HTTPResponse respond(HTTPRequest objRequest) {
        HttpResponse objResponse = new HttpResponse();
        String getDemographics = AHFC_GlobalConstans.GETDEMOGRAPHICS;
        AHFC_Integration_Setting__mdt objSetting =[select ID, DeveloperName,Endpoint_URL__c,Method__c,
                                                   HeaderValue__c,Path__c,Request_Timeout__c,ServiceName__c,
                                                   Retry__c,Environment__c from AHFC_Integration_Setting__mdt 
                                                   where DeveloperName = :getDemographics limit 1];
        Map<String,String> mapHeaderKeyToValue = AHFC_IntegrationLogUtil.getHeaderValue(objSetting.HeaderValue__c);
        for(String key : mapHeaderKeyToValue.keySet()){
            objResponse.setHeader(key,mapHeaderKeyToValue.get(key));
        }
        String strBody = '{"billToAddress": { '+
                  '"addressLine1": null,'+
                            '"addressLine2": null,'+
                            '"addressType": "Garaging",'+
                            '"city": null,'+
                            '"county": null,'+
                            '"state": null,'+
                            '"zipCode": null'+
                        '},'+
                        '"garagingAddress": {'+
                            '"addressLine1": null,'+
                            '"addressLine2": null,'+
                            '"addressType": "Garaging",'+
                            '"city": "HAM LAKE",'+
                            '"county": null,'+
                            '"state": "MN",'+
                            '"zipCode": "55304"'+
                        '},'+
                        '"otherDemographics": {'+
                            '"cellPhone": "3108888888",'+
                            '"cellPhone2": "",'+
                            '"homePhone": null,'+
                            '"placeOfEmployment": "THUNDERSTRUCK RESTORATIONS",'+
                            '"workPhone": "3104444444"'+
                        '},'+
                        '"statementSuppressed": false'+
                        '}';

        objResponse.setBody(strBody);
        objResponse.setStatusCode(200);
        return objResponse;
    }
}