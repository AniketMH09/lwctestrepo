/*******************************************************************************************************
    * @author   : SHANKAR ANAND
    * @date     : 24 JUN 2016
    * @modified : 04 AUG 2016  
    * @description : MOCK WEB SERVICE RESPONSE GENERATOR FOR THE TEST CLASS 'CybSWSResp_Test', 
    *                PURPOSE : MOCK THE VARIOUS FAILURE RESPONSES.
********************************************************************************************************/


@isTest
global class HttpMockFailureResponseGenerator implements HttpCalloutMock {

    global HttpResponse[] responses = new HttpResponse[0];
    public void addResponse(HttpResponse response) {
        responses.add(response);
    }
  
    global HTTPResponse respond(HTTPRequest req) {          
        HttpResponse response = responses.remove(0);
        return response;
    }
}