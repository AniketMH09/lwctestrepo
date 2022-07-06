/* Apex Class Name       :    AHFC_EconfigModelIntegHandlerMock
* @description        	 :    Mock Callout Class for AHFC_EconfigModelIntegHandlerTest
* Modification Log   	 :
* ---------------------------------------------------------------------------
* Developer                   Date                   Description
* ---------------------------------------------------------------------------
* Akash Solanki               29th July 2021          Created For US 6697
*********************************************************************************/
/**
* @description AHFC_EconfigModelIntegHandlerMock
**/
public class AHFC_EconfigModelIntegHandlerMock implements HttpCalloutMock{
/**
* @description respond
* @param request
* @return response mock response
**/
    public HTTPResponse respond(HTTPRequest request) {
        // Create a mock response
        HttpResponse response = new HttpResponse();
        String jsonResponse = '{"TRX300X9":"OWNERLINK/images/mc_images/at/2009/hom_TRX300X_White.jpg","SXS10M3PL":"_/media/products/family/pioneer_1000/trims/trim_main/pioneer_1000/2020/2020_pioneer_1000_olive_650x380.png"}';
        response.setBody(jsonResponse);
        response.setStatusCode(200);
        return response; 
    }
}