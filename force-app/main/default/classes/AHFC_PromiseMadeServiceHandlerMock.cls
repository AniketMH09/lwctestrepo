/* Apex Class Name       :    AHFC_PromiseMadeServiceHandlerMock
* @description        	 :    Mock Callout Class for AHFC_PromiseMadeServiceHandler 
* Modification Log   	 :
* ---------------------------------------------------------------------------
* Developer                   Date                   Description
* ---------------------------------------------------------------------------
* Akash Solanki               29 July 2021              Created For US 9020
*********************************************************************************/
/**
* @description AHFC_PromiseMadeServiceHandlerMock
**/
public class AHFC_PromiseMadeServiceHandlerMock implements HttpCalloutMock {
/**
* @description respond
* @param request
* @return response mock response
**/
    public HTTPResponse respond(HTTPRequest request) {
        HttpResponse response = new HttpResponse();
        response.setBody('SUCCESS');
        response.setStatusCode(200);
        return response; 
    }
}