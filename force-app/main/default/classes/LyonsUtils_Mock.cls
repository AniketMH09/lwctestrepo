@isTest
global class LyonsUtils_Mock implements HttpCalloutMock {
    global HTTPResponse respond(HTTPRequest req) {
     //   System.assertEquals('https://demo.lyonsreg.com/webservices/atm/ATMServiceWCF.svc/rest//Logon', req.getEndpoint());
     //   System.assertEquals('POST', req.getMethod());
     //   System.assert(req.getHeader('Authorization').startsWith('Bearer'));
     system.debug('<<<>>>>>');
       HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"error":null,"token":"05f40b25-17fb-49e6-a58c-5d8fbcd97669"}');
        res.setStatusCode(200);
       
        res.setStatus('OK');
        return res;
    }
}