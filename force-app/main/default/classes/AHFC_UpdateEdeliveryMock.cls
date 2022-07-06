@isTest
global class AHFC_UpdateEdeliveryMock implements HttpCalloutMock {
	global HTTPResponse respond(HTTPRequest req) {
        HttpResponse response = new HttpResponse();
        response.setBody('{}');
        response.setStatusCode(200);
        return response;
    }
}