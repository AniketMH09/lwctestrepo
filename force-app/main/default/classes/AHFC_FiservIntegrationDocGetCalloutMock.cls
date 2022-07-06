/*Apex Class Name   :   AHFC_FiservIntegrationHandlerTest
* Description       :   This is a webservice mock class for AHFC_FiservIntegrationHandler
* Created By        :   Akash Solanki
* Created on        :   25/5/2021
*********************************************************************************/
global class AHFC_FiservIntegrationDocGetCalloutMock implements HttpCalloutMock {
    
global HTTPResponse respond(HTTPRequest request){
        String docGetXML = '<?xml version="1.0" encoding="UTF-8"?>';
        docGetXML+='<S:Envelope xmlns:S="http://schemas.xmlsoap.org/soap/envelope/">';
        docGetXML+='<S:Body>';
        docGetXML+='<DocumentGetResponse xmlns="http://feds.fiserv.com/FEDServiceLib">';
        docGetXML+='<UUID>83aeeef3-56f0-4bc2-b51c-c5d267193de9</UUID>';
        docGetXML+='<Status>';
        docGetXML+='<StatusCode xsi:nil="true" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"/>';
        docGetXML+='<StatusDesc xsi:nil="true" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"/>';
        docGetXML+='</Status>';
        docGetXML+='<Document>';
        docGetXML+='<BinLength>328238</BinLength>';
        docGetXML+='<BinData>JVBERi0xLjcKJeLjz9MKNSAwIG9iago8PC9GaWx0ZXIvRmxhdGVEZWNvZGUvTGVuZ3RoIDM1Pj5zdHJlYW0KeJwr5CpUMFQwAEIImZyroB+RaaDgkq8QyBXIVcgFAHeA</BinData>';
        docGetXML+='</Document>';
        docGetXML+='</DocumentGetResponse>';
        docGetXML+='</S:Body>';
        docGetXML+='</S:Envelope>';
        
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'text/xml');
        response.setBody(docGetXML);
        response.setStatusCode(200);
        return response;
    }
}